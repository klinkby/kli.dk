---
date: "2021-04-21T10:22:00Z"
title: "Securing Docker containers - part I"
description: "Use a read-only file system to reduce container attack surface"
tags:
- security
- docker
- linux
- dotnet
images:
- "/images/2021/bleeping-docker.jpg"
---

![image](/images/2021/bleeping-docker.jpg)

# Securing Docker containers - part I

> Container runtimes like Docker and K8s are not entirely secure by default, so extra effort is required by devops engineers. 
> This is the first in a series of blog posts with practical advise on how to reduce your container's attack surface by using a read-only file system.

## Containers vs VMs
Containers are often compared to virtual machines like VMware or Hyper-V, which enables a single host to boot up a small 
number widely different operating systems. VMs make use of hardware-assisted tricks to ensure watertight separation 
between the guest OSes as well as the host OS. Expoits that are able to escape a VM guest OS and gain privileges outside
are relatively rare, largely because very little is shared between the guests, each having its own kernel. This is a 
pillar in public cloud compute resources, which enables e.g. Amazon able to mix customers workloads on a single host. 

Containers, on the other hand, are not virtualized, and all share a kernel with the host. So a comparison to processes 
within an OS would be more justified. Containers are simply processes running in the host, but in their own namespace, 
effectivly blinding them from processes or files from the hosts or other running containers. And exploits escaping 
from a process are much more common than VM exploits.

More about this in 
[Jails – High value but shitty Virtualization](http://phk.freebsd.dk/sagas/jails/) by its inventor PHK. 

## Immutability
A you probably know, container images are build from layered slices of immutable images applied on top of each other. 
It's also good practice to consider a container immutable during runtime, because that is much easier to
maintain, and you can rely on static security scans in you build pipeline if you don't manipulate binaries runtime. 
Also, an attacker will have a much harder time stirring things up if it's impossible to persist exploits. 

> Docker (and K8s) grant unrestricted write access to a container's file system by default.

You need to explicitly change that behavior in the `docker run` command or `docker-compose.yml` file. For the latter 
it's as simple as adding `read_only: true`, like this:

```yml
version: '3.0'
services:
  ro_test:
    image: alpine:3.13
    read_only: true # <==
    entrypoint: "tail -f /dev/null" 
```

A `docker-compose up` will start the container (`entrypoint` will keep it from immediately shutting down). If you attach to the running container, you will see you are unable to create files anywhere -- even in `/tmp`. So that's from one 
extremity to the other. 

You will have to analyse your specific service's file system write requirements to either disable umimportant writes, or 
decide whether to use persistent or temporary file systems for written data. 

## Aspnet Core Kestrel web server
For instance, the Kestrel web server in Aspnet Core default traces diagnostic data (which can safely be disabled) and 
make use of `/tmp` for buffering multipart/form file uploads.

Add this to your dockerfile to disable the diagnostic tracing (and MS telemetry):

```dockerfile
ENV COMPLUS_ENABLEDIAGNOSTICS=0
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
```

To your `docker-compose.yml` file add the pair of marked lines to let Kestrel write temp files.

```yml
version: '3.0'
services:
  ro_test:
    image: mcr.microsoft.com/dotnet/aspnet:5.0.5-alpine3.13
    read_only: true
    tmpfs:           # <==
      - /tmp         # <==
    entrypoint: "tail -f /dev/null" 
```

Your mileage may wary... For other middleware (that have as lousy documentation as Aspnet Core) running a `strace` 
command can help list open file descriptors for your service. 

If your service really need persistent data storage simply mount a volume from the host, like so:

```yml
version: '3.0'
services:
  ro_test:
    image: alpine:3.13
    read_only: true
    volumes:                            # <==
      - ./volumes/misc:/var/lib/misc    # <==
    entrypoint: "tail -f /dev/null" 
```

## Conclusion

This blog post displayed some weaknesses with containers, and demonstrated how a read only filesystem can be a good step
to reduce your container's runtime attack surface.  

[Next blog post](/post/2021/securing-docker-containers-2) will show how to reduce service account privileges. 
