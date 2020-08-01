---
author: Mads Klinkby
categories:
- azure
- hardening
- security
date: "2016-05-02T17:27:30Z"
description: ""
draft: false
slug: operations-practices-and-conclusion
tags:
- azure
- hardening
- security
title: 'Hardening web apps: 6. Operations practices and conclusion'
---


The previous posts in this [blog series](/1-hardening-web-apps-introduction/) mostly dealt with systemic weaknesses and misconfiguration. Last but not least, this post focus on the system administration practices. This is the part that involves humans, which may be the soft spot in your app’s perimeter. 

## Passwords as evil
A recent [survey](http://fortune.com/2016/03/30/passwords-sell-poor-sailpoint/) revealed that 65 % of respondents use a single same password among applications. That means a breach in any of the crazy applications those users may use on or off work will affect your application. The same survey shows that 27 % of the US (and 20 % of the German) respondents would actually be willing to sell the password to their work email. Just about half of those would even sell it for less than $1,000.  It would probably take a very disgruntled sysadm to do that, but I guess at least it shows morality has a price tag.

There is an incredible number of [leaked passwords](https://wiki.skullsecurity.org/Passwords) available for download. And generally people are not as creative and brilliant when it comes to filling out the New Password prompt as they might think. It is not easy to follow [these common guidelines](https://en.wikipedia.org/wiki/Password_strength#Common_guidelines) without password management software, simply because evolution did not prepare humans to go around remembering a list of random 14 character upper/lowercase + numbers and symbols. 

## Secret keys
In Azure secret keys is another word for passwords. They are used throughout the services to grant access to services from the app. It is good practice to avoid storing secrets in code or configuration, and not share keys to the production data with developers. Microsoft recommends putting your secret keys in Azure [Key Vault](https://azure.microsoft.com/en-us/services/key-vault/), which is a managed hardware security module (HSM) that even Microsoft cannot access the contents of. It is worth noting that the Azure data centers and services are [compliant](https://www.microsoft.com/en-us/TrustCenter/CloudServices/Azure) with a long list of security standards that includes auditing, so it is not just their word for it. 

You may have noticed that e.g. Azure Storage generate two secret keys the service can be accessed with. This is to enable automatic key rotation so you schedule a job to automatically regenerate one of the keys. At that point the app gets an authentication error, retries with the other key and immediately retries the request with success. In the background the app then loads the updated key from the vault so it is ready for the next rotation. 

## Circle of trust
Trust is of course needed when enforced security is not practically possible. Cut the number of people that have access to production data or running services to an absolute minimum and exclusively trusted employees from the operations team.
Enable administrative audit logging and agree on an auditing practice to monitor how administrators use their privileges. This is important to be able to spot irregular behavior e.g. when a hacker has gained access to a privileged account.

## Assume breach
This post’s final words may be tough for accept: Assume you already have a breach and design our application, persistent data and security practices with that defensive aspect. 
This, for instance is the reason never to store plain text passwords, and the reason to automatically rotate secret keys. And so on.

Consider regularly hiring a team of penetration testers to find the holes in your app, practices or organization before others do it.

## The end

I really hope you enjoyed reading this [blog series](/1-hardening-web-apps-introduction/) and would love to [hear your thoughts and comments](https://twitter.com/klinkby).
 
Thank you!

