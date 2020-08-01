---
author: Mads Klinkby
categories:
- .net
date: "2007-06-06T22:00:00Z"
description: ""
draft: false
slug: environmental-issue
tags:
- .net
title: Environmental issue
---


In a web application I'm impersonating the client user. The GetFolderPath expands to the impersonated user's special folders. I would expect the the Environment.ExpandEnvironmentVariables to expand to the impersonated user's environment variables - but no... The environment variables are expanded to the IIS service account's.

