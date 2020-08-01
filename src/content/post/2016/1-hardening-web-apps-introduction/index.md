---
author: Mads Klinkby
categories:
- guide
- iis
- security
date: "2016-03-05T23:00:00Z"
description: ""
draft: false
image: https://pbs.twimg.com/media/Cc4W711UEAE6HjT.jpg:large
slug: 1-hardening-web-apps-introduction
tags:
- guide
- iis
- security
title: 'Hardening web apps: 1. Introduction'
---

# Hardening web apps: 1. Introduction

It's okay. Exposing your latest web app implementation on the big bad internet should leave you somewhat anxious. While browsers have grown up to be more secure lately we are still a long way from secure-by-default, and [the list](https://www.owasp.org/index.php/Category:Attack) <span>of possible attack vectors against web apps is long enough to give *Chuck Norris* the shivers.</span>

Every month Microsoft release [ critical patches](https://technet.microsoft.com/en-us/library/security/ms16-Feb) against remote code execution exploits. Numerous implementations of SSL encryption are deemed unsafe because of renowned attacks like [Heartbleed, Poodle and Drown](https://blog.qualys.com/ssllabs). And even with infrastructure in perfect place, you have to design your application very carefully to keep it from exposing data to malicious sites.

In this blog series I will explain the most common threats and a provide practical guidance on how to block them in a modern web app (*) hosted on IIS in Azure. 

*) "Modern web app" being a single page app using [ AngularJS](https://angularjs.org/) with a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) [Web API](http://www.asp.net/web-api) backend.


## Posts in the series:

1.  [Introduction](../1-hardening-web-apps-introduction) (this post)
2.  [Architecture and infrastructure](../2-architecture-infrastructure)
3.  [Authentication and authorization](../3-authentication)
4.  [Browser cross site attacks](../4-browser-headers)
5.  [Reactive security and monitoring](../5-reactive-security-and-monitoring)
6.  [Operations practices and conclusion](../6-operations-practices-and-conclusion/) 


> Read the next post in the blog series about [designing the infrastructure](../2-architecture-infrastructure/).

