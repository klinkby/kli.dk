---
date: "2023-05-17T16:20:00Z"
title: "Quality attributes for microservices"
description: "Distinctive characteristics of good microservices"
tags:
- security
- data
- architecture
---
<!-- images:
 - "/images/2022/bullseye.jpg" -->

# Quality attributes for microservices

In my humble opinion a good microservice...

1. Exclusively owns logic and persitence for a narrow coherent set of business entities.
1. Is independently deployable and scalable.
1. Provides a well-defined, interoperable resource-centric interface.
1. Guarantee atomicity and idempotency for simple operations.
1. Guarantee eventual consistency for complex operations.
1. Can tell its healthiness, and is observable from distributed tracing and streaming logging.
1. Implement operations that are stateless, non-blocking (I/O) and handle blobs unbuffered.
1. Externalize cross-cutting policies to upstream infrastructure services.

In future posts I will elaborate on why I think each of these attributes matters.
