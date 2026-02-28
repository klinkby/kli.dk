---
author: "@klinkby"
keywords:
- dotnet
date: "2011-04-13T22:00:00Z"
description: ""
draft: false
slug: check-if-a-file-is-locked
tags:
- dotnet
title: Check if a file is locked
---


One notable feature that is missing from the IO section of the .NET base class library is a way to check if a file is
locked. When opening a file the [ OpenFile](http://msdn.microsoft.com/en-us/library/aa365430(v=vs.85).aspx) et al API
methods does actually provide the information, we just have
to [ dig a little](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.marshal.gethrforexception.aspx)
to discover it.

```C#
static bool IsFileLocked(string filename)
{
    bool locked = false;
    try
    {
        File.Open(filename, FileMode.Open, FileAccess.ReadWrite, FileShare.None).Dispose();
    }
    catch (IOException e)
    {
        const int ERROR_SHARING_VIOLATION = 0x20;
        const int ERROR_LOCK_VIOLATION = 0x21;
        int errorCode = Marshal.GetHRForException(e) & ((1 << 16) - 1);
        locked = errorCode == ERROR_SHARING_VIOLATION
               || errorCode == ERROR_LOCK_VIOLATION;
        if (!locked)
            throw;                
    }
    return locked;
}
```
