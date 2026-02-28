---
author: "@klinkby"
keywords:
- dotnet
- devops
- sharepoint
- www
- soap
date: "2010-12-09T23:00:00Z"
description: ""
draft: false
slug: sharepoint-web-config-modifications
tags:
- dotnet
- devops
- sharepoint
- www
- soap
title: SharePoint web.config modifications
---


WSP deployment packages is the MSI for SharePoint. It really helps server administrators manage deployment as well as
developers packing functionality and content in compact packages. With the introduction of Visual Studio 2010 it became
easier to produce all kinds of WSPs right in your favorite dev env. Custom web.config modifications is one aspect Visual
Studio doesn't handle though. And reading reading the documentation and blog posts on how to use
the [ SPWebConfigModification](http://msdn.microsoft.com/en-us/library/microsoft.sharepoint.administration.spwebconfigmodification.aspx)
class might make you think it's somewhat fuzzy. It isn't, but as most SharePoint API related it easily breaks if not
used exactly the way the API developer thought it should be used. And if called directly you end up with lots of tedious
code for adding simple configuration let alone your massive WCF configuration. So I wrote a small class that parses an
app.config file and returns the modifications SharePoint needs to add/remove elements to the web configuration. Example:

<pre class="csharpcode"><code>SPWebService webApp = SPWebService.ContentService;
<span class="kwrd">using</span> (var ms = <span class="kwrd">new</span> MemoryStream(Resources.MyConfig))
{
    <span class="kwrd">using</span> (var reader = XmlReader.Create(ms))
    {
        var mods = ConfigParser.GetAddMods(reader, Owner);
        <span class="rem">// use GetRemoveMods() to remove it again</span>
        <span class="kwrd">foreach</span> (var mod <span class="kwrd">in</span> mods)
        {
            webApp.WebConfigModifications
                  .Add(mod); <span class="rem">// or Remove()</span>
        }
    }
}
webApp.Update();
webApp.Farm
      .Services
      .GetValue&lt;SPWebService&gt;()
      .ApplyWebConfigModifications();</code></pre>
To remove the configuration again simply replace the two method calls as specified in the comments. Download
the [ConfigParser class](http://kli.dk/blog/configparser.zip) and have a look.

