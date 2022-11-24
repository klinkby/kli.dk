---
date: "2022-11-23T18:48:00Z"
title: "Consistency in distributed systems"
description: "Distributed transactions vs eventual consistency"
tags:
- security
- data
- architecture
images:
- "/images/2022/bullseye.jpg"
---

![image](/images/2022/bullseye.jpg)

# Consistency in distributed systems

## ACID transactions ❤️

While distributed systems, in particular microservices have many obvious benefits, like the ability to deploy small contained units, scalability and so on, distributed systems also come at a cost. Some of which may not be obvious to developers that have more experience in monolithic- or client-side applications.

Traditional monolithic applications usually come with a single ACID compliant database. That acronym's A is for Atomicity, which means the database engine guarantees that a write transaction - event if it spans multiple entities and types of changes -  either completes in full or in rolls back to the starting point - there is no middle ground. Even if the monolithic application crash or server power outage at the very most critical moment, that database is consistent when the application restarts. Thank you, two-phase commit (2PC).

A unit of work in a single microservice should behave in exactly the same way. E.g. a PUT operation that change a resource cannot leave the resource in its persistent database in an inconsistent state. That is usually not too hard to achieve in simple operations, because locally, they can enjoy the same benefits as the monolithic application. 

## Secondary data stores

That's all sweet and dandy... unless that operation cause updates in multiple data stores (database, file, or whatever) - either in that same microservice, or if it request mutations in other microservices. In that case, even if the individual databases guarantee atomicity, the microservice can crash at a time where only the first database is updated, and the other are not. If that PUT operation was a customer's order confirmation transaction that contains two units of work: 1) sent the order to shipment, and 2) withdrew an amount from customer's credit card -- well, that order shipment would never be paid for.

Unfortunately, the two-phase-commit, that worked so well for a single database, is really hard to implement reliably in a distributed system, because it is a blocking protocol, reducing throughput, it is prone to introduce deadlocks and the nescesary added distributed transaction coordinator suddenly becomes a a single point of failure. 

## Eventual consistency and the Saga pattern

For systems that can does not require guaranteed strict transactional integrity, another option is to accept eventual consisitency. That means state across systems at any point in time may be inconsistent, but sooner or later they will become consistent.

Most commonly the "Saga"-pattern is implemented to achieve this. The saga handles the asynchronous execution of individual serivices, and may based on an event store or message bus for reliable execution. A simple saga can be fan-out or chain of service executions, which works well in handling transient faults, especially if the operation input can be reliably verified at initial reception. If a service fails deterministically, and the saga needs to be compensated to roll back, it clearly becomes more complex as the resource to compensate may be already changed by another transaction. Services that participate in sagas must be idempotent as operations might be retried.

Benefits of saga are low latency and no deadlocks, but because of the transactions are distributed over systems and in time, they are hard to debug. An appliation that observe state across multiple resources will see those transient inconsistencies, which also affects backup/restore operations - let me know if I should go into that in a future post.

## Conclusion

Changing data consistently across multiple distributed resource services requires careful design and implementation compared to its classic monolithic counterpart. If strict atomicity is not required, consider using the [Saga-pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/saga/saga).

---

Hat tip to Marco Verch for CC-licensing the [image](https://www.flickr.com/photos/30478819@N08/51221838092).