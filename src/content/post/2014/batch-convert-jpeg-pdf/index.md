---
author: Mads Klinkby
categories:
- convert
date: "2014-03-31T22:00:00Z"
description: ""
draft: false
slug: batch-convert-jpeg-pdf
tags:
- convert
title: Batch Convert JPGs to PDFs
---


I needed a simple and efficient way to convert a bunch documents scanned to jpgs to compact pdfs.

Here's a Powershell script just for that:

<pre class="csharpcode">[CmdletBinding()]
Param([Parameter(Mandatory=$true)][string]$filePattern)

Get-ChildItem $filePattern |% {
  $inPath = $_
  $outPath = [IO.Path]::ChangeExtension($inPath, <span class="str">".pdf"</span>)
  $inDir = [IO.Path]::GetDirectoryName($inPath)
  $inFile = [IO.Path]::GetFileName($inPath)

  Set-Location $inDir

  $command = <span class="str">"$env:programfiles\gs\gs9.14\bin\gswin64c.exe"</span>
  $argList = <span class="str">"-dNOPAUSE -dBATCH -sDEVICE=pdfwrite -o "</span><span class="str">"$outPath"</span><span class="str">" -dCompatibilityLevel=1.4 "</span> `
           + <span class="str">"-dPDFSETTINGS=/ebook -sColorConversionStrategy=Gray -sColorConversionStrategyForImages=Gray "</span> `
           + <span class="str">"-sProcessColorModel=DeviceGray -dOverrideICC viewjpeg.ps "</span> `
           + <span class="str">"-c ("</span><span class="str">"$inFile"</span><span class="str">") viewJPEG showpage"</span>
  $proc = Start-Process -filepath $command -argumentList $argList -Wait -PassThru -NoNewWindow 
}
</pre>

The great open source tool GhostScript is a dependency so [download its installer from here](http://www.ghostscript.com/download/gsdnld.html).

