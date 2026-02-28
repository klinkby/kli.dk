---
author: "@klinkby"
keywords:
- dotnet
- www
date: "2008-12-30T23:00:00Z"
description: ""
draft: false
slug: site-refresh
tags:
- dotnet
- www
title: Site refresh
---


With the new [Wordpress](http://www.wordpress.com/) interface, it really manifests itself as the best blog service. The
CMS functionality and quickpress makes it a breeze to publish new posts and pages. The
semantic-style [Sandbox theme](http://www.plaintxt.org/themes/sandbox/) in Wordpress separates content and style
completely, which is cool because Wordpress has a paid service that lets you add css styles to your blog thus enables
you to create completely custom looking sites. See [http://sndbx.org/](http://sndbx.org/) for a recent design
competition. Also if you have your own domain, the Wordpress application is available
from [Wordpress.net](http://wordpress.org/). Well I have no intention of the hassle with setting up Apache/php and
installing Wordpress.net, so I built an HttpHandler to proxy the contents from
my [Wordpress blog](http://klinkby.wordpress.com/) to [my web site](http://kli.dk/), and modify the contents a bit on
the way. The code is available from [http://www.codeplex.com/mirrorrim/](http://www.codeplex.com/mirrorrim/)

