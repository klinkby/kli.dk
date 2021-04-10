---
author: "@klinkby"
keywords:
- dotnet
- monitor
date: "2011-01-24T23:00:00Z"
description: ""
draft: false
slug: aop-logging
tags:
- dotnet
- monitor
title: AOP logging
---


I still see code with tracing and logging statements scattered all over the code. This of course violates the separation of concerns design philosophy, as all classes gets a secondary role, i.e. to log. Also it becomes a challenge to avoid referencing a specific logging API all over the code.

It you have yet to look into aspect oriented programming (AOP) I will encouraged you to look into it and consider it whenever you have to add cross cutting functionality. Here's an example of an Interceptor for Castle Windsor that traces all (virtual) method calls with its parameters and return values.

Very handy thingy for the occational bug hunting.

```C#
class TracingInterceptor : IInterceptor
{
    Logger m_logger;
    string m_targetMethodName;
    Stopwatch m_stopwatch;

    public void Intercept(IInvocation invocation)
    {
        try
        {
            BeforeInvoke(invocation);
            invocation.Proceed();
            AfterInvoke(invocation);
        }
        catch (Exception ex)
        {
            OnError(invocation, ex);
            throw;
        }
    }

    protected virtual void BeforeInvoke(IInvocation invocation)
    {
        string targetTypeName = invocation.TargetType.FullName;
        m_targetMethodName = invocation.Method.Name;
        m_logger = LogManager.GetLogger(targetTypeName);
        if (m_logger.IsDebugEnabled)
            m_logger.Debug(
                m_targetMethodName + " [enter]" + GetParameters(invocation));
        if (m_logger.IsInfoEnabled)
        {
            m_stopwatch = new Stopwatch();
            m_stopwatch.Start();
        }
    }

    protected virtual void AfterInvoke(IInvocation invocation)
    {
        if (m_logger.IsInfoEnabled)
            m_logger.Info(m_targetMethodName + " [ok]" + GetElapsed());
        if (m_logger.IsDebugEnabled)
        {
            if (invocation.Method.ReturnType != typeof(void))
            {
                m_logger.Debug(
                    m_targetMethodName + " returned " + GetReturnValue(invocation));
            }
        }
    }

    protected virtual void OnError(IInvocation invocation, Exception exception)
    {
        m_logger.ErrorException(
            m_targetMethodName + " [fail]" + GetElapsed(), 
            exception);
    }

    static string GetParameters(IInvocation invocation)
    {
        string par = null;
        if (invocation.Arguments.Length > 0)
        {
            par = invocation.Arguments.Aggregate(
                string.Empty, 
                (acc, x) => acc += x + ",");
            par = " {" + par.TrimEnd(',') + "}";
        }
        return par;
    }

    static string GetReturnValue(IInvocation invocation)
    {
        object ret = invocation.ReturnValue;
        if (ret != null)
        {
            return (invocation.Method.ReturnType.IsArray)
                ? ((Array)ret).Length.ToString(CultureInfo.InvariantCulture) 
                    + " items"
                : ret.ToString();
        }
        else
            return "(null)";
    }

    string GetElapsed()
    {
        return " " + m_stopwatch.ElapsedMilliseconds
                                .ToString(CultureInfo.InvariantCulture) 
                + " mS";
    }
}
```

