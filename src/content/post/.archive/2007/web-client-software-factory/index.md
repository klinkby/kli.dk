---
author: Mads Klinkby
categories:
- .net
date: "2007-04-12T22:00:00Z"
description: ""
draft: false
slug: web-client-software-factory
tags:
- .net
title: Web Client Software Factory
---


Late March the Patterns & Practices team at Microsoft released the first [Web Client Software Factory](http://www.codeplex.com/websf) (WCSF) package. In short it's a set of application blocks that implements basic functionality for a composite website based on proven design patterns.

The "composite part" means you can easily add new business modules to extend a the website with little change to existing implementation.

Of course business logic, presentation and views are in separate layers. Usually you will find page flow wowen in the view. The WCSF handles this brilliantly by separating it in a [WWF](http://msdn2.microsoft.com/en-us/netframework/aa663328.aspx) based controller.

Many objects often means lots of contruction boiler plating, this is avoided by implementing an object container that implements true [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection) with on-demand creation of services.

Also included are transaction handling, exception handling, logging and other things found in the Microsoft enterprise building blocks.

Nice work guys.

