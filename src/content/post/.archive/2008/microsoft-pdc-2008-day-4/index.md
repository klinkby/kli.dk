---
author: "@klinkby"
keywords:
- dotnet
- microsoft
- pdc2008
date: "2008-10-29T23:00:00Z"
description: ""
draft: false
slug: microsoft-pdc-2008-day-4
tags:
- dotnet
- microsoft
- pdc2008
title: Microsoft PDC 2008 day 4
---


*No keynote this last day, so directly to the morning session...* **Creating SharePoint applications with VS2008** I
talked to a MS product manager at the SharePoint booth the other day, and asked him why there was no new SharePoint
features revealed at the conference. He said he couldn't tell me anything about the next release. So :-( But that didn't
stop Microsoft from throwing in a couple of SP sessions in the schedule. This session was a walkthrough of some of the
things you can build with
the[ VSeWSS3 v1.2](http://www.microsoft.com/downloads/details.aspx?FamilyID=7bf65b28-06e2-4e87-9bad-086e32185e68&displaylang=en "VSeWSS 1.2")
for VS2008, ie. applying a site theme with a feature, custom field, content type with event and custom action. He also
showed putting a Silverlight graph control in a webpart. After seeing the standards based Azure these last couple of
days, I had almost forgot how ugly the WSS SDK is. At one time the speaker said "This XML looks pretty scary", while
collapsing some of the nodes as not to have people running screaming out of the auditorium. All that POX dissecting from
web services, guids and weakly typed result sets - plenty of room for improvement here.*Updated:* *<span>I skipped the
second morning session to have a go on the hands on labs (HOL), the only way to get a token needed to sign up for a Live
Serices (Mesh) application developer account.</span>* *<span>**Advanced Asynchronous Workflow using SharePoint**</span>*
The flashy name covers over a session that demonstrated a simple pattern where a SP workflow created a task, called a
remote web service, waited for the task to complete (when a local web service completed it), before deleting the task
again and exiting. Nothing to loose your breath about here. An overview was given on the workflow ecosystem: SP is and
will be the workflow platform for IM like human workflows, and biztalk for orchestration. The new "Dublin" application
server is for actual business applications implemented with WF. *<span></span><span>I missed the sessions on "Quadrant"
ie. the graphical model schema editor for the "Oslo", so I took a HOL on the subject. It's has a very simplistic 3-color
GUI, with some new controls eg. drag-scrolling lists (without scrollbars). Though I only had time to build a basic model
it sure looked cool.</span>*

