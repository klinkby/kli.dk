---
author: Mads Klinkby
categories:
- .net
- log4net
- monitor
- nlog
date: "2011-05-09T22:00:00Z"
description: ""
draft: false
slug: nlog-configuration-file
tags:
- .net
- log4net
- monitor
- nlog
title: NLog configuration file
---


I often use NLog for diagnostic tracing in e.g. services. [NLog](http://nlog-project.org/) is very much like [log4net (log4j for .net)](http://logging.apache.org/log4net/) except that it is still being maintained, was written for .NET and features a very flexible end extensible logging framework. See also the post about [interceptors](/2011/01/25/aop-logging/). This is an example of a nlog.config I recently used for a service to get asynchronous logging and detailed exception information in a concise and structured format.   

<pre class="csharpcode"><code><span class="kwrd">&lt;?</span><span class="html">xml</span> <span class="attr">version</span><span class="kwrd">="1.0"</span> <span class="attr">encoding</span><span class="kwrd">="utf-8"</span> ?<span class="kwrd">&gt;</span>
<span class="kwrd">&lt;</span><span class="html">nlog</span> <span class="attr">xmlns</span><span class="kwrd">="http://www.nlog-project.org/schemas/NLog.xsd"</span>
      <span class="attr">xmlns:xsi</span><span class="kwrd">="http://www.w3.org/2001/XMLSchema-instance"</span><span class="kwrd">&gt;</span>
  <span class="kwrd">&lt;</span><span class="html">targets</span><span class="kwrd">&gt;</span>
    <span class="kwrd">&lt;</span><span class="html">target</span> <span class="attr">name</span><span class="kwrd">="asyncFile"</span> <span class="attr">xsi:type</span><span class="kwrd">="AsyncWrapper"</span><span class="kwrd">&gt;</span>
      <span class="kwrd">&lt;</span><span class="html">target</span> <span class="attr">name</span><span class="kwrd">="logfile"</span> <span class="attr">xsi:type</span><span class="kwrd">="File"</span> <span class="attr">fileName</span><span class="kwrd">="${environment:variable=ALLUSERSPROFILE}\MYSERVICE\Logs\${shortdate}.txt"</span><span class="kwrd">&gt;</span>
        <span class="kwrd">&lt;</span><span class="html">layout</span> <span class="attr">xsi:type</span><span class="kwrd">="CSVLayout"</span> <span class="attr">delimiter</span><span class="kwrd">="Tab"</span><span class="kwrd">&gt;</span>
          <span class="kwrd">&lt;</span><span class="html">column</span> <span class="attr">name</span><span class="kwrd">="time"</span> <span class="attr">layout</span><span class="kwrd">="${date:format=HH\:mm\:ss.ff}"</span> <span class="kwrd">/&gt;</span>
          <span class="kwrd">&lt;</span><span class="html">column</span> <span class="attr">name</span><span class="kwrd">="thread"</span> <span class="attr">layout</span><span class="kwrd">="${threadid}"</span> <span class="kwrd">/&gt;</span>
          <span class="kwrd">&lt;</span><span class="html">column</span> <span class="attr">name</span><span class="kwrd">="level"</span> <span class="attr">layout</span><span class="kwrd">="${level}"</span> <span class="kwrd">/&gt;</span>
          <span class="kwrd">&lt;</span><span class="html">column</span> <span class="attr">name</span><span class="kwrd">="idenity"</span> <span class="attr">layout</span><span class="kwrd">="${windows-identity}"</span> <span class="kwrd">/&gt;</span>
          <span class="kwrd">&lt;</span><span class="html">column</span> <span class="attr">name</span><span class="kwrd">="message"</span> <span class="attr">layout</span><span class="kwrd">="${message}"</span> <span class="kwrd">/&gt;</span>
          <span class="kwrd">&lt;</span><span class="html">column</span> <span class="attr">name</span><span class="kwrd">="exception"</span> <span class="attr">layout</span><span class="kwrd">="${exception:format=type,message,method:maxInnerExceptionLevel=5;
innerFormat=shortType,message,method }"</span> <span class="kwrd">/&gt;</span>
        <span class="kwrd">&lt;/</span><span class="html">layout</span><span class="kwrd">&gt;</span>
      <span class="kwrd">&lt;/</span><span class="html">target</span><span class="kwrd">&gt;</span>
    <span class="kwrd">&lt;/</span><span class="html">target</span><span class="kwrd">&gt;</span>
  <span class="kwrd">&lt;/</span><span class="html">targets</span><span class="kwrd">&gt;</span>
  <span class="kwrd">&lt;</span><span class="html">rules</span><span class="kwrd">&gt;</span>
    <span class="kwrd">&lt;</span><span class="html">logger</span> <span class="attr">name</span><span class="kwrd">="*"</span> <span class="attr">minLevel</span><span class="kwrd">="Debug"</span> <span class="attr">writeTo</span><span class="kwrd">="logfile"</span> <span class="kwrd">/&gt;</span>
  <span class="kwrd">&lt;/</span><span class="html">rules</span><span class="kwrd">&gt;</span>  
<span class="kwrd">&lt;/</span><span class="html">nlog</span><span class="kwrd">&gt;</span></code></pre>

