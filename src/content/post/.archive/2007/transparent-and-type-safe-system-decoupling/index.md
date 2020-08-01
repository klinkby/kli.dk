---
author: Mads Klinkby
categories:
- .net
- type
- xml
date: "2007-10-04T22:00:00Z"
description: ""
draft: false
slug: transparent-and-type-safe-system-decoupling
tags:
- .net
- type
- xml
title: Transparent and type safe system decoupling
---


A common headache in [ enterprise application integration](http://en.wikipedia.org/wiki/Enterprise_application_integration):   

> How do you make messages sent from one system to another completely independant, extensible yet strongly typed?

  By writing out Xml-messages and authoring tedious Xsd schemas to validate against? I guess that's one way to do it. If you got all the time in the world. Using my favorite [C# compiler](http://msdn2.microsoft.com/en-us/vcsharp/) I did a small implementation of the [ Pipes and Filters](http://www.enterpriseintegrationpatterns.com/PipesAndFilters.html) pattern that have some interesting characteristics:   

*   Each filter and message type can be completely independant. So when upgrading a filter or extending a message the new versions are not required to inherit from the existing type.
*   Two connected filters doesn't have to reference the same assembly that provides a common message type.
*   Concrete filters are implemented using strongly typed .NET parameters. The base class acts as a transparent proxy. See below.
*   Messages are piped in XML format, so a filter could be written in any programming language on any platform.  Example filter implementation: [sourcecode language='csharp']class Filter1 : BaseFilter<object, Message1> // input = dummy object { Â public Filter1(IFilter next) : base(next) Â { } Â protected override Message1 Process(object context) Â { Message1 message1 = new Message1(); Â  Â message1.Foo = "I'm from Message1"; Â  Â return message1; Â } }[/sourcecode] Take a look at the solution and tell me what you think. [[Download](http://kli.dk/blog/Klinkby-Decoupling.zip "Download solution (6.4 kB)")]

