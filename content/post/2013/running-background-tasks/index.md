---
author: Mads Klinkby
categories:
- .net
- asp.net
- code
- dotnet
date: "2013-01-22T23:00:00Z"
description: ""
draft: false
slug: running-background-tasks
tags:
- .net
- asp.net
- code
- dotnet
title: Running background tasks
---


Recently I had to implement a feature that ran some processing in the background at regular intervals. 

There are many ways to implement this. Usually this could mean batch processing from a headless Windows task or in a Windows Service. However, in this particular case it had to be run on a shared webhost, so in-process from the application. The background processing could take several minutes, and I wanted to make sure the background processing did not influence on the stability of the main priority i.e. serving HTTP requests.

So running it off ASP.NET's managed thread-pool was out of the question. Instead, I decided to spawn a single worker thread that could run all background tasks one item at a time. The thread would spend most of its time sleeping, and occasionally a timer would trigger it to check for due tasks. It was crucial to prevent a daily task to run twice, when for instance the host would decide to restart the application pool. So the implementation should be able to wake up and tell when it is time for each job to run.

The implementation is modular and easily extensible. It only takes reference to the BCL assemblies, so you can use it for webbed as well as Windows applications. I included a simple file based persistence implementation.

Please have a look at the code on [https://bitbucket.org/klinkby/timerjob](https://bitbucket.org/klinkby/timerjob) I have included a sample console app that should get you going in two winks of a pony's tail.

If you want to use it in an ASP.NET application you would propably like to create a singleton instance of the JobManager in the Application_Start event, and dispose of it in the Application_End in Global.asax.

