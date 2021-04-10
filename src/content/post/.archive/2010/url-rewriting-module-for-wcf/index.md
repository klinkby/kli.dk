---
author: "@klinkby"
keywords:
- dotnet
- soap
date: "2010-11-02T23:00:00Z"
description: ""
draft: false
slug: url-rewriting-module-for-wcf
tags:
- dotnet
- soap
title: URL Rewriting Module for WCF
---


Your WCF services have the .svc extension. So a request could be http://yourserver/golden.svc/echo/helloworld

With this simple HTTP module for the IIS pipeline you can avoid the .svc extension, as it automagically adds it to redirects requests with no extension specified.

<pre class="csharpcode"><code><span class="kwrd">public</span> <span class="kwrd">class</span> ServiceRedirectorHttpModule : IHttpModule
{    
    <span class="kwrd">public</span> <span class="kwrd">void</span> Init(HttpApplication context)
    {
        <span class="kwrd">const</span> <span class="kwrd">string</span> dummyAuthority = <span class="str">"http://x"</span>;
        context.BeginRequest += <span class="kwrd">delegate</span>
        {
            HttpContext ctx = HttpContext.Current;
            <span class="kwrd">string</span> path = ctx.Request
                             .AppRelativeCurrentExecutionFilePath;
            Uri uri = <span class="kwrd">new</span> Uri(dummyAuthority + path.TrimStart(<span class="str">'~'</span>));
            <span class="kwrd">if</span> (uri.Segments.Length &gt; 1)
            {
                <span class="kwrd">string</span> service = uri.Segments[1].TrimEnd(<span class="str">'/'</span>);
                <span class="kwrd">if</span> (service.Length &gt; 1 
                    &amp;&amp; Path.GetExtension(service).Length == 0)
                {
                    service = <span class="str">"~/"</span> + Path.ChangeExtension(service, <span class="str">"svc"</span>);
                    <span class="kwrd">string</span> parameters = 
                        uri.Segments
                           .Skip(2)
                           .Aggregate(<span class="kwrd">string</span>.Empty, (acc,x) =&gt; acc+=x);
                    <span class="kwrd">if</span> (parameters.Length == 0
                        &amp;&amp; path.EndsWith(<span class="str">"/"</span>, StringComparison.Ordinal))
                    {
                        parameters += <span class="str">'/'</span>;
                    }
                    ctx.RewritePath(
                        service,
                        parameters,
                        ctx.Request.QueryString.ToString(),
                        <span class="kwrd">true</span>);
                }
            }
        };
    }
    <span class="kwrd">public</span> <span class="kwrd">void</span> Dispose()
    {
    }
}</code></pre>

