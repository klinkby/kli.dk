---
date: "2026-06-27T08:00:00Z"
title: "5. Guarantee eventual consistency for complex operations"
description: "Coordinating writes across services when no single transaction can span them."
images:
- "/images/2026/edder-jimenez-OYPRK9AYIoI-unsplash.jpg"
tags:
- microservice
- architecture
---

# Quality attributes for microservices - part 5

> This is the fifth post in [the series](../../2023/quality-attributes-for-microservices/) about some ideal
> characteristics about microservices, both from the architect's perspective as well as developer's and
> operations perspective. In this post we will have a look at eventual consistency for complex operations.

_In my humble opinion a good microservice..._

# "Guarantee eventual consistency for complex operations"

The [previous post](../04-atomicity-and-idempotency/) ended on a promise. As long as an operation fits
inside one service and one transaction, atomicity is nearly free: wrap the work in a transaction, commit,
and the database engine hands you all-or-nothing. But the moment a piece of work has to touch more than one
service — reserve stock here, charge a card there, book the courier somewhere else — that promise expires.
This post is about what you do once it has.

## Where the single transaction runs out

[Part 1 insisted](../../2023/01-exclusively-owns-logic-and-persistence/) that a microservice exclusively
owns its data. That rule is what makes a service autonomous, and it is also what makes this problem hard:
if the order service owns the orders and the payment service owns the payments, there is no shared database
to wrap a transaction around. A "place order" operation that reserves stock, takes payment, and schedules
delivery is really three writes to three different owners, and there is no `COMMIT` that spans all three.

This is the dual-write problem wearing a bigger coat. You update your own database and then you need
something to happen elsewhere — another service, a message broker, an email. Two writes, two systems, no
shared transaction, and a window in between where the first has happened and the second has not. If the
process dies in that window, the two halves disagree, and nobody is coming to roll them back for you.

## Why not just a distributed transaction

The textbook answer is a distributed transaction — a two-phase commit (2PC), where a coordinator asks every
participant "can you commit?" and only tells them to go ahead once all say yes. The XA protocol has done
this for decades, and on paper it hands back the atomicity you lost.

In practice, it's last resort. 2PC holds locks across service boundaries for the whole
exchange, so one slow participant stalls everyone, and the coordinator is a single point of failure that
leaves participants blocked if it dies mid-commit. Worst of all it surrenders the very availability that
pushed you to microservices: distributed transactions work by making independent services dependent again,
which is exactly the thing you were trying to undo.

## Eventual consistency is how the real world already works

So I drop the demand for everything to be true at the same instant, and settle for everything becoming true
eventually. That sounds like a concession, and it is, but it is also just an honest description of how
business has always run. When you posted a [cheque](../04-atomicity-and-idempotency/) the money did not
move when you signed it; it moved days later when the bank cleared it, and everyone got along fine with the
gap. The warehouse does not know an item is sold the microsecond the order is placed; the picking list
catches up. Real businesses are full of these short windows where two systems disagree and then reconcile.

There is some theory under this. The **CAP theorem** says a distributed system can offer at most two of
Consistency, Availability and Partition-tolerance — and since the network *will* partition when you least like
it to, P is not optional. So the real choice is the other two: when a partition hits, do you refuse to
answer until you are sure you are consistent (CP), or do you keep answering and reconcile afterwards (AP)?
A 2PC transaction is the CP corner, but it stops serving. Eventual consistency is the AP corner:
stay available, accept a brief window where the order exists but the payment has not settled, and guarantee
the system converges rather than pretending the window is not there. For most business operations staying
up and reconciling beats going dark, which is why AP is often the default.

## Sagas: local transactions plus an undo

One pattern to make this manageable, is the **saga**. Instead of one transaction across many services, a
saga is a *sequence* of local transactions, each one atomic within its own service, chained together. Each
step that changes state comes with a paired **compensating action** that semantically undoes it. Reserve
stock; if a later step fails, release the reservation. Charge the card; if delivery cannot be scheduled,
refund it. You cannot roll back across services, so instead you roll *forward* with a deliberate apology.

