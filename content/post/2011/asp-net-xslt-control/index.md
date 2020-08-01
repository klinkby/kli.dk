---
author: Mads Klinkby
categories:
- .net
- asp.net
- programming
- www
- xml
- xsl
date: "2011-01-19T23:00:00Z"
description: ""
draft: false
slug: asp-net-xslt-control
tags:
- .net
- asp.net
- programming
- www
- xml
- xsl
title: ASP.NET XSLT Control
---


Here's a highly scalable ASP.NET control that uses the fast Data Contract Serializer to generate XML for an object and transforms it using a cached instance of XslCompiledTransforms.

I find it a very versatile little tool for generating content that doesn't post back.

<pre class="csharpcode"><code><span class="kwrd">using</span> System;
<span class="kwrd">using</span> System.IO;
<span class="kwrd">using</span> System.Runtime.Serialization;
<span class="kwrd">using</span> System.Text;
<span class="kwrd">using</span> System.Web;
<span class="kwrd">using</span> System.Web.Caching;
<span class="kwrd">using</span> System.Web.UI;
<span class="kwrd">using</span> System.Web.UI.WebControls;
<span class="kwrd">using</span> System.Xml;
<span class="kwrd">using</span> System.Xml.Xsl;

<span class="kwrd">namespace</span> Controls
{
    <span class="kwrd">public</span> <span class="kwrd">class</span> XsltControl : Control
    {
        <span class="kwrd">readonly</span> <span class="kwrd">byte</span>[] m_xslt;
        <span class="kwrd">readonly</span> Func&lt;<span class="kwrd">object</span>&gt; m_getValue;
        <span class="kwrd">readonly</span> Action&lt;XsltArgumentList&gt; m_addParams;
        Literal m_literal = <span class="kwrd">new</span> Literal();

        <span class="kwrd">public</span> XsltControl(
            <span class="kwrd">byte</span>[] xslt,
            Func&lt;<span class="kwrd">object</span>&gt; getValue,
            Action&lt;XsltArgumentList&gt; addParams)
        {
            <span class="kwrd">if</span> (xslt == <span class="kwrd">null</span>)
                <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentNullException(<span class="str">"xslt"</span>);
            m_xslt = xslt;
            m_getValue = getValue ?? (() =&gt; <span class="kwrd">new</span> <span class="kwrd">object</span>());
            m_addParams = addParams ?? (o =&gt; { });
        }

        <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> OnLoad(EventArgs e)
        {
            <span class="kwrd">base</span>.OnLoad(e);
            var arguments = <span class="kwrd">new</span> XsltArgumentList();
            m_addParams(arguments);
            <span class="kwrd">byte</span>[] xhtml = Transform(m_getValue(), arguments, m_xslt);
            m_literal.Text = Encoding.UTF8.GetString(xhtml);
        }

        <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> CreateChildControls()
        {
            <span class="kwrd">base</span>.CreateChildControls();
            Controls.Add(m_literal);
        }

        <span class="kwrd">static</span> <span class="kwrd">byte</span>[] Transform(<span class="kwrd">object</span> o, XsltArgumentList args, <span class="kwrd">byte</span>[] xslt)
        {
            <span class="kwrd">string</span> cacheKey = <span class="kwrd">typeof</span>(XsltControl).FullName + <span class="str">"$"</span>
                + o.GetType().FullName + <span class="str">"$"</span>
                + xslt.Length.ToString(<span class="str">"x"</span>);
            var tran = CacheItem.GetOrCreate(
                cacheKey,
                () =&gt; <span class="kwrd">new</span> CacheItem(o.GetType(), xslt),
                o.GetType());
            <span class="kwrd">return</span> Transform(o, args, tran.Xslt, tran.Serializer);
        }

        <span class="kwrd">static</span> <span class="kwrd">byte</span>[] Transform(
            <span class="kwrd">object</span> <span class="kwrd">value</span>,
            XsltArgumentList arguments,
            XslCompiledTransform xslt,
            DataContractSerializer serializer)
        {
            <span class="kwrd">using</span> (var xmlData = <span class="kwrd">new</span> MemoryStream())
            {
                serializer.WriteObject(xmlData, <span class="kwrd">value</span>);
                xmlData.Seek(0, SeekOrigin.Begin);
                <span class="kwrd">using</span> (var xhtmlData = <span class="kwrd">new</span> MemoryStream())
                {
                    <span class="kwrd">using</span> (var xw = <span class="kwrd">new</span> XmlTextWriter(
                        xhtmlData,
                        <span class="kwrd">new</span> UTF8Encoding()))
                    <span class="kwrd">using</span> (var xr = XmlReader.Create(xmlData))
                        xslt.Transform(xr, arguments, xw);
                    <span class="kwrd">return</span> xhtmlData.ToArray();
                }
            }
        }

        <span class="kwrd">private</span> <span class="kwrd">sealed</span> <span class="kwrd">class</span> CacheItem
        {
            <span class="kwrd">public</span> <span class="kwrd">readonly</span> DataContractSerializer Serializer;
            <span class="kwrd">public</span> <span class="kwrd">readonly</span> XslCompiledTransform Xslt;

            <span class="kwrd">public</span> CacheItem(Type typeOfValue, <span class="kwrd">byte</span>[] stylesheet)
            {
                Serializer = <span class="kwrd">new</span> DataContractSerializer(typeOfValue);
                Xslt = <span class="kwrd">new</span> XslCompiledTransform();
                <span class="kwrd">using</span> (var ms = <span class="kwrd">new</span> MemoryStream(stylesheet))
                <span class="kwrd">using</span> (var xr = XmlReader.Create(ms))
                    Xslt.Load(xr);
            }

            <span class="kwrd">public</span> <span class="kwrd">static</span> T GetOrCreate&lt;T&gt;(<span class="kwrd">string</span> key, Func&lt;T&gt; load, <span class="kwrd">object</span> sync)
            {
                var cache = HttpContext.Current.Cache;
                T dt = (T)cache[key];
                <span class="kwrd">if</span> (dt == <span class="kwrd">null</span>)
                    <span class="kwrd">lock</span> (sync)
                        <span class="kwrd">if</span> (dt == <span class="kwrd">null</span>)
                            cache.Add(
                                key,
                                dt = load(),
                                <span class="kwrd">null</span>,
                                DateTime.UtcNow + TimeSpan.FromMinutes(60),
                                Cache.NoSlidingExpiration,
                                CacheItemPriority.Normal,
                                <span class="kwrd">null</span>);
                <span class="kwrd">return</span> dt;
            }
        }
    }
}</code></pre>

