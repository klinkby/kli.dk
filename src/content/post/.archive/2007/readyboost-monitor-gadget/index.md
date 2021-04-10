---
author: "@klinkby"
keywords:
- dotnet
- soap
date: "2007-05-26T22:00:00Z"
description: ""
draft: false
slug: readyboost-monitor-gadget
tags:
- dotnet
- soap
title: ReadyBoost Monitor Gadget
---


If you connected that high speed flash memory to your Vista pc to enable the [ ReadyBoost](http://blogs.msdn.com/tomarcher/archive/2006/06/02/615199.aspx) cache, you might wonder how efficient it is. Well... I did.

To monitor its efficiency you can launch the Performance Monitor in Vista, [ elevate credentials](http://technet.microsoft.com/en-us/windowsvista/aa906021.aspx), scroll down to the ReadyBoost category and add a some counters to display. Or you could write a gadget that instantly displays how efficient ReadyBoost really is.

One problem is that the Sidebar process is not elevated by default, so unless you elevate it manually or disable UAC and log in as administrator, the gadget can't read the ReadyBoost performance counter data (PCD).

So the data has to come from somewhere else. I wrote a small Windows Service that runs with [localsystem](http://msdn2.microsoft.com/en-us/library/ms684190.aspx) credentials and reads the PCD. A small calculation is performed, the data is averaged and published as a WCF web service by the service itself.

The gadget then uses XMLHTTPRequest to get the data from the service and displays it in a nice graph.

Source is included of course. Open the readme.txt in the zip archive for installation instructions.

[Download](http://www.kli.dk/blog/Klinkby-ReadyBoost-Monitor.zip)

