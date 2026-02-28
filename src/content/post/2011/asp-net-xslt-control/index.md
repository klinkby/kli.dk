---
author: "@klinkby"
keywords:
- dotnet
- www
- xml
date: "2011-01-19T23:00:00Z"
description: ""
draft: false
slug: asp-net-xslt-control
tags:
- dotnet
- www
- xml
title: ASP.NET XSLT Control
---


Here's a highly scalable ASP.NET control that uses the fast Data Contract Serializer to generate XML for an object and
transforms it using a cached instance of XslCompiledTransforms.

I find it a very versatile little tool for generating content that doesn't post back.

```C#
using System;
using System.IO;
using System.Runtime.Serialization;
using System.Text;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;

namespace Controls
{
    public class XsltControl : Control
    {
        readonly byte[] m_xslt;
        readonly Func<object> m_getValue;
        readonly Action<XsltArgumentList> m_addParams;
        Literal m_literal = new Literal();

        public XsltControl(
            byte[] xslt,
            Func<object> getValue,
            Action<XsltArgumentList> addParams)
        {
            if (xslt == null)
                throw new ArgumentNullException("xslt");
            m_xslt = xslt;
            m_getValue = getValue ?? (() => new object());
            m_addParams = addParams ?? (o => { });
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            var arguments = new XsltArgumentList();
            m_addParams(arguments);
            byte[] xhtml = Transform(m_getValue(), arguments, m_xslt);
            m_literal.Text = Encoding.UTF8.GetString(xhtml);
        }

        protected override void CreateChildControls()
        {
            base.CreateChildControls();
            Controls.Add(m_literal);
        }

        static byte[] Transform(object o, XsltArgumentList args, byte[] xslt)
        {
            string cacheKey = typeof(XsltControl).FullName + "$"
                + o.GetType().FullName + "$"
                + xslt.Length.ToString("x");
            var tran = CacheItem.GetOrCreate(
                cacheKey,
                () => new CacheItem(o.GetType(), xslt),
                o.GetType());
            return Transform(o, args, tran.Xslt, tran.Serializer);
        }

        static byte[] Transform(
            object value,
            XsltArgumentList arguments,
            XslCompiledTransform xslt,
            DataContractSerializer serializer)
        {
            using (var xmlData = new MemoryStream())
            {
                serializer.WriteObject(xmlData, value);
                xmlData.Seek(0, SeekOrigin.Begin);
                using (var xhtmlData = new MemoryStream())
                {
                    using (var xw = new XmlTextWriter(
                        xhtmlData,
                        new UTF8Encoding()))
                    using (var xr = XmlReader.Create(xmlData))
                        xslt.Transform(xr, arguments, xw);
                    return xhtmlData.ToArray();
                }
            }
        }

        private sealed class CacheItem
        {
            public readonly DataContractSerializer Serializer;
            public readonly XslCompiledTransform Xslt;

            public CacheItem(Type typeOfValue, byte[] stylesheet)
            {
                Serializer = new DataContractSerializer(typeOfValue);
                Xslt = new XslCompiledTransform();
                using (var ms = new MemoryStream(stylesheet))
                using (var xr = XmlReader.Create(ms))
                    Xslt.Load(xr);
            }

            public static T GetOrCreate<T>(string key, Func<T> load, object sync)
            {
                var cache = HttpContext.Current.Cache;
                T dt = (T)cache[key];
                if (dt == null)
                    lock (sync)
                        if (dt == null)
                            cache.Add(
                                key,
                                dt = load(),
                                null,
                                DateTime.UtcNow + TimeSpan.FromMinutes(60),
                                Cache.NoSlidingExpiration,
                                CacheItemPriority.Normal,
                                null);
                return dt;
            }
        }
    }
}
```
