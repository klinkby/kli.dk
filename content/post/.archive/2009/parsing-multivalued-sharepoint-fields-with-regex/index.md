---
author: Mads Klinkby
categories:
- .net
- sharepoint
date: "2009-03-31T22:00:00Z"
description: ""
draft: false
slug: parsing-multivalued-sharepoint-fields-with-regex
tags:
- .net
- sharepoint
title: Parsing multivalued SharePoint fields with Regex
---


As Mark Arend [ points out](http://blogs.msdn.com/markarend/archive/2007/05/29/parsing-multi-value-fields-multichoice-lookup-user-url-rules-for-the-delimiter.aspx) on his blog, there are quite a number of ways SharePoint formats complex field values. His list even misses the Lookup multiple values variant that e.g. can be: "Kategori 2;#1;#Kategori 1".

To split the composite fields we need a little regular expression fission:

<pre class="csharpcode"><code><span class="kwrd">readonly</span> <span class="kwrd">static</span> Regex _regex = <span class="kwrd">new</span> Regex(
  <span class="str">@"([\#]?(\d+;\#)?)?(?'item'[^;]+)(\#?)"</span>,
  RegexOptions.ExplicitCapture | RegexOptions.Compiled | RegexOptions.CultureInvariant);

<span class="kwrd">static</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; SplitsAnySPMultiValueField(<span class="kwrd">string</span> <span class="kwrd">value</span>)
{
  <span class="kwrd">return</span> _regex.Matches(<span class="kwrd">value</span>).Cast&lt;Match&gt;()
         .Select(match =&gt; match.Groups[<span class="str">"item"</span>].Value);
}</code></pre>

Here is a list of examples.
  <table border="0" cellspacing="0" cellpadding="2"> <tbody> <tr> <td valign="top" width="133">Field Type</td> <td valign="top" width="120">Input</td> <td valign="top" width="113">Output</td> </tr>  <tr> <td valign="top" width="144">Choices</td> <td valign="top" width="127">;First;Second;Third</td> <td valign="top" width="118">{First,Second,Third}</td> </tr>  <tr> <td valign="top" width="147">Lookup</td> <td valign="top" width="129">1;#First</td> <td valign="top" width="120">{First}</td> </tr>  <tr> <td valign="top" width="147">Lookup multiple</td> <td valign="top" width="130">Kategori 2;#1;#Kategori 1</td> <td valign="top" width="121">{Kategori2,Kategori1}</td> </tr>  <tr> <td valign="top" width="147">Person or Group</td> <td valign="top" width="130">42;#Zaphod Beeblebrox</td> <td valign="top" width="122">{Zaphod Beeblebrox}</td> </tr> </tbody> </table>  

The Hyperlink/Picture field value is comma separated, and I didn't want to split any text containing a comma, so that one is another story.

