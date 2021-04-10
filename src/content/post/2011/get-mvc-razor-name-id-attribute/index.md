---
author: "@klinkby"
keywords:
- dotnet
- www
date: "2011-08-11T22:00:00Z"
description: ""
draft: false
slug: get-mvc-razor-name-id-attribute
tags:
- dotnet
- www
title: Getting Razor component id
---


It seems odd there is no standard way of getting the name of a control rendered with the Html helper extensions in MVC3 Razor. I saw [ some proposed solutions](http://stackoverflow.com/questions/4829193/how-to-get-the-html-id-generated-by-asp-net-mvc-editorfor), but none of the actually worked e.g. in partial views or [ list binding](http://haacked.com/archive/2008/10/23/model-binding-to-a-list.aspx).

This solution gets it right, but is nonetheless just another hack. You can easily modify the regular expression to get the id instead of the name.


```C#
@using System.Text.RegularExpressions
@{var regex = new Regex(
      @"\sname\=""(?'val'[^""]+?)""",
      RegexOptions.CultureInvariant | RegexOptions.Compiled | RegexOptions.ExplicitCapture); }
:
@Html.TextBoxFor(m => m.Value)          
<span data-valmsg-for="@(regex.Match(Html.TextBoxFor(m => m.Value).ToHtmlString())
                              .Groups[1]
                              .Value)"></span>
```