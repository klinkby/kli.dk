---
author: "@klinkby"
keywords:
- sharepoint
- media
date: "2015-07-01T22:00:00Z"
description: ""
draft: false
slug: dwg-file-icons-in-sharepoint
tags:
- sharepoint
- media
title: DWG File Icons in SharePoint
---


SharePoint does not recognize .DWG AutoCAD files in document libraries, so will display a default "blank file" icon for those files. If you are comfortable with hacking it into the Docicon.xml file in the 14 hive, an on-premise farm enables you to do that. SharePoint Online, not so much.

Instead you can add the below CSS-snippet to a custom style sheet on you site, or you can paste in into a Script Editor Web Part on a specific page, typically by editing a list view page. Obviously it performs better than JavaScript hacks, but it also plays nicely with the Minimal Download Strategy (MDS) feature.

```HTML
<style type="text/css">
img[alt='dwg File'] {
    width: 0;
    height: 0;
    padding: 8px;
    background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAiVJREFUeNqMUztoFFEUPe8zMxvXhLVQECKItmO0UNHKLiiKoLEwgiCyyCJGEQtFsQ0EJIHEiKBNMAqCRJBUikSxilhYCIZAQGuRtdBIdt/He9/sbDIbBR/MvN+555x7mBHeexy5Mlm31lV4XRz5XkBI8e3V3ctb2jctrOaXda5y6sTx7FCIUMhL3mcPsPTl62ZTG3syd//qmbUSOmdrWoOZ5y9IScI52htLuh4DRPz46QzeT93AxYnmIGpjgkgGcwKZGSQXVBAlCWJ6vNR49+AazQrGWkgihf2Fe0P9SNP0dP+l8WcFAh7GOURaQSvF/WadUyG1hx3bt+FgdRIHzo2gt3crOx4otBAIgpKmCCgwobJLpbGwsIi+3Sl29aXw1JojwnUZBAJjoLQMuecOJDn6Xq9jfv5DK0yH/fv2/oPAsQMVWrHOt84CGxGrkBOTWF900ApRUIgGjlDLDYO58Vq4fEPzz5UGfjcNGmydsyScgOhwILgFSwoSL+9Uw9Ge6gQ+PhzC69ELbfDJ29MBt6Z+tQVOO0kiHLv5CLPDZ0Mxj8PXp1CKNQUqUUrigPtLC1mICQG7yyUcvTUdLnne1LMBPRtLKHfFiOjehBbWORCBWUcRJU9pi+zz6C53kSqdydXfInPQkQF//o4SjomAcVpHOD86GwiUFAVFxonODJory28XP30+5HMZnwkKFMTy/zLg23sfGMVOWlfw/+MH1S3x4o8AAwBY5vJVER8FlQAAAABJRU5ErkJggg==');
    background-repeat: no-repeat;
}
</style>
```

