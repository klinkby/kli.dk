---
author: "@klinkby"
keywords:
- dotnet
- performance
date: "2008-01-24T23:00:00Z"
description: ""
draft: false
slug: parallel-processing-as-applied-to-net-framework-35
tags:
- dotnet
- performance
title: Parallel for 3.5
---


Some time ago I [ blogged](http://klinkby.wordpress.com/2007/07/03/parallel-processing/) about a simple way to process a
collection of lengthy operations on separate threads. The new Parallel Extensions library currently available
as [ CTP](http://www.microsoft.com/downloads/details.aspx?FamilyID=e848dc1d-5be3-4941-8705-024bc7f180ba&displaylang=en),
hits right on the spot for CPU-intensive operations. It is less suited for IO or network intensive operations with lots
of waiting, and the thread pool is invaluable. The new language features provides new possibilities for implementing
such a method.

<pre class="csharpcode"><code><span class="kwrd">class</span> Program 
{ 
    <span class="kwrd">static</span> <span class="kwrd">void</span> Main(<span class="kwrd">string</span>[] args) 
    { 
        IEnumerable&lt;<span class="kwrd">int</span>&gt; ints = <span class="kwrd">new</span> <span class="kwrd">int</span>[] { 19, 18, 17, 14, 15 }; 
        ints.ThreadPoolForEach( 
            <span class="kwrd">delegate</span>(<span class="kwrd">int</span> i) 
            { 
                Console.WriteLine(<span class="str">"start "</span> 
                    + Thread.CurrentThread.ManagedThreadId); 
                Thread.Sleep(i * 1000); 
                Console.WriteLine(<span class="str">"end "</span> 
                    + Thread.CurrentThread.ManagedThreadId); 
            }); 
    } 
} 
<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> ThreadPoolForEach&lt;T&gt;(<span class="kwrd">this</span> IEnumerable&lt;T&gt; items, Action&lt;T&gt; command)
{
    Stack&lt;WaitHandle&gt; waitHandles = <span class="kwrd">new</span> Stack&lt;WaitHandle&gt;();            
    Exception lastException = <span class="kwrd">null</span>;
    <span class="kwrd">int</span> i = 0;
    <span class="kwrd">foreach</span> (T item <span class="kwrd">in</span> items) {
        ManualResetEvent waitHandle = <span class="kwrd">new</span> ManualResetEvent(<span class="kwrd">false</span>);
        waitHandles.Push(waitHandle);
        ThreadPool.QueueUserWorkItem(
            <span class="kwrd">delegate</span>(<span class="kwrd">object</span> o) {
                <span class="kwrd">try</span> {
                    command((T)o);
                }
                <span class="kwrd">catch</span> (Exception e) {
                    lastException = e;
                }
                <span class="kwrd">finally</span> {
                    waitHandle.Set();
                }
            }, item);
        <span class="kwrd">if</span> (++i == 64) { <span class="rem">// WaitAll can wait for no more than 64 handles</span>
            i = 0;
            Mutex.WaitAll(waitHandles.ToArray());
            waitHandles.Clear();
        }
    }
    <span class="kwrd">if</span> (i&gt;0)
        Mutex.WaitAll(waitHandles.ToArray());
    <span class="kwrd">if</span> (lastException != <span class="kwrd">null</span>)
        <span class="kwrd">throw</span> lastException;
}</code></pre>

