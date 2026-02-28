---
author: "@klinkby"
keywords:
- dotnet
date: "2008-03-10T23:00:00Z"
description: ""
draft: false
slug: beware-of-the-evil-publish
tags:
- dotnet
title: Beware of the evil Publish
---


Visual Studio has a function that can publish your web application to an IIS. Nice - but dangerous if the IIS maps a
virtual dir to your project directory: I learned the hard way that Visual Studio can decide to wipe all your source
files! ![publish](http://static.getya.net/013/images/publish.gif)

