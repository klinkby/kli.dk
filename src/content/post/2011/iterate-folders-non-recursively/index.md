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

```C#
static IEnumerable<string> GetDirectories(string startDirectory)
{
    var dirsToVisit = new Stack<string>();
    dirsToVisit.Push(startDirectory);
    while (dirsToVisit.Count > 0)
    {
        string dir = dirsToVisit.Pop();
        yield return dir;
        string[] subDirs;
        try
        {
            subDirs = Directory.GetDirectories(dir);
        }
        catch (UnauthorizedAccessException)
        {
            subDirs = new string[0];
        }
        foreach (var subDir in subDirs)
            dirsToVisit.Push(subDir);
    }
}

static IEnumerable<string> GetFiles(string startDirectory)
{
    foreach (var dir in GetDirectories(startDirectory))
    {
        string[] files;
        try
        {
            files = Directory.GetFiles(dir);
        }
        catch (UnauthorizedAccessException)
        {
            files = new string[0];
        }
        foreach (var file in files)
            yield return file;
    }
}
```