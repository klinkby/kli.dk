---
author: Mads Klinkby
categories:
- .net
date: "2008-09-08T22:00:00Z"
description: ""
draft: false
slug: impersonationreverttoself
tags:
- .net
title: Impersonation.RevertToSelf()
---


In a SharePoint web.config you will find the line <identity impersonate="true"/> that causes all server code to be run in the context of the requesting client. So if you need your webpart to e.g. look up a user in the active directory (i.e. on the domain controller) you have [ a double hop issue](http://blogs.msdn.com/knowledgecast/archive/2007/01/31/the-double-hop-problem.aspx).

You can use credentials of the app pool account to overcome this using the following code snippet:

<pre class="csharpcode"><code><span class="rem">// Uncomment for pre .net 3.5 &gt; delegate void Action();</span>
<span class="kwrd">static</span> <span class="kwrd">void</span> DelegateToIIS(Action command)
{
    <span class="kwrd">if</span> (!WindowsIdentity.GetCurrent().IsSystem)
    {
        var ctx = WindowsIdentity.Impersonate(IntPtr.Zero);
        <span class="kwrd">try</span>
        {
            command();
        }
        <span class="kwrd">finally</span>
        {
            ctx.Undo();
            ctx.Dispose();
        }
    }
    <span class="kwrd">else</span>
        command();
}</code></pre>