![A string ensemble playing together from sheet music, photo by Edder Jiménez (Unsplash)](/images/2026/edder-jimenez-OYPRK9AYIoI-unsplash.jpg)

There are two ways to conduct the ensemble. **Orchestration** puts one service in charge — a coordinator
that calls each participant in turn and decides what to do when one fails, like a conductor cueing each
section. **Choreography** has no conductor: each service reacts to events the others emit and emits its own
in turn, the way players in a small ensemble follow the score and each other without anyone waving a baton.
Orchestration is easier to reason about and to debug because the flow lives in one place; choreography is
more decoupled but the overall process exists only as an emergent property of who reacts to what, which is
harder to see. For anything with real branching I lean towards orchestration, and keep the orchestrator
dumb — it sequences steps, it does not own business logic.

## The transactional outbox

Sagas move on events, which drags the dual-write problem right back: commit the order row, then publish an
"order placed" event, and a crash in between stalls the saga with nobody the wiser. The broker and the
database are two systems again.

The **transactional outbox** closes the gap. Instead of publishing directly, the service writes the event
into an `outbox` table *in the same local transaction* as the business change — one commit, genuinely
atomic, both rows or neither. A separate relay then reads the outbox and publishes to the broker, marking
rows sent; if it crashes mid-publish it just re-reads and re-sends. The dual write becomes a single local
write plus a dumb, restartable pump.

## Event-driven architecture in the large

One saga with a handful of steps you can still draw on a whiteboard. But as the business grows, the
interesting operations stop being a tidy line of calls and become a web: an order placement should also
update the loyalty balance, refresh the recommendation model, notify the warehouse, and feed the finance
ledger — none of which the order service should know or care about. Wiring all of that as direct calls
turns the order service into a hub that has to be redeployed every time someone downstream wants to react
to a new event. That is the coupling [part 2](../../2023/02-independently-deployable-and-scalable/) warned
about, sneaking back in through the call graph.

The way out is to invert it. The order service publishes one fact — "order placed" — to a **message bus**
and forgets about it. Anyone who cares **subscribes**; the publisher never holds a list of subscribers. New
consumers join by subscribing, not by getting the producer to add a call, so the event ripples outward
through the system asynchronously and each service reacts in its own time. This is **publish/subscribe**,
and it is what lets a system grow new behaviour at the edges without surgery in the middle. The broker —
RabbitMQ, Kafka, a cloud queue, whatever — is the load-bearing infrastructure here, and choosing it is an
architectural decision, not a library import.

It is a genuinely good pattern, and it has genuinely sharp edges, so a few things to look out for:

- **Decoupling cuts both ways.** Nobody owns the end-to-end flow any more. The order was placed, but did
  the ledger ever hear about it? In a pub/sub system the answer lives in logs and traces across half a
  dozen services — which is precisely why the next post is about observability and distributed tracing.
- **Out-of-order and duplicate delivery are normal.** A bus gives you at-least-once and rarely strict
  ordering, so consumers must tolerate duplicates (idempotency, below) and not assume event B arrives after
  event A.
- **Schema is a contract.** The moment two services share an event, its shape is a public API. Version it,
  add fields rather than repurposing them, and never assume you can change a published event quietly.
- **Don't let the bus become a god.** It is tempting to route everything through one broker until it is the
  most coupled thing you own. The bus carries facts between bounded contexts; it is not a dumping ground for
  every internal state change.

## Idempotent consumers

That pump delivers _at-least-once_, the same honest bargain [part 4](../04-atomicity-and-idempotency/)
described for HTTP: a relay that crashes after publishing but before marking the row sent will publish
again on restart. So every consumer in the saga has to expect duplicates and shrug them off — it must be
**idempotent**. The mechanism is the one from last time: each event carries a stable identifier, the
consumer records the ids it has already processed, and a repeat id replays the stored outcome instead of
doing the work twice. Charge the card once per payment id, no matter how many times the event arrives.
Idempotent producers and idempotent consumers are what let you choose at-least-once delivery — which never
silently drops work — without paying for it in double charges.

