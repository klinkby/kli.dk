---
author: "@klinkby"
keywords:
- dotnet
- sharepoint
date: "2010-11-09T23:00:00Z"
description: ""
draft: false
slug: sharepoint-how-a-little-linq-magic-can-list-all-users-permissions
tags:
- dotnet
- sharepoint
title: Enumerate user's permissions
---


To manage authorization in SharePoint you define a set of roles with permissions that is assigned to groups and users.
It is a versatile model with many possibilities.

But because of its complexity it is a not as easy as one might think to get a list of what each user can do with a SP
object. This little snippet will help a long way to provide that overview.

<pre class="csharpcode"><code><span class="kwrd">class</span> UserPermission
{
    <span class="kwrd">public</span> SPUser User { get; <span class="kwrd">private</span> set; }
    <span class="kwrd">public</span> SPBasePermissions Permissions { get; <span class="kwrd">private</span> set; }
    <span class="kwrd">public</span> UserPermission(
        SPUser user, 
        SPBasePermissions permissions)
    {
        User = user;
        Permissions = permissions;
    }
    <span class="kwrd">public</span> <span class="kwrd">static</span> IEnumerable&lt;UserPermission&gt;
        FromRoleAssignments(SPRoleAssignmentCollection roles)
    {
        var allGranted <span class="rem">// all assignments</span>
            = from r <span class="kwrd">in</span> roles.Cast&lt;SPRoleAssignment&gt;()
            let asGroup = r.Member <span class="kwrd">as</span> SPGroup
            let users = asGroup != <span class="kwrd">null</span>
                ? asGroup.Users.Cast&lt;SPUser&gt;()
                : <span class="kwrd">new</span>[] { (SPUser)r.Member }
            from u <span class="kwrd">in</span> users
            select <span class="kwrd">new</span> UserPermission(
                u,
                r.RoleDefinitionBindings
                    .Cast&lt;SPRoleDefinition&gt;()
                    .Aggregate(
                        SPBasePermissions.EmptyMask,
                        (acc, x) =&gt; acc |= x.BasePermissions)
                    );
        var byUser <span class="rem">// aggregate per user</span>
            = allGranted.GroupBy(
            x =&gt; x.User,
            x =&gt; x.Permissions,
            (u, p) =&gt; <span class="kwrd">new</span> UserPermission(
                u,
                p.Aggregate(
                    SPBasePermissions.EmptyMask,
                    (acc, x) =&gt; acc |= x)
            ),
            <span class="kwrd">new</span> UserComparer());
        <span class="kwrd">return</span> byUser;
    }
    <span class="kwrd">sealed</span> <span class="kwrd">class</span> UserComparer : IEqualityComparer&lt;SPUser&gt;
    {
        <span class="kwrd">public</span> <span class="kwrd">bool</span> Equals(SPUser x, SPUser y)
        { <span class="kwrd">return</span> x.ID == y.ID; }
        <span class="kwrd">public</span> <span class="kwrd">int</span> GetHashCode(SPUser obj) 
        { <span class="kwrd">return</span> obj.ID.GetHashCode(); }
    }
}</code></pre>

