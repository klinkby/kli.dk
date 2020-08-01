---
author: Mads Klinkby
categories:
- .net
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: performance-comparison
tags:
- .net
title: Performance comparison
---


I fell over some posts arguing whether C++.NET is faster than C#. The arguments looked like religion so here is a real world comparison. For the benchmark engine I calculated the first [300 decimals of PI](http://www.personalmicrocosms.com/html/cspc_samples_pi.html). It contains integer and floating point math and some string allocation/manipulation. I ran each test twice on my laptop and noted the second timer reading. Running time for release builds (no debugger attached):   

*   Native C++: 1,22 sec.
*   Native C++ w/profiled optimization: 0,97 sec.
*   C++.NET: 1,02 sec.
*   C#: 1,22 sec.  <strike>You can download the VS2005</strike> [ <strike>test solution</strike>](http://quick.dropfiles.net/download.php?file=273658884bd640747834018400fcd9c8) <strike>and try for yourself.</strike> (please contact me if you want this). Conclusion: The C++ .NET compiler generated code was 16% faster that the C# code. Only with profiled optimization the native C++ compiler performed equal to the managed C++ code!

