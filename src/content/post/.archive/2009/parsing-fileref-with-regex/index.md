---
author: "@klinkby"
keywords:
- dotnet
date: "2009-03-15T23:00:00Z"
description: ""
draft: false
slug: parsing-fileref-with-regex
tags:
- dotnet
title: Parsing FileRef with Regex
---


Custom List items in SharePoint lacks an "ego-link field". The closes is the FileRef field that contain values like:

> <code>1;#weblog/Lists/Blogmeddelelser/1_.000</code>

You can mix the fields EncodedAbsUrl with parts of FileRef, add an aspx page name and actually get the real deal. This
simple regular expression will match the ID and the list path relative to the site collection:

> <code>(?'id'\d+)(?:\;\#)(?'path'.*?)\d+_\.</code>

The following code will help a long way.

<pre class="csharpcode"><code><span class="kwrd">readonly</span> <span class="kwrd">static</span> Regex _fileRefParser = <span class="kwrd">new</span> Regex(
    <span class="str">@"(?'id'\d+)(?:\;\#)(?'path'.*?)\d+_\."</span>, 
    RegexOptions.Compiled | RegexOptions.CultureInvariant | RegexOptions.ExplicitCapture);
<span class="kwrd">static</span> Uri GetUri(<span class="kwrd">string</span> encodedAbsUrl, <span class="kwrd">string</span> fileRef, <span class="kwrd">bool</span> isBlog)
{
    Match match = _fileRefParser.Match(fileRef);
    <span class="kwrd">return</span> <span class="kwrd">new</span> Uri(
        <span class="kwrd">string</span>.Format(
            CultureInfo.InvariantCulture,
            <span class="str">"{0}{1}{2}.aspx?ID={3}"</span>,
            encodedAbsUrl,
            match.Groups[<span class="str">"path"</span>],
            isBlog ? <span class="str">"ViewPost"</span> : <span class="str">"DispForm"</span>,
            match.Groups[<span class="str">"id"</span>]),
        UriKind.Absolute);
}</code></pre>

