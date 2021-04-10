---
author: "@klinkby"
keywords:
- data
date: "2009-06-10T22:00:00Z"
description: ""
draft: false
slug: serializing-table-data-for-soap-posts-in-t-sql
tags:
- data
title: Serializing table data for SOAP posts in T-SQL
---


In an integration setup where a SQL Server trigger uses a CLR method with a generic WS client to publish changes to table data, you need to transform the 'inserted' table data to a serialized XML. In this example the CLR method simply wraps the xml content in the common SOAP envelope, and uses HttpWebRequest to post it to the specified  SOAP action and endpoint URL. 

<pre class="csharpcode"><code><span class="kwrd">CREATE</span> <span class="kwrd">TRIGGER</span> oncustomermodified
 <span class="kwrd">   ON</span> dbo.[CRONUS Danmark A_S$Customer]
 <span class="kwrd">   AFTER</span> <span class="kwrd">UPDATE</span> <span class="kwrd">AS</span> 
<span class="kwrd">BEGIN</span>
    <span class="kwrd">DECLARE</span> @url NVARCHAR(255) = N<span class="str">'http://testsrv/publish.svc'</span>;
    <span class="kwrd">DECLARE</span> @soapAction NVARCHAR(255);
    <span class="kwrd">DECLARE</span> @<span class="kwrd">data</span> XML;
    <span class="kwrd">SET</span> @soapAction = N<span class="str">'urn:test:ws/ITestEndPoint/OnCustomerUpdated'</span>;
    <span class="kwrd">WITH</span> xmlnamespaces (
        <span class="kwrd">DEFAULT</span> <span class="str">'urn:test:ws'</span>, 
        <span class="str">'http://schemas.datacontract.org/2004/07/System'</span> <span class="kwrd">as</span> dc)
    <span class="kwrd">SELECT</span> @<span class="kwrd">data</span> = (
        <span class="kwrd">SELECT</span> <span class="kwrd">TOP</span> 1 
            <span class="str">''</span> <span class="kwrd">as</span> <span class="str">'dc:__identity'</span>, 
            [No_] <span class="kwrd">AS</span> <span class="str">'ContactId'</span>, 
            [Name] <span class="kwrd">AS</span> <span class="str">'FirstName'</span> 
            <span class="kwrd">FROM</span> inserted 
            <span class="kwrd">FOR</span> xml <span class="kwrd">path</span>(<span class="str">'entity'</span>), root(<span class="str">'OnCustomerUpdated'</span>) 
            );    
    <span class="kwrd">EXEC</span> dbo.PublishToWS @url, @soapAction, @<span class="kwrd">data</span>;
<span class="kwrd">END</span>
GO</code></pre>

Note the __identity element is required for the WS endpoint to deserialize the record.

