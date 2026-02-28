---
author: "@klinkby"
keywords:
- dotnet
- soap
date: "2011-01-11T23:00:00Z"
description: ""
draft: false
slug: wcf-client-channel
tags:
- dotnet
- soap
title: WCF Client Channel snippet
---


Generally I use WCF client channels with the code snippet below that handles channel lifetime, failed channel states and
context required for nested WCF calls.

```C#
static TReturn WithChannel<TChannel, TReturn>(Func<TChannel, TReturn> func)
    where TChannel : IContextChannel
{
    TChannel channel = CreateChannel();
    try
    {
        using (new OperationContextScope(channel)) 
        {
            TReturn ret = func(channel);
            return ret;
        }
    }
    finally
    {
        try
        {
            ((IDisposable)channel).Dispose(); // ~= Close()
        }
        catch (CommunicationException) { ((IChannel)channel).Abort(); }
        catch (TimeoutException) { ((IChannel)channel).Abort(); }
    }
}
```
