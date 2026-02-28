---
author: "@klinkby"
keywords:
- dotnet
date: "2007-01-20T23:00:00Z"
description: ""
draft: false
slug: skype-status-web-service
tags:
- dotnet
title: Skype status web service
---


Skype provides some http requests to display your online status as an image or text but there's no web service that
provides the information. That's too bad, but here is the code required (simplest webservice ever).

<%@ WebService Language=<span class="str">"C#"</span> Class=<span class="str">"
Klinkby.Skyper"</span> %> <span class="kwrd">using</span> System; <span class="kwrd">using</span>
System.IO; <span class="kwrd">using</span> System.Net; <span class="kwrd">using</span>
System.Web.Services; <span class="kwrd">namespace</span> Klinkby {     <span class="kwrd">
public</span> <span class="kwrd">enum</span> Status { Unknown, Offline = 1, Online = 2, Away = 3, NotAvailable = 4,
DoNotDisturb = 5, SkypeMe =
7, }     [WebService(Namespace = <span class="str">"http://kli.dk"</span>)]     [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]     <span class="kwrd">
public</span> <span class="kwrd">class</span> Skyper :
System.Web.Services.WebService {         [WebMethod(Description=<span class="str">"Gets the current online status of a Skype user"</span>)]         <span class="kwrd">
public</span> Status GetStatus(<span class="kwrd">string</span> userName)         {             <span class="kwrd">
string</span> statusUrl = String.Format(<span class="str">"http://mystatus.skype.com/{0}.num"</span>, userName);
WebRequest request = (WebRequest)WebRequest.Create(statusUrl); WebResponse response = (WebResponse)
request.GetResponse(); Stream stream = response.GetResponseStream();             <span class="kwrd">int</span>
statusId = stream.ReadByte() - (<span class="kwrd">int</span>)<span class="str">'0'</span>; stream.Dispose(); Status
status = (Status)statusId;             <span class="kwrd">return</span> status; } } }

