---
author: "@klinkby"
keywords:
- dotnet
date: "2006-10-12T22:00:00Z"
description: ""
draft: false
slug: use-weakreference-for-objects-that-are-cheap-to-create
tags:
- dotnet
title: reate…
---


I think Microsoft forgot to implement a generic WeakReference. Well here it is - it still requires a type cast but I think it's a lot nicer to use it strongly typed.   

 <span class="kwrd">internal</span> <span class="kwrd">sealed</span> <span class="kwrd">class</span> WeakReference<T>  {      WeakReference weakRef;       [DebuggerStepThrough]      <span class="kwrd">public</span> WeakReference(T target)      {          weakRef = <span class="kwrd">new</span> WeakReference(target);      }      [DebuggerStepThrough]      <span class="kwrd">public</span> WeakReference(<span class="kwrd">object</span> target, <span class="kwrd">bool</span> trackResurrection)      {          weakRef = <span class="kwrd">new</span> WeakReference(target, trackResurrection);      }      <span class="kwrd">public</span> <span class="kwrd">bool</span> IsAlive      {          [DebuggerStepThrough]          get { <span class="kwrd">return</span> weakRef.IsAlive; }      }      <span class="kwrd">public</span> T Target      {          [DebuggerStepThrough]          get { <span class="kwrd">return</span> (T)weakRef.Target; }          [DebuggerStepThrough]          set { weakRef.Target = <span class="kwrd">value</span>; }      }      <span class="kwrd">public</span> <span class="kwrd">bool</span> TrackResurrection      {          [DebuggerStepThrough]          get { <span class="kwrd">return</span> weakRef.TrackResurrection; }      }  }

