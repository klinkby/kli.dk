---
author: "@klinkby"
keywords:
- dotnet
- performance
- sharepoint
date: "2011-10-12T22:00:00Z"
description: ""
draft: false
slug: sharepoint-list-performance-or-how-i-saved-94
tags:
- dotnet
- performance
- sharepoint
title: SharePoint List Performance
---


In a recent performance test session, I had created a thousand documents in a document library. They all had a 20 custom
metadata fields filled out with data. The unit under test read all this data along with the common file information like
this:

```C#
SPUser user = listItem.File.CheckedOutByUser;
result.CheckedOutBy = user != null ? user.LoginName : null;
result.Author = new SPFieldUserValue(m_web, (string)row["Author"]).User.LoginName;
result.Editor = new SPFieldUserValue(m_web, (string)row["Editor"]).User.LoginName;
result.Link = m_serverUrl + listItem.File.ServerRelativeUrl;
result.Version = listItem.File.UIVersionLabel;
```

Using SPList.GetItems(SPQuery) it took 5042 mS. The data was used in request/response scenario so this delay was totally
unacceptable as this obviously meant the user should be waiting for five seconds while SlugPoint™ was digging through
the list. First thought was to avoid the repeatedly creation of SPUser instances for the first three properties. Usually
only a dozen users creates all the documents so a bit of caching can be applied with this class:

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
Replacing the first couple of lines in the original code with the following code snippet reduced the execution time to
3017 mS saving 42%.

```C#
class UserCache
{
    SPWeb m_web;
    Dictionary<string, string> m_map = new Dictionary<string, string>();

    public UserCache(SPWeb web)
    {
        m_web = web;
    }

    public string GetLoginName(string fieldValue)
    {
        if (string.IsNullOrEmpty(fieldValue))
            return null;
        string loginName;
        if (!m_map.TryGetValue(fieldValue, out loginName))
        {
            loginName = new SPFieldUserValue(m_web, fieldValue).User.LoginName;
            m_map.Add(fieldValue, loginName);
        }        
        return loginName;
    }
}
```

The Link property can be resolved by reading the FileRef field directly instead of creating the SPFile instance.
Replacing that line with the following reduced the execution time to 2903 mS saving a further 2%.

```C#
result.Link = m_serverUrl + listItem[SPBuiltInFieldId.FileRef];
```

The last line looks much like the preceding one, so I was expecting a similar saving when replacing it with:

```C#
result.Version = (string)listItem["_UIVersionString"];
```

Instead the operation now took 286 mS a further saving of 52%, which means it now only took 6% of the original
processing time. I did not have the time to Reflector the SPFile.UIVersionLabel property but will propably stay away
from that one in the near future. My conlusion is for performance you should pull values from the list item fields
directly instead of reading properties from the object model.

