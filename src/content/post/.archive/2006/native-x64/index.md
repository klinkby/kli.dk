---
author: Mads Klinkby
categories:
- .net
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: native-x64
tags:
- .net
title: Native x64
---


Your managed code will by default take advange of the extra processor functionality when running under Windows x64. This means a nice "free" performance boost. Except if your process depends on native Win32 dlls, as these cannot be loaded. Only dlls compiled for x64 can be loaded into a 64 bit process. This little C++.NET example shows how to determine the library to load at runtime depending of the process bitness. I.e. on Win32 and x64 it will use Interopx86.dll and Interopx64.dll respectively.   

<pre class="csharpcode"><code>#include <span class="str">"StdAfx.h"</span> 
#include &lt;tchar.h&gt; 
#include &lt;windows.h&gt; 

<span class="kwrd">using</span> <span class="kwrd">namespace</span> System; 
<span class="kwrd">using</span> <span class="kwrd">namespace</span> System::IO; 
<span class="kwrd">using</span> <span class="kwrd">namespace</span> System::Runtime::InteropServices; 

<span class="kwrd">ref</span> <span class="kwrd">class</span> TestInterop 
{ 
    typedef <span class="kwrd">void</span> (*TestProc)(); 
    TestProc test; 
    HMODULE hModule; 

<span class="kwrd">public</span>: 
    TestInterop() 
    { 
        String^ assemblyName = <span class="str">"Interop"</span> + (IsWin32() ? <span class="str">"x86.dll"</span> : <span class="str">"x64.dll"</span>); 
        IntPtr pAssemblyName = Marshal::StringToHGlobalUni(assemblyName); 
        LPCWSTR szAssemblyName = (LPCWSTR)pAssemblyName.ToPointer(); 
        hModule = ::LoadLibraryW(szAssemblyName); 
        Marshal::FreeHGlobal(pAssemblyName); 
        <span class="kwrd">if</span> (hModule==NULL) 
            <span class="kwrd">throw</span> gcnew FileNotFoundException(<span class="str">"LoadLibrary failed"</span>); 
        test = (TestProc) ::GetProcAddress(hModule, <span class="str">"Test"</span>); 
        <span class="kwrd">if</span> (test==NULL) 
            <span class="kwrd">throw</span> gcnew MissingMethodException(<span class="str">"Test is missing"</span>); 
    } 
    <span class="kwrd">void</span> Test() 
    { 
        test(); 
    } 
    <span class="kwrd">virtual</span> ~TestInterop() 
    { 
        FreeLibrary(hModule); 
        hModule = NULL; 
    } 
    <span class="kwrd">static</span> <span class="kwrd">bool</span> IsWin32() 
    { 
        <span class="kwrd">return</span> <span class="kwrd">sizeof</span>(<span class="kwrd">void</span>*) == 4; 
    } 
}; 

<span class="kwrd">int</span> main(array&lt;System::String ^&gt; ^args) 
{ 
    TestInterop iop; 
    iop.Test(); 
    <span class="kwrd">return</span> 0; 
}</code></pre>

