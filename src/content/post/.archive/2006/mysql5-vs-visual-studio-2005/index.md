---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: mysql5-vs-visual-studio-2005
tags:
- dotnet
title: MySQL5 vs Visual Studio 2005
---


Some time ago I build a website with ASP.NET1.1 and MySQL4. It's time for upgrading to ASP.NET 2.0 (for XHTML
compliance) and MySQL5 (for views and stored procedures). I must say after hours of investigation that MySQL5 and Visual
Studio 2005 is not a happy couple, but with a little twisting and caution they can work together. Sadly Microsoft "
forgot" to add a MySQL .NET data provider so the old MyODBC 3.51 connector is the only option (MyODBC5 is still in alpha
state). **TableAdapter Queries** Select queries must be kept really simple, i.e. no subqueries, multiple statements,
functions or calculation. Just plain fields Views are available (in the Tables tab) To use parameters write statements
like 'SELECT fld FROM mytable where fld=?' **Stored Procedures** OUT or INOUT parameters are not supported Set
CommandType to StoredProcedure and write CommandText like 'CALL myproc(?,?)' - ignore the error message (note: the
Parameters property is cleared). Then manually add the procedure parameters to the parameters collection, remember to
set the DbType (and Size for strings). You can return a value from your SPs by setting ExecutionMode=Scalar selecting a
value in the SP. e.g.

> CREATE PROCEDURE `spInsertOrder`(fld INT) BEGIN INSERT INTO `mytable` (`fld`) VALUES (fld); SELECT @@IDENTITY; END

