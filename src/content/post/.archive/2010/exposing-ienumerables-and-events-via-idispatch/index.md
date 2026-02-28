---
author: "@klinkby"
keywords:
- dotnet
date: "2010-10-28T22:00:00Z"
description: ""
draft: false
slug: exposing-ienumerables-and-events-via-idispatch
tags:
- dotnet
title: Exposing IEnumerables and events via IDispatch
---


No doubt in my mind. The world would be a better place without COM (sorry @donbox). Just spent some time relearning *s*
the best practices for exposing an enumeration to IDispatch affected applications (like Dynamics NAV). One of the
gotchas is .NET exposes the IEnumerable.GetEnumerator() as DispId(-4), that returns IEnumVARIANT, which doesn't
implement IDispatch.

<pre class="csharpcode"><code>[ComVisible(<span class="kwrd">true</span>),
    Guid(<span class="str">"6BBEFFA7-4215-40B1-AC27-65C093C1D9A8"</span>),
    InterfaceType(ComInterfaceType.InterfaceIsDual)]
<span class="kwrd">public</span> <span class="kwrd">interface</span> IClientEnumerator
{
    [DispId(0x01)]
    Client Current
    { get; }
    [DispId(0x02)]
    <span class="kwrd">bool</span> MoveNext();
    [DispId(0x03)]
    <span class="kwrd">void</span> Reset();
    [DispId(0x04)]
    <span class="kwrd">int</span> Count
    { get; }
}
   
[ComVisible(<span class="kwrd">true</span>),
    Guid(<span class="str">"8008EE9E-5C2B-4F17-BD81-21B199550BD2"</span>),
    ProgId(<span class="str">"ClientEnumerator"</span>),
    ClassInterface(ClassInterfaceType.None),
    ComDefaultInterface(<span class="kwrd">typeof</span>(IClientEnumerator))]
<span class="kwrd">public</span> <span class="kwrd">class</span> ClientEnumerator : IClientEnumerator, IEnumerator
{
    IEnumerator&lt;Client&gt; m_e;
    Func&lt;<span class="kwrd">int</span>&gt; m_count;
    <span class="kwrd">internal</span> ClientEnumerator(IEnumerable&lt;Client&gt; e)
    {            
        m_e = e.GetEnumerator();
        m_count = () =&gt; e.Count();
    }
    <span class="kwrd">public</span> <span class="kwrd">int</span> Count
    {
        get { <span class="kwrd">return</span> m_count(); }
    }
    <span class="kwrd">public</span> <span class="kwrd">bool</span> MoveNext()
    {
        <span class="kwrd">return</span> m_e.MoveNext();
    }
    <span class="kwrd">public</span> <span class="kwrd">void</span> Reset()
    {
        m_e.Reset();
    }       
    <span class="kwrd">public</span> Client Current
    {
        get { <span class="kwrd">return</span> m_e.Current; }
    }
    <span class="kwrd">object</span> IEnumerator.Current
    {
        get { <span class="kwrd">return</span> <span class="kwrd">this</span>.Current; }
    }
}   </code></pre>

Also remember to put a GuidAttribute on the assembly scope. The AssemblyDescriptionAttribute is used for typelib title
i.e. "MyTypelib 1.0 Type Library", and the assembly name set in project properties defines the type library name used
for "typelibid.progid".

Events, or so called connection point, can be exposed by defining a dispatch interface like:

<pre class="csharpcode"><code>[ComVisible(<span class="kwrd">true</span>),
    CLSCompliant(<span class="kwrd">false</span>),
    Guid(<span class="str">"B9C6A999-CD39-4C8D-B072-639069CFA8B6"</span>),
    InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
<span class="kwrd">public</span> <span class="kwrd">interface</span> _ClientsEvents
{
    [DispId(0x01)]
    <span class="kwrd">void</span> AddCompleted(<span class="kwrd">object</span> sender, AsyncCompletedEventArgs e);
}</code></pre>

And adding a [ComSourceInterfaces(typeof(_ClientsEvents))] attribute to the class with an event which name and delegate
corresponds exactly to each method in the interface.

Note that generic types cannot be exported, and ALL types that i marshalled (even if they are only exposed though an
interface) must have ComVisible(true).

