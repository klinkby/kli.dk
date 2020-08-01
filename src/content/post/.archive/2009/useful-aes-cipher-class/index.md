---
author: Mads Klinkby
categories:
- .net
date: "2009-06-25T22:00:00Z"
description: ""
draft: false
slug: useful-aes-cipher-class
tags:
- .net
title: Useful AES cipher class
---


Transforms any text to/from URL friendly encrypted text.

<pre class="csharpcode"><code><span class="rem">/// &lt;summary&gt;</span>
<span class="rem">/// Encrypts and decrypts string using the AES algorithm.</span>
<span class="rem">/// &lt;example&gt;&lt;c&gt;&lt;![CDATA[</span>
<span class="rem">///   Cipher _cipher = new Cipher("veryhardtoguess");</span>
<span class="rem">///   var text = "protectme";</span>
<span class="rem">///   Console.WriteLine("Original: " + text);</span>
<span class="rem">///   var encrypted = _cipher.Encrypt(text);</span>
<span class="rem">///   Console.WriteLine("Encrypted: " + encrypted);</span>
<span class="rem">///   var decrypted = _cipher.Decrypt(encrypted);</span>
<span class="rem">///   Console.WriteLine("Decrypted: " + decrypted);</span>
<span class="rem">/// ]]&gt;&lt;/c&gt;&lt;/example&gt;</span>
<span class="rem">/// &lt;/summary&gt;</span>
<span class="kwrd">class</span> Cipher
{
    <span class="kwrd">readonly</span> ICryptoTransform _encryptor;
    <span class="kwrd">readonly</span> ICryptoTransform _decryptor;

    <span class="kwrd">public</span> Cipher(<span class="kwrd">string</span> password)
    {
        var sp = CreateSP(password);
        _encryptor = sp.CreateEncryptor();
        _decryptor = sp.CreateDecryptor();
    }

    <span class="kwrd">private</span> <span class="kwrd">static</span> AesCryptoServiceProvider CreateSP(<span class="kwrd">string</span> password)
    {
        var sp = <span class="kwrd">new</span> AesCryptoServiceProvider()
        {
            Key = CreateKey(password),
            Mode = CipherMode.ECB,
            Padding = PaddingMode.ISO10126,
        };
        <span class="kwrd">return</span> sp;
    }

    <span class="kwrd">private</span> <span class="kwrd">static</span> <span class="kwrd">byte</span>[] CreateKey(<span class="kwrd">string</span> password)
    { 
        var key = Encoding.Unicode.GetBytes(password);
        Array.Resize(<span class="kwrd">ref</span> key, 256 / 8);
        <span class="kwrd">return</span> key;
    }

    <span class="kwrd">public</span> <span class="kwrd">string</span> Encrypt(<span class="kwrd">string</span> text)
    {
        var buf = Encoding.Unicode.GetBytes(text);
        var encrypted = _encryptor.TransformFinalBlock(buf, 0, buf.Length);
        <span class="kwrd">return</span> Encode(encrypted);
    }

    <span class="kwrd">public</span> <span class="kwrd">string</span> Decrypt(<span class="kwrd">string</span> encryptedText)
    {
        var encryptedBuf = Decode(encryptedText);
        var buf = _decryptor.TransformFinalBlock(encryptedBuf, 0, encryptedBuf.Length);
        <span class="kwrd">return</span> Encoding.Unicode.GetString(buf);
    }        

    <span class="kwrd">static</span> <span class="kwrd">string</span> Encode(<span class="kwrd">byte</span>[] payload)
    {
        <span class="kwrd">string</span> base64 = Convert.ToBase64String(payload);
        <span class="kwrd">string</span> base64Url = <span class="kwrd">new</span> <span class="kwrd">string</span>(
            base64.ToCharArray().TakeWhile((ch) =&gt; ch != <span class="str">'='</span>).Select((ch) =&gt; ch == <span class="str">'+'</span> ? <span class="str">'-'</span> : ch == <span class="str">'/'</span> ? <span class="str">'_'</span> : ch).ToArray()
            );
        <span class="kwrd">return</span> base64Url;
    }

    <span class="kwrd">static</span> <span class="kwrd">byte</span>[] Decode(<span class="kwrd">string</span> base64Url)
    {
        <span class="kwrd">string</span> base64 = <span class="kwrd">new</span> <span class="kwrd">string</span>(base64Url.ToCharArray().Select((ch) =&gt; ch == <span class="str">'-'</span> ? <span class="str">'+'</span> : ch == <span class="str">'_'</span> ? <span class="str">'/'</span> : ch).ToArray())
            + ((base64Url.Length % 4) != 0 ? <span class="kwrd">new</span> <span class="kwrd">string</span>(<span class="str">'='</span>, 4 - (base64Url.Length % 4)) : <span class="kwrd">string</span>.Empty);
        <span class="kwrd">return</span> Convert.FromBase64String(base64);
    }
}</code></pre>

