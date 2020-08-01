---
author: Mads Klinkby
categories:
- .net
date: "2007-12-02T23:00:00Z"
description: ""
draft: false
slug: authentication-prompt-opening-office-doc-from-vista
tags:
- .net
title: Office proxy
---


Microsoft just announced the release for Office SP1 will be out on December 11th. One of the slides in the presentation has a workaround for the "Opening an Office document on an internal SharePoint site from Vista client prompts for authentication"-issue.

> Configure a fake proxy and configure to bypass for the site
>  Internet Options -> Connections -> LAN Settings ->
> 
> - click Proxy Server check box
>  Address: fakeproxy port: 80
>  - click Bypass proxy server for local addresses
>  - click Advanced and put a * in the exceptions so client can access external addresses as well
> 
> Office Integration Support investigating with Windows

