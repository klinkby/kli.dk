---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: microsoft-and-w3-standards-blues
tags:
- dotnet
title: Microsoft and W3 standards blues
---


I have been working on an ASP.NET 2.0 website for a while and I like interoperability so I aim for XHTML1.1 conformance.
I set strict=true in web config, and add the doctype to the top of my master page, and set the content type to "
application/xhtml+xml" as the [standard](http://www.w3.org/TR/xhtml11/) suggests. Opera and Mozilla renders the pages
very nice, but IE just spews out an XML error. A
little [digging](http://blogs.msdn.com/ie/archive/2005/09/15/467901.aspx) reveals that IE6 doesn't support the content
type for XHTML. Nor will the unreleased (state-of-the-art?) IE7 :-( With the content type reverted back to "
application/html", even IE rendered the page. Opera has this nice feature where it can upload a document to the W3
validator, and I was not entirely surpised to see that the document rendered by the asp.net engine, was not xhtml
compliant. After some tweaking I decided to drop the asp:menu control alltogether, it renders a tables-bloat anyway -
instead I used a solution where my xml menu is transformed into
a [Suckerfish](http://www.htmldog.com/articles/suckerfish/dropdowns/)-like menu that is xhtml1.1 compliant,<li> based
and much more compact. I hope M$ will get it right next time.

