---
author: "@klinkby"
keywords:
- dotnet
date: "2009-06-16T22:00:00Z"
description: ""
draft: false
slug: substringbefore-and-substringafter-for-net
tags:
- dotnet
title: SubstringBefore and SubstringAfter for .NET
---


C# implementation of the functions available in XPath for getting either the string before or after a given part:

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">class</span> StringEx
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">string</span> SubstringAfter(<span class="kwrd">this</span> <span class="kwrd">string</span> source, <span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(source) || <span class="kwrd">string</span>.IsNullOrEmpty(<span class="kwrd">value</span>))
            <span class="kwrd">return</span> source;
        <span class="kwrd">int</span> index = source.IndexOf(<span class="kwrd">value</span>, StringComparison.Ordinal);
        <span class="kwrd">return</span> (index &gt;= 0) 
            ? source.Substring(index + <span class="kwrd">value</span>.Length)
            : source;
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">string</span> SubstringBefore(<span class="kwrd">this</span> <span class="kwrd">string</span> source, <span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(source) || <span class="kwrd">string</span>.IsNullOrEmpty(<span class="kwrd">value</span>))
            <span class="kwrd">return</span> source;
        <span class="kwrd">int</span> index = source.IndexOf(<span class="kwrd">value</span>, StringComparison.Ordinal);
        <span class="kwrd">return</span> (index &gt;= 0)
            ? source.Substring(0, index)
            : source;
    }
}</code></pre>

