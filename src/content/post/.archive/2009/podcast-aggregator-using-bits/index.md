---
author: "@klinkby"
keywords:
- dotnet
date: "2009-10-10T22:00:00Z"
description: ""
draft: false
slug: podcast-aggregator-using-bits
tags:
- dotnet
title: Podcast aggregator using BITS
---


Looking for a podcast [aggregator](http://en.wikipedia.org/wiki/Aggregator "Wikipedia: Aggregator"), I didn't really
find one that wasn't either bloated, slow or cluttered up the episodes to download. So without further ado I thought
about coding a basic and lightweight console application that didn't have to run as a background process, really robust
and use
the [ Background Intelligent Transfer Service](http://en.wikipedia.org/wiki/Background_Intelligent_Transfer_Service "Wikipedia: BITS")
to download the podcasts posts fast using idle
bandwidth. ![Add Scheduled Task](http://static.getya.net/013/images/addtask.jpg "Add Scheduled Task") The app is quite
simple to use. You add new podcasts to monitor with the command line arguments "add {url}", and remove them again with "
remove {url}". Then there is a "list" command that dumps all the feeds and the download status of each post. The last
command is "refresh", and it checks all feeds for new posts and queues them up for download. It always stores downloads
and a configuration file to the process working directory so make sure you run the app from where you want the
downloaded files to go. The above screen shot is an example of how to configure Windows Task Scheduler to let the app
automatically check for new podcast episodes. The result is
at [http://podcast.codeplex.com/](http://podcast.codeplex.com/) and there is even a ready to
use [ release build](http://podcast.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=34287#DownloadId=87225 "Download zip").
Enjoy!

