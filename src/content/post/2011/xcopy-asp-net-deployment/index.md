---
author: "@klinkby"
keywords:
- dotnet
- www
date: "2011-10-24T22:00:00Z"
description: ""
draft: false
slug: xcopy-asp-net-deployment
tags:
- dotnet
- www
title: Minimalist's build script for ASP.NET projects
---


When deploying ASP.NET web sites you have a number of options ranging from full blown (up) MSI installers, MSDeploy or the [KISS](http://en.wikipedia.org/wiki/KISS_principle) option: [xcopy deployment](http://en.wikipedia.org/wiki/XCOPY_deployment). If the target IIS set up this is a very clean way to redistribute your application. First download a 7za.exe archiver and put it in your solution root. Then create a make.bat file in your web project (build action = none) and paste the following section in it.   

```BAT
FOR %%A IN (%Date%) DO SET today=%%A
set archive=NextBigThing-%today%.zip
set z=..\7za.exe
cd ..
del %archive%
echo Creating %archive%
%z% a -tzip -r -mx9 %archive% -x!obj\*.* favicon.ico global.asax robots.txt
   web.config App_Data Bin\*.dll Content\*.png
   Content\*.gif Content\site.min.css Scripts\site.min.js Views\*.cshtml
   Views\*.config
```

Finally add the following line to your web project's Post-build event command line property:

```BAT
 ..\make
```

Run the build again and you will be granted with a zip file named with today's date containing the files needed to run your application.

Note you might need to tweak the last line in the script to include the files your app needs.

