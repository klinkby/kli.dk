---
author: Mads Klinkby
categories:
- .net
date: "2008-03-28T23:00:00Z"
description: ""
draft: false
slug: jpeg-xr-converter
tags:
- .net
title: JPEG XR converter
---


The .NET Framework 3 packs an image cdec for [ JPEG XR](http://blogs.msdn.com/billcrow/archive/2006/06/09/623058.aspx) (formerly [ HD Photo](http://blogs.msdn.com/billcrow/archive/2006/11/17/introducing-hd-photo.aspx) [formerly [ Windows Media Photo](http://blogs.msdn.com/billcrow/archive/2006/06/09/623058.aspx)]) that is a first class image format in Vista.

I tried converting some JPEGs I've shot with my Canon PowerShot, and I'm quite impressed with the compression/quality ratio.

Depending on the image contents the images shrunk to 1/4-1/3 of the original size with virtually no image quality loss.

You can download the command line converter and the source [here](http://kli.dk/blog/JpegXr.zip). It takes an argument that should specify the image search pattern e.g. "c:\temp\*.jpg" - note that is traverses all sub directories of the path specified, and the original image files are sent to the recycle bin.

