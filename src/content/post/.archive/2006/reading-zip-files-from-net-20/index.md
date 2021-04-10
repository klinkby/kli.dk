---
author: "@klinkby"
keywords:
- dotnet
date: "2006-12-20T23:00:00Z"
description: ""
draft: false
slug: reading-zip-files-from-net-20
tags:
- dotnet
title: Reading Zip files from .NET 2.0
---


The .NET Framework 2.0 has Deflate and GZip implementations, but no support for Zip files. I want make a zip file available for download from a web server, and enable the server to open the archive and read the file contents.

The code uncompresses the first file in the zip archive.

 <span class="kwrd">using</span> System; <span class="kwrd">using</span> System.IO; <span class="kwrd">using</span> System.IO.Compression; <span class="kwrd">using</span> System.Runtime.InteropServices; <span class="kwrd">using</span> System.Text;  <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> Unzipper {     <span class="rem">// See Zip file specification for magic numbers etc.</span>     <span class="rem">// http://www.pkware.com/business_and_developers/developer/appnote/</span>     <span class="kwrd">const</span> <span class="kwrd">uint</span> LocalFileHeaderSignature = 0x04034b50;     <span class="kwrd">const</span> <span class="kwrd">int</span> BytesToSkip = 2 + 2 + 2 + 2 + 2 + 4 + 4;     <span class="kwrd">const</span> <span class="kwrd">int</span> BufferSize = 1<<14; <span class="rem">// read chunks of 16k</span>      <span class="kwrd">static</span> <span class="kwrd">uint</span> SeekContents(Stream zipStream)     {         BinaryReader br = <span class="kwrd">new</span> BinaryReader(zipStream);         <span class="kwrd">uint</span> uncompressedSize = 0;         <span class="kwrd">if</span> (br.ReadUInt32() == LocalFileHeaderSignature)         {             <span class="rem">// skip part of the header</span>             zipStream.Seek(BytesToSkip, SeekOrigin.Current);             uncompressedSize = br.ReadUInt32();             <span class="kwrd">ushort</span> fileNameLength = br.ReadUInt16();             <span class="kwrd">ushort</span> extraFieldLength = br.ReadUInt16();             <span class="rem">// the compressed contents is right after the header</span>             zipStream.Seek(fileNameLength + extraFieldLength, SeekOrigin.Current);         }         <span class="kwrd">return</span> uncompressedSize;             }      <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">long</span> Deflate(Stream outputStream, Stream compressedStream)     {         <span class="kwrd">uint</span> uncompressedSize = SeekContents(compressedStream);         <span class="kwrd">byte</span>[] buf = <span class="kwrd">new</span> <span class="kwrd">byte</span>[BufferSize];         <span class="kwrd">using</span> (Stream decompressor = <span class="kwrd">new</span> DeflateStream(compressedStream, CompressionMode.Decompress))         {             <span class="kwrd">for</span> (<span class="kwrd">int</span> i = 0; i < uncompressedSize; )             {                 <span class="rem">// make sure we don't read past the stream</span>                 <span class="kwrd">int</span> bytesToRead = ((i + BufferSize) > uncompressedSize)                     ? (<span class="kwrd">int</span>)(uncompressedSize % BufferSize)                     : BufferSize;                 <span class="kwrd">int</span> bytesRead = decompressor.Read(buf, 0, bytesToRead);                 <span class="kwrd">if</span> (bytesRead != bytesToRead)                     <span class="kwrd">throw</span> <span class="kwrd">new</span> InvalidDataException();                 outputStream.Write(buf, 0, bytesRead);                 i += bytesRead;             }         }         <span class="kwrd">return</span> uncompressedSize;     } }

