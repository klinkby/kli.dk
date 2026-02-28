---
author: "@klinkby"
keywords:
- gadgets
- music
- powershell
- technology
date: "2010-02-28T23:00:00Z"
description: ""
draft: false
slug: ps3-play-aac
tags:
- gadgets
- music
- powershell
- technology
title: Make Playstation3 play AAC files
---


Odd machine, this Sony Playstation3. The processing powerhouse plays DIVX
movies, [ WMA9](https://www.microsoft.com/windows/windowsmedia/forpros/codecs/audio.aspx#WindowsMediaAudio9) audio,
and [AVCHD](http://en.wikipedia.org/wiki/AVCHD) movies with [AAC](http://en.wikipedia.org/wiki/Advanced_Audio_Coding)
packed in [MP4](http://en.wikipedia.org/wiki/MPEG-4_Part_14) part 14 containers (*). M4v that is. But doesn't support
the open standard MP4 audio (M4a) that most audio players (including Walkman® killer iPod) use today. Instead genious
Sony supports AAC in [3gpp](http://www.3gpp.org/) containers, used in GSM mobile phones. Well it's not really a
proprietary format, which Sony is very well [disrespected](http://www.google.dk/search?q=sony+proprietary) for
embracing, but more an annoyance to Apple I guess(and of course Playstation owners). See the actual audio track of and
M4a file is identical to the 3gpp file. Both are compressed using AAC. Only the container and the tags (i.e. album,
artist etc.) are different, so it's easy and lossless to convert one format to the other - no transcoding necessary. The
following [Powershell 2.0](http://support.microsoft.com/kb/968929) script converts an M4A file to 3gpp, preserving the
tagging in the file. Two dependencies are requred: [Mp4Box](http://www.videohelp.com/tools/mp4box)
and [AtomicParsley](http://atomicparsley.sourceforge.net/). Drop the binaries with the script. The one parameter the
.ps1 script needs is the input mp4 audio file.


<pre class="csharpcode"><code>Param ($m4aFile = <span class="str">"sample.m4a"</span>)
$regex = [regex]<span class="str">'(?x)Atom[^\w]+(?&lt;key&gt;\w+)[^:]+:\s(?&lt;value&gt;.+)'</span>
$tags = @{ }
.\AtomicParsley ($m4aFile) -t |
    <span class="kwrd">foreach</span> {$regex.matches($_)} |
        <span class="kwrd">foreach</span> {
            <span class="kwrd">if</span> (!$tags.Contains($_.Groups[<span class="str">"key"</span>].Value)) {
                $tags.Add($_.Groups[<span class="str">"key"</span>].Value, $_.Groups[<span class="str">"value"</span>].Value)
                }
            }
$newFile = [System.IO.Path]::ChangeExtension($m4aFile, <span class="str">".3gp"</span>)
$newFile
$map = @{
    <span class="str">"nam"</span> = <span class="str">"--3gp-title"</span>;
    <span class="str">"wrt"</span> = <span class="str">"--3gp-author"</span>;
    <span class="str">"ART"</span> = <span class="str">"--3gp-performer"</span>;
    <span class="str">"gnre"</span> = <span class="str">"--3gp-genre"</span>;
    <span class="str">"desc"</span> = <span class="str">"--3gp-description"</span>;
    <span class="str">"cprt"</span> = <span class="str">"--3gp-copyright"</span>;
    <span class="str">"alb"</span> = <span class="str">"--3gp-album"</span>;
    <span class="str">"day"</span> = <span class="str">"--3gp-year"</span>;
    <span class="str">"keyword"</span> = <span class="str">"--3gp-keyword"</span>;
}
[void] (.\MP4Box ($m4aFile) -out ($newFile) -brand 3gp6 -3gp -isma -psp -new)
$a = @($newFile, "-W")
$tags.Keys | <span class="kwrd">foreach</span> {
    <span class="kwrd">if</span> ($_ <span class="preproc">-ne</span> $null -and $map.Contains($_))
    {
        $a += $map[$_]
        $a += $tags[$_]
        <span class="kwrd">if</span> ($_ <span class="preproc">-eq</span> <span class="str">"alb"</span> -and $tags.Contains(<span class="str">"trkn"</span>))
        {
            $a += <span class="str">"track="</span> + $tags[<span class="str">"trkn"</span>]
        }
        <span class="kwrd">if</span> ($_ <span class="preproc">-ne</span> <span class="str">"day"</span>)
        {
            $a += <span class="str">"UTF16"</span>
        }
    }
}
[void] (.\AtomicParsley @a)
</code></pre>
For your convenience here's an [archive with script, dependencies and a sample file](http://kli.dk/blog/To3gpp.zip).

