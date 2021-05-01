---
date: "2021-04-26T18:22:00Z"
title: "Securing Docker containers - part II"
description: "Drop root privileges to reduce container attack surface"
tags:
- security
- docker
- linux
- dotnet
images:
- "/images/2021/bleeping-docker.jpg"
---

![image](/images/2021/bleeping-docker.jpg)

# Securing Docker containers - part II

> Container runtimes like Docker and K8s are not entirely secure by default, so extra effort is required by devops engineers. 
> This is the second in a series of blog posts with practical advise on how to reduce your container's attack surface by revoking service `root` privileges.

## Almighty containers

In the [first post](/post/2021/securing-docker-containers-1/) we saw there are fundamental differences between VMs and 
containers, and DevOps engineers should take active measures to improve container runtime security. And specifically 
how to mount a container image read-only at runtime to make it default immutable, and handling temporary and persistent 
volumes.

Another interesting default for containers is that Docker and K8s runs with `root` privileges. Not just inside the 
container, but also on the host. 

Without containers, you would probably not be running your services as `root`. That is because you want to limit the 
blast radius from vulnerabilities in your service. For the exact same reason, containers should run as a user with the 
least privileges possible. 

If an attacker manage to exploit a container escape volunerability to access the host, they would have complete control 
over the host to deploy persistent backdoors, clean up audit logs. 

# Rootless containers

Your `Dockerfile` can specify a low privilege user to be used to run the service. The following snippet from a 
Aspnet Core service create a new `appuser` that owns the `app` directory, where the service binaries are deployed. The 
last `USER` command drops `root` privileges by changing to `appuser` security context.

The image is Alpine-based.

```dockerfile
WORKDIR /app
RUN adduser -D appuser && chown -R appuser /app 
COPY --chown=appuser:appuser --from=publish /app/publish .
USER appuser
```

Developers tend to follow the path of least resistance, so default insecure behavior completely dominate public images 
on Docker Hub.   

# Rootless daemon

While the container process has now dropped the `root` privileges, the runtime daemon is still default executing as 
`root`. The container community is working on changing this behavior but at the time of writing it still "experimental",
i.e. has some road ahead to go before it can become default. 

- To run a rootless Docker daemon please refer to https://docs.docker.com/engine/security/rootless/
- Kubernetes has a "usernetes" initiative going on at https://github.com/rootless-containers/usernetes

# Rootless builds

The community is also working on splitting build tools from the Docker daemon. If you want to run rootless build 
pipeline have a look at [Podman](https://podman.io/) and [Buildah](https://buildah.io/). Note the latter use an 
alternative to `Dockerfile`-syntax to build OCI compliant container images.

## Conclusion

This blog post displayed a big issue with container default privileges and how to fix it by dropping `root` to 
unprivileges user to reduce the blast radius of your container.  
