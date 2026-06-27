---
date: "2026-06-13T08:00:00Z"
title: "4. Guarantee atomicity and idempotency for simple operations"
description: "Why simple microservice operations should be atomic and safe to retry."
images:
- "/images/2026/cheque.jpg"
tags:
- microservice
- architecture
---

# Quality attributes for microservices - part 4

> This is the fourth post in [the series](../../2023/quality-attributes-for-microservices/) about some ideal characteristics
> about microservices, both from the architect's perspective as well as developer's and operations perspective. In this
> post we will have a look at atomicity and idempotency for simple operations.

_In my humble opinion a good microservice..._

# "Guarantee atomicity and idempotency for simple operations"

The microservice is the sole guardian of the data behind the resources it exposes. No other service
reaches into its database, so when that data goes inconsistent there is nobody else to blame. 
That responsibility sounds obvious right up until you remember there is a
network between you and every caller, and the network does not care about your data integrity.

## The lost response

HTTP is a request followed by a response, and either half can go missing. The client sends a `POST
/order`, the service dutifully creates the order, and then the response evaporates — a dropped
connection, a proxy timeout, a load balancer that gave up half a second too early. The order exists.
But the client has no idea: As far as it is concerned, the request failed.

So it does the only sensible thing: it retries. And now you have two orders.

This is not an edge case you can wish away. HTTP clients and message brokers alike default to
_at-least-once_ delivery, because the alternative — at-most-once — means quietly dropping work, which
is usually the worse sin. At-least-once is honest about the bargain: it would rather deliver twice
than not at all, and it leaves you, the author of the service, to make the duplicate harmless. 

## Safe, idempotent, and the pesky POST

Happily, HTTP thought about this decades ago. [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html),
the current HTTP semantics specification, classifies its methods along two axes that matter here.

A method is **safe** if it is read-only — it makes no meaningful change to server state, so calling
it has no consequences worth worrying about. `GET` and `HEAD` are safe; you can retry them all day.

A method is **idempotent** if making the same request twice has the same effect as making it once.
`PUT` and `DELETE` qualify: `PUT /order/42` with the same body leaves the resource in the same state
whether it arrives once or five times, and `DELETE /order/42` leaves the order gone — the second
delete is a no-op, not an error. `GET` is idempotent too, trivially, by being safe.

