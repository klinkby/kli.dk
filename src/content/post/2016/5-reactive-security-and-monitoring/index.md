---
author: Mads Klinkby
categories:
- hardening
- monitor
- security
date: "2016-04-22T18:01:08Z"
description: ""
draft: false
slug: 5-reactive-security-and-monitoring
tags:
- hardening
- monitor
- security
title: 'Hardening web apps: 5. Reactive security and monitoring'
---


The fifth post in the [blog series](/1-hardening-web-apps-introduction/) covers practical measures for actively defending against malicious users.

## Reactive security measures 

Microsoft’s Office 365 APIs allows a user to make one request per second on average over an undisclosed period of time. Sustained load testing on an Office 365 API will quickly turn into HTTP error <code>429 Too many requests</code>.  After a little “cool off”-time the API will again start serving normal requests.

On Internet Information Server (IIS) the [Dynamic IP Restrictions](https://www.iis.net/downloads/microsoft/dynamic-ip-restrictions) module enables automatic blocking IP specific addresses based on request frequency. It is simple to configure and provides basic protection against denial of service as well as brute force attacks against the web server, i.e. when a hacker tries to guess secrets. 

If you know exactly where your users are coming from, you can also configure IIS with static rules to [deny access]( https://technet.microsoft.com/en-us/library/cc733090(v=ws.10).aspx) from certain IP ranges. 
A variant of this is using the [URL Rewrite Module](https://www.iis.net/learn/extensions/url-rewrite-module/using-url-rewrite-module-20) to block users with certain browser headers, e.g. if you know your users never come from specific countries, simply filter out requests from browsers with those countries’ languages.

To implement an active defense first determine what normal user behavior is and add a large margin to that, because some users may not use your app quite as you expect. The above are general measures and will require you leave quite some margin for your users to actually interact with your app.
But given you design your app smarter to detect when a user crosses that irrational line, you can really harden the security. For instance it may be normal for a user to make 20 requests within ten seconds. But more than 5 login attempts within one minute might be a bit excessive?

## Security forensics

When the app perimeter is under siege or even breached you will want to know about it as soon as possible of course to gather information about the attack, naturally to be able to close the hole, but also any information about the attackers you can hand over to the authorities for prosecution.

A low hanging fruit is enabling standard IIS logging on your web front to trace all request URLs, user IPs and response codes. Out of the box it does not provide any automated monitoring, but standard log monitoring tools will be able to provide you with an alarm when something starts looking suspicious, e.g. when a user is throttled by the Dynamic IP Restrictions module.

Your app’s code can include an additional custom log of request parameters, and smarter logic for detecting irrational user behavior.

>Read the next and final chapter about [operations practices](/operations-practices-and-conclusion/).

