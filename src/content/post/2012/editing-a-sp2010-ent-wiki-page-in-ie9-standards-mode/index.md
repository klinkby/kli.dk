---
author: Mads Klinkby
categories:
- javascript
- quirks
- sharepoint
- sp
- sp2010
- www
date: "2012-06-18T22:00:00Z"
description: ""
draft: false
slug: editing-a-sp2010-ent-wiki-page-in-ie9-standards-mode
tags:
- javascript
- quirks
- sharepoint
- sp
- sp2010
- www
title: SP2010 vs IE
---


SharePoint 2010 is not really compatible with IE9. The master page forces it in IE8 compatibility mode.

One of the odd quirks you will experience if you change the master page to IE9 mode is when editing an enterprise wiki page. When you press the '[' key, the cursor jumps to the end of the paragraph.

The code below will let SharePoint know that IE9 is just like any other browser and prevent this behavior.

<pre class="csharpcode"><code> <span class="kwrd">if</span> (RTE) {
     <span class="rem">// stop ie from moving caret to end of paragraph when typing a [ in ent wiki</span>
     RTE.Cursor.updateRangeToCurrentSelectionWithOptions = <span class="kwrd">function</span> (b) {
         ULSNVe: ;
         RTE.Cursor.$41_0 = <span class="kwrd">false</span>;
         RTE.Cursor.$40_0 = <span class="kwrd">false</span>;
         RTE.Cursor.$4x_0();
         RTE.Cursor.$1I_0 = <span class="kwrd">false</span>;
         <span class="kwrd">var</span> c = RTE.Selection.getSelectionRange(),
             a = <span class="kwrd">true</span>;
         <span class="kwrd">if</span> (RTE.Canvas.$K && RTE.Canvas.$K.parentNode && RTE.Canvas.$K.parentNode.parentNode) a = RTE.Cursor.s_range.moveToNode(RTE.Canvas.$K);
         <span class="kwrd">else</span> <span class="kwrd">if</span> (!c) a = <span class="kwrd">false</span>;
         <span class="kwrd">else</span> a = RTE.Cursor.s_range.moveToRange(c);
         <span class="kwrd">if</span> (!a && !b) RTE.Cursor.s_range.clear();
         <span class="kwrd">else</span> <span class="kwrd">if</span> (a) {
             <span class="kwrd">var</span> d = RTE.Cursor.s_range.expandInNonEditableRegion();
             <span class="kwrd">if</span> (d) RTE.Canvas.$K = d;
             <span class="kwrd">if</span> (<span class="rem">/*!RTE.RteUtility.isInternetExplorer()&&*/</span>!RTE.Canvas.$K) {
                 <span class="kwrd">var</span> e = RTE.Cursor.s_range.$1N();
                 e.select()
             }
         }
         !b && RTE.Canvas.$F()
     };
 } </code></pre>

