---
author: "@klinkby"
keywords:
- dotnet
- data
- performance
date: "2010-11-24T23:00:00Z"
description: ""
draft: false
slug: fast-datatable-load
tags:
- dotnet
- data
- performance
title: Fast (dynamic) DataTable load
---


When you stuff data in a DataTable you need to first build the columns with, then add the rows containing all of the
field values. To map properties from strongly typed objects to DataTables involves either tedious error prone mapping
code or a more versatile and CPU hungry way using Reflection.

The small code snippet below is a combination of these, using reflection just once then a fast mapping code from then on
based
on [ Gerhard Stephan's code emitting method](http://jachman.wordpress.com/2006/08/22/2000-faster-using-dynamic-method-calls/).
It is used with a DataTable like this: <code>dt.Columns.AddRange(TableMapper<MyDTO>.Columns); : dt.LoadDataRow(
TableMapper<MyDTO>.GetPropertyValues(item), true);</code>
Now for the actual code. Have fun!

<pre class="csharpcode"><code><span class="kwrd">static</span> <span class="kwrd">class</span> TableMapper&lt;T&gt;
{
    <span class="kwrd">readonly</span> <span class="kwrd">static</span> Func&lt;<span class="kwrd">object</span>, <span class="kwrd">object</span>&gt;[] m_getters = CreateGetters();
    <span class="kwrd">readonly</span> <span class="kwrd">static</span> DataColumn[] m_columns = CreateColumns();

    <span class="kwrd">public</span> <span class="kwrd">static</span> DataColumn[] Columns
    {
        get { <span class="kwrd">return</span> m_columns; }
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">object</span>[] GetPropertyValues(T obj)
    {
        <span class="kwrd">if</span> (obj == <span class="kwrd">null</span>)
            <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentNullException(<span class="str">"obj"</span>);
        var values = m_getters.Select(getter =&gt; getter(obj))
                              .ToArray();
        <span class="kwrd">return</span> values;
    }

    <span class="kwrd">static</span> Func&lt;<span class="kwrd">object</span>, <span class="kwrd">object</span>&gt;[] CreateGetters()
    {
        var getters = <span class="kwrd">typeof</span>(T).GetProperties()
                               .Select(CreateGetMethod)
                               .ToArray();
        <span class="kwrd">return</span> getters;
    }

    <span class="kwrd">static</span> Func&lt;<span class="kwrd">object</span>, <span class="kwrd">object</span>&gt; CreateGetMethod(PropertyInfo propertyInfo)
    {
        MethodInfo getMethod = propertyInfo.GetGetMethod();
        <span class="kwrd">if</span> (getMethod == <span class="kwrd">null</span>)
            <span class="kwrd">return</span> <span class="kwrd">null</span>;
        var arguments = <span class="kwrd">new</span> System.Type[1];
        arguments[0] = <span class="kwrd">typeof</span>(<span class="kwrd">object</span>);
        DynamicMethod getter = <span class="kwrd">new</span> DynamicMethod(
            String.Concat(<span class="str">"_Get"</span>, propertyInfo.Name, <span class="str">"_"</span>),
            <span class="kwrd">typeof</span>(<span class="kwrd">object</span>), arguments, propertyInfo.DeclaringType);
        ILGenerator generator = getter.GetILGenerator();
        generator.DeclareLocal(<span class="kwrd">typeof</span>(<span class="kwrd">object</span>));
        generator.Emit(OpCodes.Ldarg_0);
        generator.Emit(OpCodes.Castclass, propertyInfo.DeclaringType);
        generator.EmitCall(OpCodes.Callvirt, getMethod, <span class="kwrd">null</span>);
        <span class="kwrd">if</span> (!propertyInfo.PropertyType.IsClass)
            generator.Emit(OpCodes.Box, propertyInfo.PropertyType);
        generator.Emit(OpCodes.Ret);
        <span class="kwrd">return</span> (Func&lt;<span class="kwrd">object</span>, <span class="kwrd">object</span>&gt;)
            getter.CreateDelegate(<span class="kwrd">typeof</span>(Func&lt;<span class="kwrd">object</span>, <span class="kwrd">object</span>&gt;));
    }

    <span class="kwrd">static</span> DataColumn[] CreateColumns()
    {
        var columns = <span class="kwrd">typeof</span>(T)
            .GetProperties()
            .Select(p =&gt; <span class="kwrd">new</span> DataColumn(p.Name, p.PropertyType))
            .ToArray();
        <span class="kwrd">return</span> columns;
    }
}</code></pre>

