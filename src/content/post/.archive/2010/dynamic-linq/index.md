---
author: "@klinkby"
keywords:
- dotnet
- pattern
date: "2010-01-18T23:00:00Z"
description: ""
draft: false
slug: dynamic-linq
tags:
- dotnet
- pattern
title: Validation rules engine
---


A client had got a requirement from their customer that specified a rule definition engine that should validate input
for a data entry appliation. The specification was completely general and allowed for any arbitrary rule to be processed
on any of the current and historic structured data, including intermediate results, mathematical, logical operators and
statistical functions. The rules should be maintained by a server administrator. After reading this requirement most
developers instantly get the shivers after quickly thinking DSL, parsers, interpreter pattern and lexical analysis. Due
to abstractness this is indeed a mammoth requirement. The solution is obviously some kind of DSL that enables an IT
pro (rule out XML-based DSLs) to describe a validation rule as a functional expression containing context dependent data
properties and common operators. The expression resolves to a boolean value determining if the data passed validation.
Expression. Expression tree. LINQ expression trees match the above requirements, are build and evaluated runtime and a
technology familiar to many developers. Feeding an expression tree with a domain model of the data will enable writing
expressions like:

Orders.Count >= Employees.Count * 20
One thing is missing though. Expression trees are constructed as an object model, not a literal query. The parser that
converts a string to an expression tree is included in
Microsoft's [VS2008 samples](http://msdn.microsoft.com/en-us/vcsharp/bb894665.aspx). See
also [ ScottGu's walkthrough](http://weblogs.asp.net/scottgu/archive/2008/01/07/dynamic-linq-part-1-using-the-linq-dynamic-query-library.aspx).

var expr = DynamicExpression.ParseLambda<MyModel, <span class="kwrd">bool</span>>(<span class="str">"Employees.Count >=
1"</span>); Assert.IsTrue(expr.Compile()(<span class="kwrd">new</span> MyModel()));
Executing dynamic code always calls for
the [ security goggles](http://abdullin.com/journal/2009/1/13/vulnerability-of-the-dynamic-linq.html), this is no
exception. But as the requirement states the expressions must be maintained by the server administrator precautions can
be taken. Mammoth now mouse.

