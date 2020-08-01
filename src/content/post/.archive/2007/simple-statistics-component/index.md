---
author: Mads Klinkby
categories:
- .net
date: "2007-01-28T23:00:00Z"
description: ""
draft: false
slug: simple-statistics-component
tags:
- .net
title: Simple statistics component
---


Last week I had to generate statistics for a website that had gathered more than a million hits. The database "log" table took up about 130MB on the server.

First it took some time to download the table to a local pc. Then I had to write the queries that filtered out automated web crawlers, then queries that aggregated the page hits, unique visitors and get the latest [IP location database](http://www.maxmind.com/), import it into the database, and it took an unreasonable long time to execute the join between the 1½ mio row log table and the 65k row IP location table.

There must be a better way: Generate the statistics on the fly.

So I wrote a simple yet very efficient website statistics aggregator, that gather essential statistics from human web surfers that visit your site.

The statistics is reset on an hourly basis, serialized directly to xml and a new statistics file is generated for each month.

The data collected include:

*   Total hit count for individual pages
*   Primary browser language (unique visitors)
*   Country of IP address (uv)
*   Browser type (uv)
*   OS platform (uv)
*   Referrer hosts (uv)  

The code is highly extensibe, should you like to gather other information. A request is handled in about 0.5mS, so there's not much overhead there. To use it just insert the a simple parameterless call in your master page (or any other page you like to gather statistics from).

 <span class="kwrd">readonly</span> <span class="kwrd">static</span> Statistics statistics = Statistics.Create();  <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> OnLoad(EventArgs e) {   statistics.OnRequest();   <span class="kwrd">base</span>.OnLoad(e); } 

The IP location lookup is done by binary search in a compact version of the MaxMind database. To update the database, dump the csv file from the MaxMind zip in the GeoIP folder and delete the bin file. The component will then automatically rebuild the bin file, and you can safely delete the csv file again.

The default configuration will write files to a Log sub-folder so make sure to create it or change the config file. The DLL can be used directly in Visual Web Developer Express.

[Download the C# project](http://www.kli.dk/blog/WebStats.zip)

