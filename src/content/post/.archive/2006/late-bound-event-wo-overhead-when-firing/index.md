---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: late-bound-event-wo-overhead-when-firing
tags:
- dotnet
title: Late bound event w/o overhead when firing
---


<pre class="csharpcode"><span class="kwrd">interface</span> IDynamicEvents 
{ 
    <span class="kwrd">bool</span> Subscribe(MulticastDelegate eventHandler, <span class="kwrd">string</span> eventName); 
    <span class="kwrd">bool</span> Unsubscribe(MulticastDelegate eventHandler, <span class="kwrd">string</span> eventName); 
} 

<span class="kwrd">abstract</span> <span class="kwrd">class</span> DynamicEventsBase : IDynamicEvents 
{ 
    <span class="preproc">#region</span> Private 
    <span class="kwrd">private</span> WeakReference _wrEventDictionary = <span class="kwrd">new</span> WeakReference(<span class="kwrd">null</span>); 

    <span class="kwrd">private</span> SortedDictionary&lt;<span class="kwrd">string</span>, EventInfo&gt; EventDictionary 
    { 
        get 
        { 
            SortedDictionary&lt;<span class="kwrd">string</span>, EventInfo&gt; eventDictionary = _wrEventDictionary.Target <span class="kwrd">as</span> SortedDictionary&lt;<span class="kwrd">string</span>, EventInfo&gt;; 
            <span class="kwrd">if</span> (eventDictionary == <span class="kwrd">null</span>) 
            { 
                _wrEventDictionary.Target = eventDictionary = <span class="kwrd">new</span> SortedDictionary&lt;<span class="kwrd">string</span>, EventInfo&gt;(StringComparer.Ordinal); 
                <span class="kwrd">foreach</span> (EventInfo ei <span class="kwrd">in</span> GetType().GetEvents(BindingFlags.Instance  BindingFlags.Public)) 
                    eventDictionary.Add(ei.Name, ei); 
            } 
            <span class="kwrd">return</span> eventDictionary; 
        } 
    } 
    <span class="preproc">#endregion</span> 

    <span class="preproc">#region</span> IDynamicEvents Members 
    <span class="kwrd">public</span> <span class="kwrd">bool</span> Subscribe(MulticastDelegate eventHandler, <span class="kwrd">string</span> eventName) 
    { 
        EventInfo ei = EventDictionary[eventName]; 
        <span class="kwrd">if</span> (ei != <span class="kwrd">null</span>) 
        { 
            ei.AddEventHandler(<span class="kwrd">this</span>, eventHandler); 
            <span class="kwrd">return</span> <span class="kwrd">true</span>; 
        } 
        <span class="kwrd">return</span> <span class="kwrd">false</span>; 
    } 

    <span class="kwrd">public</span> <span class="kwrd">bool</span> Unsubscribe(MulticastDelegate eventHandler, <span class="kwrd">string</span> eventName) 
    { 
        EventInfo ei = EventDictionary[eventName]; 
        <span class="kwrd">if</span> (ei != <span class="kwrd">null</span>) 
        { 
            ei.RemoveEventHandler(<span class="kwrd">this</span>, eventHandler); 
            <span class="kwrd">return</span> <span class="kwrd">true</span>; 
        } 
        <span class="kwrd">return</span> <span class="kwrd">false</span>; 
    } 
    <span class="preproc">#endregion</span> 
}</code></pre>

