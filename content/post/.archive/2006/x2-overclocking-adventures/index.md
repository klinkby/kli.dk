---
author: Mads Klinkby
categories:
- .net
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: x2-overclocking-adventures
tags:
- .net
title: X2 overclocking adventures
---


I got (myself) some new hardware for christmas. This post describes my overclocking adventures with the goodies. The new hardware is:   

*   *   *Asus A8N-Premium motherboard* The [ board](http://www.asus.com/products4.aspx?l1=3&l2=15&amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;l3=148&model=539&modelmenu=1) is nForce4 based with passive clipset cooling using heatpipes. The board has x16 PCI express slot for graphics adapter (or x8 when using two graphics adapters in SLI mode).
    *   *AMD Athlon X2 3800+ processor* I really like the responsiveness of an [SMP](http://en.wikipedia.org/wiki/Symmetric_multiprocessing) workstation, but since the good ol' [ BP6](http://www.abit-usa.com/products/mb/products.php?categories=1&model=109) days, dual processors were just not for desktop use. With the introduction of the Intel D and AMD [ X2](http://www.amd.com/us-en/Processors/ProductInformation/0,,30_118_9485_13041,00.html) dual core processors it's again within reach.
    *   *Innovision GeForce 7800GT video card* I do play some 3d games so I chose a reference design 7800GT video card from Innovision. It's just incredible to see the 7800GT is [ faster](http://www.hardwareonline.dk/vis_artikel.asp?aID=105&s=4) that the high end x1800 card from ATI that costs the double.
    *   *Kingston HyperX KHX3200AK2/1G memory* CL2.5? I guess it's value-ram with a heat sink.
    *   *Zalman CNPS9500 cooler* Low noise heat pipe [cooler](http://www.silentpcreview.com/article267-page5.html) in pure copper with 8cm fan.   The hardware installation went smooth. I used the nice free utility [nLite](http://www.nliteos.com/) to prepare a bootable Windows XP x64 edition CD image with integrated nForce4 SATA drivers. After OS installation I installed the 64 bit drivers for my hardware. Note: The Unknown Device in Device Manager disappears when installing Asus AiBooster. I also installed [CPU-Z](http://klinkby.blogspot.com/www.cpuid.com/cpuz.php) for monitoring system frequencies, [7-Zip (x64)](http://klinkby.blogspot.com/www.7-zip.org/) for CPU/RAM load and quick benchmark, and finally [Half Life 2: Lost Coast (x64)](http://klinkby.blogspot.com/www.steampowered.com/) for 3D benchmark and stability verification. For reference the stock system ran 72 fps in the Lost Coast video stress test. Then I prepared the BIOS for overclocking: Turned off Cool'n'Quiet, Q-Fan, locked the PCI bus at 33Mhz, and HyperTransport at 4x. The suggested RAM timing is CL2,5-3-3-7-1T at 400MHz but I locked it at CL2 333MHz. Though the CPU runs stock at 10x200MHz I lowered the multiplier to 8x before overclocking the front side bus. In Windows I started the 7-Zip benchmark to load the CPU, then used Asus AiBooster to raise the external frequency in steps of 5MHz until the computer froze at 245 MHz. [ ![](http://photos1.blogger.com/blogger/517/39/320/overclock.jpg)](http://photos1.blogger.com/blogger/517/39/1600/overclock.jpg)In BIOS I lowered the frequency to 240MHz and booted Windows. I started the 7-Zip benchmark to verify stability. In AiBooster I raised the CPU voltage from to 1,35 to 1,375 and the set the multiplier back to x10. I was glad to see the system was still stable, running at the speed of the 4600+ X2 that costs the double of my 3800+ X2! Ran the Lost Cost video stress test again, now I got 98 fps.

