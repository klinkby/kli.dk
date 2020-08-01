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

<pre class="csharpcode"><code><span class="kwrd">DBCC</span> SQLPERF(logspace)
<span class="kwrd">GO</span>
<span class="kwrd">DECLARE</span> @logsize <span class="kwrd">AS</span> <span class="kwrd">INT</span> = 256; <span class="rem">-- MB</span>
<span class="kwrd">DECLARE</span> @databasename <span class="kwrd">AS</span> <span class="kwrd">VARCHAR</span>(256);
<span class="kwrd">DECLARE</span> @filename <span class="kwrd">VARCHAR</span>(256);
<span class="kwrd">DECLARE</span> @cmd <span class="kwrd">VARCHAR</span>(<span class="kwrd">MAX</span>);
<span class="kwrd">DECLARE</span> curdb <span class="kwrd">CURSOR</span> <span class="kwrd">FOR</span> 
    <span class="kwrd">SELECT</span> f.name <span class="kwrd">AS</span> filename, d.name <span class="kwrd">AS</span> databasename
    <span class="kwrd">FROM</span> msdb.sys.master_files f
        <span class="kwrd">INNER</span> <span class="kwrd">JOIN</span> master.sys.sysdatabases d
        <span class="kwrd">ON</span> d.dbid = f.database_id
    <span class="kwrd">WHERE</span> type = 1 <span class="kwrd">AND</span> <span class="kwrd">state</span> = 0 <span class="kwrd">AND</span> <span class="kwrd">size</span> &gt; @logsize <span class="kwrd">AND</span> database_id &gt; 4    
<span class="kwrd">OPEN</span> curdb
<span class="kwrd">FETCH</span> <span class="kwrd">NEXT</span> <span class="kwrd">FROM</span> curdb <span class="kwrd">INTO</span> @filename, @databasename
<span class="kwrd">WHILE</span> <span class="preproc">@@FETCH_STATUS</span> = 0
<span class="kwrd">BEGIN</span>
    --<span class="kwrd">PRINT</span> @filename
    <span class="kwrd">SET</span> @cmd = (<span class="str">'USE ['</span> + @databasename + <span class="str">']; '</span>)
    <span class="kwrd">SET</span> @cmd = @cmd + <span class="str">'DBCC SHRINKFILE (['</span> + @filename + <span class="str">'], '</span> + <span class="kwrd">CAST</span>(@logsize <span class="kwrd">AS</span> <span class="kwrd">VARCHAR</span>) + <span class="str">');'</span>;
    <span class="kwrd">EXEC</span> (@cmd)
    <span class="kwrd">FETCH</span> <span class="kwrd">NEXT</span> <span class="kwrd">FROM</span> curdb <span class="kwrd">INTO</span> @filename, @databasename
<span class="kwrd">END</span>
<span class="kwrd">DEALLOCATE</span> curdb
<span class="kwrd">GO</span>
<span class="kwrd">DBCC</span> SQLPERF(logspace)
<span class="kwrd">GO</span></code></pre>

