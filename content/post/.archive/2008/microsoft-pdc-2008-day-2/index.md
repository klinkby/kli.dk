---
author: Mads Klinkby
categories:
- .net
- microsoft
- pdc2008
date: "2008-10-27T23:00:00Z"
description: ""
draft: false
slug: microsoft-pdc-2008-day-2
tags:
- .net
- microsoft
- pdc2008
title: Microsoft PDC 2008 day 2
---


**Keynote 1** Ozzie announced the poor kept secret Windows 7 as a solid foundation for new possibilities. New features include Paint and Wordpad now got ribbons (yea), the latter supports openxml. The (yet again) new taskbar pre-beta (build 6933) was demonstrated, and touch functionality in IE and Word was shown, which is good for those with touch screens. *Updated: An older build 6801 was handed out after the session.* The proudly presented Workgroup networking V2.0, called Homegroup. It automatically allows access to documents, pictures and printers on your home network. Other new features presented was Ribbon, Ink, Speech and DirectX plus fundamentals a ka scalability, responsiveness and load times. - Hey -- waitaminute... Wasn't that what Vista was announced to provide? Oh well...  But the UAC has been relaxed. Two other things worth noting is the disk manager now supports mounting  .vhd  images - and boot from them. And remote desktop now supports dual montor setup. Visual Studio 2010 will include a rewritten text editor that takes advantage of WPF to provide cool extensibility: A custom WPF control was shown that replaced a class comment in the actual text editor. A new Silverlight designer and jQuery intellisense is also on its way. The Live Services will support OpenID, and today Phone and Mac support was announced. Phone support was demonstrated when one presenter pulled out a WM phone and took a picture. Thanks to Live Mesh, the image appeared seconds later on the PC. Pretty cool! **Keynote 2** The presentation everyone have been looking forward to, where Cris Andersson and Don Box had their take on WCF as applied to Azure Services. Today the traditional Box tool Emacs was replaced by Visual Studio. :-)  Lot of basic REST here using HttpWebRequest. The finally ended up publishing a web service in the cloud, that pulled data from SQL Online. The news here was how easy it is to publish web services to the internet. It's all about Urls, Http and Xml. **Concurrency & Coordination Runtime and Decentralized Software Services** It's better than the old "Robotics", but I sure hope somebody soon comes up with a better name for this cool API Microsoft Research has developed with robotics industry in order to process highly parallel operations on many cores in a distributed environment with the least overhead and in a fail tolerant environement. The speaker mentioned Siemens was running an OCR application on this platform that handled 500.000 operations/sec. The ASP in Live.com also uses this technology. You could say this is the "Extreme Edition" of Parallel Fx that will be incorporated in the next .NET core. It has a fresh perspective using 1 thread pr. core + dispatcher queues but no thread locks or synchronization. Instead it relies on a service based publish/subscribe pattern and ports for sending asynchrous messages. This is propably common knowledge for RTOS people, but it's definately a new way of thinking for traditional Win32 coders. One of the common headaches in parallelizing operations is exception handling. The error could be raised on another machine, while lots of other related operations have been kicked off to be processed in the meantime. The DSS handles this by setting a root cause, and letting the exception bubble to that port, letting that particular port handle it. Instead of synchronization, clever use of "yield return port.Recieve();" enables asynchronous operations to wait on each other. It runs on Compact framework, is lightweight with little overhead. He mentioned a port is 24 bytes and a single core box would see an added 5% overhead by using this framework. In a futureversion the task scheduler will merge with the one in Parallel Fx, and the speaker expected we would see it in the framework within a few years. **The OSLO language: M** For many reasons domain specific languages and code generation and major trends today. As Hejsberg put it: "It's about describing what, not the how". Until now many xml based DSLs have emerged, and Microsoft's codename Oslo contains three things to help creating DSL:The visual editor Quadrant, a model store and the new DSL schema language codename 'M'. The presentations was done mostly by Don Box. He started one of his examples like this: "A guy comes into a bar, start writing m-models", and the audience cracked. The demonstration showed how to create database creation statements from M without writing any T-SQL. It looked ok, but I guess it would have been cool if they had built an entity model from the dsl as well, but it's propably still too early.
