---
author: Mads Klinkby
categories:
- .net
- download
- iis
- sharepoint
- www
date: "2012-08-26T22:00:00Z"
description: ""
draft: false
slug: content-disposition-bug-chrome-sharepoint
tags:
- .net
- download
- iis
- sharepoint
- www
title: Comma SharePoint
---


A simple HTTP Module that implements a workaround for a common bug in ASP.NET applications that prevents downloading of files with comma in the filename. When a Chrome browser downloads a file that have a comma in its file name, according to the RFC6266 the file name must be enclosed in quotes. If not the browser simply prevents the download with the following message:  <div>  

> [![Chrome error message](http://static.getya.net/013/images/duplicateheaders.png)](http://static.getya.net/013/images/duplicateheaders.png)Duplicate headers received from server
>  Error 349 (net::ERRRESPONSEHEADERSMULTIPLECONTENT_DISPOSITION): Multiple Content-Disposition headers received. This is disallowed to protect against HTTP response splitting attacks.

  Very few applications does this right, and even SharePoint and Office 365 are affected by this bug. On [ https://bitbucket.org/klinkby/workaround-for-content-disposition-bug-in-asp.net-sharepoint/](https://bitbucket.org/klinkby/workaround-for-content-disposition-bug-in-asp.net-sharepoint/) I have published a source and binaries for a simple HTTP module that plugs in to an existing application, examines responses, looking for those ill formatted filenames in content-disposition headers using an efficient regular expression. Those affected are corrected and returned to the client, thus allowing Chrome to download the files. To use the module add the dll to the GAC or the bin folder, and register the module in the application's web.config file in the system.webserver element:   

<pre class="csharpcode"><code> <span class="kwrd"><</span><span class="html">system.webServer</span><span class="kwrd">></span>
  <span class="kwrd"><</span><span class="html">modules</span> <span class="attr">runAllManagedModulesForAllRequests</span><span class="kwrd">="true"</span><span class="kwrd">></span>
    <span class="kwrd"><</span><span class="html">add</span> <span class="attr">name</span><span class="kwrd">="cdf"</span> <span class="attr">type</span><span class="kwrd">="Klinkby.Web.ContentDispositionFix.RemedyHttpModule, Klinkby.Web.ContentDispositionFix, Version=1.0.0.0, Culture=neutral, PublicKeyToken=f97db8c3b9326f3e"</span><span class="kwrd">/></span>
  <span class="kwrd"></</span><span class="html">modules</span><span class="kwrd">></span>
 <span class="kwrd"></</span><span class="html">system.webServer</span><span class="kwrd">></span> </code></pre>
  <div>  
 </div>  Learn more:   

*   [ https://bitbucket.org/klinkby/workaround-for-content-disposition-bug-in-asp.net-sharepoint/](https://bitbucket.org/klinkby/workaround-for-content-disposition-bug-in-asp.net-sharepoint/)
*   [http://code.google.com/p/chromium/issues/detail?id=100011](http://code.google.com/p/chromium/issues/detail?id=100011)
*   [ http://community.office365.com/en-us/forums/170/p/55360/201746.aspx](http://community.office365.com/en-us/forums/170/p/55360/201746.aspx) </div>

