---
date: "2026-08-13T18:00:00Z"
title: "6. Can tell its healthiness, and is observable"
description: "Health probes, structured logs, metrics and distributed tracing — how a service explains itself."
images:
- "/images/2026/oscilloscope.jpg"
tags:
- microservice
- architecture
- monitor
---

# Quality attributes for microservices - part 6

> This is the sixth post in [the series](../../2023/quality-attributes-for-microservices/) about some ideal
> characteristics about microservices, both from the architect's perspective as well as developer's and
> operations perspective. In this post we will have a look at health checks and observability.

_In my humble opinion a good microservice..._

# "Can tell its healthiness, and is observable from distributed tracing and streaming logging"

The [previous post](../05-eventual-consistency/) left a loose end hanging. Once an operation is a saga
rippling through a message bus, nobody owns the end-to-end flow any more: the order was placed, but did the
ledger ever hear about it? In a monolith you would set a breakpoint. In a distributed system the answer
exists in the telemetry or it does not exist at all.

I have watched what happens when it does not. Operations staff at more than one client would routinely SSH
into production boxes to `tail` a log file, poke at a process list and guess — not because they were
careless, but because it was the only diagnostic tool they had been given. That is not operations, that is
archaeology, and it scales exactly as far as the number of servers a human can log into. The whole point of
this attribute is that a service should explain itself well enough that nobody needs a shell prompt to find
out what it is doing.

## Healthiness is a question the service must answer itself

Start with the simplest form of self-explanation: is this instance fit to serve? The platform around the
service — Kubernetes, a load balancer, a Docker `HEALTHCHECK` — is deliberately dumb. It can restart a
container and it can take an instance out of rotation, and those are two very different decisions, so it
needs two different answers:

- **Liveness** — is the process wedged beyond recovery? If this fails, the platform kills and restarts it.
- **Readiness** — can this instance serve traffic *right now*? If this fails, it is pulled out of the load
  balancer until it recovers.

Startup is not a third state, it is a timing gate: a startup probe simply holds the liveness probe back until
the slow boot has finished, so an impatient platform does not shoot a service that is merely still warming
up. Same two questions, asked later.

The single most common mistake I see is a probe that transitively checks the world. The readiness endpoint
pings the database, which pings its replica, and helpfully also calls three downstream services, each of
which does the same. Now one slow dependency marks half the estate as unready, the load balancer removes
everything, and you have built a machine for converting a minor outage into a total one. Readiness checks
the dependencies *this instance needs to serve its own requests*, nothing more. Liveness must never fail
because something downstream is having a bad day — a service that cannot reach the payment provider is not
broken, it is degraded, and restarting it fixes precisely nothing.

There is a format for saying all this, and it is worth using instead of inventing a fourth dialect of
`{"status":"ok"}` of your own. The IETF draft [Health Check Response Format for HTTP APIs](https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check-06)
defines a media type, `application/health+json`, with a top-level `status` of `pass`, `fail` or `warn`, plus
optional `version`, `releaseId`, `description` and a `checks` object detailing each individual component.
No RFC for health checks exists, and this draft expired years ago, but it is widespread, expressive, and
trivial to generate from whatever health-check plumbing you already have.

`warn` is the field I would single out, because it is the vocabulary for "degraded but still serving", and
that is the state most real incidents actually start in. At one client we learned it the entertaining way: a
malformed message ended up in a dead letter queue, the service dutifully reported that failure as "down",
and the platform did exactly what it was told — killed the instance. The replacement read the same queue,
reported the same failure, and was killed too. One poisoned message, an infinite restart loop across every
instance, and an outage caused entirely by a health check that could only count to two. We fixed it by
keeping the two apart: the dead letter queue raised an alert and a `warn`, and the probe went back to
answering whether the process could serve traffic. A stuck message needs a human, not a reboot.

