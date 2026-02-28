---
author: "@klinkby"
keywords:
- dotnet
- sharepoint
date: "2011-05-23T22:00:00Z"
description: ""
draft: false
slug: property-promotion
tags:
- dotnet
- dotnet
- sharepoint
title: Document Property Promotion in SharePoint
---


While building a service for SP2010 that uploads a document and adds metadata, I ran into some trouble with
the [document property promotion](http://msdn.microsoft.com/en-us/library/aa543341.aspx)service in SharePoint.

In short its job is to keep properties in the files in sync with the list item field values. When you upload
an [Office OpenXML](http://en.wikipedia.org/wiki/Office_Open_XML)document or an image, SharePoint reads the properties
in the file and updates the matching columns in the list item. If you then edit the list item properties in your
browser, Sharepoint then updates the file with the modified properties to keep them in sync.

A very nice feature, albeit should you want to upload a document and update the properties yourself. Because the
document parser runs asynchronously you will have a race condition. Will you or the document parser get to update the
properties last? You can disable document parsers by [removing](http://msdn.microsoft.com/en-us/library/aa544149.aspx)
them from
the [ SPWebService](http://msdn.microsoft.com/en-us/library/microsoft.sharepoint.administration.spwebservice.aspx)if you
are a farm admin. Or you can disable all parsing for
a [ single web](http://msdn.microsoft.com/en-us/library/microsoft.sharepoint.spweb.parserenabled.aspx)if you are a site
owner. So can I just set ParserEnabled=false call web.Update (in an elevated operation), then let the user upload the
document and then set ParserEnabled back to
true? [ Wrong](http://platinumdogs.wordpress.com/2010/03/29/sharepoint-updating-office-based-document-library-items-automatic-document-property-promotion/)!
The parser runs delayed from the upload operation. So even when ParserEnabled is false when uploading the document, and
you set ParserEnabled true immediately after - the upload will still trigger the parser.

The sad conclusion is that if you have to manage document properties programatically at any point, you must leave the
web's property promotion disabled from then on.

