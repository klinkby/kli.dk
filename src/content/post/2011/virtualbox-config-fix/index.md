---
author: Mads Klinkby
categories:
- .net
- configuration
date: "2011-06-29T22:00:00Z"
description: ""
draft: false
slug: virtualbox-config-fix
tags:
- .net
- configuration
title: VirtualBox Config Workaround
---


I have been having some [trouble with VirtualBox](http://www.virtualbox.org/ticket/8948) since I upgraded some time ago. Every time I close a VM VirtualBox places an invalid character (for an XML-parser anyway) in the config file, rendering the file unreadable for VirtualBox the next time I want to start it. So I did this naïve Python script to fix it.   

```PYTHON
filename = "/home/user/VirtualBox VMs/MyMachine/MyMachine.vbox" 
istr = '"/VirtualBox/GuestAdd/VersionEx"'
jstr = 'value="'
kstr = '"'

fi = open(filename)
s = fi.read()
fi.close()

i = s.index(istr) + len(istr)
j = s.index(jstr, i) + len(jstr)
k = s.index(kstr, j)
t = s[:j] + s[k:]

fi = open(filename, "w+")
fi.write(t)
fi.close()
```