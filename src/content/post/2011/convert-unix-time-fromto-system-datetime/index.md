---
author: "@klinkby"
keywords:
- dotnet
date: "2011-04-25T22:00:00Z"
description: ""
draft: false
slug: convert-unix-time-fromto-system-datetime
tags:
- dotnet
title: Convert Unix Time from/to System.DateTime
---


A pair of simple methods for working with [Unix time](http://en.wikipedia.org/wiki/Unix_epoch) in .NET. The code uses a
64 bit integer datatype so is not affected by [2038 problem](http://en.wikipedia.org/wiki/Year_2038_problem).

```C#
static class DateTimeExtensions
{
    static readonly DateTime BeginningOfUnixTime = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

    public static DateTime FromUnix(long unixTime)
    {
        return BeginningOfUnixTime.AddSeconds(unixTime).ToLocalTime();
    }

    public static long ToUnix(this DateTime dt)
    {
        return (long)((dt.ToUniversalTime() - BeginningOfUnixTime).TotalSeconds);
    }
}
```
