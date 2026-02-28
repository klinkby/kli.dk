---
author: "@klinkby"
keywords:
- dotnet
date: "2009-08-08T22:00:00Z"
description: ""
draft: false
slug: the-tuples-are-coming
tags:
- dotnet
title: The Tuples Are Coming
---


Great to see the tuple types, that some of you might have stumbled upon in F#, is
being [ included in the BCL upcoming .NET 4.0 release](http://blogs.msdn.com/bclteam/archive/2009/07/07/building-tuple-matt-ellis.aspx).
Tuples are strongly typed sequences that unlike strongly typed arrays can have items of different types. For example a
tuple can contain <code>(1,2,"many")</code>, and can e.g. be compared to the tuple <code>(1,2,"many")</code>, of course
resulting in true. Or should it? The BCL classes are still subject to some polemic on whether tuples are basic values
like Point or KeyValuePair, or reference types like arrays. There are surprisingly many choices to be taken concerning a
seemingly simple type like this, that dramatically defines its usage and number of potential bugs in written code. In
the current state of the BCL, the above example results in false because the <code>Equals(x)</code> or <code>==</code>
methods treats the tuples as reference types, ignoring the individual field values!
Instead [ IStructuralEquatable](http://msdn.microsoft.com/en-us/library/system.collections.istructuralequatable(VS.100).aspx)
interface is added that should be used if the field values are to be compared. If you forget this special case, no
compiler or runtime errors will occur, but the app will not work as expected. Aw snap! After taking a glance
at [Wikipedia's definition](http://en.wikipedia.org/wiki/Tuple) it is obvious that the CLR has some shortcomings that
make it hard or very tedious to implement. For example supporting the <code>(1, (2,3.0)) == ((1,2), 3.0)</code> would
result in writing an exponential number of factory methods. I implemented a .NET 3.0 compilable version somewhat like
the upcoming BCL4.0 version. Note I did not implement the <code>IStructural*</code> interfaces: My Equals compares each
field value, so use <code>object.ReferenceEquals</code> if you want to compare the addresses. The source code is
on [http://tuples.codeplex.com/](http://tuples.codeplex.com/) and you can download the assembly directly
from [ here](http://tuples.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=31335#DownloadId=78575).

