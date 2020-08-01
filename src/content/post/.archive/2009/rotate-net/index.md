---
author: Mads Klinkby
categories:
- .net
date: "2009-05-18T22:00:00Z"
description: ""
draft: false
slug: rotate-net
tags:
- .net
title: Rotate.NET
---


One of the remarkable missing CPU instructions from the .NET BCL is bitwise rotation. The shift operators are there: <code>&lt;&lt;</code>, <code>&gt;&gt;</code>. The following implementation fills out the blanks (based on RCA Lab's RC5 reference implementation).

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">class</span> Spinner
{
    <span class="kwrd">const</span> <span class="kwrd">byte</span> LongLong = 64;
    <span class="kwrd">const</span> <span class="kwrd">byte</span> Long = 32;
    <span class="kwrd">const</span> <span class="kwrd">byte</span> Word = 16;
    <span class="kwrd">const</span> <span class="kwrd">byte</span> Byte = 8;
    <span class="kwrd">public</span> <span class="kwrd">static</span> UInt64 RotateLeft(<span class="kwrd">this</span> UInt64 x, <span class="kwrd">byte</span> leftShifts) {
        <span class="kwrd">return</span> ((x) &lt;&lt; (leftShifts &amp; (LongLong - 1))) 
            | ((x) &gt;&gt; (LongLong - (leftShifts &amp; (LongLong - 1))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> UInt64 RotateRight(<span class="kwrd">this</span> UInt64 x, <span class="kwrd">byte</span> rightShifts) {
        <span class="kwrd">return</span> ((x) &gt;&gt; (rightShifts &amp; (LongLong - 1))) 
            | ((x) &lt;&lt; (LongLong - (rightShifts &amp; (LongLong - 1))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">uint</span> RotateLeft(<span class="kwrd">this</span> <span class="kwrd">uint</span> x, <span class="kwrd">byte</span> leftShifts) {
        <span class="kwrd">return</span> ((x) &lt;&lt; (leftShifts &amp; (Long - 1))) 
            | ((x) &gt;&gt; (Long - (leftShifts &amp; (Long - 1))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">uint</span> RotateRight(<span class="kwrd">this</span> <span class="kwrd">uint</span> x, <span class="kwrd">byte</span> rightShifts) {
        <span class="kwrd">return</span> ((x) &gt;&gt; (rightShifts &amp; (Long - 1))) 
            | ((x) &lt;&lt; (Long - (rightShifts &amp; (Long - 1))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">ushort</span> RotateLeft(<span class="kwrd">this</span> <span class="kwrd">ushort</span> x, <span class="kwrd">byte</span> leftShifts) {
        <span class="kwrd">return</span> <span class="kwrd">unchecked</span>((<span class="kwrd">ushort</span>)(((x) &lt;&lt; (leftShifts &amp; (Word - 1))) 
            | ((x) &gt;&gt; (Word - (leftShifts &amp; (Word - 1))))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">ushort</span> RotateRight(<span class="kwrd">this</span> <span class="kwrd">ushort</span> x, <span class="kwrd">byte</span> rightShifts) {
        <span class="kwrd">return</span> <span class="kwrd">unchecked</span>((<span class="kwrd">ushort</span>)(((x) &gt;&gt; (rightShifts &amp; (Word - 1))) 
            | ((x) &lt;&lt; (Word - (rightShifts &amp; (Word - 1))))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">byte</span> RotateLeft(<span class="kwrd">this</span> <span class="kwrd">byte</span> x, <span class="kwrd">byte</span> leftShifts) {
        <span class="kwrd">return</span> <span class="kwrd">unchecked</span>((<span class="kwrd">byte</span>)(((x) &lt;&lt; (leftShifts &amp; (Byte - 1))) 
            | ((x) &gt;&gt; (Byte - (leftShifts &amp; (Byte - 1))))));
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">byte</span> RotateRight(<span class="kwrd">this</span> <span class="kwrd">byte</span> x, <span class="kwrd">byte</span> rightShifts) {
        <span class="kwrd">return</span> <span class="kwrd">unchecked</span>((<span class="kwrd">byte</span>)(((x) &gt;&gt; (rightShifts &amp; (Byte - 1))) 
            | ((x) &lt;&lt; (Byte - (rightShifts &amp; (Byte - 1))))));
    }       
}</code></pre>

