---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: get-languages-spoken-by-an-assembly
tags:
- dotnet
title: Get languages spoken by an assembly
---


<pre class="csharpcode"><code><span class="rem">/// &lt;summary&gt;</span> 
<span class="rem">/// Returns the languages a given assembly "speaks".</span> 
<span class="rem">/// &lt;/summary&gt;</span> 
<span class="rem">/// &lt;param name="asm"&gt;The asm to analyze&lt;/param&gt;</span> 
<span class="rem">/// &lt;returns&gt;Array of cultures installed for the assembly&lt;/returns&gt;</span> 
<span class="kwrd">static</span> CultureInfo[] GetSupportedLanguages(Assembly asm) 
{ 
    ArrayList al = <span class="kwrd">new</span> ArrayList(); 
    DirectoryInfo dir = <span class="kwrd">new</span> DirectoryInfo( 
        Path.GetDirectoryName(asm.Location) 
        ); 
    Regex sattelitePattern = <span class="kwrd">new</span> Regex(<span class="str">@"(^w{2}-w{2}$)|(^w{2}$)"</span>); 
    <span class="kwrd">bool</span> englishFound = <span class="kwrd">false</span>; 
    <span class="kwrd">foreach</span>(DirectoryInfo subDir <span class="kwrd">in</span> dir.GetDirectories()) 
    { 
        <span class="kwrd">if</span> (sattelitePattern.IsMatch(subDir.Name)) 
        { 
            <span class="rem">// has cultureinfo form</span> 
            CultureInfo ci = <span class="kwrd">new</span> CultureInfo(subDir.Name); 
            <span class="kwrd">if</span> (ci!=<span class="kwrd">null</span>) 
            { 
                <span class="rem">// it's a culture</span> 
                <span class="kwrd">string</span> strCultureFileName = 
                    String.Format(CultureInfo.InvariantCulture, <span class="str">"{0}.resources.dll"</span>, 
                    Path.GetFileNameWithoutExtension(asm.Location)); 
                <span class="kwrd">if</span> (File.Exists( 
                    Path.Combine(subDir.FullName, 
                    strCultureFileName))) 
                { 
                    <span class="kwrd">try</span> 
                    { 
                        asm.GetSatelliteAssembly(ci); 
                        <span class="rem">// it's for the specific assembly</span> 
                        al.Add(ci); 
                        <span class="kwrd">if</span> (ci.LCID == 1033) 
                            englishFound = <span class="kwrd">true</span>; 
                    } 
                    <span class="kwrd">catch</span>(FileLoadException e) 
                    { 
                        <span class="rem">// invalid version/strong name</span> 
                    } 
                    <span class="kwrd">catch</span>(BadImageFormatException e) 
                    { 
                        <span class="rem">// Not a resource</span> 
                    } 
                } 
            } 
        } 
    } 
    <span class="kwrd">if</span> (!englishFound) 
        al.Add(<span class="kwrd">new</span> CultureInfo(1033)); <span class="rem">// add default language (english) if it wasn't found as satelites</span> 
    <span class="kwrd">return</span> (CultureInfo[]) al.ToArray(<span class="kwrd">typeof</span>(CultureInfo)); 
}</code></pre>

