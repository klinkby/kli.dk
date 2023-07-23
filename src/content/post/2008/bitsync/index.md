---
author: "@klinkby"
keywords:
- dotnet
date: "2008-01-18T23:00:00Z"
description: ""
draft: false
slug: bitsync
tags:
- dotnet
title: BITSync
---


Since Windows 2000 your favorite OS have had a service called [Background Intelligent Transfer Service](http://en.wikipedia.org/wiki/Background_Intelligent_Transfer_Service) or BITS in short.   

It is used by Windows Update to download the update packages in the background using idle bandwidth. It supports retries, resuming after reboots and lots of other cool stuff. It can be controlled by a [ COM interface](http://msdn2.microsoft.com/en-us/library/aa362820(VS.85).aspx), and I always wondered why so few applications uses it. I regularly need to move some large files from one computer to another. The destination computer is not always on, and [SMB file transfer](http://en.wikipedia.org/wiki/Server_message_block) is really not very suited for large files - not on my unreliable WLAN anyway. 

![BITSync](/images/2008/bitsync.gif)  

So I wrote a small utility called BITSync that can compare two file system directories and add the the files missing in the destination folder to a BITS download job. It also has a simple status dialog to monitor progress and control BITS jobs. The application is written in [Visual C++ 2008 Express](http://www.microsoft.com/express/vc/) edition. 
  
 
Should you have a look at the included source code, you will surely find that this is not my preferred programming language. So I'm sure there is a million ways to improve the application - and feel free to do so.
But please send me a copy. [Download source ZIP](/bitsync.zip)

Updated 2008-02-27: When I wrote this tool, I didn't realize Vista comes with a [robust file copying](http://en.wikipedia.org/wiki/Robocopy) tool. [XCOPY is now deprecated](http://www.pluralsight.com/blogs/dbox/archive/2008/01/02/49606.aspx)!
