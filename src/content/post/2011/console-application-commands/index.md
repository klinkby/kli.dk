---
author: Mads Klinkby
categories:
- .net
- dotnet
- pattern
- programming
- reflection
date: "2011-02-28T23:00:00Z"
description: ""
draft: false
slug: console-application-commands
tags:
- .net
- dotnet
- pattern
- programming
- reflection
title: Commands in console application
---


Here is a simple template for creating C# console applications that take a parameter that controls what the application should do. The example code has one (exciting) command "sayhello", but you can add new commands simply by creating a new public static method in the class. Central of course is GoF command pattern, and .NET Reflection gives the dynamics.   

<pre class="csharpcode"><code><span class="kwrd">using</span> System;
<span class="kwrd">using</span> System.Diagnostics;
<span class="kwrd">using</span> System.Linq;
<span class="kwrd">using</span> System.Reflection;

<span class="kwrd">class</span> Program
{
<span class="kwrd">const</span> BindingFlags flags = BindingFlags.Public 
    | BindingFlags.Static | BindingFlags.IgnoreCase;

<span class="kwrd">static</span> <span class="kwrd">int</span> Main(<span class="kwrd">string</span>[] args)
{
    <span class="kwrd">if</span> (args.Length &gt; 0)
    {
        MethodInfo mi = <span class="kwrd">typeof</span>(Program).GetMethod(
                            args[0].ToLowerInvariant(),
                            flags);
        var cmd = (Func&lt;<span class="kwrd">int</span>&gt;)Delegate.CreateDelegate(
                            <span class="kwrd">typeof</span>(Func&lt;<span class="kwrd">int</span>&gt;),
                            mi);
        <span class="kwrd">return</span> Execute(cmd);
    }
    <span class="kwrd">else</span>
    {
        Console.WriteLine(
            <span class="str">"Usage:\r\n\t{0} command"</span>, 
            Process.GetCurrentProcess().ProcessName );
        Console.WriteLine(
            <span class="str">"\r\nList of commands:\r\n\t{0}"</span>,
            <span class="kwrd">string</span>.Join(
                <span class="str">"\r\n\t"</span>,
                <span class="kwrd">typeof</span>(Program).GetMethods(flags)
                                .Select(x =&gt; x.Name
                                              .ToLowerInvariant())
                                .OrderBy(x =&gt; x)
                                .ToArray())
            );
        <span class="kwrd">return</span> 0;
    }
}

<span class="kwrd">static</span> <span class="kwrd">int</span> Execute(Func&lt;<span class="kwrd">int</span>&gt; command)
{
    <span class="kwrd">int</span> retval = 0;
    <span class="kwrd">try</span>
    {
        retval = command();
    }
    <span class="kwrd">catch</span> (Exception e)
    {
        Console.Error.WriteLine(<span class="str">"FAIL: "</span> + e.ToString());
        <span class="kwrd">return</span> -1;
    }
    <span class="kwrd">return</span> retval;
}

<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">int</span> SayHello()
{
    Console.WriteLine(<span class="str">"Hello world!"</span>);
    <span class="kwrd">return</span> 0;
}
}</code></pre>

