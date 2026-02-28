---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: managed-directx-becomes-xna
tags:
- dotnet
title: Managed DirectX becomes XNA
---


Microsoft decided some time ago to stop developing the MDX libraries and thus never release the 2.0 version. Instead
they migrate the library to XNA, which is a managed game engine shared with XBox360. It has not yet been announced that
DirectX 10 will be incorporated into Xna. So IUnknown is the only way to use Dx10. First the XNA beta SDK can only
install on C# Express. If you already has VS2005 thats pretty lame. Fortunately a "msiexec -a" can extract the install
files so you can grab the Microsoft.Xna.* assemblies and use in VS2005. Using the MDX2 beta I built a pretty fast 2D
library, and it was not as easy to port to Xna as I had hoped because lots of functionality is missing.

* Shader is everything. Fixed function pipeline is gone so for instance View/World/Projection is handled by a shader. If
  you want your primitives to be anything but gray, you must also write a shader.
* You can no longer fill the vertexbuffer using Lock/Unlock - only SetData can be used. I was very sad to see this as
  it's much faster to fill the buffer directly than the extra pin/memcpy used by SetData. DirectSound has been
  completely replaced by XACT. I haven't yet figured out how to render realtime sound data.

