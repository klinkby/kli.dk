---
author: Mads Klinkby
categories:
- .net
- www
date: "2011-08-11T22:00:00Z"
description: ""
draft: false
slug: get-mvc-razor-name-id-attribute
tags:
- .net
- www
title: Getting Razor component id
---


It seems odd there is no standard way of getting the name of a control rendered with the Html helper extensions in MVC3 Razor. I saw [ some proposed solutions](http://stackoverflow.com/questions/4829193/how-to-get-the-html-id-generated-by-asp-net-mvc-editorfor), but none of the actually worked e.g. in partial views or [ list binding](http://haacked.com/archive/2008/10/23/model-binding-to-a-list.aspx).

This solution gets it right, but is nonetheless just another hack. You can easily modify the regular expression to get the id instead of the name.

<pre class="csharpcode"><code><span class="rem">@using</span> System.Text.RegularExpressions
<span class="rem">@{</span><span class="kwrd">var</span> regex = <span class="kwrd">new</span> Regex(
      @"\sname\=""(?'val'[^""]+?)""",
      RegexOptions.CultureInvariant | RegexOptions.Compiled | RegexOptions.ExplicitCapture); <span class="rem">}</span>
:
@Html.TextBoxFor(m =&gt; m.Value)          
&lt;span data-valmsg-for="<span class="rem">@(</span>regex.Match(Html.TextBoxFor(m =&gt; m.Value).ToHtmlString())
                              .Groups[1]
                              .Value<span class="rem">)</span>"&gt;&lt;/span&gt;</code></pre>

