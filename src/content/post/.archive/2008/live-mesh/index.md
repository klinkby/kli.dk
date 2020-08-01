---
author: Mads Klinkby
categories:
- .net
- mesh
- microsoft
- www
date: "2008-04-29T22:00:00Z"
description: ""
draft: false
slug: live-mesh
tags:
- .net
- mesh
- microsoft
- www
title: Live Mesh
---


Microsoft's latest technical preview in the [Live](http://live.com) line called Mesh really caught my attention.

First it's not every day Microsoft releases something that's not in some way related to Office or a Windows server, and at the same time being a [ scalable, stable](http://research.microsoft.com/users/misard/papers/osr2007.pdf) and free service.

Secondly it's based on a [Ray Ozzie](http://www.microsoft.com/presspass/exec/ozzie/default.mspx) idea, which basically means it's decoupled peer-to-peer technology like [ Groove](http://office.microsoft.com/en-us/groove/HA101656331033.aspx), with transparent synchronization based on open standard [FeedSync](http://en.wikipedia.org/wiki/FeedSync).

It allows you to loosely connect your PCs, Macs, mobile phones and whathavewe to a mesh, i.e. a P2P grid. Each device can publish objects or files to the mesh, and Mesh will the transparently synchronize objects/files between the devices or persist them on the 5G free online storage Microsoft provides.

On first sight it looks a bit like [Wuala](http://wua.la/), but note that Mesh is not restricted to files, and more importantly it's an open interface. No, it's more like [Google App Engine](http://code.google.com/appengine/), but not restritected to Python: Mesh objects can be interfaced via .NET, REST, RSS, JSON, file system, VB, etc.

Currently the technical preview <strike>is available</strike> though Connect, and Microsoft expect the API to be released on the PDC in fall '08.

The only thing I quite don't get now, is how is M$ going to make money on this? Take a look at [ JamieG's post](http://www.crafted.com.au/blog/2008/04/30/an-understandable-description-of-microsoft-mesh/) for some interesting thoughts on that aspect.

More on [Mesh.com](http://mesh.com/).

