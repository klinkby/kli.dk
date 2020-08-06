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

## My problem with Ghost
My blog has been served from the NodeJS based [Ghost](https://ghost.org/)
platform for [some years](../../2016/ghost-blogging-platform/) from a small
Linux VM in Azure.

Ghost is a great authoring experiance but I wanted to avoid maintaining the VM
components, and to have a safer repository that does not require backing up page
content on the VM.

## Now meet...
![HUGO](/post/2020/hugo/hugo-logo-wide.svg)


The new setup is based on maintaining the content pages as markdown files in Git.
Static site framework [Hugo](https://gohugo.io/) eventually compiles the
pages and merges a [theme](https://themes.gohugo.io/hugo-theme-cactus/) into
final HTML files, then uploads the lot to an Azure blob store to form a static
website. In front of that I added a free Cloudflare reverse proxy service to
manage DNS, edge caching, transport security and DDOS resilience.

## Resources
The following  helped me convert the site:

- https://dwmkerr.com/migrating-from-ghost-to-hugo
- https://github.com/jbarone/ghostToHugo
- At some point I might add [CD like Andrew Connell suggests](https://www.andrewconnell.com/blog/automated-hugo-releases-with-github-actions/)

Comments? Please reach me at [@klinkby](https://www.twitter.com/klinkby).