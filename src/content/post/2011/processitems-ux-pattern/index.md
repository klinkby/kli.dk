---
author: Mads Klinkby
categories:
- .net
- dotnet
- pattern
- programming
date: "2011-07-21T22:00:00Z"
description: ""
draft: false
slug: processitems-ux-pattern
tags:
- .net
- dotnet
- pattern
- programming
title: ProcessItems UX pattern
---


Here's a general implementation for the common UX scenario where a items in a list should be processed, and that processing might fail, so reprocessing might be needed for those items. This used e.g. when copying a bunch of files or collecting data from loosely connected distributed systems.   

```C#
/// <summary>
/// General UX process pattern that processes some items sequencially, while
/// reporting progress. Should items fail processing, the caller can retry
/// processing those.
/// </summary>
/// <typeparam name="T">Item type</typeparam>
/// <param name="items">Collection of items to process</param>
/// <param name="processItem">Callback to process an item. The second parameter is for reporting 
/// progress in completion percentage for that item.</param>
/// <param name="askRetry">Callback to determine if failed items should be reprocessed</param>
/// <param name="progress">Callback to report progress in percentage</param>
/// <returns></returns>
IEnumerable<T> ProcessItems<T>(
    IList<T> items,
    Action<T, Action<int>> processItem,
    Func<IEnumerable<KeyValuePair<T, Exception>>, bool> shallRetry,
    Action<int> progress)
{
    int count = items.Count;
    var completed = new HashSet<T>();
    bool eject = false;
    do
    {
        progress(0);
        var failures = new Queue<KeyValuePair<T, Exception>>();
        for (int i = 0; i < count; i++)
        {
            T item = items[i];
            if (!completed.Contains(item))
            {
                try
                {
                    processItem(item, p => progress(p / count + i * 100 / count));
                    completed.Add(item);
                }
                catch (Exception e)
                {
                    failures.Enqueue(new KeyValuePair<T, Exception>(item, e));
                }
            }
            progress((i + 1) * 100 / count);
        }
        if (failures.Any())
        {
            eject = !shallRetry(failures);
        }
    }
    while (completed.Count < count && !eject);
    return completed;
}
```

