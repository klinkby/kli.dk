---
author: "@klinkby"
keywords:
- dotnet
date: "2010-11-30T23:00:00Z"
description: ""
draft: false
slug: stream-copyto-snippet
tags:
- dotnet
title: Stream.CopyTo
---


Here's a small snippet I use a lot when working with streams. It simply copies content from one stream to the other in chunks of 4 KB. It is so handy that the BCL team added it to the stream class in .NET 4.0.

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">long</span> CopyTo(<span class="kwrd">this</span> Stream input, Stream output)
{
    <span class="kwrd">if</span> (!input.CanRead || !output.CanWrite)
        <span class="kwrd">throw</span> <span class="kwrd">new</span> InvalidOperationException(<span class="str">"Stream state"</span>);
    <span class="kwrd">const</span> <span class="kwrd">int</span> bufferSize = 1024 * 4;
    <span class="kwrd">byte</span>[] buffer = <span class="kwrd">new</span> <span class="kwrd">byte</span>[bufferSize];
    <span class="kwrd">int</span> read;
    <span class="kwrd">long</span> sum = 0;
    <span class="kwrd">while</span> ((read = input.Read(buffer, 0, bufferSize)) != 0)
    {
        output.Write(buffer, 0, read);
        sum += read;
    }
    <span class="kwrd">return</span> sum;
}</code></pre>

