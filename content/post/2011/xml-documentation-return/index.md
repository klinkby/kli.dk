---
author: Mads Klinkby
categories:
- .net
- xml
- xsl
date: "2011-05-02T22:00:00Z"
description: ""
draft: false
slug: xml-documentation-return
tags:
- .net
- xml
- xsl
title: Return value missing from xml doc
---


I recently used Oleg Tkachenko's nice (and old) [MultiOutTransform](http://msdn.microsoft.com/en-us/library/ms950784.aspx) to generate HTML documentation for a little C# project. It was important that the documentation was always updated, so I checked the "XML documentation file" project setting and added a call to MultiOutTransform in the post build event. There is a small, but quite imporant thing missing from the generated output: Return values. To get them in the output, insert the following chunk at line 271 in xmldoc-class.xsl.   

 <span class="kwrd"><</span><span class="html">xsl:if</span> <span class="attr">test</span><span class="kwrd">="returns"</span><span class="kwrd">></span>   <span class="kwrd"><</span><span class="html">h4</span> <span class="attr">class</span><span class="kwrd">="dtH4"</span><span class="kwrd">></span>Returns<span class="kwrd"></</span><span class="html">h4</span><span class="kwrd">></span>   <span class="kwrd"><</span><span class="html">div</span> <span class="attr">class</span><span class="kwrd">="returns"</span><span class="kwrd">></span>     <span class="kwrd"><</span><span class="html">xsl:apply-templates</span> <span class="attr">select</span><span class="kwrd">="returns"</span><span class="kwrd">/></span>   <span class="kwrd"></</span><span class="html">div</span><span class="kwrd">></span> <span class="kwrd"></</span><span class="html">xsl:if</span><span class="kwrd">></span>

