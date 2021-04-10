---
author: "@klinkby"
keywords:
- www
- cms
- cloud
date: "2016-04-20T17:43:00Z"
description: ""
draft: false
slug: ghost-blogging-platform
tags:
- cloud
- cms
- www
title: Ghost blogging platform
---

# Ghost blogging platform

Moved my blog to the open source [Ghost](https://ghost.org/) platform. Notable features are the use of markdown to format articles, and being based on the asynchronous I/O web server NodeJS. 

I run it on a basic Azure A0-sized Linux instance. Thanks to Poul-Henning Kamp's amazing [Varnish](https://www.varnish-cache.org) cache  I put in front of Ghost, and using a theme based on [Google AMP](https://www.ampproject.org/) the small server provides a real snappy browsing experience, optimized for handheld devices.

All my posts dating back to 2006 are still available. It is amazing what happened in those 10 years! 

**Thank you for reading <3**

---
==Updated:==

The theme is a fork of the Casper-based [Ampsper](https://github.com/varun-d/ampsper) theme Varun Dhanwantri built. I modified the theme a bit to make it pass  AMP's [built in validator](https://www.ampproject.org/docs/guides/validate.html). Most noticably is the absense of the menu from the original Casper theme. Unfornunately it had to go as AMP does not allow custom scripts. 
You can git it from https://github.com/klinkby/ampsper

My configuration file for Varnish redirects old Wordpress-style `/yyyy/mm/dd/slug` type URLs to `/slug`, and `/rss20.xml` to Ghost's feed endpoint `/rss/`. To speed up things it also allows 60 minutes cachability. Among others, it adds a specific Content Security Policy (CSP) HTTP header for AMP. On https://securityheaders.io/ it validates to A+ browser security. 
See https://gist.github.com/klinkby/938759b66ba808e893b79a16e3ea1cab


