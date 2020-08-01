---
author: Mads Klinkby
categories:
- .net
date: "2008-09-10T22:00:00Z"
description: ""
draft: false
slug: are-we-alone
tags:
- .net
title: Are we alone?
---


Simple way to make sure there is only one instance of your application running in the window session. If you need there to be only one instance on the machine, change 'Local' to 'Global'.

 <pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">void</span> Main()
{
    <span class="kwrd">using</span> (Mutex m = <span class="kwrd">new</span> Mutex(<span class="kwrd">true</span>, @"Local\" + Application.ProductName))
    {
        <span class="kwrd">if</span> (m.WaitOne(0, <span class="kwrd">true</span>))
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(<span class="kwrd">false</span>);
            Application.Run(<span class="kwrd">new</span> Program());
        }
    }
}</code></pre>

