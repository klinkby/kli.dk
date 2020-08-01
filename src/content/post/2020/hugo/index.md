---
author: Mads Klinkby
date: "2020-08-01T19:01:30Z"
description: "Moved my blog to Hugo static site"
draft: false
slug: hugo
title: Hugo
tags:
- blog
- www
categories:
- blog
- www
---

# Hugo

My blog has been served from the NodeJS based [Ghost](https://ghost.org/)
platform for [some years](../../2016/ghost-blogging-platform/) from a small
Linux VM in Azure.

Ghost is a great authoring experiance but I wanted to avoid maintaining the VM
components, and to have a safer repository that does not require backing up page
content on the VM.

The new setup is based on maintaining the page source as markdown files in Git.
Static site framework [Hugo](https://gohugo.io/) eventually compiles the
pages and merges a [theme](https://themes.gohugo.io/hugo-theme-cactus/) into
final HTML files, then uploads the lot to an Azure blob store to form a static
website. In front of that I added a free Cloudflare reverse proxy service to
manage DNS, edge caching, transport security and DDOS resilience.

The following  helped me convert the site:

- https://dwmkerr.com/migrating-from-ghost-to-hugo
- https://github.com/jbarone/ghostToHugo

Leave me a message at @klinkby