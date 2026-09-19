---
date: "2026-09-19T05:45:00Z"
title: "Hosting on GitHub Pages"
description: "The blog left the self-hosted Hetzner box for GitHub Pages — for convenience, and at a cost."
tags:
- Www
- DevOps
---

# Hosting on GitHub Pages

Earlier this year I [moved the blog off Azure]({{< ref "/post/2026/cloud-native-hosting" >}}) to a
self-hosted, cloud-native setup on Hetzner: Hugo compiling Markdown into a tiny Lighttpd container,
fronted by HAProxy for TLS. It was cheap, portable, and mine.

It was also one more thing to keep patched and alive for a site that changes a few times a year.
So I gave in to convenience: the blog now lives on GitHub Pages. The source still sits in
[klinkby/kli.dk](https://github.com/klinkby/kli.dk), a GitHub Actions workflow compiles it with
Hugo on every push to `main`, and Pages serves the result at `www.kli.dk`. No container, no server,
no certificate renewals. DNS is still Cloudflare.

The trade-off is real. I lost the control the container gave me — the custom
`Content-Security-Policy` and cache headers Lighttpd set, the HTTP/2-over-Unix-socket plumbing, and
the freedom to host the exact same image anywhere. And having spent [a whole post]({{< ref "/post/2026/cloud-native-hosting" >}})
grumbling about European dependence on US tech giants, handing the hosting straight to GitHub is not
exactly a step toward data residency. Convenience won this round. Alas, Europe still has some way to go.
