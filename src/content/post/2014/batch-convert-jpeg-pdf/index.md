---
author: "@klinkby"
keywords:
- media
date: "2014-03-31T22:00:00Z"
description: ""
draft: false
slug: batch-convert-jpeg-pdf
tags:
- media
title: Batch Convert JPGs to PDFs
---


I needed a simple and efficient way to convert a bunch documents scanned to jpgs to compact pdfs.

Here's a Powershell script just for that:

```PS1
[CmdletBinding()]
Param([Parameter(Mandatory=$true)][string]$filePattern)

Get-ChildItem $filePattern |% {
  $inPath = $_
  $outPath = [IO.Path]::ChangeExtension($inPath, ".pdf")
  $inDir = [IO.Path]::GetDirectoryName($inPath)
  $inFile = [IO.Path]::GetFileName($inPath)

  Set-Location $inDir

  $command = "$env:programfiles\gs\gs9.14\bin\gswin64c.exe"
  $argList = "-dNOPAUSE -dBATCH -sDEVICE=pdfwrite -o ""$outPath"" -dCompatibilityLevel=1.4 " `
           + "-dPDFSETTINGS=/ebook -sColorConversionStrategy=Gray -sColorConversionStrategyForImages=Gray " `
           + "-sProcessColorModel=DeviceGray -dOverrideICC viewjpeg.ps " `
           + "-c (""$inFile"") viewJPEG showpage"
  $proc = Start-Process -filepath $command -argumentList $argList -Wait -PassThru -NoNewWindow 
}
```

The great open source tool GhostScript is a dependency
so [download its installer from here](http://www.ghostscript.com/download/gsdnld.html).

