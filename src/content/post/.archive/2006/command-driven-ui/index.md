---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-21T22:00:00Z"
description: ""
draft: false
slug: command-driven-ui
tags:
- dotnet
title: Command driven UI (updated)
---


User interface should be built around the command pattern. Windows is command driven by WM_COMMAND, Delphi has the TAction and the upcoming WPF has an ICommand interface. But not Windows Forms. Unfortunately this have animated too many programmers to build primary application functionality built into events handlers in the user interface. We have all seen horrible examples of this typical old-school VB code smell. I recently discovered Marco De Sanctis' [excellent port of Delhi Actions](http://www.codeproject.com/cs/miscctrl/CradsActions.asp) to C#2.0.  Well I have no sentimental feelings for Delhi, so I decided to build a command driven UI on the WPF ICommand, that will allow me to reuse my business logic in WPF. I also threw in a [memento pattern](http://en.wikipedia.org/wiki/Memento_pattern) based undo stack, command metadata and a application startup mechanism that makes the percieved application startup faster by immediately showing the main form, and then load the contents. In other words it's an application building block for .NET applications. Currently the supported controls are ButtonBase and ToolStripItem derivates. It would be easy to extend the framework to support both Windows Forms and ASP.NET applications using the same business logic. [ ![](http://klinkby.files.wordpress.com/2006/10/WindowsLiveWriter/CommanddrivenUI_AA4A/AppCore_thumb%5B3%5D.jpg)](http://klinkby.files.wordpress.com/2006/10/WindowsLiveWriter/CommanddrivenUI_AA4A/AppCore%5B5%5D.jpg) The core functionality is the CommandProvider control that extends controls with a Command property, which enables assigning a command to each control. Well, enough talk - check the image, [download the solution](http://www.kli.dk/blog/AppCore.zip), and tell me what you think. (Updated download link 2006-11-02).

