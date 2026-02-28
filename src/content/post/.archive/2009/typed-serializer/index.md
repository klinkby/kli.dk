---
author: "@klinkby"
keywords:
- dotnet
date: "2009-08-10T22:00:00Z"
description: ""
draft: false
slug: typed-serializer
tags:
- dotnet
title: Typed binary stream reader/writer
---


Remember back in the good (?) old days when you could open a file containing a collection of records and access the
records directly? Quite useful if you don't have a database, or if you just need to access the records stack-like. I
implemented a C#3.0 class library that is allows you to write this kind of LINQ friendly file access:

<pre class="csharpcode"><code>Console.WriteLine(
    <span class="kwrd">new</span> TypedReader&lt;Employee&gt;(File.Open(<span class="str">"dut"</span>), recordSize)
    .First(f =&gt; f.ID == 43));
</code></pre>

The source code is on [http://typedserializer.codeplex.com/](http://typedserializer.codeplex.com/) and you can download
the assembly directly
from [ here](http://typedserializer.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=31421#DownloadId=78839).

