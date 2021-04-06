---
author: Mads Klinkby
categories:
- security
date: "2014-09-11T22:00:00Z"
description: ""
draft: false
slug: cors-cross-origin-resource-sharing
tags:
- security
title: Cross Origin Resource Sharing
---


## Security has always been the evil brother of ease of use.



I think one of the hardest parts of transitioning to  browser-based applications for traditional .NET developers is the strict sandboxing  called “Same-Origin policy” that browsers employ to prevent the loss of data  confidentiality or integrity. It is certainly a topic that I am often asked about. This post covers the reason behind this security precaution,  the sandbox limits, and finally how a web service can successfully support cross-site  requests.

## Same-Origin policy

Code running outside e.g. server side or in a Windows  application can make web requests to any address it may please. Any web browser  on the other hand provides a strict separation between content provided by  unrelated sites. Not that all resources must reside on the same site, in fact it  is common practice to load scripts and style sheets from separate sites, e.g.  millions of sites reference the exact same JavaScript file for Google Analytics.  ![The grass is greener on the other side](/images/2014/grass-is-greener.jpg)  

However, JavaScript running in web browser is strictly limited  to making web requests from the site from where the current web page is loaded.  That prevents JavaScript that runs in your browser when visiting [http://www.evilhaxxor.org/](http://www.evilhaxxor.org/) from making  web requests on your behalf to your bank’s web site or steal information from your  corporate intranet.

More specifically the site is URL authority. Exchanging http  for https, changing part of the domain name (including subdomain) or switching  to a different the port number would make up different authorities.  For instance, the JavaScript running on a web  page loaded from [http://www.kli.dk](http://www.kli.dk/) cannot immediately  request resources from [http://kli.dk](http://kli.dk/), [https://www.kli.dk](https://www.kli.dk/) or [http://www.kli.dk:81](http://www.kli.dk:81/).  

Too bad if you are building a web service that must be  consumed by client side applications hosted on two different authorities or if  you want your resource to be publically available to client side applications,  right? Nope, there’s a [W3C specification](http://www.w3.org/TR/cors/)  for that: Cross-Origin Resource Sharing (CORS) that supported by all modern browsers  (and [partially](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx)  by IE9 as well). 

## CORS

The specification loosens up on the Same-Origin policy and allows  JavaScript running in a browser page to make requests to a web service on a different  authority, given that the web service explicitly allows request coming from that  page. 

Say the web page [https://www.sunnybeach.com/index.html](https://www.sunnybeach.com/index.html)  provide a local weather forecast by performing a request to a web service on [https://api.weather.com/geo/N42.691966E27.7124523](https://api.weather.com/geo/N42.691966E27.7124523).

Specifically the web page would issue a request like the  following (simplified), expecting the server to respond with JSON serialized weather  data in the response body. 

```
GET /geo/N42.691966E27.7124523  HTTP/1.1  
  Host: api.weather.com  
  Accept: application/json  
  Referer: [https://www.sunnybeach.com/index.html](https://www.sunnybeach.com/index.html)  
  Origin: [https://www](https://www/).sunnybeach.com
```

However, the browser automatically first sends a pre-flight CORS  request to the server like this:


```
OPTIONS / geo/N42.691966E27.7124523  HTTP/1.1  
  Host: api.weather.com  
  Accept: application/json  
  Origin: [https://www.sunnybeach.com](https://www.sunnybeach.com/)  
  Access-Control-Request-Method: GET
```

The web service must process the OPTIONS request and construct  a response like the following:

```
HTTP/1.1 200 OK  
  Date: Mon, 15 Sep 2014 01:15:39 GMT  
  Access-Control-Allow-Origin: [https://www.sunnybeach.com](https://www.sunnybeach.com/)    
  Access-Control-Allow-Methods: GET, OPTIONS  
  Content-Length: 0
```

The browser automatically processes the response and checks  if the authority of the page exists in the Access-Control-Allow-Origin response  header, and if the method of the request to issue (GET) is in the Access-Control-Allow-Methods  header. If one of those does not match, the browser simply cancels the GET  request because the server-side did not specifically permit that request. But if all is good, the browser finally issues the GET request.

While the browser enforces CORS automatically, the server  must specifically implement it. Default ASP.NET Web API rejects CORS requests altogether.  However, it is supported in Web API 2.0 and there is a great [NuGet package](https://www.nuget.org/packages/Microsoft.AspNet.WebApi.Cors/)  available that takes care of responding to OPTIONS requests.

Note that there are more Access-Control-Allow-… headers to  take care of than in the naïve example above. Things like authentication, custom  HTTP headers and caching tend to complicates things.

## Pro Tips

  ![Fiddler](/images/2014/fiddler.jpg "Fiddler")  

In a development environment you will find Eric Lawrence’s [Fiddler](http://www.telerik.com/fiddler/) to be helpful in monitoring  the preflight requests. Another developer tip is to close all instances of  Chrome and start it again with the command line parameter --disable-web-security  it will then allow all CORS requests without issuing the preflight requests  (careful!).

There is a good list of tips for secure CORS implementation at [OWASP](https://www.owasp.org/index.php/HTML5_Security_Cheat_Sheet#Cross_Origin_Resource_Sharing).

As I noted in the beginning, this Same-Origin policy is only enforced in the browser. So a common workaround is to proxy calls to different sites in a web service right next to the web page. Specifically SharePoint does not allow CORS requests, but Apps can leverage the [web proxy](http://msdn.microsoft.com/en-us/library/office/microsoft.sharepoint.client.webproxy(v=office.15).aspx) approach to request external resources.

Thank you for reading this post. Please let me know if you found the article interesting, or if you have any questions regarding the topic by leaving a comment below.

