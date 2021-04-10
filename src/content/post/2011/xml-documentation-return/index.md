---
author: "@klinkby"
keywords:
- dotnet
- xml
date: "2011-05-02T22:00:00Z"
description: ""
draft: false
slug: xml-documentation-return
tags:
- dotnet
- xml
title: Return value missing from xml doc
---


I recently used Oleg Tkachenko's nice (and old) [MultiOutTransform](http://msdn.microsoft.com/en-us/library/ms950784.aspx) to generate HTML documentation for a little C# project. It was important that the documentation was always updated, so I checked the "XML documentation file" project setting and added a call to MultiOutTransform in the post build event. There is a small, but quite imporant thing missing from the generated output: Return values. To get them in the output, insert the following chunk at line 271 in xmldoc-class.xsl.   

```XML
<xsl:if test="returns"> <h4 class="dtH4">Returns</h4> <div class="returns"> <xsl:apply-templates select="returns"/> </div> </xsl:if>
```
