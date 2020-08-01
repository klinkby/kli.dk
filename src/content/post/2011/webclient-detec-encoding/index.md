---
author: Mads Klinkby
categories:
- .net
- dotnet
- download
- xml
date: "2011-06-22T22:00:00Z"
description: ""
draft: false
slug: webclient-detec-encoding
tags:
- .net
- dotnet
- download
- xml
title: Read from WebClient with the right encoding
---


I've had some encoding trouble with the [DownloadString](http://msdn.microsoft.com/en-us/library/fhd1f0sw.aspx)(Async) method on the [ WebClient class](http://msdn.microsoft.com/en-us/library/system.net.webclient.aspx), so I wrote my own encoding detection to get a string with the correct encoding.   

<pre class="csharpcode"><code><span class="kwrd">readonly</span> <span class="kwrd">static</span> Regex m_enc = <span class="kwrd">new</span> Regex(
    <span class="str">@"charset=(?'encoding'[^\s]+)"</span>,
    RegexOptions.Compiled | RegexOptions.CultureInvariant
        | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);

<span class="kwrd">static</span> <span class="kwrd">string</span> GetString(WebHeaderCollection responseHeaders, <span class="kwrd">byte</span>[] data)
{
    <span class="kwrd">string</span> html;
    Encoding encoding = <span class="kwrd">null</span>;
    <span class="kwrd">try</span>
    {
        <span class="kwrd">string</span> contentEncoding = responseHeaders[HttpResponseHeader.ContentEncoding];
        <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(contentEncoding))
            contentEncoding 
                = m_enc.Match(responseHeaders[HttpResponseHeader.ContentType])
                        .Groups[<span class="str">"encoding"</span>]
                        .Value;
        encoding = Encoding.GetEncoding(contentEncoding);
    }
    <span class="kwrd">catch</span> (Exception)
    {
        <span class="kwrd">try</span>
        {
            <span class="kwrd">using</span> (var ms = <span class="kwrd">new</span> MemoryStream(data))
            {
                <span class="kwrd">using</span> (var xmlreader = <span class="kwrd">new</span> XmlTextReader(ms))
                {
                    xmlreader.MoveToContent();
                    encoding = xmlreader.Encoding;
                }
            }
        }
        <span class="kwrd">catch</span> (Exception)
        {
        }
    }
    <span class="kwrd">using</span> (var ms = <span class="kwrd">new</span> MemoryStream(data))
    <span class="kwrd">using</span> (var sr = encoding != <span class="kwrd">null</span> 
        ? <span class="kwrd">new</span> StreamReader(ms, encoding) 
        : <span class="kwrd">new</span> StreamReader(ms, <span class="kwrd">true</span>))
        html = sr.ReadToEnd();
    <span class="kwrd">return</span> html;
}</code></pre>

