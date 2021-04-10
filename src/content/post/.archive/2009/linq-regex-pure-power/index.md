---
author: "@klinkby"
keywords:
- dotnet
date: "2009-05-11T22:00:00Z"
description: ""
draft: false
slug: linq-regex-pure-power
tags:
- dotnet
title: Linq + Regex = pure power
---


Combining regular expressions with linq gives an extremely fast and powerful high level description of string parsing, that traditionally results in very verbose iteration/condition/assignment code.

Due to the complete lack of strongly typed IEnumerable<T> implementations in the System.Text.RegularExpression namespace, some Cast<T> need to be applied.

Here's an example that returns a unique lowercase list of the first word from a list of camel-cased strings that have multiple words:

<pre class="csharpcode"><code><span class="kwrd">static</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; FirstWords(
    <span class="kwrd">this</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; values)
{
    Regex reg = <span class="kwrd">new</span> Regex(
        <span class="str">@"(?'entity'[A-Za-z\d][\da-z_]+)([A-Za-z\d][\da-z_]+)"</span>,
        RegexOptions.Compiled | 
        RegexOptions.CultureInvariant | 
        RegexOptions.ExplicitCapture);
    <span class="kwrd">return</span> values.SelectMany(
        <span class="kwrd">value</span> =&gt; reg.Matches(<span class="kwrd">value</span>).Cast&lt;Match&gt;().Select(
           match =&gt; match.Groups[<span class="str">"entity"</span>].Value.ToLowerInvariant()
        )
    ).Distinct(StringComparer.Ordinal);
}</code></pre>
Sweet eh? Try do that with System.String...

