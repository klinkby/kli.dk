---
author: "@klinkby"
keywords:
- www
- security
date: "2016-04-11T22:00:00Z"
description: ""
draft: false
slug: 4-browser-headers
tags:
- www
- security
title: 'Hardening web apps: 4. Browser cross site attacks'
---

# Hardening web apps: 4. Browser cross site attacks

This fourth post in the</span> [blog series](../1-hardening-web-apps-introduction)<span> goes into detail about safeguarding the browser against malicious users and cross site attacks</span><span>.

## XSS (cross site scripting)

Cross site scripting (XSS) is the threat from a malicious script entered as input by one user, possibly persisted and then rendered in other users' sessions, while the script being able to e.g. leak passwords, tokens and personal information to the hacker's server. This is possible whenever inputted text is not properly HTML-escaped, stripping out HTML-tag characters, before echoing it in the document. 

AngularJS incudes the [$sanitize service](https://docs.angularjs.org/api/ngSanitize/service/$sanitize#!) that automatically parses values from the model before embedding its content in the view. If your application includes scripts from external sources, they can be changed to include malicious scripts by external server operators. Pick your content delivery networks (CDN) with care.

External script resources can be hardened by including the integrity attribute on the script tag that specifies e.g. a cryptographic checksum for that script, which modern browsers validate the downloaded script against before executing it. 

Reflected, non-persistent XSS attacks, where the malicious script is injected via query string or form submission from e.g. an email or bait-clicking from another website can be prevented by enabling a [filter](https://blogs.msdn.microsoft.com/ie/2008/07/02/ie8-security-part-iv-the-xss-filter/) in the browser. Simply set HTTP header <code>X-XSS-Protection: 1; mode=block</code>. 

If you have the opportunity to design your application with security in mind, you should include a [Content Security Policy](https://www.w3.org/TR/CSP2/) (CSP) to disable inline scripting and restrict scripts to be loaded from your trusted domains only. You must tell AngularJS by adding an [ng-csp](https://docs.angularjs.org/api/ng/directive/ngCsp) attribute to the app view, as it affects Angular's use of the <code>eval()</code> function. 

A variant of malicious input, however unrelated to web security, is the SQL injection attack, where bad server side code inserts text input into SQL queries instead of using parameterized commands. 

 Always treat text input as nuclear waste!

## CSRF (cross site resource forgery)

Malicious users can even trick other user's browser to perform requests without the use of scripts. For example, clicking a link or setting an image source as hyperlink to an external website where the HTTP GET have side effects like sending mail or perform privileged actions on behalf of an implicitly authenticated user. 

HTTP GET requests are easier to forge than POST requests. As a rule of thumb GET requests should not mutate state server side, only fetch data. 

 HTTP POSTs can be safeguarded by including an unpredictable token in the request. While ASP.NET included a cryptographic hash in a hidden form field for the server to validate, AngularJS uses [ another approach](http://www.bennadel.com/blog/2568-preventing-cross-site-request-forgery-csrf-xsrf-with-angularjs-and-coldfusion.htm) based on the fact that foreign domains are unable to access the document's cookies. 

 Requests to foreign domains that are initiated from script (using XMLHttpRequest) are usually banned by the browser's cross origin resource sharing (CORS). However, if a foreign misconfigured server respond the <code>Access-Control-Allow-Origin: *</code> header, CORS filtering are disabled, leaving the server wide open.

The CSP header mentioned earlier can also restrict the browser to request resources from trusted domains.

## Other Security Headers

Besides the X-XSS-Protection and Content-Security-Policy headers, you can also set the <code>X-Content-Type-Options: nosniff</code> HTTP header to stop the browser from detecting the MIME type by parsing the file's content, instead relying on the server's headers. 

Clickjacking attacks where a malicious site iframe your site, and trick users to click around in your site can be prevented by setting the <code>X-Frame-Options: DENY</code> HTTP header, effectively preventing framing of your site. 

You should **really** have a look at Scott Helme's [securityheaders.io](https://securityheaders.io), which will help you examine and rate your site's security header settings.

> Read the next post in the blog series about [reactive security and monitoring](../5-reactive-security-and-monitoring/).

