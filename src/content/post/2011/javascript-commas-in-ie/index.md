---
author: "@klinkby"
keywords:
- javascript
- www
date: "2011-09-20T22:00:00Z"
description: ""
draft: false
slug: javascript-commas-in-ie
tags:
- javascript
- www
title: JavaScript commas in IE
---


While working with [JQuery UI DataTables](http://datatables.net) I got some strange JS errors in IE. And not from any-better-browser.   

> `'style' is null or not an object`

  My Google cortex provided [the answer](http://www.openjs.com/articles/ie/array_comma_problem.php): IE javascript engine treats array/object initialization different from other engines. While other browsers simply ignores if the initialization has a trailing comma, IE don't. Searching through code to find commas ain't my kind of fun, so the following regular expression will find the instances for you.   

> `,\s*?[\}\]]`

  I use [ Derek Slager's better regex tester](http://derekslager.com/blog/posts/2007/09/a-better-dotnet-regular-expression-tester.ashx) regularly (pun intended).

