---
author: Mads Klinkby
categories:
- .net
date: "2008-03-23T23:00:00Z"
description: ""
draft: false
slug: aspnet-mvc
tags:
- .net
title: ASP.NET MVC
---


I played a bit with the [ MVC preview 2](http://www.microsoft.com/downloads/details.aspx?FamilyID=38cc4cf1-773a-47e1-8125-ba3369bf54a3&displaylang=en). From an architectural point the new the [building block](http://en.wikipedia.org/wiki/Model-view-controller) is very much appreciated, and in many ways it reminded me of the [Web Client Software Factory](http://msdn2.microsoft.com/en-us/library/bb264518.aspx), I used in a project for a client some time ago. Lots of similarities here. But where WCSF depends on the huge [enterprise library](http://www.codeplex.com/entlib), the new MVC just references three assemblies.

Though it isn't supported in [Visual Web Developer 2008 Express](http://www.microsoft.com/express/vwd/), it isn't very hard to get to work in this "home"-edition ([ thanks](http://mrpmorris.blogspot.com/2008/03/small-sample-website.html)). You can download my solution and use it as a start for your own projects. It implements a really basic web site, where the model simply generates [fibonacchi numbers](http://en.wikipedia.org/wiki/Fibonacci_number) (yes, I've done too much F# lately), a view that displays the numbers and a demonstrates linking to views, and a controller that has an optional querystring parameter.

[[Download solution](http://kli.dk/blog/MVCWebSite.zip)]

