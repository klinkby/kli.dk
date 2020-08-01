---
author: Mads Klinkby
categories:
- .net
date: "2011-04-13T22:00:00Z"
description: ""
draft: false
slug: check-if-a-file-is-locked
tags:
- .net
title: Check if a file is locked
---


One notable feature that is missing from the IO section of the .NET base class library is a way to check if a file is locked. When opening a file the [ OpenFile](http://msdn.microsoft.com/en-us/library/aa365430(v=vs.85).aspx) et al API methods does actually provide the information, we just have to [ dig a little](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.marshal.gethrforexception.aspx) to discover it.   

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">bool</span> IsFileLocked(<span class="kwrd">string</span> filename)
{
    <span class="kwrd">bool</span> locked = <span class="kwrd">false</span>;
    <span class="kwrd">try</span>
    {
        File.Open(filename, FileMode.Open, FileAccess.ReadWrite, FileShare.None).Dispose();
    }
    <span class="kwrd">catch</span> (IOException e)
    {
        <span class="kwrd">const</span> <span class="kwrd">int</span> ERROR_SHARING_VIOLATION = 0x20;
        <span class="kwrd">const</span> <span class="kwrd">int</span> ERROR_LOCK_VIOLATION = 0x21;
        <span class="kwrd">int</span> errorCode = Marshal.GetHRForException(e) &amp; ((1 &lt;&lt; 16) - 1);
        locked = errorCode == ERROR_SHARING_VIOLATION
               || errorCode == ERROR_LOCK_VIOLATION;
        <span class="kwrd">if</span> (!locked)
            <span class="kwrd">throw</span>;                
    }
    <span class="kwrd">return</span> locked;
}</code></pre>

