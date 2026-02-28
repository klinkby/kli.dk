---
author: "@klinkby"
keywords:
- dotnet
date: "2008-03-03T23:00:00Z"
description: ""
draft: false
slug: events-a-la-c-30
tags:
- dotnet
title: Events a la C# 3.0
---


The new language features makes it possible to minimize much of that nasty boiler plate code. With these helpers:

<pre class="csharpcode"><code><span class="kwrd">delegate</span> <span class="kwrd">void</span> EventHandler&lt;T&gt;(<span class="kwrd">object</span> sender, T e); 

<span class="kwrd">class</span> EventArgs&lt;T&gt; : EventArgs { 
    <span class="kwrd">readonly</span> T _args; 
    <span class="kwrd">public</span> EventArgs(T args) { 
        _args = args; 
    } 
    <span class="kwrd">public</span> T Args { 
        get { <span class="kwrd">return</span> _args; } 
    } 
} 

<span class="kwrd">static</span> <span class="kwrd">class</span> EventExtensions { 
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> OnEvent&lt;T&gt;( 
            <span class="kwrd">this</span> <span class="kwrd">object</span> sender, 
            EventHandler&lt;T&gt; handler, T e) { 
        <span class="kwrd">if</span> (handler != <span class="kwrd">null</span>) 
            handler(sender, e); 
    } 
}
</code></pre>

I can raise thread safe events with a generic typed event argument as simple as this:

<pre class="csharpcode"><code><span class="kwrd">class</span> MyClass 
{ 
    <span class="kwrd">public</span> <span class="kwrd">event</span> EventHandler&lt;Point&gt; Click; 

    : <span class="rem">// some method body</span> 
    <span class="kwrd">this</span>.OnEvent(Click, <span class="kwrd">new</span> Point(4,2)); 
    : 
}</code></pre>

I currently find much inspiration in functional programming and the [F#](http://research.microsoft.com/fsharp/) project.

