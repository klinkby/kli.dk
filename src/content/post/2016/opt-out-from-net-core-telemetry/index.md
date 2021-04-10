---
author: "@klinkby"
keywords:
- dotnet
- microsoft
- monitor
- security
date: "2016-07-06T06:32:04Z"
description: ""
draft: false
image: /images/2017/09/et_phone_home_extra_terrestrial.jpg
slug: opt-out-from-net-core-telemetry
tags:
- dotnet
- microsoft
- monitor
- security
title: Opt out from .NET Core telemetry
---
![image](/images/2017/09/et_phone_home_extra_terrestrial.jpg)
# Opt out from .NET Core telemetry

So Microsoft decided that the [.NET Core](https://github.com/dotnet/core) Tools should "phone home" with [telemetry](https://docs.microsoft.com/en-us/dotnet/articles/core/tools/telemetry) data it gathers while using the tools to e.g. run or build applications using .NET Core. 
   
While it is an aggressive default for an open source project, it is easy to opt-out. Open a terminal in Linux and type the following to disable telemetry system-wide for good. 

```SH
echo DOTNET_CLI_TELEMETRY_OPTOUT=1 | sudo tee -a /etc/environment
```

