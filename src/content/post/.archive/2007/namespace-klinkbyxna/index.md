---
author: "@klinkby"
keywords:
- dotnet
date: "2007-03-26T22:00:00Z"
description: ""
draft: false
slug: namespace-klinkbyxna
tags:
- dotnet
title: namespace Klinkby.Xna
---


My[spare time project](/2006/10/13/managed-directx-becomes-xna/), implementing a highly optimized, hardware accelerated
and easy to use graphics control, is really going forward at the moment. I've now replaced the Managed DirectX with Xna,
and done lots of refactoring and optimizing combined with static and dynamic code analysis to get to a point where the
control is extremely fast and flexible.

* Does 2d as well as 3d shapes
* Custom shapes can easily be added
* Flicker free screen updates w/o [tearing](http://en.wikipedia.org/wiki/Page_tearing)
* Multithreaded design avoids any waiting on the main thread
* Real-time updates are done without message-loop overhead
* Running an animation at 60 fps is barely measurable in the task manager
* Only minimum Xna prerequisites: DX9c and a Shader Model 1.0 capable graphics card ** Full alpha blending and
                                                                                       anti-aliazing
                                                                                       support  [![Klinkby.Xna](http://klinkby.files.wordpress.com/2007/03/untitled.thumbnail.jpg)](http://static.getya.net/013/images/untitled.jpg "Klinkby.Xna") *
                                                                                       SM1.0 was introduced in DX8 and
                                                                                       implemented in GPUs after year
                                                                                       2000 such as Geforce 3 series,
                                                                                       Radeon 8500 series, Intel 845G or
                                                                                       newer.

