---
date: "2026-10-28T08:00:00Z"
title: "7. Stateless, non-blocking and unbuffered"
description: "Why a request should borrow a thread and a little memory, give them back promptly, and leave nothing behind."
images:
    - "/images/2026/bucket-brigade.jpg"
tags:
    - microservice
    - architecture
---

# Quality attributes for microservices - part 7

> This is the seventh post in [the series](../../2023/quality-attributes-for-microservices/) about some ideal
> characteristics about microservices, both from the architect's perspective as well as developer's and
> operations perspective. In this post we will have a look at statelessness, non-blocking I/O and streaming.

_In my humble opinion a good microservice..._

# "Implement operations that are stateless, non-blocking (I/O) and handle blobs unbuffered"

At first glance these are three unrelated pieces of advice bundled into one line. They are not. They are the
same rule seen from three angles: _a request borrows a thread and a little memory, holds them only while it is
actually using them, and leaves nothing behind when it is done._ Statelessness is about what is left behind.
Non-blocking I/O is about what is held while waiting. Unbuffered blobs are about how much is held at once.

Get all three right and you are rewarded with an instance that any request can be sent to, that serves a
great many requests at once, runs in a flat memory footprint, and can be killed at any moment without anybody
noticing. Get one of them wrong and the service still works fine. On your laptop, with one user.

## Any instance, any request

The reason we care about statelessness is horizontal scaling. A load balancer in front of a stateless service
is free to route on load alone (round-robin, least connections, whatever it likes) because every instance
can answer every request. Scaling out is adding an instance. Scaling in is removing one. Neither is an event.

The moment an instance remembers something between requests, the load balancer loses that freedom. The
classic symptom is **sticky sessions**: the user's session lives in one instance's memory, so the load
balancer pins the user to it with a cookie. It works, and it quietly undoes everything:

- Load skews. One instance runs hot with the chatty customers while its neighbours idle.
- The autoscaler adds an instance when the hot one struggles, and the new instance receives none of the
  traffic that is already pinned elsewhere. You pay for capacity that cannot help.
- Scale-in, a rolling deploy or a crash throws away every session pinned to that instance. Users get logged
  out, carts get emptied.

At that point the load balancer has been promoted to session database, a job it was never designed for.

Sessions are the obvious case. The sneaky ones are the state nobody thought of as state: temp files written to
local disk and picked up by a later request, an in-memory rate limiter that with five replicas enforces a
fifth of the intended limit, WebSocket connections whose subscriptions live in one process, and the in-process
background job on a timer that now runs once per replica. A cache is fine, as long as it is disposable and
correctness never depends on it being warm, or the same on every instance.

Statelessness does not make state go away; it moves it. Into the database the service owns, a distributed
cache, the client as a signed token, or the message itself as in the [previous posts on
consistency](../05-eventual-consistency/). That shared store is now your scaling bottleneck, which is the honest
price of the trick, but it is one bottleneck you can see and size, instead of state smeared across instances.

The test is `kill -9`. Pick any instance, at any time, and kill it. The platform will do this to you anyway on
scale-in, node maintenance and spot eviction, so you may as well design for it. Be polite on the way out,
though: on `SIGTERM`, stop reporting ready [so the load balancer drains you](../06-healthiness-and-observability/),
let in-flight requests finish, then exit.

## Threads are the expensive part

A typical microservice does very little computing. It spends nearly all of its wall-clock time waiting: for
the database, for another service, for the blob store. What it does with its threads while it waits is the
difference between a server that handles hundreds of concurrent requests and one that handles tens of thousands.

In the legacy **thread-per-request** model, each request holds a worker thread from the first byte to the
last, including all the time spent waiting on the network. Threads are not cheap: each reserves a megabyte or
more of stack, costs the scheduler context switches, and the practical limit is in the hundreds to low
thousands per server. Tomcat's default pool is 200, for scale.

