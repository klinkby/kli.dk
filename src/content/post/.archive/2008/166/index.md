---
author: "@klinkby"
keywords:
- dotnet
- powershell
date: "2008-09-16T22:00:00Z"
description: ""
draft: false
slug: "166"
tags:
- dotnet
- powershell
title: LDAP query in PowerShell
---


I was looking for away of listing the account names of the active users in the AD, and Google suggested som more or less
exotic ways of doing that. But this little PowerShell script is not too bad have in the toolbox:

<pre class="csharpcode"><code>$Search = New-Object DirectoryServices.DirectorySearcher([ADSI]<span class="str">"LDAP://CN=Users,DC=domain,DC=local"</span>)
$Search.<span class="kwrd">filter</span> = <span class="str">"(&amp;(objectCategory=person)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"</span>
Foreach($result <span class="kwrd">in</span> $Search.Findall()){
$user = $result.GetDirectoryEntry()
$user.sAMAccountName
}</code></pre>
The filter prevents service accounts and disabled users to show up in the list.

