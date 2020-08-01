---
author: Mads Klinkby
categories:
- .net
- convert
- dotnet
- programming
date: "2011-04-25T22:00:00Z"
description: ""
draft: false
slug: convert-unix-time-fromto-system-datetime
tags:
- .net
- convert
- dotnet
- programming
title: Convert Unix Time from/to System.DateTime
---


A pair of simple methods for working with [Unix time](http://en.wikipedia.org/wiki/Unix_epoch) in .NET. The code uses a 64 bit integer datatype so is not affected by [2038 problem](http://en.wikipedia.org/wiki/Year_2038_problem).   

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">class</span> DateTimeExtensions
{
    <span class="kwrd">static</span> <span class="kwrd">readonly</span> DateTime BeginningOfUnixTime = <span class="kwrd">new</span> DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

    <span class="kwrd">public</span> <span class="kwrd">static</span> DateTime FromUnix(<span class="kwrd">long</span> unixTime)
    {
        <span class="kwrd">return</span> BeginningOfUnixTime.AddSeconds(unixTime).ToLocalTime();
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">long</span> ToUnix(<span class="kwrd">this</span> DateTime dt)
    {
        <span class="kwrd">return</span> (<span class="kwrd">long</span>)((dt.ToUniversalTime() - BeginningOfUnixTime).TotalSeconds);
    }
}</code></pre>

