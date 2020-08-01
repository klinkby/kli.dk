---
author: Mads Klinkby
categories:
- .net
- dotnet
- generic
- programming
date: "2011-07-18T22:00:00Z"
description: ""
draft: false
slug: generic-iterator
tags:
- .net
- dotnet
- generic
- programming
title: Generic Iterator
---


I just generalized the iterator implemented in my [previous blog post](http://kli.dk/2011/05/25/iterate-folders-non-recursively) to non-recursively iterate **any** object tree.   

<pre class="csharpcode"><code><span class="kwrd">static</span> IEnumerable&lt;T&gt; Iterate&lt;T&gt;(T rootNode, Func&lt;T, IEnumerable&lt;T&gt;&gt; getChildren)
{
    var stack = <span class="kwrd">new</span> Stack&lt;T&gt;();
    stack.Push(rootNode);
    <span class="kwrd">while</span> (stack.Count &gt; 0)
    {
        T node = stack.Pop();
        <span class="kwrd">yield</span> <span class="kwrd">return</span> node;
        IEnumerable&lt;T&gt; childNodes = getChildren(node);
        <span class="kwrd">foreach</span> (var childNode <span class="kwrd">in</span> childNodes)
            stack.Push(childNode);
    }
}</code></pre>

