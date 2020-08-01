---
author: Mads Klinkby
categories:
- .net
date: "2007-07-02T22:00:00Z"
description: ""
draft: false
slug: parallel-processing
tags:
- .net
title: Parallel processing
---


When you run lenghty CPU intensive operations, you can save a lot of time by leveraging the multicore/hyperthreading capabilities of modern processors. This little method takes out the pain of spawning and managing threads. Just remember to synchronize access to objects that are manipulated to the callback method. [sourcecode language='csharp'] static void RunInParallel<T>(WaitCallback callBack, IEnumerable<T> parameters) where T : class { int threadsRunning = 0; AutoResetEvent goOn = new AutoResetEvent(false); foreach (object parameter in parameters) { Interlocked.Increment(ref threadsRunning); ThreadPool.QueueUserWorkItem(delegate(object state) { Debug.WriteLine("Processing " + state.ToString()); try { callBack(state); } finally { Interlocked.Decrement(ref threadsRunning); goOn.Set(); Debug.WriteLine("Completed " + state.ToString()); } }, parameter); while (threadsRunning >= System.Environment.ProcessorCount) goOn.WaitOne(); } while (threadsRunning > 0) goOn.WaitOne(); } [/sourcecode]

