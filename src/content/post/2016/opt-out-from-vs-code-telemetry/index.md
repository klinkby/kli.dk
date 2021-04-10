---
author: "@klinkby"
keywords:
- dotnet
- microsoft
- security
date: "2016-10-28T05:50:02Z"
description: ""
draft: false
image: /images/2017/09/et_phone_home_extra_terrestrial.jpg
slug: opt-out-from-vs-code-telemetry
tags:
- dotnet
- microsoft
- security
title: Opt out from VS Code telemetry
---
![image](/images/2017/09/et_phone_home_extra_terrestrial.jpg)
# Opt out from VS Code telemetry

[Visual Studio Code](https://code.visualstudio.com/) defaults to automatically gather information about how you use the cross platform open source code editor, and send it back to Microsoft. 

If you like to opt out from this, add the following to your user preferences (File > Preferences > User).

```JS
{
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
}
```