## When the events _are_ the truth: event sourcing

Everything so far treats events as a side effect: you change the current state and emit an event to tell the
world. **Event sourcing** turns that on its head. The append-only log of events *is* the system of record,
and current state is just a projection you replay from it — you do not store "balance: 110", you store
"deposited 100", "deposited 10" and compute it.

It is a heavy commitment, and most services should not reach for it. The requirement that earns it is when
the *history* is itself a business asset — a full audit trail of who changed what and when, for finance,
compliance, or dispute resolution, where "how did it get here" matters more than "what is it now". The cost
is real too: queries mean maintaining projections, the schema is forever, and fixing a mistake becomes
"append a correcting event", not "UPDATE the row". Adopt it where the audit trail is the product; resist it
where you just wanted a database.

## Or: don't distribute in the first place

By now a pattern of a different kind should be obvious. Every tool in this post is a workaround for one
fact: the data lives in separate services, so the single transaction is gone. Sagas, compensations,
outboxes, idempotent consumers, a message bus — that is a lot of moving parts, failure modes, and
operational surface area bought to recover a guarantee a single database hands you for free. Sometimes that
price is worth paying. Often it is paid by teams who adopted microservices for fashion rather than need,
and who would have been better served by *not* distributing the data in the first place.

The honest alternative is the **modular monolith**: one deployable, one database, but partitioned inside
into well-bounded modules with explicit interfaces and no reaching into each other's tables. You keep the
thing microservices were really about — clear ownership and boundaries — while a "place order" operation
that touches stock, payment and delivery stays a single local `COMMIT`. Atomicity is free again, there is 
no eventual-consistency window to reason about, and you can still call out to
genuinely independent services where they earn their keep. If a module later proves it needs its own
release cadence or scaling profile, a clean boundary is exactly what lets you extract it into a service
*then* — and pay this chapter's tax only for the part that truly needs it.

Distribute only when a real, demonstrated requirement like scalability forces your hand. Everything above 
is how you cope once you have crossed that line; CAP is not a reason to cross it.

## Conclusion

To sum up: once an operation crosses service boundaries the single transaction is gone, and chasing it with
a distributed two-phase commit buys atomicity by surrendering the autonomy that made microservices worth
having. The pragmatic trade is eventual consistency — accept a brief, well-defined window of disagreement
and engineer the convergence. Model the operation as a saga of local transactions, give every step a
compensating action, ship its events through a transactional outbox so the publish is atomic with the
write, and let those events ripple through a publish/subscribe bus so the system can grow new behaviour
without rewiring the middle. Make every consumer idempotent so at-least-once delivery stays harmless, and
reach for event sourcing only when the history itself is the product. The business has run on this bargain
since long before computers; we are just writing it down. And if all of that machinery looks like a lot of
moving parts to recover what one database gave you for free — that is the case for a modular monolith, and
for distributing only the module that genuinely demands it.

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next post we will look at how a microservice can tell its own healthiness and stay observable through
distributed tracing and streaming logs. Thank you for reading and have a wonderful day!

---

## References

- [Pattern: Saga](https://microservices.io/patterns/data/saga.html) by Chris Richardson — sagas and
  compensating transactions
- [Pattern: Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html) by
  Chris Richardson
- [Pattern: Idempotent Consumer](https://microservices.io/patterns/communication-style/idempotent-consumer.html)
  by Chris Richardson
- [Pattern: Event-driven architecture](https://microservices.io/patterns/data/event-driven-architecture.html)
  by Chris Richardson — publish/subscribe between services
- [Pattern: Event sourcing](https://microservices.io/patterns/data/event-sourcing.html) by Chris Richardson
- [Sagas](https://www.cs.princeton.edu/research/techreps/598) by Hector
  Garcia-Molina and Kenneth Salem — the 1987 paper that named the pattern
- [Distributed Transaction Processing: The XA Specification](https://pubs.opengroup.org/onlinepubs/009680699/toc.pdf)
  by The Open Group — the two-phase commit standard
