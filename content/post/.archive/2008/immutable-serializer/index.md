---
author: Mads Klinkby
categories:
- .net
date: "2008-02-05T23:00:00Z"
description: ""
draft: false
slug: immutable-serializer
tags:
- .net
title: Immutable serializer
---


As often as possible, I create immutable classes. Immutable means once an instance is created, all its member variables are read only. I will not go into the many reasons why to do this (start [ here](http://blogs.msdn.com/lucabol/archive/2007/12/03/creating-an-immutable-value-object-in-c-part-i-using-a-class.aspx) and [ here](http://blogs.msdn.com/lucabol/archive/2007/12/03/creating-an-immutable-value-object-in-c-part-i-using-a-class.aspx)). I just like to say it should be applied to any struct and very often to data entity classes, i.e. objects that you often would like to serialize. So more than once, I've found myself banging my head against the wall, because the XmlSerializer in the .NET Framework does not allow serialization nor deserialization of immutable objects: A parameterless constructor and getter/setter for each property is required. This means you either have to make your data entities mutable (very bad design) or you can use the Soap serializer that can take any [Serializable] object (very bad XML).

To save myself from any more headache, I've created two simple classes to perform serialization/deserialization of shallow immutable types. The deserializer is made as an extension to the one in the Framework, whereas the serializer is completely custom.

Here is a C# example of it in action:

<pre class="csharpcode"><code>XmlTextWriter wr = new XmlTextWriter(@"c:\test.xml", Encoding.UTF8);  
 ImmutableSerializer.Serialize<MyClass>(wr, deserializedObject);  
 wr.Close();  

 [XmlType("MyClass")]  
 public class MyClassDeserializer : ImmutableDeserializer<MyClass>  
 { }  

 XmlSerializer ser = new XmlSerializer(typeof(MyClassDeserializer));  
 MyClass deserializedObject = (MyClassDeserializer)  
    ser.Deserialize(  
       new XmlTextReader(@"c:\test.xml"),  
       MyClassDeserializer.GetEvents());</code></pre>

Start doing better design: [[Download](http://kli.dk/blog/Klinkby.ImmutableSerialization.zip)] the classes.

