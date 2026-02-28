---
author: "@klinkby"
keywords:
- dotnet
- dotnet
- pattern
date: "2011-02-28T23:00:00Z"
description: ""
draft: false
slug: console-application-commands
tags:
- dotnet
- dotnet
- pattern
title: Commands in console application
---


Here is a simple template for creating C# console applications that take a parameter that controls what the application
should do. The example code has one (exciting) command "sayhello", but you can add new commands simply by creating a new
public static method in the class. Central of course is GoF command pattern, and .NET Reflection gives the dynamics.

```C#
using System;
using System.Diagnostics;
using System.Linq;
using System.Reflection;

class Program
{
const BindingFlags flags = BindingFlags.Public 
    | BindingFlags.Static | BindingFlags.IgnoreCase;

static int Main(string[] args)
{
    if (args.Length > 0)
    {
        MethodInfo mi = typeof(Program).GetMethod(
                            args[0].ToLowerInvariant(),
                            flags);
        var cmd = (Func<int>)Delegate.CreateDelegate(
                            typeof(Func<int>),
                            mi);
        return Execute(cmd);
    }
    else
    {
        Console.WriteLine(
            "Usage:\r\n\t{0} command", 
            Process.GetCurrentProcess().ProcessName );
        Console.WriteLine(
            "\r\nList of commands:\r\n\t{0}",
            string.Join(
                "\r\n\t",
                typeof(Program).GetMethods(flags)
                                .Select(x => x.Name
                                              .ToLowerInvariant())
                                .OrderBy(x => x)
                                .ToArray())
            );
        return 0;
    }
}

static int Execute(Func<int> command)
{
    int retval = 0;
    try
    {
        retval = command();
    }
    catch (Exception e)
    {
        Console.Error.WriteLine("FAIL: " + e.ToString());
        return -1;
    }
    return retval;
}

public static int SayHello()
{
    Console.WriteLine("Hello world!");
    return 0;
}
}
```

