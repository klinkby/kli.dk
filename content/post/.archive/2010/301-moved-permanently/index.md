---
author: Mads Klinkby
categories:
- .net
- asp.net
- httpmodule
- ihttpmodule
- www
date: "2010-09-23T22:00:00Z"
description: ""
draft: false
slug: 301-moved-permanently
tags:
- .net
- asp.net
- httpmodule
- ihttpmodule
- www
title: 301 Moved Permanently
---


It's generally good practice to set up a DNS A-record to point to 'yoursite.com' and a CNAME that aliases 'www.yoursite.com' with 'yoursite.com'. Many users still think all addresses begins with www, and smarter/more lazy surfers simply skips the leading www and types in the top level domain name. If you don't do anymore about it, traffic analysis tools, logs, search engines and whatnot will see yourhost.com and www.yourhost.com as two separate sites. Reducing pagerank and giving more complex traffic analysis. External references and bookmarks will use both variants. Thus I usually redirects the www. variant to the shorter version. This is best done using a 301 HTTP redirection that instructs browsers and search engines that the page moved permanently to a new location, ie. to yoursite.com. The most common way is to write a HTTPModule and register it in web.config. The simpler way I present here is adding 10 lines of code in global.asa.cs.   
<pre class="csharpcode"><code><span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Init() {
     <span class="kwrd">base</span>.Init();
     BeginRequest += <span class="kwrd">new</span> EventHandler(App_BeginRequest);
}
<span class="kwrd">void</span> App_BeginRequest(<span class="kwrd">object</span> sender, EventArgs e) {
     <span class="kwrd">const</span> <span class="kwrd">string</span> www = <span class="str">"www."</span>;
     Uri requestUrl = Request.Url;
     <span class="kwrd">bool</span> hostBeginsWithWww = requestUrl.Host.StartsWith(www, StringComparison.OrdinalIgnoreCase);
     <span class="kwrd">if</span> (hostBeginsWithWww)
     {
         <span class="kwrd">string</span> newLocation = requestUrl.GetLeftPart(UriPartial.Authority)
                                        .Replace(www, <span class="kwrd">string</span>.Empty)
                            + requestUrl.PathAndQuery;
         Response.Status = <span class="str">"301 Moved Permanently"</span>;
         Response.AddHeader(<span class="str">"Location"</span>, newLocation);
         Response.End();
     }
} </code></pre>

