---
author: Mads Klinkby
categories:
- asp.net
- hacking
- security
date: "2014-01-02T23:00:00Z"
description: ""
draft: false
slug: avoid-json-hijacking-with-web-api-odata
tags:
- asp.net
- hacking
- security
title: Avoid JSON hijacking
---


Microsoft's ODATA plugin to the amazing Web API lets you expose a ODATA endpoint basically by decorating the enumerable getter in your REST interface with a [Queryable] attribute and returning IQueryable<T> from the method. The ODATA API takes care of converting e.g.  $select and $filter ODATA parameters to LINQ expressions. Very cool stuff indeed.

Except that the method returns an array of the elements. And that opens up the [JSON hijacking exploit](http://haacked.com/archive/2009/06/25/json-hijacking.aspx/) that could leak data from the service. Basically the exploit leverages the dynamic nature of JavaScript to rewrite the [ __defineSetter__](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineSetter?redirectlocale=en-US&redirectslug=JavaScript%2FReference%2FGlobal_Objects%2FObject%2FdefineSetter) prototype and then fetch JSON data from the service using a script element on the page. The loaded JSON is run as a script, and the data is then available to the attacker.

There are several ways to avoid this. Exposing the endpoint only with POST or prepending [ while(1);](http://stackoverflow.com/questions/2669690/why-does-google-prepend-while1-to-their-json-responses) to the result stream. Those would require changes to the client code. Or the server could verify that the incoming request did actually come from a XHR and not from a malicious script element.

A friendly XHR always requests data with the header *Accept: application/json, …*  Whereas a script element on the page will be requested with *Accept: */** (Chrome/FF) or *Accept: application/javascript, …* (IE)

With this information it is quite easy to extend the QueryableAttribute to perform this simple validation:

```C#
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using System.Web.Http.Filters;

public class SafeQueryableAttribute : QueryableAttribute
{
    private static readonly MediaTypeWithQualityHeaderValue ApplicationJson =         MediaTypeWithQualityHeaderValue.Parse("application/json");
    public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
    {
        var res = actionExecutedContext.Response;
        if (res.StatusCode < HttpStatusCode.BadRequest
            && !actionExecutedContext.Request.Headers.Accept.Contains(ApplicationJson))
        {
            actionExecutedContext.Response = new HttpResponseMessage(HttpStatusCode.Forbidden);
        }
        base.OnActionExecuted(actionExecutedContext);
    }
} 
 ```