The quieter case for `warn` showed up at the same client, in the database. Connections took longer and
longer to hand out, queries that had run in 5 ms were taking 80, and the service still answered every
request correctly — just slowly, and with its connection pool a good deal closer to exhaustion than anyone
would like. `pass` would have been a lie, and `fail` would have taken a working instance out of rotation and
handed its traffic to the instances sharing that same struggling database. Reporting `warn`, with the
connection and query latencies in the `checks` object, was what got somebody looking at the database an hour
before the outage instead of during it. If the only states you can express are pass and fail, every problem
becomes a restart.

## Streaming logs, not log files

A microservice does not own log files. It does not own rotation, retention, compression, or a `logs`
directory that fills the disk at 3am. It writes an event stream to stdout and the platform takes it from
there — [twelve-factor](https://12factor.net/logs) has been saying this since 2011 and containers made it
non-negotiable. The container filesystem is ephemeral; a log written inside it is a log written in sand.

I have written about logging over the years — [AOP logging](../../2011/aop-logging/) and
[NLog configuration](../../2011/nlog-configuration-file/) both date from an era when the sophisticated
answer was a file target with rolling archives. The instrumentation ideas hold up. The
assumption that the log lands on a disk you can visit does not.

Two things make the difference between a stream you can query and a stream you can only stare at:

- **Structure.** Log an event with fields — an order id, a tenant, a duration — not a sentence with the
  values glued into it by string interpolation. Structured logging is what turns "find every failed
  checkout for this customer last Tuesday" into a query instead of a regular expression written under
  pressure.
- **Restraint.** Every line costs money to ship, index and retain, and a service that logs every happy-path
  step at `Information` is buying an expensive way to hide the one line that mattered. Levels are not
  decoration.

And the obvious one: no personal data, no tokens, no card numbers, nor authorization headers — these must be
redacted before going to logs, otherwise the logs become part of your production data set. A log aggregator
is a searchable database with a broad audience and a long retention period, and it hurts my eyes to see
incidents involving credentials that leaked into a log.

![A hand-held Jyetech digital storage oscilloscope showing a trace, photo by vlxs, Warranty Voider
(CC BY-NC-SA 2.5)](/images/2026/oscilloscope.jpg)

## The correlation id, industrialised

Every team eventually invents the same thing: a request id, generated at the edge, passed along in a header,
written into every log line so you can stitch a request back together afterwards. It works, right up until
the id has to survive a hop through a queue, a third-party library, or another team's service that calls the
header something else.

That convention is now a standard. [W3C Trace Context](https://www.w3.org/TR/trace-context/) defines the
`traceparent` header: a trace id shared by every step of an operation, a span id for the current step, and a
sampling flag. Each service creates a span, records its duration and outcome, and passes the context on. The
collected spans form a tree, so instead of correlating by hand you can see the whole operation as a
waterfall, with the 900 ms of it that was one unindexed query sitting there in plain sight.

The part everyone forgets is the message bus. HTTP client libraries propagate trace context for you these
days; a broker does not. If the [transactional outbox](../05-eventual-consistency/) from last time stores an
event without the trace context alongside it, the trail ends at the broker and the asynchronous half of your
saga — the interesting, hard-to-debug half — becomes invisible. Put `traceparent` in the event envelope,
restore it in the consumer, and the trace crosses the queue with the message.

## Metrics you would actually wake up for

Traces tell you about one request; metrics tell you about all of them. The trap is the dashboard with forty
graphs that nobody looks at because none of them answers a question. For a request-serving microservice, the
short list is **RED**: rate, errors, and duration as a distribution — p95 and p99, not an average, because
an average latency is a number that has been carefully calculated to hide your worst users.

Point those at an objective rather than at a green light. An SLO — "99.9% of checkouts complete under 500 ms
over 30 days" — turns monitoring into a budget: how much unreliability is left this month, and is the burn
rate fast enough to get somebody out of bed? "Is it green" is not a question with an actionable answer.

Metrics have their own bill, and it is paid in cardinality. Put a customer id, a request path or an order id
in a metric label and you have not created one time series, you have created a million; the difference
between a metric and a log is precisely that a metric is not allowed to be that specific. Keep the
high-cardinality detail in logs and traces where it belongs.

## Just use OpenTelemetry

For most of my career, instrumenting an application meant picking a vendor and inheriting their agent, their
SDK and their opinion, then doing it all again when procurement changed its mind.
[OpenTelemetry](https://opentelemetry.io/) ended that argument. It is one vendor-neutral set of APIs and
wire formats for all three signals — traces, metrics and logs — and every backend worth considering ingests
OTLP. Instrumentation stops being a lock-in decision and becomes plumbing, which is exactly what it should
have been all along.

In .NET it is barely an adoption at all: `Activity` and `Meter` are in the base class library, ASP.NET Core,
`HttpClient` and the data providers are already instrumented, and you are mostly turning things on rather
than writing them. [Aspire](https://aspire.dev/) takes that further and wires up OpenTelemetry across the
whole solution by default, with a dashboard that shows traces and logs across every service from the first
`run`. Being handed the distributed trace before you have written any of it is the correct default, and it
makes the local development story genuinely nicer than production used to be.

Two honest caveats. The Collector is another moving part to deploy, secure and keep up — worth it for the
decoupling, but it is not free. And sampling is a real trade: trace everything and the bill is absurd, trace
1% and the pathological request a customer is complaining about is almost certainly the one you threw away.
Tail-based sampling — decide after the fact, keep the slow and the failed — is the compromise, and it is
another component to run.

## While you are at it, this is a security control

Observability is usually sold as an operations concern, but the same data is the raw material for incident
response. [Years ago I wrote](../../2016/5-reactive-security-and-monitoring/) about reactive security, and
nothing since has changed the fundamentals: access logs, authentication failures and anomalous traffic
patterns are how you find out that something is wrong before a customer or a journalist tells you. When an
incident does happen, the forensic question is "what did this identity touch, and when" — which is a query
against exactly the structured logs and traces you built for debugging.

That cuts both ways. Telemetry that answers "what did this user do" is by definition a rich store of
behavioural data, so retention limits, access control and keeping personal data out of the payload are not
compliance box-ticking, they are the price of having the data at all.

## Conclusion

To sum up: a microservice should be able to answer "am I fit to serve?" itself, and answer it narrowly —
liveness that ignores the outside world, readiness that checks only what it needs to do its own job, and a
response format someone else has already designed — one with room for "degraded", so a problem that needs a
human does not get read as a problem that needs a restart. Everything else it knows, it should stream:
structured logs to stdout for the platform to ship, spans that carry W3C trace context across HTTP *and* the message
bus, and a small set of RED metrics pointed at an objective rather than a green light. Use OpenTelemetry,
because the interesting decisions are what you measure, not which agent you install.

The test is simple. If diagnosing a production problem requires an SSH session, the service is not
observable — it is a mute black box.

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next post we will look at why a microservice should implement operations that are stateless,
non-blocking and handle blobs unbuffered. Thank you for reading and have a wonderful day!

---

## References

- [Health Check Response Format for HTTP APIs](https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check-06)
  by Irakli Nadareishvili — the `application/health+json` draft
- [Trace Context](https://www.w3.org/TR/trace-context/) by the W3C — the `traceparent` header
- [OpenTelemetry](https://opentelemetry.io/docs/) — specification and language SDKs
- [Aspire](https://aspire.dev/) — OpenTelemetry wired up across a solution by default
- [The Twelve-Factor App: Logs](https://12factor.net/logs) by Adam Wiggins
- [Configuring Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-containers/configure-liveness-readiness-startup-probes/)
  by the Kubernetes project
- [Implementing SLOs](https://sre.google/workbook/implementing-slos/) from the Google SRE Workbook
- Oscilloscope photo from [Feel the power in your hands](https://vlxs.wordpress.com/2010/02/13/feel-the-power-in-your-hands-jyetech-digital-storage-oscilloscope/)
  by vlxs, Warranty Voider — [CC BY-NC-SA 2.5](https://creativecommons.org/licenses/by-nc-sa/2.5/es/)
