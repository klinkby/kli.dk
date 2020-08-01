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

<pre class="csharpcode"><code><span class="rem">/// &lt;summary&gt;</span>
<span class="rem">/// General UX process pattern that processes some items sequencially, while</span>
<span class="rem">/// reporting progress. Should items fail processing, the caller can retry</span>
<span class="rem">/// processing those.</span>
<span class="rem">/// &lt;/summary&gt;</span>
<span class="rem">/// &lt;typeparam name="T"&gt;Item type&lt;/typeparam&gt;</span>
<span class="rem">/// &lt;param name="items"&gt;Collection of items to process&lt;/param&gt;</span>
<span class="rem">/// &lt;param name="processItem"&gt;Callback to process an item. The second parameter is for reporting</span> 
<span class="rem">/// progress in completion percentage for that item.&lt;/param&gt;</span>
<span class="rem">/// &lt;param name="askRetry"&gt;Callback to determine if failed items should be reprocessed&lt;/param&gt;</span>
<span class="rem">/// &lt;param name="progress"&gt;Callback to report progress in percentage&lt;/param&gt;</span>
<span class="rem">/// &lt;returns&gt;&lt;/returns&gt;</span>
IEnumerable&lt;T&gt; ProcessItems&lt;T&gt;(
    IList&lt;T&gt; items,
    Action&lt;T, Action&lt;<span class="kwrd">int</span>&gt;&gt; processItem,
    Func&lt;IEnumerable&lt;KeyValuePair&lt;T, Exception&gt;&gt;, <span class="kwrd">bool</span>&gt; shallRetry,
    Action&lt;<span class="kwrd">int</span>&gt; progress)
{
    <span class="kwrd">int</span> count = items.Count;
    var completed = <span class="kwrd">new</span> HashSet&lt;T&gt;();
    <span class="kwrd">bool</span> eject = <span class="kwrd">false</span>;
    <span class="kwrd">do</span>
    {
        progress(0);
        var failures = <span class="kwrd">new</span> Queue&lt;KeyValuePair&lt;T, Exception&gt;&gt;();
        <span class="kwrd">for</span> (<span class="kwrd">int</span> i = 0; i &lt; count; i++)
        {
            T item = items[i];
            <span class="kwrd">if</span> (!completed.Contains(item))
            {
                <span class="kwrd">try</span>
                {
                    processItem(item, p =&gt; progress(p / count + i * 100 / count));
                    completed.Add(item);
                }
                <span class="kwrd">catch</span> (Exception e)
                {
                    failures.Enqueue(<span class="kwrd">new</span> KeyValuePair&lt;T, Exception&gt;(item, e));
                }
            }
            progress((i + 1) * 100 / count);
        }
        <span class="kwrd">if</span> (failures.Any())
        {
            eject = !shallRetry(failures);
        }
    }
    <span class="kwrd">while</span> (completed.Count &lt; count &amp;&amp; !eject);
    <span class="kwrd">return</span> completed;
}</code></pre>

