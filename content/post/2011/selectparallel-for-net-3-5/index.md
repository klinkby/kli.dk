---
author: Mads Klinkby
categories:
- .net
- linq
- parallel
- performance
- programming
- threadpool
date: "2011-03-14T23:00:00Z"
description: ""
draft: false
slug: selectparallel-for-net-3-5
tags:
- .net
- linq
- parallel
- performance
- programming
- threadpool
title: SelectParallel for .NET 3.5
---


A simple method that does exactly what Select LINQ function does, except the items are processed as work items on the thread pool. The implementation here is best for items that takes about an equal amount of processing time, and do avoid using it for tiny work items. If an exception occurs during processing of an item, the exception is rethrown on the caller's thread. 

Please note this implementation is very different from how the Parallel LINQ library works, and I would always recommend using the implementation in NET 4.0 if your application can take dependency of that.   

<pre class="csharpcode"><code><span class="kwrd">static</span> IEnumerable&lt;TD&gt; SelectParallel&lt;TS, TD&gt;(
    <span class="kwrd">this</span> IEnumerable&lt;TS&gt; coll,
    Func&lt;TS, TD&gt; func)
{
    var results = <span class="kwrd">new</span> Queue&lt;TD&gt;();
    <span class="kwrd">int</span> processed = 0;
    Exception ex = <span class="kwrd">null</span>;
    <span class="kwrd">using</span> (var evt = <span class="kwrd">new</span> AutoResetEvent(<span class="kwrd">false</span>))
    {
        <span class="kwrd">int</span> count = 0;
        <span class="kwrd">foreach</span> (var s <span class="kwrd">in</span> coll)
        {
            <span class="kwrd">int</span> index = count++;
            TS t = s;
            ThreadPool.QueueUserWorkItem(o =&gt;
            {
                <span class="kwrd">try</span>
                {
                    TD result = func(t);
                    <span class="kwrd">while</span> (processed != index)
                    {
                        evt.WaitOne(10);
                        <span class="kwrd">if</span> (ex != <span class="kwrd">null</span>)
                            <span class="kwrd">return</span>;
                    }
                    <span class="kwrd">lock</span>(evt)
                    {
                        results.Enqueue(func(t));
                        Interlocked.Increment(<span class="kwrd">ref</span> processed);
                    }
                    evt.Set();
                }
                <span class="kwrd">catch</span> (Exception e)
                {
                    ex = e;
                }
            });
        }
        <span class="kwrd">int</span> resultCount = 0;
        <span class="kwrd">while</span> (resultCount &lt; count &amp;&amp; ex == <span class="kwrd">null</span>)
        {
            evt.WaitOne(10);
            <span class="kwrd">while</span> (resultCount &lt; processed &amp;&amp; ex == <span class="kwrd">null</span>)
            {
                TD item;
                <span class="kwrd">lock</span> (evt)
                {
                    item = results.Dequeue();
                }
                <span class="kwrd">yield</span> <span class="kwrd">return</span> item;
                resultCount++;
            }
        }
    }
    <span class="kwrd">if</span> (ex != <span class="kwrd">null</span>)
        <span class="kwrd">throw</span> ex;
}</code></pre>

