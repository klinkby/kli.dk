---
author: "@klinkby"
keywords:
- security
- docker
- devops
date: "2017-01-20T19:35:00Z"
description: ""
draft: false
image: /images/2017/09/chromesecurity_primary-100029482-large.jpg
slug: encryption-by-default
tags:
- security
- docker
- devops
title: Encryption by default
---
![image](/images/2017/09/chromesecurity_primary-100029482-large.jpg)
# Encryption by default

*Google is on the brink of releasing the next version of Chrome that marks the first of a number of changes to the security UX in the browser.*

Version 56 will start clearly marking HTTP (unencrypted) sites that contain password or credit card fields as [Not Secure](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html). Eventually all unencrypted sites will get that, whether or not they contain those types of fields. [Arguably](https://queue.acm.org/detail.cfm?id=2904894) this may seem a bit silly for instance for a site like this blog, but I think it is one of the steps towards raising the general level of security on the web. 

The [LetsEncrypt](https://letsencrypt.org) initiative releaves you from the pain of manual certificate renewal and generally dealing with obnoxious certificate resellers. 

To implement encryption on the blog, first I created a new "A0 standard" sized VM instance (which is around €12/mo) on Azure with Intel's optimized Clear Linux (container edition), and pulled the following from Docker hub:  

- [nginx:alpine](https://hub.docker.com/_/nginx/) - very efficient web server + reverse proxy that supports http/2
- [jwilder/docker-gen](https://hub.docker.com/r/jwilder/docker-gen/) - generate dynamic proxy config files for nginx
- [jrcs/letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion/) - handles certificate generation, renewal for nginx running as a proxy
- [zzrot:alpine-ghost](https://hub.docker.com/r/zzrot/alpine-ghost/) - ghost blog engine with a few configuration improvements
 
Where *alpine* refers to an incredibly lightweight Linux image, which helps keepin the container overhead to a minimum.

You can check out the complete deployment script on https://gist.github.com/klinkby/3c0b944892376dec67e98278d4a3b4de

I also made a few changes to the nginx.tmpl configuration file, but as you see, it was really easy to get up and running.

The Qualsys SSL Labs [test result](https://www.ssllabs.com/ssltest/analyze.html?d=www.kli.dk) says HTTPS implementation is a perfect A+. And despite the tiny Linux box, Pingdom Tools [rate](https://tools.pingdom.com/#!/cGWrzr/https://www.kli.dk) the site's performance to A (91).

