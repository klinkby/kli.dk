---
author: "@klinkby"
keywords:
- dotnet
date: "2009-02-01T23:00:00Z"
description: ""
draft: false
slug: class-cached-part-1
tags:
- dotnet
title: class Cached - Part 1
---


Here's a nice little helper class that implements a thread safe generic lazy factory and is real easy to use. Create a readonly instance in your constructor, providing the factory method. The first time the actual instance is requested, the factory method is invoked.

<pre class="csharpcode"><code><span class="kwrd">internal</span> <span class="kwrd">class</span> Cached&lt;T&gt;
{
    <span class="kwrd">readonly</span> Func&lt;T&gt; _factory;
    <span class="kwrd">private</span> T _value;
    <span class="kwrd">private</span> <span class="kwrd">bool</span> _initialized;

    <span class="kwrd">public</span> Cached(Func&lt;T&gt; factory)
    {
        <span class="kwrd">if</span> (factory == <span class="kwrd">null</span>)
            <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentNullException(<span class="str">"factory"</span>);
        _factory = factory;
    }

    <span class="kwrd">private</span> T PlainGetter()
    {
        <span class="kwrd">return</span> _value;
    }

    <span class="kwrd">public</span> T Instance
    {
        get
        {
            <span class="kwrd">if</span> (!_initialized)
                <span class="kwrd">lock</span> (_factory)
                    <span class="kwrd">if</span> (!_initialized)
                    {
                        _value = _factory();
                        _initialized = <span class="kwrd">true</span>;
                    }
            <span class="kwrd">return</span> _value;
        }
    }
    
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">implicit</span> <span class="kwrd">operator</span> T(Cached&lt;T&gt; cached)
    {
        <span class="kwrd">return</span> cached.Instance;
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">bool</span> Equals(<span class="kwrd">object</span> obj)
    {
        <span class="kwrd">return</span> Instance.Equals(obj);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> GetHashCode()
    {
        <span class="kwrd">return</span> Instance.GetHashCode();
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">string</span> ToString()
    {
        <span class="kwrd">return</span> Instance.ToString();
    }
}</code></pre>

