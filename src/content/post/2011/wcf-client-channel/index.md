---
author: Mads Klinkby
categories:
- .net
- code
- programming
- wcf
date: "2011-01-11T23:00:00Z"
description: ""
draft: false
slug: wcf-client-channel
tags:
- .net
- code
- programming
- wcf
title: WCF Client Channel snippet
---


Generally I use WCF client channels with the code snippet below that handles channel lifetime, failed channel states and context required for nested WCF calls.

<pre class="csharpcode"><code><span class="kwrd">static</span> TReturn WithChannel&lt;TChannel, TReturn&gt;(Func&lt;TChannel, TReturn&gt; func)
    <span class="kwrd">where</span> TChannel : IContextChannel
{
    TChannel channel = CreateChannel();
    <span class="kwrd">try</span>
    {
        <span class="kwrd">using</span> (<span class="kwrd">new</span> OperationContextScope(channel)) 
        {
            TReturn ret = func(channel);
            <span class="kwrd">return</span> ret;
        }
    }
    <span class="kwrd">finally</span>
    {
        <span class="kwrd">try</span>
        {
            ((IDisposable)channel).Dispose(); <span class="rem">// ~= Close()</span>
        }
        <span class="kwrd">catch</span> (CommunicationException) { ((IChannel)channel).Abort(); }
        <span class="kwrd">catch</span> (TimeoutException) { ((IChannel)channel).Abort(); }
    }
}</code></pre>

