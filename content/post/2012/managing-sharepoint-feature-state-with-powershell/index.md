---
author: Mads Klinkby
categories:
- microsoft
- programming
- sharepoint
date: "2012-04-26T22:00:00Z"
description: ""
draft: false
slug: managing-sharepoint-feature-state-with-powershell
tags:
- microsoft
- programming
- sharepoint
title: Managing SharePoint feature state
---


This is a small function that wraps the [Get-SPFeature](http://technet.microsoft.com/en-us/library/ff607945.aspx), [Enable-SPFeature](http://technet.microsoft.com/en-us/library/ff607803.aspx) and [Disable-SPFeature](http://technet.microsoft.com/en-us/library/ff607879.aspx) to control state of farm, site or web scoped features.

I makes it a breeze to set the state of the built-in SharePoint features during a PowerShell deployment.

<pre class="csharpcode"><code> <span class="kwrd">function</span> EnsureFeatureState(
     [Parameter(Mandatory=$true, Position=0)]
     [string] $id,
     [Parameter(Mandatory=$true, Position=1)]
     [bool] $enabled,
     [Parameter(Mandatory=$false, Position=2)]
     [string] $site)
 {
     <span class="kwrd">if</span> (!$site) {
         [Microsoft.SharePoint.Administration.SPFeatureDefinition]$f = Get-SPFeature -Identity $id -Farm:$true -ErrorAction SilentlyContinue
         <span class="kwrd">if</span> ($f -and !$enabled) {
             Disable-SPFeature -Identity $id -Confirm:$false
         }
         <span class="kwrd">if</span> (!$f -and $enabled) {
                 Enable-SPFeature -Identity $id
         }
     }
     <span class="kwrd">else</span>
     {
         [Microsoft.SharePoint.Administration.SPFeatureDefinition]$f = Get-SPFeature -Identity $id -Site $site -ErrorAction SilentlyContinue
         <span class="kwrd">if</span> (!$f) {
             $f = Get-SPFeature -Identity $id -Web $site -ErrorAction SilentlyContinue
         }
         <span class="kwrd">if</span> ($f -and !$enabled) {
             Disable-SPFeature -Identity $id -Url $site -Confirm:$false
         }
         <span class="kwrd">if</span> (!$f -and $enabled) {
                 Enable-SPFeature -Identity $id -Url $site
         }
     }
 } </code></pre>

Here is an example that enables two farm features.

<pre class="csharpcode"><code> <span class="rem"># enable farm features</span>
 ( <span class="str">'319d8f70-eb3a-4b44-9c79-2087a87799d6'</span>, <span class="rem"># Global Web Parts</span>
 <span class="str">'612d671e-f53d-4701-96da-c3a4ee00fdc5'</span>  <span class="rem"># Spell Checking</span>
 ) | <span class="kwrd">foreach</span>-object {
      EnsureFeatureState $_ $true
 } </code></pre>

