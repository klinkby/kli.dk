---
author: "@klinkby"
keywords:
- gadgets
- technology
date: "2006-12-15T23:00:00Z"
description: ""
draft: false
slug: striping
tags:
- gadgets
- technology
title: Striping
---


I have had a 250GB Maxtor hard
disk([ 6V250F0](http://www.maxtor.com/_files/maxtor/en_us/documentation/data_sheets/diamondmax_10_data_sheet.pdf))in my
setup for some time, and been very happy with it.
It's [very quiet](http://www.silentpcreview.com/article244-page3.html), has 16 MB
cache, [SATA2](http://en.wikipedia.org/wiki/SATA2#SATA_3.0_Gb.2Fs)
and [NCQ](http://en.wikipedia.org/wiki/Native_Command_Queuing). Recently I added another one of these disks to my box. I
have an Asus A8N-SLI Premium motherboard, that have a nForce4 and a Silicon Image 3114 based RAID controller installed.
The [ nVRAID is faster than the SI](http://www.planetamd64.com/index.php?showtopic=21897&st=40#)controller, so decided
to go with nVidia's. I started out with only the new hard drive cabled, and changed the bios to enable RAID on the
controller. In RAID bios I then added the drive as a stripe (yes that's striping on one drive). I have an XP
installation CD with my motherboard drivers prepared with[nLite](http://www.nliteos.com/), so Windows setup immediately
recognised the RAID controller and installed Windows onto
that. [ ![](http://static.getya.net/013/images/windowslivewriterstriping-d264striping-thumb1.jpg)](http://static.getya.net/013/images/windowslivewriterstriping-d264striping21.jpg)
In Windows I copied data from my old harddisk to the new one. Went back to the bios and added my old drive to the raid
drive pool. In nVidia's MediaShield application I could then add the drive to the stripe, and immediately started
rebuilding the RAID. Pretty easy setup, and it's blazing fast. Update:
See [http://klinkby.wordpress.com/2007/06/18/nvraid-errors/](http://klinkby.wordpress.com/2007/06/18/nvraid-errors/)

