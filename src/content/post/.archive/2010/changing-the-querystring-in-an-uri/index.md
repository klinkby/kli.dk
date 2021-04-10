---
author: "@klinkby"
keywords:
- dotnet
date: "2010-10-26T22:00:00Z"
description: ""
draft: false
slug: changing-the-querystring-in-an-uri
tags:
- dotnet
title: Changing the querystring in an Uri
---


Here's a nice little [fluent](http://en.wikipedia.org/wiki/Fluent_interface) [extension method](http://msdn.microsoft.com/en-us/library/bb383977.aspx) that changes a querystring parameter in an [Uri](http://msdn.microsoft.com/en-us/library/system.uri.aspx).

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">class</span> UriExtensions
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> Uri WithQueryStringParameter(
        <span class="kwrd">this</span> Uri uri, 
        <span class="kwrd">string</span> key, 
        <span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="kwrd">string</span> encodedKey = HttpUtility.UrlEncode(key);
        <span class="kwrd">string</span> encodedValue = HttpUtility.UrlEncode(<span class="kwrd">value</span>);
        <span class="kwrd">string</span>[] parameters = uri.Query.TrimStart(<span class="str">'?'</span>).Split(<span class="str">'&amp;'</span>);
        IEnumerable&lt;<span class="kwrd">string</span>&gt; allButKey = parameters.Where(
            x =&gt; !x.StartsWith(
                encodedKey + <span class="str">"="</span>,
                StringComparison.OrdinalIgnoreCase)
                );
        IEnumerable&lt;<span class="kwrd">string</span>&gt; withNewParam = allButKey.Concat(
            <span class="kwrd">new</span>[] { encodedKey + <span class="str">"="</span> + encodedValue }
            );
        <span class="kwrd">string</span> query = <span class="kwrd">string</span>.Join(<span class="str">"&amp;"</span>, withNewParam.ToArray());
        <span class="kwrd">return</span> <span class="kwrd">new</span> Uri(uri.GetLeftPart(UriPartial.Path) + <span class="str">"?"</span> + query);
    }
}</code></pre>

