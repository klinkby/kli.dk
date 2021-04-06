---
author: Mads Klinkby
categories:
- .net
- linq
- parallel
- performance
- programming
- threadpool
date: "2011-03-14T23:00:00Z"
description: ""
draft: false
slug: selectparallel-for-net-3-5
tags:
- .net
- linq
- parallel
- performance
- programming
- threadpool
title: SelectParallel for .NET 3.5
---


A simple method that does exactly what Select LINQ function does, except the items are processed as work items on the thread pool. The implementation here is best for items that takes about an equal amount of processing time, and do avoid using it for tiny work items. If an exception occurs during processing of an item, the exception is rethrown on the caller's thread. 

Please note this implementation is very different from how the Parallel LINQ library works, and I would always recommend using the implementation in NET 4.0 if your application can take dependency of that.   

```C#
static IEnumerable<TD> SelectParallel<TS, TD>(
    this IEnumerable<TS> coll,
    Func<TS, TD> func)
{
    var results = new Queue<TD>();
    int processed = 0;
    Exception ex = null;
    using (var evt = new AutoResetEvent(false))
    {
        int count = 0;
        foreach (var s in coll)
        {
            int index = count++;
            TS t = s;
            ThreadPool.QueueUserWorkItem(o =>
            {
                try
                {
                    TD result = func(t);
                    while (processed != index)
                    {
                        evt.WaitOne(10);
                        if (ex != null)
                            return;
                    }
                    lock(evt)
                    {
                        results.Enqueue(func(t));
                        Interlocked.Increment(ref processed);
                    }
                    evt.Set();
                }
                catch (Exception e)
                {
                    ex = e;
                }
            });
        }
        int resultCount = 0;
        while (resultCount < count && ex == null)
        {
            evt.WaitOne(10);
            while (resultCount < processed && ex == null)
            {
                TD item;
                lock (evt)
                {
                    item = results.Dequeue();
                }
                yield return item;
                resultCount++;
            }
        }
    }
    if (ex != null)
        throw ex;
}
```
