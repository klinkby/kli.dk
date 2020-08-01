---
author: Mads Klinkby
categories:
- .net
- www
date: "2009-04-29T22:00:00Z"
description: ""
draft: false
slug: gravatar
tags:
- .net
- www
title: Gravatar
---


Just a little method to get an url to a [public avatar image](http://en.wikipedia.org/wiki/Avatar_(computing)) from [gravatar.com](http://gravatar.com).

<pre class="csharpcode"><code><span class="kwrd">readonly</span> <span class="kwrd">static</span> MD5CryptoServiceProvider _md5 = <span class="kwrd">new</span> MD5CryptoServiceProvider();
<span class="kwrd">static</span> Uri GetGravatar(<span class="kwrd">string</span> email)
{
    <span class="kwrd">const</span> <span class="kwrd">string</span> uriFormat = <span class="str">"http://www.gravatar.com/avatar/{0}.jpg"</span>;
    StringBuilder sb = <span class="kwrd">new</span> StringBuilder();            
    <span class="kwrd">foreach</span>(<span class="kwrd">byte</span> ch <span class="kwrd">in</span> _md5.ComputeHash(
        Encoding.ASCII.GetBytes(email.Trim().ToLowerInvariant())
        ))
        sb.AppendFormat(<span class="str">"{0:x2}"</span>, ch);
    <span class="kwrd">return</span> <span class="kwrd">new</span> Uri(<span class="kwrd">string</span>.Format(uriFormat, sb.ToString()));
}</code></pre>

