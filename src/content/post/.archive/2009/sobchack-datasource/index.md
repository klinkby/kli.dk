---
author: "@klinkby"
keywords:
- dotnet
date: "2009-05-13T22:00:00Z"
description: ""
draft: false
slug: sobchack-datasource
tags:
- dotnet
title: Sobchack.DataSource
---


Struggled a bit with handling update on a dynamically instansiated DetailsView, and as the solutions wasn't too
obvious (ungooglable) so I would like to share it.

I have an ObjectDataSource that selects a DataTable. The ObjectDataSource was assigned to the the DetailsView.DataSource
property, and an event receiver attached to ItemUpdating, where the changed fields are provided in the event arguments
NewValues property.

Great stuff, except it's always empty!

If the ObjectDataSource is assigned via its ID to the DetailsView.DataSourceID instead of DataSource... Well for
non-obvious reasons it works.

Alas, once again I have to recognise that when asp.net controls are used programatically instead of declarative (allow
me to quote Walter Sobchack) "you're entering a world of pain, son".

