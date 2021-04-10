---
author: "@klinkby"
keywords:
- www
- security
date: "2016-03-19T23:00:00Z"
description: ""
draft: false
slug: 2-architecture-infrastructure
tags:
- www
- security
title: 'Hardening web apps: 2. Architecture+infrastructure'
---

# Hardening web apps: 2. Architecture+infrastructure

This second post in the [ blog series](../1-hardening-web-apps-introduction) goes into detail about the infrastructure your app is running on, designing a secure physical architecture and securing your site against DNS attacks.

## Infrastructure

The infrastructure your app runs on is of course vital in securing your app. Unpatched servers or firewalls leaves it exposed to remote code execution attacks that means a hacker can take over your servers. When hosting your app in Azure you should configure your cloud service to run on the latest OS (currently Windows Server 2012 R2) and must choose [ Automatic](https://azure.microsoft.com/da-dk/documentation/articles/cloud-services-guestos-update-matrix/) operating system version that basically means Microsoft will install security patches on your servers as soon as they are released. 

Azure also handles the network perimeter defense for you. The datacenters gigabit internet connections and are actively being monitored for incoming distributed denial of service (DDoS) attacks and have a built-in [ defense system](https://azure.microsoft.com/en-us/blog/microsoft-azure-network-security-whitepaper-version-3-is-now-available/) against such attacks. Configure the public facing network load balancing firewalls to have only port 443 open (do not enable RDP), and enable the automatic scaling feature to spin up more web servers in case your app gets hammered. 

Oh, and your Azure bill also covers physical security, including the [ armed guards](http://up2v.nl/2012/11/11/a-look-into-windows-azure-datacenter/) at the data centers.

## Architectural Security

Of course the you should try not to store any secrets on a web serve you put on the internet. In case it gets compromised it cannot reveal anything. But in practice you have to put your private SSL certificate on it to provide transport security (more on certificates in the following next blog post). 

The "modern web application" this blog series is hardening exposes a set of REST services implemented with Web API. So naturally there are more secrets involved, like passwords for backend databases or intellectual property such as business logic components. Microsoft recommends implementing the [gatekeeper architectural pattern](https://msdn.microsoft.com/en-us/library/dn589793.aspx) to protects those. 

An effective way to set it up in Azure is to run a cloud service startup script on the front end IIS servers that installs the Application Request Routing module to reverse proxy Web API requests to a custom internal NLB endpoint. <span>A strict single page app will consist of only static files and a REST API, so you can even disable .NET code in the app pool to further reduce the attack surface to prevent, and add a firewall rule that prevents the front end servers from communicating directly to the back end servers. Besides separating the servers, the custom internal NLB also enables scale out of the backend servers, that will be running your custom Web API service and business logic with all its secrets. </span>

<span>Many HTTP requests are for static resources, which are served with no overhead by the front end servers (that also provide SSL termination). However, there is a small overhead for proxying the API requests to the backend.</span>

## DNS Security

In Azure you must use PowerShell to register a [ static IP address](https://blogs.technet.microsoft.com/heyscriptingguy/2012/02/28/use-powershell-to-configure-static-ip-and-dns-settings/) and configure your cloud service's public NLB to use that to prevent a new deployment from changing the IP. Naturally, your users will look up that IP address from your domain name because you registered an A-record with your name server hosting provider. 

An exploit known as [ DNS cache poisoning](http://www.networkworld.com/article/2277316/tech-primers/how-dns-cache-poisoning-works.html) will allow an attacker to divert traffic meant for your server over to a server on another IP address that he controls. If your name server host supports [DNSSEC](https://en.wikipedia.org/wiki/Dnssec), it basically allows you to enable PKI for your domain. You register a secret from the TLD-registrar with your name server host, which means it will become the only authority for DNS records for that domain. <span>Note that Azure DNS does not support DNSSEC. </span>

Verisign provides an online [DNSSEC debugger](http://dnssec-debugger.verisignlabs.com/) that verifies the DNSSEC configuration for your domain.

>Read the next post in the blog series about [transport security and authentication](../3-authentication/).

