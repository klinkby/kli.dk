---
author: "@klinkby"
keywords:
- dotnet
- monitor
date: "2011-05-09T22:00:00Z"
description: ""
draft: false
slug: nlog-configuration-file
tags:
- dotnet
- monitor
title: NLog configuration file
---


I often use NLog for diagnostic tracing in e.g. services. [NLog](http://nlog-project.org/) is very much like [log4net (log4j for .net)](http://logging.apache.org/log4net/) except that it is still being maintained, was written for .NET and features a very flexible end extensible logging framework. See also the post about [interceptors](/2011/01/25/aop-logging/). This is an example of a nlog.config I recently used for a service to get asynchronous logging and detailed exception information in a concise and structured format.   

```XML
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <targets>
    <target name="asyncFile" xsi:type="AsyncWrapper">
      <target name="logfile" xsi:type="File" fileName="${environment:variable=ALLUSERSPROFILE}\MYSERVICE\Logs\${shortdate}.txt">
        <layout xsi:type="CSVLayout" delimiter="Tab">
          <column name="time" layout="${date:format=HH\:mm\:ss.ff}" />
          <column name="thread" layout="${threadid}" />
          <column name="level" layout="${level}" />
          <column name="idenity" layout="${windows-identity}" />
          <column name="message" layout="${message}" />
          <column name="exception" layout="${exception:format=type,message,method:maxInnerExceptionLevel=5;
innerFormat=shortType,message,method }" />
        </layout>
      </target>
    </target>
  </targets>
  <rules>
    <logger name="*" minLevel="Debug" writeTo="logfile" />
  </rules>  
</nlog>
```
