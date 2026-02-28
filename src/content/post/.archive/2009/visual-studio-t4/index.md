---
author: "@klinkby"
keywords:
- dotnet
date: "2009-09-03T22:00:00Z"
description: ""
draft: false
slug: visual-studio-t4
tags:
- dotnet
title: VS2008 template for immutables
---


The best kept Visual Studio 2008 secret is the built in code generator called T4 that lets you define a DSL to write
code, xml or whatever for you to be included at compile time. Yes, that's right. This is quite useful for generating
e.g. DAL or tedious verbose implementations, like immutable classes. So as an example I wrote a T4 template for the
latter. To use it add the template to a C# project, and create a file called e.g. Size.tt with the following contents:

 <pre class="csharpcode"><code>&lt;#@ include file=<span class="str">"Immutable.tt"</span> #&gt;
&lt;#= Immutable.Struct(Host, <span class="str">"float Width;float Height"</span>) #&gt;</code>
</pre>

As you save the files, you will see that a .cs file is created below the .tt file, and the struct have been generated in
the project's default namespace. The struct is partial so you can easily extend it with attributes, base classes or
additional methods in other class files. The template can be found
at [http://t4.codeplex.com/](http://t4.codeplex.com/). I hope you find it useful or at least feel inspired to make some
of your own.

