---
author: Mads Klinkby
categories:
- .net
date: "2007-08-18T22:00:00Z"
description: ""
draft: false
slug: securer-forms-authentication
tags:
- .net
title: Securer Forms authentication
---


Unless you have a server certficate and a HTTPS website, forms authentication means sending plain text passwords over the internet. 

A way to avoid this is to use a challenge response protocol, where the server first sends a key to the client, and the client then uses the key to encrypt the password into a hash code before it is sent to the server. The server then computes the same hash code and verifies the client's hash code against it. Neat, isn't it?

Of couse a hacker could still employ session hijacking and replay posts, so obviously it's not as secure as SSL. On the other hand you don't need a certificate to use this and still avoid plain text passwords over the wire.

Inspired by [Paul A. Johnston](http://pajhome.org.uk/crypt/md5/auth.html) and using his SHA-1 javascript, I implemented a simple ASP.NET login control.

Note the control allows persisting the login to enable autologin. The current imlementation of this lowers security a great deal, as it is not session-based.

[[ Download](http://cid-a9f3560513ea82b1.skydrive.live.com/self.aspx/Public/CHAP.zip)]

