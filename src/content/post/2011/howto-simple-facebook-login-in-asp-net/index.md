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

```C#
using System;
using System.Globalization;
using System.IO;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Web.Security;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    readonly static string App_ID = "PLACE YOUR APP ID HERE";
    readonly static string App_Secret = "PLACE YOUR APP SECRET HERE";
    readonly static string scope = "email";

    readonly static DataContractJsonSerializer userSerializer
        = new DataContractJsonSerializer(typeof(FacebookUser));

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
        if (!IsPostBack)
        {
            string code = Request.QueryString["code"];
            string error_description = Request.QueryString["error_description"];
            string originalReturnUrl = Request.QueryString["ReturnUrl"]; // asp.net logon param
            Uri backHereUri = Request.Url; // modify for dev server
            if (!string.IsNullOrEmpty(code)) // user is authenticated
            {
                FacebookUser me = GetUserDetails(code, backHereUri);
                FormsAuthentication.SetAuthCookie(me.email, false); // authorize!
                if (!string.IsNullOrEmpty(originalReturnUrl))
                    Response.Redirect(originalReturnUrl);
            }
            if (!string.IsNullOrEmpty(error_description)) // user propably disallowed
            {
                OnError(error_description);
            }
            fbLogin.Visible = !User.Identity.IsAuthenticated;
            fbLogin.NavigateUrl = string.Format(
                CultureInfo.InvariantCulture,
                "https://www.facebook.com/dialog/oauth?"
                + "client_id={0}&scope={1}&redirect_uri={2}",
                App_ID,
                scope,
                Uri.EscapeDataString(backHereUri.OriginalString));
        }
    }

    FacebookUser GetUserDetails(string code, Uri backHereUri)
    {
        Uri getTokenUri = new Uri(
            string.Format(
            CultureInfo.InvariantCulture,
            "https://graph.facebook.com/oauth/access_token?"
            + "client_id={0}&client_secret={1}&code={2}&redirect_uri={3}",
            App_ID,
            App_Secret,
            Uri.EscapeDataString(code),
            Uri.EscapeDataString(backHereUri.OriginalString))
            );
        using (var wc = new WebClient())
        {
            string token = wc.DownloadString(getTokenUri);
            Uri getMeUri = new Uri(
                string.Format(
                CultureInfo.InvariantCulture,
                "https://graph.facebook.com/me?{0}",
                token)
                );
            using (var ms = new MemoryStream(wc.DownloadData(getMeUri)))
            {
                var me = (FacebookUser)userSerializer.ReadObject(ms);
                return me;
            }
        }
    }

    void OnError(string error_description)
    {
        Controls.Add(new Label() { 
            CssClass = "oauth-error", 
            Text = error_description 
        });
    }

    [Serializable]
    class FacebookUser
    { 
        public long id;
        public string name;
        public string first_name;
        public string last_name;
        public string link;
        public string email;
        public string timezone;
        public string locale;
        public bool verified;
        public string updated_time;        
    }
}
```
