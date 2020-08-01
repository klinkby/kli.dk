---
author: Mads Klinkby
categories:
- .net
- performance
- sharepoint
date: "2011-10-12T22:00:00Z"
description: ""
draft: false
slug: sharepoint-list-performance-or-how-i-saved-94
tags:
- .net
- performance
- sharepoint
title: SharePoint List Performance
---


In a recent performance test session, I had created a thousand documents in a document library. They all had a 20 custom metadata fields filled out with data. The unit under test read all this data along with the common file information like this:   

<pre class="csharpcode"><code>SPUser user = listItem.File.CheckedOutByUser;
result.CheckedOutBy = user != <span class="kwrd">null</span> ? user.LoginName : <span class="kwrd">null</span>;
result.Author = new SPFieldUserValue(m_web, (<span class="kwrd">string</span>)row[<span class="str">"Author"</span>]).User.LoginName;
result.Editor = new SPFieldUserValue(m_web, (<span class="kwrd">string</span>)row[<span class="str">"Editor"</span>]).User.LoginName;
result.Link = m_serverUrl + listItem.File.ServerRelativeUrl;
result.Version = listItem.File.UIVersionLabel;
</code></pre>

  Using SPList.GetItems(SPQuery) it took 5042 mS. The data was used in request/response scenario so this delay was totally unacceptable as this obviously meant the user should be waiting for five seconds while SlugPoint™ was digging through the list. First thought was to avoid the repeatedly creation of SPUser instances for the first three properties. Usually only a dozen users creates all the documents so a bit of caching can be applied with this class:   

<pre class="csharpcode"><code><span class="kwrd">class</span> UserCache
{
    SPWeb m_web;
    Dictionary&lt;<span class="kwrd">string</span>, <span class="kwrd">string</span>&gt; m_map = <span class="kwrd">new</span> Dictionary&lt;<span class="kwrd">string</span>, <span class="kwrd">string</span>&gt;();

    <span class="kwrd">public</span> UserCache(SPWeb web)
    {
        m_web = web;
    }

    <span class="kwrd">public</span> <span class="kwrd">string</span> GetLoginName(<span class="kwrd">string</span> fieldValue)
    {
        <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(fieldValue))
            <span class="kwrd">return</span> <span class="kwrd">null</span>;
        <span class="kwrd">string</span> loginName;
        <span class="kwrd">if</span> (!m_map.TryGetValue(fieldValue, <span class="kwrd">out</span> loginName))
        {
            loginName = <span class="kwrd">new</span> SPFieldUserValue(m_web, fieldValue).User.LoginName;
            m_map.Add(fieldValue, loginName);
        }        
        <span class="kwrd">return</span> loginName;
    }
}</code></pre>
  Replacing the first couple of lines in the original code with the following code snippet reduced the execution time to 3017 mS saving 42%.  

<pre class="csharpcode"><code>m_userCache = <span class="kwrd">new</span> UserCache(web);
:
result.CheckedOutBy = m_users.GetLoginName(<span class="str">"CheckoutUser"</span>);
result.Author = m_users.GetLoginName(<span class="str">"Author"</span>);
result.Editor = m_users.GetLoginName(<span class="str">"Editor"</span>);
</code></pre>

  The Link property can be resolved by reading the FileRef field directly instead of creating the SPFile instance. Replacing that line with the following reduced the execution time to 2903 mS saving a further 2%.   

<pre class="csharpcode"></code>result.Link = m_serverUrl + listItem[SPBuiltInFieldId.FileRef];
</code></pre>
  The last line looks much like the preceding one, so I was expecting a similar saving when replacing it with:   

<pre class="csharpcode"><code>result.Version = (<span class="kwrd">string</span>)listItem[<span class="str">"_UIVersionString"</span>];
</code></pre>
  Instead the operation now took 286 mS a further saving of 52%, which means it now only took 6% of the original processing time. I did not have the time to Reflector the SPFile.UIVersionLabel property but will propably stay away from that one in the near future. My conlusion is for performance you should pull values from the list item fields directly instead of reading properties from the object model.

