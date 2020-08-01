---
author: Mads Klinkby
categories:
- sharepoint
date: "2009-01-19T23:00:00Z"
description: ""
draft: false
slug: powershell-script-for-copying-sp-webs-to-a-new-site-collection
tags:
- sharepoint
title: te collection…
---


I often see SharePoint farms that contains a single huge root site collection that contains e.g. project team sites and issues sites. Of course that leads to degraded performance and maintainability issues like handling 100GB+ backups. Microsoft recommends keeping content databases below 25GB. A web is contained in a site collection that is contained in a content database. So the solution is to move sites to newly created site collections, that can be placed in new, smaller content databases. This have a few positive side effects. Site collections can be moved to new content databases. Content databases can be taken offline for archived content and have different backup schedule. For a client, that had 50000 numbered issues sites i developed this small PowerShell script that exports web sites and imports them in another site collection each holding up to 5000 webs. The source sites located in e.g /1, /2, /15352 etc. are moved to /sites/0k/1, /sites/0k/2, /sites/15k/15352 `$startingnumber = 10000 $maxsites = 5000 $kilo = 1000 $scNumber = ([Int64]($startingnumber/$kilo)) $parentweb = "http://*YOURSERVER*" # The web uri where subwebs are to be read $sitecollectionpath = ($parentweb + "/*YOURMANAGEDPATH*/" + $scNumber + "k") # target site collection name (placed under a managedpath)` `function get-webname([string]$webpath) { $webpath.Substring($webpath.LastIndexOf("/")+1) } function get-filetitle([string]$filename) { $filename.Substring(0, $filename.LastIndexOf(".")) }` `######### LIST SITES` `$exportfile = "export-" + (get-webname($parentweb)) + ".xml" function get-webname([string]$webpath) { $webpath.Substring($webpath.LastIndexOf("/")+1) } function get-filetitle([string]$filename) { $filename.Substring(0, $filename.LastIndexOf(".")) } # --- list of sites .\stsadm -o enumsubwebs -url $parentweb >$exportfile # --- load list of subsites at $parentweb $subwebs = ([XML](gc $exportfile)).Subwebs ######### SELECT THE SITES AND EXPORT/IMPORT THEM # --- filter out batch of sites $index = $parentweb.Length + 2 $xpath = "Subweb[substring(., "+ $index +") >= "+ $startingnumber +" and substring(., " + $index +") < " + ($startingnumber + $maxsites)+ "]" $siteurls = $subwebs.SelectNodes($xpath)`     `# --- export each site from the source $siteurls | foreach-object { $source = $_.get_InnerText() $webname = get-webname($source) echo ("Exporting " + $webname + "...") .\stsadm -o export -url ($source) -filename ($webname) -includeusersecurity -nofilecompression -quiet echo ("Importing " + $webname + "...") .\stsadm -o import -url ($sitecollectionpath + "/" + $webname) -filename ($webname) -includeusersecurity -nofilecompression -quiet del ($webname + "\*.*") rd ($webname) echo "---------------" }`

