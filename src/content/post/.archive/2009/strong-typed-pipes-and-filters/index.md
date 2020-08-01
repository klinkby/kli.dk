---
author: Mads Klinkby
categories:
- .net
date: "2009-10-20T22:00:00Z"
description: ""
draft: false
slug: strong-typed-pipes-and-filters
tags:
- .net
title: Strong typed Pipes-and-Filters
---


The idea of [piping](http://en.wikipedia.org/wiki/Pipeline_(software)) (feeding) the output of one task to the input of the next dates back to early UNIX days. A common MS example is "`type readme.txt | more`", where the contents of the file is directed to the more command that prints it on the console a page at a time. Basically its definition is contains two elements:   

1.  The filter is an interface with single method that takes one parameter, and either allows the method to change its value or return another value. The name filter is a bit misleading, as the implementation doesn't have to actually filter anything, it can e.g. enrich the input or as seen above print pages on the console. Think functors, f(x).
2.  The pipe connects the filters, and can augment each process with persistence, monitoring etc.  Over the last few years I've come across various perceptions and implementations of the pipes and filters pattern, and previously I've [published one](http://microbus.codeplex.com/) where the two where merged together, so the filter was responsible for calling the next in the chain. Of course this is a violation of the single responsibility principle. Anyways, that implementation piped messages with byte arrays, others pipe objects but I have yet to see strongly typed implementation, which would abstract to:   

<pre class="csharpcode"><code><span class="kwrd">interface</span> IFilter&lt;TIn, TOut&gt;
{
   TOut Process(TIn <span class="kwrd">value</span>);
}
</code></pre>

  In the following called IFilter`2. Where the implementations could have different template parameters. This would avoid casting/serialization and bring full compile time type check. One reason why it's not so common could be that the iterators in the .NET CLR can't handle abstract generic types. For instance you cannot have an array with both   

<pre class="csharpcode"><code> IFilter&lt;<span class="kwrd">int</span>,<span class="kwrd">string</span>&gt; </code></pre>

and  

<pre class="csharpcode"><code>IFilter&lt;<span class="kwrd">byte</span>,Uri&gt;</code></pre>

  in it without up/downcasting, as they refer to to separate concrete types. So get around that, I implemented the pipes as a [strategy](http://en.wikipedia.org/wiki/Strategy_pattern)/[composite](http://en.wikipedia.org/wiki/Composite_pattern) patterns that hide the details of the filter chain to the context object, by exposing only the first input and last output endpoints thus forming a new IFilter`2. A-ha! So given the above mentioned concrete filters would combine into an IFilter<int, Uri>. Programmatically this is done as simple as:   

<pre class="csharpcode"><code>firstFilterInstance.ConnectTo(secondFilterInstance)
</code></pre>
 
 I should note there is also support for assembling the filters by declarative construction using [IoC containers](http://en.wikipedia.org/wiki/Inversion_of_control). In the example I used [Castle Windsor](http://www.castleproject.org/container/index.html). I decided to let the interface be [ IDisposable](http://msdn.microsoft.com/en-us/library/system.idisposable(lightweight).aspx) and added a second method:   

<pre class="csharpcode"><code><span class="kwrd">bool</span> CanProcess(Tin <span class="kwrd">value</span>)
</code></pre>

  It obviously determines whether the filter is able to handle that particular type of input. This enables building a message mediator, where a number of filters can have their inputs connected, but only the one(s) for that particular message type will handle it. This is done using the SplitterFilter`2. Or it can be used for doing forks and parallel processing filter graphs. The solution is available at [http://pnf.codeplex.com/](http://pnf.codeplex.com/) under the Lesser GPL license.

