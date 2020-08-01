---
author: Mads Klinkby
categories:
- .net
- asp.net
- code
- dotnet
- programming
- web
date: "2011-02-02T23:00:00Z"
description: ""
draft: false
slug: howto-simple-facebook-login-in-asp-net
tags:
- .net
- asp.net
- code
- dotnet
- programming
- web
title: 'How to: Simple Facebook login in ASP.NET'
---


I've been looking all over the net for a simple and efficient way to use [Facebook](http://developers.facebook.com/docs/authentication) to handle authentication of users on my ASP.NET web site. I've looked at the [DotNetOpenAuth](http://www.dotnetopenauth.net/) project that has implemented an feature rich implementation of [OpenID](http://openid.net/developers/) and [OAuth](http://oauth.net/documentation/), and sample code for Twitter. I didn't find an easy way to bend it for Facebook, and it looked a bit complex, so I wrote my own little implementation.

To try it out register an application with Facebook, it's important that the site authority you provide matches the server you run the code from, so for a dev machine you might need an entry in your hosts file. Then create an ASP.NET project and drop these lines in an aspx page:

<pre class="csharpcode"><code><span class="kwrd">&lt;</span><span class="html">asp:HyperLink</span> <span class="attr">runat</span><span class="kwrd">="server"</span> <span class="attr">Text</span><span class="kwrd">="Log in with Facebook"</span> <span class="attr">id</span><span class="kwrd">="fbLogin"</span><span class="kwrd">/&gt;</span>
<span class="kwrd">&lt;</span><span class="html">asp:LoginName</span> <span class="attr">runat</span><span class="kwrd">="server"</span> <span class="kwrd">/&gt;</span></code></pre>

The idea is to send the user to a Facebook dialog for authentication and authorization. Facebook sends the user back again with an authorization code. This code is then exchanged for a graph token, that can be used to query for the user's details. See the FacebookUser class at the bottom.

Merge the following code in the code behind, and replace the app key with the ones from your app registration.

<pre class="csharpcode"><code><span class="kwrd">using</span> System;
<span class="kwrd">using</span> System.Globalization;
<span class="kwrd">using</span> System.IO;
<span class="kwrd">using</span> System.Net;
<span class="kwrd">using</span> System.Runtime.Serialization.Json;
<span class="kwrd">using</span> System.Web.Security;
<span class="kwrd">using</span> System.Web.UI.WebControls;

<span class="kwrd">public</span> <span class="kwrd">partial</span> <span class="kwrd">class</span> _Default : System.Web.UI.Page
{
    <span class="kwrd">readonly</span> <span class="kwrd">static</span> <span class="kwrd">string</span> App_ID = <span class="str">"PLACE YOUR APP ID HERE"</span>;
    <span class="kwrd">readonly</span> <span class="kwrd">static</span> <span class="kwrd">string</span> App_Secret = <span class="str">"PLACE YOUR APP SECRET HERE"</span>;
    <span class="kwrd">readonly</span> <span class="kwrd">static</span> <span class="kwrd">string</span> scope = <span class="str">"email"</span>;

    <span class="kwrd">readonly</span> <span class="kwrd">static</span> DataContractJsonSerializer userSerializer
        = <span class="kwrd">new</span> DataContractJsonSerializer(<span class="kwrd">typeof</span>(FacebookUser));

    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> OnLoad(EventArgs e)
    {
        <span class="kwrd">base</span>.OnLoad(e);
        <span class="kwrd">if</span> (!IsPostBack)
        {
            <span class="kwrd">string</span> code = Request.QueryString[<span class="str">"code"</span>];
            <span class="kwrd">string</span> error_description = Request.QueryString[<span class="str">"error_description"</span>];
            <span class="kwrd">string</span> originalReturnUrl = Request.QueryString[<span class="str">"ReturnUrl"</span>]; <span class="rem">// asp.net logon param</span>
            Uri backHereUri = Request.Url; <span class="rem">// modify for dev server</span>
            <span class="kwrd">if</span> (!<span class="kwrd">string</span>.IsNullOrEmpty(code)) <span class="rem">// user is authenticated</span>
            {
                FacebookUser me = GetUserDetails(code, backHereUri);
                FormsAuthentication.SetAuthCookie(me.email, <span class="kwrd">false</span>); <span class="rem">// authorize!</span>
                <span class="kwrd">if</span> (!<span class="kwrd">string</span>.IsNullOrEmpty(originalReturnUrl))
                    Response.Redirect(originalReturnUrl);
            }
            <span class="kwrd">if</span> (!<span class="kwrd">string</span>.IsNullOrEmpty(error_description)) <span class="rem">// user propably disallowed</span>
            {
                OnError(error_description);
            }
            fbLogin.Visible = !User.Identity.IsAuthenticated;
            fbLogin.NavigateUrl = <span class="kwrd">string</span>.Format(
                CultureInfo.InvariantCulture,
                <span class="str">"https://www.facebook.com/dialog/oauth?"</span>
                + <span class="str">"client_id={0}&amp;scope={1}&amp;redirect_uri={2}"</span>,
                App_ID,
                scope,
                Uri.EscapeDataString(backHereUri.OriginalString));
        }
    }

    FacebookUser GetUserDetails(<span class="kwrd">string</span> code, Uri backHereUri)
    {
        Uri getTokenUri = <span class="kwrd">new</span> Uri(
            <span class="kwrd">string</span>.Format(
            CultureInfo.InvariantCulture,
            <span class="str">"https://graph.facebook.com/oauth/access_token?"</span>
            + <span class="str">"client_id={0}&amp;client_secret={1}&amp;code={2}&amp;redirect_uri={3}"</span>,
            App_ID,
            App_Secret,
            Uri.EscapeDataString(code),
            Uri.EscapeDataString(backHereUri.OriginalString))
            );
        <span class="kwrd">using</span> (var wc = <span class="kwrd">new</span> WebClient())
        {
            <span class="kwrd">string</span> token = wc.DownloadString(getTokenUri);
            Uri getMeUri = <span class="kwrd">new</span> Uri(
                <span class="kwrd">string</span>.Format(
                CultureInfo.InvariantCulture,
                <span class="str">"https://graph.facebook.com/me?{0}"</span>,
                token)
                );
            <span class="kwrd">using</span> (var ms = <span class="kwrd">new</span> MemoryStream(wc.DownloadData(getMeUri)))
            {
                var me = (FacebookUser)userSerializer.ReadObject(ms);
                <span class="kwrd">return</span> me;
            }
        }
    }

    <span class="kwrd">void</span> OnError(<span class="kwrd">string</span> error_description)
    {
        Controls.Add(<span class="kwrd">new</span> Label() { 
            CssClass = <span class="str">"oauth-error"</span>, 
            Text = error_description 
        });
    }

    [Serializable]
    <span class="kwrd">class</span> FacebookUser
    { 
        <span class="kwrd">public</span> <span class="kwrd">long</span> id;
        <span class="kwrd">public</span> <span class="kwrd">string</span> name;
        <span class="kwrd">public</span> <span class="kwrd">string</span> first_name;
        <span class="kwrd">public</span> <span class="kwrd">string</span> last_name;
        <span class="kwrd">public</span> <span class="kwrd">string</span> link;
        <span class="kwrd">public</span> <span class="kwrd">string</span> email;
        <span class="kwrd">public</span> <span class="kwrd">string</span> timezone;
        <span class="kwrd">public</span> <span class="kwrd">string</span> locale;
        <span class="kwrd">public</span> <span class="kwrd">bool</span> verified;
        <span class="kwrd">public</span> <span class="kwrd">string</span> updated_time;        
    }
}</code></pre>

