---
author: Mads Klinkby
categories:
- data
date: "2011-11-09T23:00:00Z"
description: ""
draft: false
slug: shrink-all-sql-server-logfiles
tags:
- data
title: Shrink all SQL Server logfiles
---


After backing up the log files on a SQL server, the logs are truncated and you might want to reclaim the disk space held by those empty log files. This little Transact-SQL script will do just that.  

```SQL
DBCC SQLPERF(logspace)
GO
DECLARE @logsize AS INT = 256; -- MB
DECLARE @databasename AS VARCHAR(256);
DECLARE @filename VARCHAR(256);
DECLARE @cmd VARCHAR(MAX);
DECLARE curdb CURSOR FOR 
    SELECT f.name AS filename, d.name AS databasename
    FROM msdb.sys.master_files f
        INNER JOIN master.sys.sysdatabases d
        ON d.dbid = f.database_id
    WHERE type = 1 AND state = 0 AND size > @logsize AND database_id > 4    
OPEN curdb
FETCH NEXT FROM curdb INTO @filename, @databasename
WHILE @@FETCH_STATUS = 0
BEGIN
    --PRINT @filename
    SET @cmd = ('USE [' + @databasename + ']; ')
    SET @cmd = @cmd + 'DBCC SHRINKFILE ([' + @filename + '], ' + CAST(@logsize AS VARCHAR) + ');';
    EXEC (@cmd)
    FETCH NEXT FROM curdb INTO @filename, @databasename
END
DEALLOCATE curdb
GO
DBCC SQLPERF(logspace)
GO
```