[`PATCH`](https://www.rfc-editor.org/rfc/rfc5789) is the odd one out, neither safe nor idempotent in
the general case: a partial update like "add 10 to the balance" plainly is not safe to repeat. If you
want an idempotent `PATCH`, you have to design the patch to be absolute ("set the balance to 110"),
not relative.

And then there is `POST`, the troublemaker. In the [resource-centric design from part
3](../03-well-defined-resource-centric-interface/), `POST /order` means _create a new order_, and by
definition every call is meant to create something new. Retry it and you get exactly what the verb
promised: another order. `POST` is neither safe nor idempotent, and it is precisely the method you
reach for when the stakes — orders, payments, bookings — are highest.

## Making POST safe to retry

You cannot make `POST` idempotent by decree, but you can let the client make it idempotent. The trick
is to have the client mint a unique identifier — a nonce — _before_ it sends the request, and attach
it. The emerging convention is the [`Idempotency-Key`
header](https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/): the client
picks a UUID, puts it on the request, and reuses the _same_ key on every *retry*.

The server keeps a short-lived record of the keys it has already processed. The first time it sees a
key it does the work and stores the outcome against that key. If the same key turns up again — the
retry after a lost response — it skips the work and replays the stored result. The duplicate create
is deduplicated, and the client gets back the same order id it would have got the first time, none
the wiser that its first attempt was ever in doubt.

This is how serious payment APIs avoid charging your card twice; Stripe has shipped an
`Idempotency-Key` header for years. It is still an IETF draft rather than a ratified RFC, but the
pattern is settled enough that I would not build a create endpoint that touches money without it.

![A handwritten cheque — the original idempotency key, void once cashed](/images/2026/cheque.jpg)

## Atomic: all or nothing

Idempotency stops a retry from doubling up. **Atomicity** stops a single attempt from leaving a mess.
An operation is atomic when it either happens completely or not at all — there is no in-between state
where the order row was written but the stock count was not.

With a single transactional database this is very nearly free, and it is the main reason [part 1
insisted a microservice own exactly one
database](../../2023/01-exclusively-owns-logic-and-persistence/). Wrap the work in a transaction,
commit at the end, and the engine guarantees all-or-nothing for you. If anything throws, you roll
back and the world looks as though the request never arrived — which, conveniently, is also what
makes the subsequent retry clean.

It stops being free the moment a service spans more than one storage engine: a relational database
for the order, a blob store for the attachment, a search index for the catalogue. There is no single
`COMMIT` across all three, so a failure halfway through leaves them disagreeing. Now you are writing
_compensation_ logic — undo the blob upload because the database transaction rolled back — and you
have quietly wandered into distributed-transaction territory. For a _simple_ operation my advice is
not to: keep simple writes inside one transactional store, and if an action genuinely has to touch
several, treat it as a complex operation — the subject of the next post.

## Concurrency: ETag and If-Match

Retries are one way two writes collide; two users are another. Alice and Bob both `GET /order/42`,
both edit it, both `PUT` it back. Without protection the second write silently clobbers the first —
the classic lost update.

HTTP's answer is optimistic concurrency, built on conditional requests (also [RFC
9110](https://www.rfc-editor.org/rfc/rfc9110.html#name-conditional-requests)). The service stamps
each response with an `ETag`, a version marker for that representation. When a client wants to write
it sends the tag back in an `If-Match` header: _only apply this if the resource is still the version I
read_. If it is, the write proceeds and the `ETag` moves on. If someone got there first, the server
refuses with `412 Precondition Failed`, and the client re-reads, reconciles, and tries again. It is
cheap — no locks, no transactions held open across think time — and it fails safely: under contention
you get an honest error instead of a silent overwrite.

## When it goes wrong, say so clearly

Everything above produces error responses — a `412` on a stale write, a `409` on a duplicate the
idempotency layer caught, a `400` on a malformed body. A bare status code and a sentence of prose are
not much for a machine to act on, and these are exactly the cases where the _client_ has to decide
whether to re-read, retry, or give up.

So report failures in a structured form. [RFC 9457, Problem Details for HTTP
APIs](https://www.rfc-editor.org/rfc/rfc9457.html)  — defines a small JSON schema that
turns an error into something the caller can branch on rather than scrape. It costs almost nothing to
emit, and it is the difference between a client that recovers gracefully and one that throws up its
hands at "HTTP 412".

## Conclusion

To sum up: The network corrupts your data through lost responses and retries; the cure is to make every simple
operation safe to repeat and all-or-nothing. Make reads safe, make `PUT` and `DELETE` idempotent,
give `POST` an idempotency key, keep the write atomic in a single transactional database, guard
concurrent writes with `ETag`, and report failures as Problem Details. Do that and "I am not sure if
my request went through" stops being a data-corruption bug and becomes a harmless retry.

This all held because the operation fit inside one service and one transaction. Span several services
and atomicity is off the table — which is where the next post goes.

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next post we will look at how a microservice can [guarantee eventual consistency for complex operations](../05-eventual-consistency/).
Thank you for reading and have a wonderful day!

---

## References

- [HTTP Semantics (RFC 9110)](https://www.rfc-editor.org/rfc/rfc9110.html) by the IETF — method
  properties, conditional requests, `ETag` and `If-Match`
- [PATCH Method for HTTP (RFC 5789)](https://www.rfc-editor.org/rfc/rfc5789) by the IETF
- [The Idempotency-Key HTTP Header Field](https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/)
  — IETF draft
- [Problem Details for HTTP APIs (RFC 9457)](https://www.rfc-editor.org/rfc/rfc9457.html) by the IETF
  — obsoletes RFC 7807
- [Designing robust and predictable APIs with idempotency](https://stripe.com/blog/idempotency) by Stripe
</content>
