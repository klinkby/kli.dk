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

<pre class="csharpcode"><code>filename = "/home/user/VirtualBox VMs/MyMachine/MyMachine.vbox" 
istr = <span class="str">'"/VirtualBox/GuestAdd/VersionEx"'</span>
jstr = <span class="str">'value="'</span>
kstr = <span class="str">'"'</span>

fi = <span class="kwrd">open</span>(filename)
s = fi.<span class="kwrd">read</span>()
fi.<span class="kwrd">close</span>()

i = s.<span class="kwrd">index</span>(istr) + len(istr)
j = s.<span class="kwrd">index</span>(jstr, i) + len(jstr)
k = s.<span class="kwrd">index</span>(kstr, j)
t = s[:j] + s[k:]

fi = <span class="kwrd">open</span>(filename, "w+")
fi.<span class="kwrd">write</span>(t)
fi.<span class="kwrd">close</span>()</code></pre>