[Little's Law](https://en.wikipedia.org/wiki/Little%27s_law) does the rest. Requests in flight equals
throughput times latency, so a blocking server's ceiling is its thread count divided by how long each request
holds a thread. 200 threads and 50 ms of database time: about 4,000 requests per second. Now the database has
a bad afternoon and answers in 2 seconds. Same server, same code, same idle CPU, and the ceiling is 100
requests per second.

That is how **thread pool exhaustion** unfolds. A slow dependency holds threads longer. The pool fills and new
requests queue. Latency climbs, so threads are held longer still. The health probes queue behind real traffic,
time out, and the platform restarts instances that were perfectly healthy, shoving their load onto the
survivors, which then fall over in turn. One slow dependency, a cascading outage, and an autoscaler watching
a CPU graph at 5% and concluding all is well.

## Non-blocking: waiting for free

The non-blocking model separates the request from the thread. When a request awaits I/O, its thread goes back
to the pool, and the kernel (epoll on Linux) signals when the socket is ready, so any free thread can pick
the work back up. A handful of threads, about one per core, serve everything. A waiting request costs a small
state machine on the heap and some socket buffers: kilobytes, not megabytes.

That changes what "capacity" means. Concurrency stops being the limit: a modest instance can hold tens of
thousands of requests in flight, and the [C10K problem](http://www.kegel.com/c10k.html) is a history lesson
rather than an engineering challenge. The ceiling moves to CPU, memory, file descriptors and, above all, to
whatever is downstream. For an ordinary JSON API doing a database call per request, expect throughput in the
low thousands of requests per second per core, bounded by CPU and the database, not by threads. The
[TechEmpower benchmarks](https://www.techempower.com/benchmarks/) put ASP.NET Core in the millions, which is
true and tells you about as much about your API as a top speed figure tells you about your commute.

Now the honest part. Non-blocking does not make anything faster; a single request takes exactly as long as
before. And the queue does not vanish, it moves: from your thread pool to the database connection pool
(ADO.NET defaults to a `Max Pool Size` of 100) and to the database itself. You can now accept 20,000
concurrent requests. Your database cannot serve them.

What you gain is control. A slow dependency no longer silently eats your threads, so the failure becomes
yours to decide:

- Time out deliberately, rather than whenever the pool runs dry.
- Pass the `CancellationToken` (`HttpContext.RequestAborted`) all the way down, so work stops when the client
  has given up.
- Put a bulkhead, a concurrency limit per dependency, in front of each downstream, so one slow neighbour
  cannot consume everything.
- Shed load with `503` and `Retry-After` when you are full, which is a lot easier to live with when the
  operations behind it are [idempotent](../04-atomicity-and-idempotency/).

And because the instance stays responsive, its health probe keeps answering truthfully.

A blocking server is sized by its slowest dependency. A non-blocking one is sized by its CPU.

Two caveats before moving on. CPU-bound work gains nothing from `async`; image resizing or report generation
belongs on a queue and a worker, not on the request path. And .NET charges a tax for all this: `async` spreads
through every method signature like a dye. Java's virtual threads and Go's goroutines let you write blocking-style
code and get non-blocking behaviour from the runtime, which is frankly the nicer deal. Node gets it for free
too, but with a single event loop, so one CPU-heavy request stalls everybody.

![Men working a bucket brigade along the Niukluk River, Council, Alaska, circa 1907. Fixed-size buffers,
constant memory, photo by Albert B. Kinne (public domain)](/images/2026/bucket-brigade.jpg)

## Blobs: a hose, not a bucket

The last angle is how much memory a request holds at once. Read an uploaded file into a byte array, process
it, write it on, and memory use is payload size times concurrency. The service handles 2 MB profile pictures
beautifully, right up until three people upload 2 GB videos at the same time and the container is OOMKilled,
which the telemetry will faithfully report as a crash, not as "someone sent a large file".

Streaming flips that around. Read a chunk, process it, write it on, reuse the buffer. Memory per request is
the buffer size, whatever the payload, and instance sizing becomes predictable. Hash the content as it flows
through rather than afterwards; scan it for malware in the same pass. Everything that can be done on a stream
should be.

In .NET the traps are in the convenient APIs. `ReadAsByteArrayAsync` and `MemoryStream` do exactly what they
say. Anything above 85 KB lands on the Large Object Heap, which the garbage collector is in no hurry to
compact. And model-bound `IFormFile` quietly spills uploads larger than 64 KB to local disk, which is
both the hidden state from earlier and, on Linux, not really asynchronous either, as epoll cannot wait for
regular files and async file I/O ends up on a pool thread anyway. Read the request body as a stream and copy
it to its destination.

Better still: do not let the blob through the service at all. Hand the client a short-lived, narrowly scoped
**pre-signed URL** (a SAS token in Azure), let it upload directly to object storage, and have the service deal
only with the metadata. Messages on the bus carry a reference to the blob, never the blob itself: the
[claim-check pattern](https://learn.microsoft.com/azure/architecture/patterns/claim-check). The cheapest byte
to process is the one that never reaches you.

Streaming has its own costs. You cannot validate a file before you start writing it, so write to a staging
location and commit only once the checks pass. That is [atomicity](../04-atomicity-and-idempotency/) in another hat.
Once response headers are sent you can no longer change your mind about the status code, so an error halfway
through a download becomes a truncated stream rather than a tidy `500`. 

## Also a security control

An endpoint that buffers uploads is a memory exhaustion attack waiting for an attacker. Streaming removes the
amplification, but set the limits anyway: a maximum request body size, a minimum data rate so a slowloris
client cannot hold a connection open with a byte a minute (Kestrel has both), and a hard ceiling on
decompressed size, because a zip bomb is a small upload with big ambitions. Pre-signed URLs should expire in
minutes, allow one operation on one object, and nothing else.

## Conclusion

To sum up: a microservice should treat every request as a short loan. It borrows a thread only while it is
working, not while it is waiting. It borrows memory one buffer at a time, not one payload at a time. And when
it is done, it leaves nothing on the instance that the next request, on whichever instance, would need.
Statelessness gives the load balancer and the autoscaler their freedom, non-blocking I/O stops a slow
dependency from turning into an outage, and streaming keeps memory flat whatever the client sends.

There are two tests. Can you kill any instance in the middle of a request without anybody noticing? And does
the memory graph stay flat when someone uploads a 4K movie?

The best microservice instance is one nobody would miss.

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next and final post we will look at why a microservice should externalize cross-cutting policies to
upstream infrastructure services. Thank you for reading and have a wonderful day!

---

## References

- [Little's law](https://en.wikipedia.org/wiki/Little%27s_law) on Wikipedia
- [Debug ThreadPool starvation](https://learn.microsoft.com/dotnet/core/diagnostics/debug-threadpool-starvation)
  by Microsoft
- [The C10K problem](http://www.kegel.com/c10k.html) by Dan Kegel
- [TechEmpower Web Framework Benchmarks](https://www.techempower.com/benchmarks/)
- [Claim-Check pattern](https://learn.microsoft.com/azure/architecture/patterns/claim-check) by Microsoft
- [tus: resumable file uploads](https://tus.io/) and the IETF
  [Resumable Uploads for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/) draft
- [The Twelve-Factor App: Processes](https://12factor.net/processes) by Adam Wiggins
- Bucket brigade photo by Albert B. Kinne, circa 1907, via
  [Wikimedia Commons](<https://commons.wikimedia.org/wiki/File:Men_working_a_bucket_brigade_along_the_Niukluk_River_to_put_out_a_fire,_Council,_Alaska,_circa_1907_(AL%2BCA_101).jpg>)
  (public domain)
