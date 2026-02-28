---
author: "@klinkby"
keywords:
- dotnet
date: "2007-04-24T22:00:00Z"
description: ""
draft: false
slug: readyboost
tags:
- dotnet
title: ReadyBoost
---


The new Vista technology ReadyBoost caches the page file on fast flash memory. So to improve performance of memory-hawk
Vista x64, I got a [ 150x speed 2GB SD card](http://www.transcendusa.com/products/ModDetail.asp?ModNo=87&LangNo=0) for
my notebook.

Unfortunately there are no x64 MS drivers for the TI PCIxx21 controller in my notebook, but after a good deal of search
I managed to find a compatible driver
on [cardr_x64_(dv8000).zip](http://www.foxframes.net/download/cardr_x64_(dv8000).zip "cardr_x64_(dv8000).zip"). The
setup program doesn't seem to work, but you can update the driver for PCI\VEN_104C&DEV_803B from the Device Manager.

Then insert the media, quick format it to FAT32 allocation size 4096 and finally enable ReadyBoost. Windows will then
build the ReadyBoost.sfcache file on the drive.

[ More on ReadyBoost](http://blogs.msdn.com/tomarcher/archive/2006/06/02/615199.aspx)

