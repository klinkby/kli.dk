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

```C#
readonly static Regex m_enc = new Regex(
    @"charset=(?'encoding'[^\s]+)",
    RegexOptions.Compiled | RegexOptions.CultureInvariant
        | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);

static string GetString(WebHeaderCollection responseHeaders, byte[] data)
{
    string html;
    Encoding encoding = null;
    try
    {
        string contentEncoding = responseHeaders[HttpResponseHeader.ContentEncoding];
        if (string.IsNullOrEmpty(contentEncoding))
            contentEncoding 
                = m_enc.Match(responseHeaders[HttpResponseHeader.ContentType])
                        .Groups["encoding"]
                        .Value;
        encoding = Encoding.GetEncoding(contentEncoding);
    }
    catch (Exception)
    {
        try
        {
            using (var ms = new MemoryStream(data))
            {
                using (var xmlreader = new XmlTextReader(ms))
                {
                    xmlreader.MoveToContent();
                    encoding = xmlreader.Encoding;
                }
            }
        }
        catch (Exception)
        {
        }
    }
    using (var ms = new MemoryStream(data))
    using (var sr = encoding != null 
        ? new StreamReader(ms, encoding) 
        : new StreamReader(ms, true))
        html = sr.ReadToEnd();
    return html;
}```

