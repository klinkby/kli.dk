---
author: Mads Klinkby
categories:
- .net
date: "2009-02-01T23:00:00Z"
description: ""
draft: false
slug: class-cached-part-2
tags:
- .net
title: class Cached - Part 2
---


Here's another useful little helper class that implements a thread safe generic lazy factory that's real easy to use. Create a readonly instance in your constructor, providing the factory method. The factory takes a parameter, that is as parameter to create the value, as well as look up the value the next time it is requested.

<pre class="csharpcode"><code><span class="kwrd">internal</span> <span class="kwrd">class</span> Cached&lt;T, U&gt;
{
    <span class="kwrd">readonly</span> Func&lt;T, U&gt; _factory;
    <span class="kwrd">readonly</span> Dictionary&lt;U, T&gt; _cache = <span class="kwrd">new</span> Dictionary&lt;U, T&gt;();

    <span class="kwrd">public</span> Cached(Func&lt;T, U&gt; factory)
    {
        <span class="kwrd">if</span> (factory == <span class="kwrd">null</span>)
            <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentNullException(<span class="str">"factory"</span>);
        _factory = factory;
    }
    
    <span class="kwrd">public</span> T <span class="kwrd">this</span>[U seed]
    {
        get {
            T <span class="kwrd">value</span>;
            <span class="kwrd">if</span> (!_cache.TryGetValue(seed, <span class="kwrd">out</span> <span class="kwrd">value</span>))
                <span class="kwrd">lock</span>(_cache)
                    <span class="kwrd">if</span> (!_cache.TryGetValue(seed, <span class="kwrd">out</span> <span class="kwrd">value</span>))
                        _cache.Add(seed, <span class="kwrd">value</span> = _factory(seed));
            <span class="kwrd">return</span> <span class="kwrd">value</span>;
        }
    }
}</code></pre>

