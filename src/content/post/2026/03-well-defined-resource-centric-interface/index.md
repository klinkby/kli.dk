---
date: "2026-06-06T08:00:00Z"
title: "3. Provides a well-defined, interoperable resource-centric interface"
description: "Designing the REST interface a microservice exposes to the world."
images:
- "/images/2026/switchboard.jpg"
tags:
- microservice
- architecture
---

# Quality attributes for microservices - part 3

> This is the third post in [the series](../../2023/quality-attributes-for-microservices/) about some ideal characteristics
> about microservices, both from the architect's perspective as well as developer's and operations perspective. In this
> post we will have a look at the interface a microservice exposes to its consumers.

_In my humble opinion a good microservice..._

# "Provides a well-defined, interoperable resource-centric interface"

A service nobody can call is just an expensive way to heat a data center. Once the
microservice owns its [logic and persistence](../../2023/01-exclusively-owns-logic-and-persistence/)
and is [independently deployable](../../2023/02-independently-deployable-and-scalable/), the next
question is how the rest of the world talks to it. My answer is REST: model the
business entities as resources at stable paths, and let the HTTP method say what to do
with them.

## Nouns, not verbs

The mistake I see again and again is dragging the old RPC habit into HTTP. People
expose endpoints like `POST /createOrder`, `POST /cancelOrder`, `GET /getOrderById` —
the verb is baked into the path, and every new use case grows another bespoke
endpoint. That is operation-centric thinking, and it ends in the same sprawling,
tightly coupled mess we were trying to escape.

Resource-centric design flips it around. The path names a _thing_, not an action. The
HTTP method _is_ the verb:

- `GET /order/{orderId}` — read it
- `POST /order` — create one
- `PUT /order/{orderId}` — replace it
- `PATCH /order/{orderId}` — amend it
- `DELETE /order/{orderId}` — bin it

Four or five well-understood verbs cover almost everything, and a consumer who has met
one of your resources already knows how to use the next. "Cancel an order" stops being
a new RPC call and becomes a state change on the order resource — a `PATCH`, or a
`POST` to a nested `/order/{orderId}/cancellation` if you prefer to model the
cancellation as a resource in its own right.

## REST is as old as the web

None of this is new. REST was described by Roy Fielding in his 2000 dissertation, and
it is really just a name for the way HTTP was meant to be used all along. There is no
"REST spec" you can validate against, no committee stamping conformance certificates —
it is a set of constraints, and real-world APIs sit all over the spectrum of how
faithfully they follow them. That looseness annoys purists, but it is also why REST
outlived every framework that promised to replace it.

It also means REST inherits everything HTTP already gives you for free: caching,
content negotiation, status codes, conditional requests, authentication. You are not
inventing a protocol, you are using the one the entire web already runs on.

![A Western Electric PBX telephone switchboard, photo by Daderot (CC0)](/images/2026/switchboard.jpg)

## Modelling the resources

The resources are your business entities: `order`, `customer`, `product`, `invoice`.
Each gets a path, and instances are addressed by their identifier — `GET /product/42`.

Some entities only make sense inside a parent. An order line cannot exist without its
order, so I nest it: `/order/{orderId}/order-line`. The path itself documents the
ownership. Standalone entities that happen to be related — orders and products — stay
at the top level and reference each other by id, rather than nesting `product` under
`order`. If a child can be addressed on its own, it is not a child.

A couple of conventions I stick to:

- **Kebab-case paths.** `/order-line`, not `/orderLine` or `/order_line`. Lowercase,
  hyphen-separated, and consistent everywhere.
- **Path params are mandatory, query string is optional.** Anything that identifies
  the resource lives in the path and is required to resolve it. Anything optional — a
  search filter, paging, sorting — goes in the query string: `GET
  /order?status=open&page=2`. If a parameter is allowed to be absent, it does not
  belong in the path.

## Interoperable, not just integrable

"Interoperable" is the word I care about most in this attribute. A REST interface can
be driven by anything that speaks HTTP — `curl` from a shell script, a browser, a
forty-year-old mainframe, a junior developer poking at it by hand. There is no
mandatory SDK, no special client, no schema you must compile before you can send your
first request.

That is a genuine advantage over the fashionable alternatives. GraphQL and OData are
both capable, but they ask the caller to learn a query language and lean on tooling to
be productive, and they make HTTP caching and the humble `curl` test harder than they
should be. For a resource microservice that should stay decoupled and outlive its
clients, "anyone with an HTTP library can call this" beats "powerful, once you have
installed our client".

## How RESTful is it, really?

The classic way to grade an interface is the [Richardson Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html),
which Martin Fowler popularised. Roughly:

- **Level 0** — one URI, one verb. HTTP as a dumb tunnel for RPC. The swamp.
- **Level 1** — many resources, each with its own URI, but still one verb.
- **Level 2** — proper use of HTTP verbs and status codes. This is where most decent
  REST APIs live, and honestly where most of the value is.
- **Level 3** — hypermedia controls (HATEOAS): responses link to the next available
  actions, so the API is self-navigating.

Level 3 is elegant and almost nobody ships it. In practice I would rather spend the
effort on a detailed [OpenAPI](https://www.openapis.org/) contract — which, with
tongue only slightly in cheek, I think of as _level 4_. A good OpenAPI document makes
the service discoverable, and a client can generate a strongly typed proxy straight
from it and call the service without ever reading my prose documentation. I did exactly
this years ago for a small [malware-scan microservice](../../2021/malware-scan-microservice/):
a plain HTTP/REST endpoint with an OpenAPI/Swagger contract, callable from .NET or a
shell, whichever you prefer.

Discoverability now reaches one level further out. [RFC 9727](https://www.rfc-editor.org/rfc/rfc9727.html),
published in 2025, standardises a `/.well-known/api-catalog` URI: a fixed address where
a publisher lists its APIs and links to their descriptions. So instead of emailing
someone a Swagger URL, a client can ask an organisation "what APIs do you have?" and
follow the catalog to each contract. OpenAPI tells you how to call one service; the API
catalog tells you which services exist in the first place. That, to me,
is what "well-defined" earns you: the contract is machine-readable, the consumer's
tooling does the boring work, and the interface stops being a source of integration
bugs.

## Conclusion

So, to wrap up: model the entities as resources at stable, kebab-case paths, nest the
children that cannot live without their parent, and let the HTTP verb carry the action
instead of stuffing it into the URL. Keep mandatory identifiers in the path and
optional filters in the query string. REST is not a specification so much as the grain
of HTTP itself, which is exactly why it is so interoperable — and a thorough OpenAPI
contract turns "interoperable" into "self-service".

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next post we will look at how a microservice can guarantee atomicity and idempotency for simple operations.
Thank you for reading and have a wonderful day!

---

## References

- [Architectural Styles and the Design of Network-based Software Architectures](https://ics.uci.edu/~fielding/pubs/dissertation/top.htm)
  by Roy Fielding — the dissertation that named REST
- [Richardson Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html) by Martin Fowler
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) by the OpenAPI Initiative
- [API Discovery via Well-Known URI (RFC 9727)](https://www.rfc-editor.org/rfc/rfc9727.html) by the IETF
- [HTTP Semantics (RFC 9110)](https://www.rfc-editor.org/rfc/rfc9110.html) by the IETF
