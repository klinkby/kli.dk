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

<pre class="csharpcode"><code><span class="kwrd">abstract</span> <span class="kwrd">class</span> DecoratorStream : Stream
{
    Stream m_stream;

    <span class="kwrd">protected</span> DecoratorStream(Stream stream)
    {
        m_stream = stream;
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> ReadByte()
    {
        <span class="kwrd">return</span> m_stream.ReadByte();
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> Read(<span class="kwrd">byte</span>[] buffer, <span class="kwrd">int</span> offset, <span class="kwrd">int</span> count)
    {
        <span class="kwrd">return</span> m_stream.Read(buffer, offset, count);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">long</span> Seek(<span class="kwrd">long</span> offset, SeekOrigin origin)
    {
        <span class="kwrd">return</span> m_stream.Seek(offset, origin);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> IAsyncResult BeginRead(<span class="kwrd">byte</span>[] buffer, <span class="kwrd">int</span> offset, <span class="kwrd">int</span> count, AsyncCallback callback, <span class="kwrd">object</span> state)
    {
        <span class="kwrd">return</span> m_stream.BeginRead(buffer, offset, count, callback, state);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> IAsyncResult BeginWrite(<span class="kwrd">byte</span>[] buffer, <span class="kwrd">int</span> offset, <span class="kwrd">int</span> count, AsyncCallback callback, <span class="kwrd">object</span> state)
    {
        <span class="kwrd">return</span> m_stream.BeginWrite(buffer, offset, count, callback, state);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">bool</span> CanRead
    {
        get { <span class="kwrd">return</span> m_stream.CanRead; }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">bool</span> CanSeek
    {
        get { <span class="kwrd">return</span> m_stream.CanSeek; }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">bool</span> CanTimeout
    {
        get
        {
            <span class="kwrd">return</span> m_stream.CanTimeout;
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">bool</span> CanWrite
    {
        get { <span class="kwrd">return</span> m_stream.CanWrite; }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Close()
    {
        m_stream.Close();
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> EndRead(IAsyncResult asyncResult)
    {
        <span class="kwrd">return</span> m_stream.EndRead(asyncResult);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> EndWrite(IAsyncResult asyncResult)
    {
        m_stream.EndWrite(asyncResult);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Flush()
    {
        m_stream.Flush();
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">long</span> Length
    {
        get { <span class="kwrd">return</span> m_stream.Length; }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">long</span> Position
    {
        get
        {
            <span class="kwrd">return</span> m_stream.Position;
        }
        set
        {
            m_stream.Position = <span class="kwrd">value</span>;
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> ReadTimeout
    {
        get
        {
            <span class="kwrd">return</span> m_stream.ReadTimeout;
        }
        set
        {
            m_stream.ReadTimeout = <span class="kwrd">value</span>;
        }
    }

    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Dispose(<span class="kwrd">bool</span> disposing)
    {
        <span class="kwrd">try</span>
        {
            m_stream.Dispose();
        }
        <span class="kwrd">finally</span>
        {
            <span class="kwrd">base</span>.Dispose(disposing);
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> SetLength(<span class="kwrd">long</span> <span class="kwrd">value</span>)
    {
        m_stream.SetLength(<span class="kwrd">value</span>);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Write(<span class="kwrd">byte</span>[] buffer, <span class="kwrd">int</span> offset, <span class="kwrd">int</span> count)
    {
        m_stream.Write(buffer, offset, count);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> WriteByte(<span class="kwrd">byte</span> <span class="kwrd">value</span>)
    {
        m_stream.WriteByte(<span class="kwrd">value</span>);
    }

    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> WriteTimeout
    {
        get
        {
            <span class="kwrd">return</span> m_stream.WriteTimeout;
        }
        set
        {
            m_stream.WriteTimeout = <span class="kwrd">value</span>;
        }
    }
}</code></pre>

