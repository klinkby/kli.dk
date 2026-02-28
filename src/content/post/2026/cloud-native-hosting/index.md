---
date: "2026-02-28T13:37:00Z"
title: "Cloud-native hosting"
description: "My blog moved from Azure cloud to self-hosted on Hetzner."
tags:
- Docker
- Linux
- Www
- DevOps
---

# Cloud-native hosting

In Europe, there is currently a lot of talk about data residency and decoupling from the power
of US tech giants. A lot of cool technologies and practices have emerged from the cloud. But many 
PAAS services means vendor lock-in, making it difficult to move to other providers.

For one of my customers, I have been working with [cloud-native](https://www.cncf.io/) technologies and products for years. 
It gives the benefits of DevOps, zero-trust and modern technologies while providing unlimited
flexibility and freedom to host anywhere, in the cloud or on-premises.

[Hetzner](https://www.hetzner.com/) is a popular provider for cloud-native hosting as it is cheap, reliable and it has a convenient
control plane. With the right middleware, a single small Linux server can handle an impressive amount of traffic.

This blog is a static web site, compiled from [Markdown-files](https://github.com/klinkby/kli.dk) 
with the Hugo, to the tiny Lighttd web server on the minimal Alpine Docker base image. 
The image is around ~10 MB and consumes ~1½ MB of RAM.

The web server hosts the static pages via unencrypted HTTP/2 (H2C, prior knowledge) via an efficient 
Unix socket to [HAProxy](https://www.haproxy.org/) that provides TLS termination and traffic sanitization. SSL-certificates are 
generated via [Let's Encrypt](https://letsencrypt.org/)'s free ACME script.

This setup is very simple and easy to maintain, and can be scaled and hosted anywhere.
