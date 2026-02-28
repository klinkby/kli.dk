---
author: "@klinkby"
keywords:
- microsoft
- sharepoint
date: "2012-04-26T22:00:00Z"
description: ""
draft: false
slug: managing-sharepoint-feature-state-with-powershell
tags:
- microsoft
- sharepoint
title: Managing SharePoint feature state
---


This is a small function that wraps
the [Get-SPFeature](http://technet.microsoft.com/en-us/library/ff607945.aspx), [Enable-SPFeature](http://technet.microsoft.com/en-us/library/ff607803.aspx)
and [Disable-SPFeature](http://technet.microsoft.com/en-us/library/ff607879.aspx) to control state of farm, site or web
scoped features.

I makes it a breeze to set the state of the built-in SharePoint features during a PowerShell deployment.

```PS1
 function EnsureFeatureState(
     [Parameter(Mandatory=$true, Position=0)]
     [string] $id,
     [Parameter(Mandatory=$true, Position=1)]
     [bool] $enabled,
     [Parameter(Mandatory=$false, Position=2)]
     [string] $site)
 {
     if (!$site) {
         [Microsoft.SharePoint.Administration.SPFeatureDefinition]$f = Get-SPFeature -Identity $id -Farm:$true -ErrorAction SilentlyContinue
         if ($f -and !$enabled) {
             Disable-SPFeature -Identity $id -Confirm:$false
         }
         if (!$f -and $enabled) {
                 Enable-SPFeature -Identity $id
         }
     }
     else
     {
         [Microsoft.SharePoint.Administration.SPFeatureDefinition]$f = Get-SPFeature -Identity $id -Site $site -ErrorAction SilentlyContinue
         if (!$f) {
             $f = Get-SPFeature -Identity $id -Web $site -ErrorAction SilentlyContinue
         }
         if ($f -and !$enabled) {
             Disable-SPFeature -Identity $id -Url $site -Confirm:$false
         }
         if (!$f -and $enabled) {
                 Enable-SPFeature -Identity $id -Url $site
         }
     }
 } 
 ```

Here is an example that enables two farm features.

```PS1
 # enable farm features
 ( '319d8f70-eb3a-4b44-9c79-2087a87799d6', # Global Web Parts
 '612d671e-f53d-4701-96da-c3a4ee00fdc5'  # Spell Checking
 ) | foreach-object {
      EnsureFeatureState $_ $true
 } 
 ```

