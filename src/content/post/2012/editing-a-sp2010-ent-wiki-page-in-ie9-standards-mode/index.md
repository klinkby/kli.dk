---
author: "@klinkby"
keywords:
- javascript
- sharepoint
- www
date: "2012-06-18T22:00:00Z"
description: ""
draft: false
slug: editing-a-sp2010-ent-wiki-page-in-ie9-standards-mode
tags:
- javascript
- sharepoint
- www
title: SP2010 vs IE
---


SharePoint 2010 is not really compatible with IE9. The master page forces it in IE8 compatibility mode.

One of the odd quirks you will experience if you change the master page to IE9 mode is when editing an enterprise wiki
page. When you press the '[' key, the cursor jumps to the end of the paragraph.

The code below will let SharePoint know that IE9 is just like any other browser and prevent this behavior.

```JS
if (RTE) {
     // stop ie from moving caret to end of paragraph when typing a [ in ent wiki
     RTE.Cursor.updateRangeToCurrentSelectionWithOptions = function (b) {
         ULSNVe: ;
         RTE.Cursor.$41_0 = false;
         RTE.Cursor.$40_0 = false;
         RTE.Cursor.$4x_0();
         RTE.Cursor.$1I_0 = false;
         var c = RTE.Selection.getSelectionRange(),
             a = true;
         if (RTE.Canvas.$K && RTE.Canvas.$K.parentNode && RTE.Canvas.$K.parentNode.parentNode) a = RTE.Cursor.s_range.moveToNode(RTE.Canvas.$K);
         else if (!c) a = false;
         else a = RTE.Cursor.s_range.moveToRange(c);
         if (!a && !b) RTE.Cursor.s_range.clear();
         else if (a) {
             var d = RTE.Cursor.s_range.expandInNonEditableRegion();
             if (d) RTE.Canvas.$K = d;
             if (/*!RTE.RteUtility.isInternetExplorer()&&*/!RTE.Canvas.$K) {
                 var e = RTE.Cursor.s_range.$1N();
                 e.select()
             }
         }
         !b && RTE.Canvas.$F()
     };
 } 
 ```

