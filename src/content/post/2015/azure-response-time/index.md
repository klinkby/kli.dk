---
author: "@klinkby"
keywords:
- cloud
- performance
date: "2015-09-30T22:00:00Z"
description: ""
draft: false
slug: azure-response-time
tags:
- cloud
- performance
title: Azure Europe response times
---


A note on response times from the two local Azure data centers to **Copenhagen, DK**.

I created a public BLOB container in each of the data centers North Europe (Dublin, IE) and West Europe (Amsterdan, NL), and monitored the Network tab in Chrome while issusing HTTP requests to the BLOB containers.

Times in miliseconds:
   | Req#            | West Europe     | North Europe    |
| --------------- | --------------- | --------------- |
| 1               | 36              | 50              |
| 2               | 34              | 51              |
| 3               | 52              | 52              |
| 4               | 37              | 50              |
| 5               | 44              | 53              |
| 6               | 40              | 56              |
| 7               | 38              | 50              |
| 8               | 40              | 52              |
| 9               | 36              | 52              |
| 10              | 41              | 54              |
| **Average** | **40**      | **52**      |



In October 2015 the **West Europe** data center provide **23% quicker** response time than the North Europe data center to Copenhagen, DK.

