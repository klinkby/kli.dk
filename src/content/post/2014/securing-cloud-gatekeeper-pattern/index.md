---
author: "@klinkby"
keywords:
- cloud
- security
date: "2014-07-05T22:00:00Z"
description: ""
draft: false
slug: securing-cloud-gatekeeper-pattern
tags:
- cloud
- security
title: Securing cloud apps
---

## Almost daily

<span>...the tech news goes breaking with stories about breached sites leaking their sensitive personal data or credit
cards of their trusting users to evil hackers.</span>

It seems to happen to everyone. The new
book [Cybersecurity  and Cyberwar](http://www.amazon.com/gp/product/0199918112/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0199918112&linkCode=as2&tag=klinkby-20&linkId=ZCZUIVU2F6MUHO37)
out of Oxford University say 97 % of Fortune 500 companies acknowledges to have been hacked and the remaining 3 % are
simply ignorant. Many of these companies’ most valuable information is their user’s data, and they can afford some of
the best experts to secure that data. So keeping data safe from hackers is obviously very, very hard.

## Business as usual

Lately I have been thinking more about security for applications in the cloud. One thing is to keep data secure on your
internal network, but to deploy applications to the internet that have access to that data is another task that requires
careful planning.

Below is the most common pattern for modern web applications that provides good performance and is easy to deploy.

![sketch](/images/2014/web-1.jpg)

Requests from an internet user hit the web server. A web service running on the server processes the request on behalf
of the user and accesses the specific data on the database backend, which in turn the application responds to the user.

Let us for a moment replace the user with a hacker. The hacker knows there
are [bugs  in the application software](http://queue.acm.org/detail.cfm?id=2602816), the web server or the server
operating system. By carefully constructing specific requests to that exploits software bugs the web server opens up a
backdoor to escalation of privileges or remote code execution, which enables the hacker to tap unrestricted information
from the database.

Can you spot the problem? All the application’s secrets like database access credentials, cached data from other users
is right there on the machine on the internet.

Architects might object that in practice e.g. Microsoft Azure puts a load balancer in front of the web server so it is
not directly exposed. However, it is simply a Layer-4 load balancer, which routes TCP traffic to one of the active role
instances.

## Reverse Proxy

One way to harden the application would be to move the application logic off to a backend server that cannot be
addressed from the internet. Instead exposing a reverse proxy that screens and sanitizes the requests before sending
them on to the privileged backend server. In an on-premise solution, this role would typically be a Microsoft TMG (ISA)
server.

Have a look at this special case of
the [Gatekeeper  Pattern](https://blogs.msdn.com/b/sdl/archive/2010/06/16/10024587.aspx?Redirected=true) that I propose:

![sketch](/images/2014/web-2.jpg)

Again, requests from a user hit the public web server. It returns all static content like html and scripts directly as
in the above diagram. Dynamic requests to the application’s web service however, the
deployed  [Application  Request Routing](http://www.iis.net/downloads/microsoft/application-request-routing) IIS
extension, forwards to an internal endpoint on a backend web server, which is running the custom application logic that
communicates with the database. In a HTML5 application e.g. that could be all requests to the path */api/**. Moving the
application logic off the public web server greatly reduces the attack surface of that server, and in case it should get
compromised, the server contains no secrets at all.

Being a more complex architecture, it requires a few more instances with more clearly defined roles. The public web
server serves static content and provide SSL termination, while the backend server solely runs the custom web service
logic.

## How to

The ARR extension is by default not installed in Cloud service web roles so that should be installed and configured
using a [role startup task](http://robindotnet.wordpress.com/tag/azure-arr/).

Last Thursday Microsoft announced a GA
for [load  balancing internal endpoints](http://azure.microsoft.com/en-us/updates/general-availability-internal-load-balancing/)
so set up one of those to<span>load balance the internal endpoints of the backend role instances.</span><span>Then wire
the URL rewriter</span><span>up to fetch dynamic data from that.</span>

## Summary

Architects and developers have to start thinking much more defensively about solution design in a cloud environment.
What I have proposed in this post is a pattern that may help keeping common web applications a bit more secure.

