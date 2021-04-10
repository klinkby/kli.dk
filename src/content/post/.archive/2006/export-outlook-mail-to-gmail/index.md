---
author: "@klinkby"
keywords:
- gadgets
- technology
date: "2006-11-08T23:00:00Z"
description: ""
draft: false
slug: export-outlook-mail-to-gmail
tags:
- gadgets
- technology
title: '"Export" Outlook mail to Gmail'
---


I am really beginning to like Gmail, and find myself opening the browser to check mail instead of Outlook. I miss an import function in Gmail though. It would be nice if I could upload a .pst file to Gmail. Instead I made this little VB script that runs though my inbox and forwards every single mail to my Gmail account (and of course a filter to automatically archive and categorize it). It takes a while to process a large inbox, but the pause is required to avoid flodding the SMTP server.   

**Put this in ThisOutlookSession:**

 <span class="kwrd">Sub</span> ProcessInbox() <span class="kwrd">Dim</span> ns <span class="kwrd">As</span> <span class="kwrd">NameSpace</span> <span class="kwrd">Set</span> ns = ThisOutlookSession.Session <span class="kwrd">Dim</span> ib <span class="kwrd">As</span> MAPIFolder <span class="kwrd">Set</span> ib = ns.GetDefaultFolder(olFolderInbox) <span class="kwrd">Dim</span> item <span class="kwrd">As</span> MailItem <span class="kwrd">For</span> <span class="kwrd">Each</span> item <span class="kwrd">In</span> ib.Items <span class="kwrd">Dim</span> fwd <span class="kwrd">As</span> MailItem <span class="kwrd">Set</span> fwd = item.Forward fwd.Recipients.Add <span class="str">"[INSERT ACCOUNT NAME]+import@**gmail**.com"</span> fwd.Subject = Replace(fwd.Subject, <span class="str">"FW: "</span>, <span class="str">""</span>, 1, 1) fwd.Send <span class="kwrd">While</span> ns.GetDefaultFolder(olFolderOutbox).Items.Count > 5 <span class="kwrd">Dim</span> i <span class="kwrd">As</span> <span class="kwrd">Integer</span> <span class="kwrd">For</span> i = 0 <span class="kwrd">To</span> 1000 DoEvents Sleep 15 <span class="kwrd">Next</span> i <span class="kwrd">Wend</span> <span class="kwrd">Next</span> <span class="kwrd">End</span> <span class="kwrd">Sub</span> 

**And this in a module:**   

 <span class="kwrd">Public</span> <span class="kwrd">Declare</span> <span class="kwrd">Sub</span> Sleep <span class="kwrd">Lib</span> <span class="str">"kernel32″</span> (<span class="kwrd">ByVal</span> dwMilliseconds <span class="kwrd">As</span> <span class="kwrd">Long</span>)

