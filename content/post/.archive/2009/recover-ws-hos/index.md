---
author: Mads Klinkby
categories:
- .net
- sharepoint
date: "2009-01-10T23:00:00Z"
description: ""
draft: false
slug: recover-ws-hos
tags:
- .net
- sharepoint
title: Recover from SharePoint HOS bug
---


Some SP* API objects like SPApplication have a hierarchial object store for persisting objects, which is great for e.g. timerjobs . The propertybag can serialize strings, value types and specific SharePoint objects for persistence. But the indexer's setter has a bug that accepts ANY .net object without any error. The next time you access the property bag an InvalidOperationException is thrown:   

The platform does not know how to deserialize an object of type [yourclasstype]. The platform can deserialize primitive types such as strings, integers, and GUIDs; other SPPersistedObjects or SPAutoserializingObjects; or collections of any of the above. Consider redesigning your objects to store values in one of these supported formats, or contact your software vendor for support.   at Microsoft.SharePoint.Administration.SPAutoSerializingObject.DeserializeBasicObject(XmlElement xmlValue)
  Unfortunatelty the exception is also thrown even if you call Clear() to empty the entire property bag. A single method call is all that is required to corrupt a SharePoint farm. Duh! Sure you can restore a backup on a production system. But if that's not an option, you can bring out your "SQL surgeon's toolbox", backup the configuration database and execute the query:   

select * from objects where properties like '%[yourclasstype]%'
  The properties field in the result is serialized xml you can edit to remove the invalid property to get your SharePoint ba:   

<fld type="System.Collections.Hashtable, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" name="m_Properties" />

