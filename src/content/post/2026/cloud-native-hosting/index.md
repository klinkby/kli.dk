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
of Trump-flattering US tech giants. A lot of cool technologies and practices have emerged from the cloud. While convenient, PAAS services and IaS also means vendor lock-in, making it extremely difficult to move to other providers.

For one of my customers, I have been working with [cloud-native](https://www.cncf.io/) technologies and products for years. 
The open souce licence model also gives the benefits of DevOps, zero-trust and modern technologies, while providing unlimited
flexibility and freedom to host anywhere, in the cloud or on-premises.

This blog is a static website, compiled from [Markdown-files](https://github.com/klinkby/kli.dk) 
with the [Hugo](https://gohugo.io/), to the tiny Lighttd web server on the minimal Alpine Docker base image. 
The image is around ~10 MB and consumes ~1½ MB of RAM.

The web server hosts the static pages via unencrypted HTTP/2 (H2C, prior knowledge) via an efficient 
Unix socket to [HAProxy](https://www.haproxy.org/) that provides TLS termination and traffic sanitization. SSL-certificates are 
generated via [Let's Encrypt](https://letsencrypt.org/)'s free ACME script.

I chose to host the service at [Hetzner](https://www.hetzner.com/), a popular provider for cloud-native hosting as it has a local datacenter 
here in Scandinavia, it's cheap, reliable, and has a convenient control plane.

With the right middleware, a single small Linux server can handle an impressive amount of traffic. This setup is just as 
easy to maintain as my previous Azure-bound service and can be scaled and hosted anywhere.

Still, US tech completely dominates my tech stack. The source code and CI pipeline is still on feature rich GitHub 
[klinkby/kli.dk](https://github.com/klinkby/kli.dk), the container image available conveniently on 
[Docker Hub](https://hub.docker.com/repository/docker/klinkby/kli.dk), DNS is CloudFlare (not proxied though), and the code conversion was implemented in an hour 
by Antrophic's [Claude](https://claude.ai/) LLM. 

One small step. Alas, Europe has some way to go.
