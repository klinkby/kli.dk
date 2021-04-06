---
author: Mads Klinkby
categories:
- .net
- pattern
- stream
date: "2011-09-21T22:00:00Z"
description: ""
draft: false
slug: decorator-stream
tags:
- .net
- pattern
- stream
title: DecoratorStream
---


In scenarios where you want to extend functionality of a simple [ System.IO.Stream](http://msdn.microsoft.com/en-us/library/system.io.stream.aspx) instance, it is convenient to have a [decorator](http://en.wikipedia.org/wiki/Decorator_pattern).   <div>  
 </div>  <div>Neither the original stream or the client instance will have to know anything about the extension as it is still just a Stream. This can be used to add position tracking or to manage lifetime. For instance you might want to dispose a [ System.Net.HttpWebResponse](http://msdn.microsoft.com/en-us/library/system.net.httpwebresponse.aspx) instance that created the stream when the stream is being closed. The most straightforward way to achieve this is to copy/paste the code below and inherit that class to create your stream extender. </div>  <div>  
 </div>  <div>Of course you could also have done this with a [dynamic proxy](http://www.castleproject.org/dynamicproxy/index.html) plus [interceptor](http://en.wikipedia.org/wiki/Interceptor_pattern).</div>  <div>    

```C#
abstract class DecoratorStream : Stream
{
    Stream m_stream;

    protected DecoratorStream(Stream stream)
    {
        m_stream = stream;
    }

    public override int ReadByte()
    {
        return m_stream.ReadByte();
    }

    public override int Read(byte[] buffer, int offset, int count)
    {
        return m_stream.Read(buffer, offset, count);
    }

    public override long Seek(long offset, SeekOrigin origin)
    {
        return m_stream.Seek(offset, origin);
    }

    public override IAsyncResult BeginRead(byte[] buffer, int offset, int count, AsyncCallback callback, object state)
    {
        return m_stream.BeginRead(buffer, offset, count, callback, state);
    }

    public override IAsyncResult BeginWrite(byte[] buffer, int offset, int count, AsyncCallback callback, object state)
    {
        return m_stream.BeginWrite(buffer, offset, count, callback, state);
    }

    public override bool CanRead
    {
        get { return m_stream.CanRead; }
    }

    public override bool CanSeek
    {
        get { return m_stream.CanSeek; }
    }

    public override bool CanTimeout
    {
        get
        {
            return m_stream.CanTimeout;
        }
    }

    public override bool CanWrite
    {
        get { return m_stream.CanWrite; }
    }

    public override void Close()
    {
        m_stream.Close();
    }

    public override int EndRead(IAsyncResult asyncResult)
    {
        return m_stream.EndRead(asyncResult);
    }

    public override void EndWrite(IAsyncResult asyncResult)
    {
        m_stream.EndWrite(asyncResult);
    }

    public override void Flush()
    {
        m_stream.Flush();
    }

    public override long Length
    {
        get { return m_stream.Length; }
    }

    public override long Position
    {
        get
        {
            return m_stream.Position;
        }
        set
        {
            m_stream.Position = value;
        }
    }

    public override int ReadTimeout
    {
        get
        {
            return m_stream.ReadTimeout;
        }
        set
        {
            m_stream.ReadTimeout = value;
        }
    }

    protected override void Dispose(bool disposing)
    {
        try
        {
            m_stream.Dispose();
        }
        finally
        {
            base.Dispose(disposing);
        }
    }

    public override void SetLength(long value)
    {
        m_stream.SetLength(value);
    }

    public override void Write(byte[] buffer, int offset, int count)
    {
        m_stream.Write(buffer, offset, count);
    }

    public override void WriteByte(byte value)
    {
        m_stream.WriteByte(value);
    }

    public override int WriteTimeout
    {
        get
        {
            return m_stream.WriteTimeout;
        }
        set
        {
            m_stream.WriteTimeout = value;
        }
    }
}
```
