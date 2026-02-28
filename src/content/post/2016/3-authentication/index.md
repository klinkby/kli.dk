---
author: "@klinkby"
keywords:
- security
date: "2016-03-25T23:00:00Z"
description: ""
draft: false
slug: 3-authentication
tags:
- security
title: 'Hardening web apps: 3. Authentication'
---

# Hardening web apps: 3. Authentication

This third post in the [blog series](../1-hardening-web-apps-introduction) goes into detail about authenticating users
but first<span>, let's agree there is no sane way of implementing authentication without an underlying transport
encryption.</span>

## Transport security

Because of man-in-the-middle attacks, any information transmitted over the internet without using strong encryption you
can safely assume is public knowledge. Some would argue that is also the case for data transmitted on an enterprise
corporate LAN.

Basically to enable transport security you need a certificate authority that you clients' browsers trust to issue a
public/private key pair in form of a certificate. The private key is kept secret on your front end web servers and used
for decrypting an incoming request and encrypting the response by adding an SSL layer on top of HTTP. Instead of using
port 80 HTTPS defaults to port 443.

It is best practice to have a short SSL certificate lifetime to minimize damage should a certificate be exposed without
your knowledge. For example, certificates issued by the [LetsEncrypt](https://letsencrypt.org/) initiative have 90 days'
lifetime to encourage automated certificate renewal. However, these tools are not yet ported to IIS. If you just need
standard domain validated certificates go with 1 year certificates from any cheap certificate authority. Besides domain
validated (DV) certificates, that basically tells your users the can trust you have some sort of control over the
internet domain name, there are also organization validated (OV) and extended validation (EV) certificates. Forget about
OV, and purchase the quite expensive EV only if your users require that you prove your legal entity.

The excellent online [Qualsys SSL Server Test](https://www.ssllabs.com/ssltest/) will check your HTTPS configuration for
weaknesses and score it accordingly. Unless you really need to support legacy WinXP there is no reason to go for less
than an A. Retest your configuration periodically as holes in cryptography are commonly discovered. In reality several
classes of cryptography that was thought to be secure a year ago are now completely useless.

## Authentication

Web apps usually need to have some sort of way to identify its users e.g. to restrict access to a partitions of
persisted data.

Legacy systems on corporate LANs would traditionally simply use integrated Windows authentication (IWA), however it will
not work over the internet or from small devices. Another classic, form based authentication (FBA) is still a fair
choice for really simple scenarios.

For maximum flexibility use [OpenID Connect](https://openid.net/connect/). That will enable your users to sign in using
their existing Facebook, Google, Microsoft or whatever account, and you will not have to deal with storing passwords,
let alone support forgotten passwords scenarios.

Do not try to design, or let alone implement your own magic cryptography or user authentication. Writing security
libraries is extremely hard, and unless you are in the security library business go and reference a good battle proven
open source component instead, e.g.
the [OWIN middleware](https://www.microsoftpressstore.com/articles/article.aspx?p=2473126).

Always generate secrets using a strong random number generator (i.e. from the `System.Security.Cryptography` namespace).
Let me explicitly mention that System.Guid or System.Random was never meant for this level of randomness and should not
be used for secrets.

Microsoft currently have [Azure AD B2C](https://azure.microsoft.com/en-us/services/active-director-b2c/) in preview.
Built on Azure AD that handles billions of sign-ins per day, but targeted towards consumers it looks promising with
advanced features like multi factor authentication, however still in preview and
has [some shortcomings](https://azure.microsoft.com/en-us/documentation/articles/active-directory-b2c-limitations/).

> Read the next post in the blog series about mitigating [cross site attacks](../4-browser-headers/).

