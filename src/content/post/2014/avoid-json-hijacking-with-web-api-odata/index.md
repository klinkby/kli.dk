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

<pre class="csharpcode"><code> <span class="kwrd">using</span> System.Net;
 <span class="kwrd">using</span> System.Net.Http;
 <span class="kwrd">using</span> System.Net.Http.Headers;
 <span class="kwrd">using</span> System.Web.Http;
 <span class="kwrd">using</span> System.Web.Http.Filters;
 <span class="kwrd">public</span> <span class="kwrd">class</span> SafeQueryableAttribute : QueryableAttribute
 {
     <span class="kwrd">private</span> <span class="kwrd">static</span> <span class="kwrd">readonly</span> MediaTypeWithQualityHeaderValue ApplicationJson =         MediaTypeWithQualityHeaderValue.Parse(<span class="str">"application/json"</span>);
      <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
     {
         <span class="kwrd">var</span> res = actionExecutedContext.Response;
         <span class="kwrd">if</span> (res.StatusCode < HttpStatusCode.BadRequest
             && !actionExecutedContext.Request.Headers.Accept.Contains(ApplicationJson))
         {
             actionExecutedContext.Response = <span class="kwrd">new</span> HttpResponseMessage(HttpStatusCode.Forbidden);
         }
         <span class="kwrd">base</span>.OnActionExecuted(actionExecutedContext);
     }
 } </code></pre>
  <div id="jp-post-flair" class="sharedaddy sd-rating-enabled sd-like-enabled"></div>

