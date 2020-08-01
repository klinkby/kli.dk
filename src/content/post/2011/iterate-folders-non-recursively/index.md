---
author: Mads Klinkby
categories:
- .net
- file
- performance
date: "2011-05-24T22:00:00Z"
description: ""
draft: false
slug: iterate-folders-non-recursively
tags:
- .net
- file
- performance
title: Iterate folders non-recursively
---


Here are a few methods to help iterate complete directory trees and the files in them without using recursive method calls. The directories are read one at a time to keep memory usage at a minimum. These restrictions enables iterating trees in very large file shares.   

<pre class="csharpcode"><code><span class="kwrd">static</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; GetDirectories(<span class="kwrd">string</span> startDirectory)
{
    var dirsToVisit = <span class="kwrd">new</span> Stack&lt;<span class="kwrd">string</span>&gt;();
    dirsToVisit.Push(startDirectory);
    <span class="kwrd">while</span> (dirsToVisit.Count &gt; 0)
    {
        <span class="kwrd">string</span> dir = dirsToVisit.Pop();
        <span class="kwrd">yield</span> <span class="kwrd">return</span> dir;
        <span class="kwrd">string</span>[] subDirs;
        <span class="kwrd">try</span>
        {
            subDirs = Directory.GetDirectories(dir);
        }
        <span class="kwrd">catch</span> (UnauthorizedAccessException)
        {
            subDirs = <span class="kwrd">new</span> <span class="kwrd">string</span>[0];
        }
        <span class="kwrd">foreach</span> (var subDir <span class="kwrd">in</span> subDirs)
            dirsToVisit.Push(subDir);
    }
}

<span class="kwrd">static</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; GetFiles(<span class="kwrd">string</span> startDirectory)
{
    <span class="kwrd">foreach</span> (var dir <span class="kwrd">in</span> GetDirectories(startDirectory))
    {
        <span class="kwrd">string</span>[] files;
        <span class="kwrd">try</span>
        {
            files = Directory.GetFiles(dir);
        }
        <span class="kwrd">catch</span> (UnauthorizedAccessException)
        {
            files = <span class="kwrd">new</span> <span class="kwrd">string</span>[0];
        }
        <span class="kwrd">foreach</span> (var file <span class="kwrd">in</span> files)
            <span class="kwrd">yield</span> <span class="kwrd">return</span> file;
    }
}</code></pre>

