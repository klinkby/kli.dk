---
author: "@klinkby"
keywords:
- dotnet
- pattern   
date: "2011-07-18T22:00:00Z"
description: ""
draft: false
slug: generic-iterator
tags:
- dotnet
- pattern
title: Generic Iterator
---


I just generalized the iterator implemented in my [previous blog post](http://kli.dk/2011/05/25/iterate-folders-non-recursively) to non-recursively iterate **any** object tree.   

```C#
static IEnumerable<T> Iterate<T>(T rootNode, Func<T, IEnumerable<T>> getChildren)
{
    var stack = new Stack<T>();
    stack.Push(rootNode);
    while (stack.Count > 0)
    {
        T node = stack.Pop();
        yield return node;
        IEnumerable<T> childNodes = getChildren(node);
        foreach (var childNode in childNodes)
            stack.Push(childNode);
    }
}
```

