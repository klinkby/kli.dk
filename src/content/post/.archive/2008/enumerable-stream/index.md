---
author: "@klinkby"
keywords:
- dotnet
date: "2008-02-25T23:00:00Z"
description: ""
draft: false
slug: enumerable-stream
tags:
- dotnet
title: Enumerable stream
---


As MVP Dustin R. Campbell [points out on his blog](http://diditwith.net/2008/02/25/WhyILoveFOptionTypes.aspx) the
Stream.ReadByte() has a pretty bad code smell:

> First of all, it returns an int instead of a byte. Initially, that should seem strange since the method specifically
> states that it's a byte generator. ReadByte returns -1 when the current position is at the end of the stream. Because -1
> is not expressible as an unsigned byte, ReadByte returns an int. Of course, that's the second problem: extra non-obvious
> information is encoded into the result value of this function. However, unless you read the documentation, there's no
> way of knowing that.

He then suggests a solutions for F#. Here's an elegant C# 3.5 equivalent:

 <pre class="csharpcode"><code><span class="kwrd">class</span> Program 
{ 
    <span class="kwrd">static</span> <span class="kwrd">void</span> Main(<span class="kwrd">string</span>[] args) { 
        FileStream fs = <span class="kwrd">new</span> FileStream(<span class="str">@"C:Windowssystem.ini"</span>, FileMode.Open); 
        <span class="kwrd">foreach</span> (<span class="kwrd">byte</span> b <span class="kwrd">in</span> fs.AsEnumerable()) 
            Console.Write(b.ToString(<span class="str">"x"</span>)); 
        fs.Dispose(); 
    } 
}  

<span class="kwrd">static</span> <span class="kwrd">class</span> StreamEnumerabler { 
    <span class="kwrd">public</span> <span class="kwrd">static</span> IEnumerable&lt;<span class="kwrd">byte</span>&gt; AsEnumerable(<span class="kwrd">this</span> Stream _stream) { 
        <span class="kwrd">for</span> (<span class="kwrd">int</span> b; (b = _stream.ReadByte()) &gt; -1; ) 
            <span class="kwrd">yield</span> <span class="kwrd">return</span> <span class="kwrd">unchecked</span>((<span class="kwrd">byte</span>)b); 
    } 
}</code></pre>

