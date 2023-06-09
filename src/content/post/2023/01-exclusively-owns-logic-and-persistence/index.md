---
date: "2023-06-09T08:22:00Z"
title: "1. Exclusively owns logic and persistence for a narrow coherent set of business entities"
description: "The scope and responsibility of a microservice."
images:
- "/images/2023/parcels.jpg"
tags:
- microservice
- architecture
---

# Quality attributes for microservices - part 1

> This is the first post in [the series](../quality-attributes-for-microservices/) about some ideal characteristics about
microservices, both from the architect's perspective as well as developer's and operations
perspective. In this post we will have a look on the scope and responsibility of a microservice.

_In my humble opinion a good microservice..._
# "Exclusively owns logic and persistence for a narrow coherent set of business entities"

## Micro

As the microservice name suggests, the service should be small. The scope is focused to a single business entity or resource, and compound related entities that can only be understood in the context of the primary entity.

Number of code lines is not a good measure of the size of a service, but the service should be small enough to be build and managed by a single team.

Dividing the system into too many services can lead to a distributed monolith, where the services get tightly coupled and changes in one service requires changes in other services. "Nano services" can also lead to a lot of overhead in terms of deployment and operations.

![Parcels photo by George Hodan](/images/2023/parcels.jpg)

## Entities

Microservices are resource-centric as opposed to traditional RPC-style services, which are operation-centric. The primary business entity could be customer, order or product, or a more technical resource like a user, session or a log entry.

The microservice can also compound related entities that can only be understood in the context of the primary entity. For example, a customer service could have the logic for customer profile, addresses and payment information. But not for orders or products, which would be separate services.

The resources are typically identified by a unique identifier, like a database primary key or a GUID.

In large domain models that are split in several bounded contexts, the microservice should only have the entities that are relevant for its context. That means that the same entity can exist in multiple services, but with different attributes and functionality. For example, a customer service in a sales context would differ from the customer service in a marketing context.

## Operations

The service should expose a set of operations that are relevant for the business entities. This includes any data validation, business rules and calculations. This code logic is not shared or duplicated in other services. This reduces coupling and make it easier to deploy and manage the services independently.

The only exception is shared libraries used for common functionality like logging, configuration and security.

## Persistence

The microservice exclusively owns the persistence for the business entities it handles. The database should not be shared with other services, and the storage engine can be in principle freely selected depending on whether the data are relational, document or graph-like in nature. Because of atomicity and consistency requirements a microservice should only use a single database.

A physical database engine cluster can be shared between services if databases are exclusively separated. For example, a single MongoDB cluster can be used for multiple services, if each service has its own database and there is no crosstalk. This makes it easier to manage things like backups, monitoring and upgrades.

## Dependencies

A resource microservice should not have any dependencies to other services. Tight coupling between services should be avoided as it leads to a distributed monolith.

Decoupling can be achieved by using asynchronous messaging, like RabbitMQ or Kafka, shared between the services in a publisher/subscriber pattern. For example, a customer service could publish a customer created event, which is consumed by other services that need to know about the customer.

Aggregating services, also called "backend-for-frontend" services can be used to combine data from multiple services into a single response. This is useful to supply a facade for a specific client, like a mobile app or a web page. This type of service is always stateless and does not have persistent data.

## Conclusion

Ok, just to wrap up microservices should be focused on a single business entity or resource, highly coupled entities that can only be understood in the context of an instance of the primary entity. The service should exclusively own the logic and persistence for the business entities it is responsible for, and should be maintained by a single team.

If you have any comments or questions, please send me a note on [Mastodon](https://fosstodon.org/@klinkby).

In the next post we will have a look on how microservices can be deployed.
Thank you for reading and have a wonderful day!

---

## References

- [What are microservices?](https://learn.microsoft.com/en-us/devops/deliver/what-are-microservices) by Microsoft
- [Microservices](https://martinfowler.com/articles/microservices.html) by Martin Fowler
- [Domain Driven Design](https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) by Eric Evans
