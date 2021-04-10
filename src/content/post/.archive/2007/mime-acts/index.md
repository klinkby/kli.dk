---
author: "@klinkby"
keywords:
- dotnet
date: "2007-06-11T22:00:00Z"
description: ""
draft: false
slug: mime-acts
tags:
- dotnet
title: Mime acts
---


If you've served stuff programatically on the IIS, you know you need to set the Response.ContentType. This little function helps getting the mime for any registered extension (without the huge switch statements that I've seen some articles suggest). [sourcecode language='csharp'] private static string GetMime(string fileName) { RegistryKey classesRoot = Registry.ClassesRoot; string fileExtension = Path.GetExtension(fileName); RegistryKey typekey = classesRoot.OpenSubKey(@"MIME\Database\Content Type"); foreach (string strKeyName in typekey.GetSubKeyNames()) { RegistryKey curKey = classesRoot.OpenSubKey(@"MIME\Database\Content Type\" + strKeyName); string regExt = (string)curKey.GetValue("Extension"); if (string.Compare(regExt, fileExtension, true) == 0) { return strKeyName; } } return null; } [/sourcecode]

