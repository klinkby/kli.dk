---
date: "2023-06-09T08:32:00Z"
title: "2. Is independently deployable and scalable"
description: "Characteristics of deployment and scalability of microservices."
images:
- "/images/2023/parcels.jpg"
tags:
- microservice
- architecture
---

# Quality attributes for microservices - part 2

> This is the second post in [the series](../quality-attributes-for-microservices/) about some ideal characteristics
about microservices, both from the architect's perspective as well as developer's and operations perspective. In this
post we will have a look on deployment and scalability of microservices.

_In my humble opinion a good microservice..._
# "Is independently deployable and scalable"

## Scaling up or out

For systems that may experience growing load, or demands high availability, it is important to be able to scale the system.

More load can be managed by either vertical (up) or horizontal (out) scaling. Vertical scaling is achieved by adding
more resources to the existing system, like purchasing beefier servers with more memory or CPU cores. Raising
availability by vertical scaling means expensive redundant server components like dual power supplies, network cards and
RAID hard drives. While hardware is getting faster and cheaper, this approach will only get you so far, and eventually
the system will reach a limit where it is not feasible to add more resources.

While scale up is usually the only option for monolithic systems, microservices can enjoy the benefits of horizontal
scaling, where more cheap commodity servers are added to the system behind a network load balancer to provide almost
linear scale in performance and availability.

![Seedlings photo by J. Garget](/images/2023/seedlings.jpg)

## Independently deployable

As stated in the previous post, a microservice should not have dependencies to other services. This is the first step
towards safe deploys, where a service can be updated and redeployed without affecting consumers.

This can also enable independent scaling, or elasticity, where a service behind a network load balancer can be scaled
up or down without affecting other services. More nodes can be added dynamically at peak load times and stopped again
when load decreases. In the cloud service that only charge for running time this is a very cost-effective solution
for handling dynamic load. As opposed to paying for a group of idle servers, just waiting for that peak day of the month.  

## Deterministic and stateless

The load balancer can choose to send an incoming request to any service node. The processing of the request should
ideally come up with the same result no matter what joined service that processed it. To achieve this the services
must behave deterministic and stateless.

Stateless means that no state is shared between requests within the service and can only be stored in the persistent
backend database shared between the nodes. Therefore, special care must be taken with static singletons for things like
incremental counters, in-service caching where one request will influence the next.

Processing that takes input from random number generators or server-generated timestamps makes requests
non-deterministic. The fact that a server's real time clock drift means each node will produce different responses to
the same request, and these inputs should ideally be avoided or generated by the shared backend database.

## Conclusion

So, to wrap up, microservices should be independently deployable and scalable. For this cool trick to work the services
must be stateless and deterministic, so that the processing of a request will produce the same result no matter what
joined service that processed it. This enables horizontal scaling, where more cheap commodity servers can be added
and join the load balancer during dynamic peak system load.

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next post we will explore how to expose a useful REST interface for the resource.
Again, thank you for reading and have a wonderful day!

---

## References

- [Independent deployment](https://martinfowler.com/articles/microservice-trade-offs.html#deployment) by Martin Fowler
- [Containers and microservices — a perfect pair](https://developer.ibm.com/learningpaths/get-started-application-modernization/intro-microservices/containers-and-microservices/) by IBM
- [Scaling Stateful Services](https://www.infoq.com/news/2015/11/scaling-stateful-services/) by InfoQ
