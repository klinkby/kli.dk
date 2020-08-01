---
author: Mads Klinkby
categories:
- .net
- log4net
- nlog
date: "2011-01-24T23:00:00Z"
description: ""
draft: false
slug: aop-logging
tags:
- .net
- log4net
- nlog
title: AOP logging
---


I still see code with tracing and logging statements scattered all over the code. This of course violates the separation of concerns design philosophy, as all classes gets a secondary role, i.e. to log. Also it becomes a challenge to avoid referencing a specific logging API all over the code.

It you have yet to look into aspect oriented programming (AOP) I will encouraged you to look into it and consider it whenever you have to add cross cutting functionality. Here's an example of an Interceptor for Castle Windsor that traces all (virtual) method calls with its parameters and return values.

Very handy thingy for the occational bug hunting.

<pre class="csharpcode"><code><span class="kwrd">class</span> TracingInterceptor : IInterceptor
{
    Logger m_logger;
    <span class="kwrd">string</span> m_targetMethodName;
    Stopwatch m_stopwatch;

    <span class="kwrd">public</span> <span class="kwrd">void</span> Intercept(IInvocation invocation)
    {
        <span class="kwrd">try</span>
        {
            BeforeInvoke(invocation);
            invocation.Proceed();
            AfterInvoke(invocation);
        }
        <span class="kwrd">catch</span> (Exception ex)
        {
            OnError(invocation, ex);
            <span class="kwrd">throw</span>;
        }
    }

    <span class="kwrd">protected</span> <span class="kwrd">virtual</span> <span class="kwrd">void</span> BeforeInvoke(IInvocation invocation)
    {
        <span class="kwrd">string</span> targetTypeName = invocation.TargetType.FullName;
        m_targetMethodName = invocation.Method.Name;
        m_logger = LogManager.GetLogger(targetTypeName);
        <span class="kwrd">if</span> (m_logger.IsDebugEnabled)
            m_logger.Debug(
                m_targetMethodName + <span class="str">" [enter]"</span> + GetParameters(invocation));
        <span class="kwrd">if</span> (m_logger.IsInfoEnabled)
        {
            m_stopwatch = <span class="kwrd">new</span> Stopwatch();
            m_stopwatch.Start();
        }
    }

    <span class="kwrd">protected</span> <span class="kwrd">virtual</span> <span class="kwrd">void</span> AfterInvoke(IInvocation invocation)
    {
        <span class="kwrd">if</span> (m_logger.IsInfoEnabled)
            m_logger.Info(m_targetMethodName + <span class="str">" [ok]"</span> + GetElapsed());
        <span class="kwrd">if</span> (m_logger.IsDebugEnabled)
        {
            <span class="kwrd">if</span> (invocation.Method.ReturnType != <span class="kwrd">typeof</span>(<span class="kwrd">void</span>))
            {
                m_logger.Debug(
                    m_targetMethodName + <span class="str">" returned "</span> + GetReturnValue(invocation));
            }
        }
    }

    <span class="kwrd">protected</span> <span class="kwrd">virtual</span> <span class="kwrd">void</span> OnError(IInvocation invocation, Exception exception)
    {
        m_logger.ErrorException(
            m_targetMethodName + <span class="str">" [fail]"</span> + GetElapsed(), 
            exception);
    }

    <span class="kwrd">static</span> <span class="kwrd">string</span> GetParameters(IInvocation invocation)
    {
        <span class="kwrd">string</span> par = <span class="kwrd">null</span>;
        <span class="kwrd">if</span> (invocation.Arguments.Length &gt; 0)
        {
            par = invocation.Arguments.Aggregate(
                <span class="kwrd">string</span>.Empty, 
                (acc, x) =&gt; acc += x + <span class="str">","</span>);
            par = <span class="str">" {"</span> + par.TrimEnd(<span class="str">','</span>) + <span class="str">"}"</span>;
        }
        <span class="kwrd">return</span> par;
    }

    <span class="kwrd">static</span> <span class="kwrd">string</span> GetReturnValue(IInvocation invocation)
    {
        <span class="kwrd">object</span> ret = invocation.ReturnValue;
        <span class="kwrd">if</span> (ret != <span class="kwrd">null</span>)
        {
            <span class="kwrd">return</span> (invocation.Method.ReturnType.IsArray)
                ? ((Array)ret).Length.ToString(CultureInfo.InvariantCulture) 
                    + <span class="str">" items"</span>
                : ret.ToString();
        }
        <span class="kwrd">else</span>
            <span class="kwrd">return</span> <span class="str">"(null)"</span>;
    }

    <span class="kwrd">string</span> GetElapsed()
    {
        <span class="kwrd">return</span> <span class="str">" "</span> + m_stopwatch.ElapsedMilliseconds
                                .ToString(CultureInfo.InvariantCulture) 
                + <span class="str">" mS"</span>;
    }
}</code></pre>

