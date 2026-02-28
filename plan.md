# Fix Socket Permissions — Root Cause & Plan

## Root Cause

**Dockerfile line 21** correctly creates `/var/run/lighttpd` owned by `web:web`:
```dockerfile
RUN ... mkdir -p /var/run/lighttpd && chown web:web /var/run/lighttpd
```

**serve.sh line 10** then bind-mounts a host temp directory over it:
```sh
docker run --rm --name kli.dk-serve -v "$SOCK_DIR:/var/run/lighttpd" kli.dk-local &
```

`mktemp -d` creates a directory owned by the **host user** (e.g. UID 1000, mode `0700`). The bind mount replaces the image's `web:web`-owned directory with this host directory. The container's `web` user (different UID) has no write permission, so lighttpd cannot create the socket.

`chmod 777` works around this by making the host directory world-writable, but that's not a proper fix.

## Fix — Switch to a Docker Volume

Docker **named volumes** have a key property: when first mounted to a container path, Docker initializes the volume from the image's directory — preserving ownership and permissions. So the `web:web` ownership set in the Dockerfile survives the mount.

### Changes

#### 1. `Dockerfile` — declare the volume mount point

Add after the `RUN chown` line:

```dockerfile
VOLUME /var/run/lighttpd
```

This documents to operators (and Docker) that this path is a volume mount point. When no explicit `-v` is given, Docker auto-creates an anonymous volume with the correct `web:web` ownership.

#### 2. `serve.sh` — use a named volume + socat sidecar

Since the host can't directly access files inside a Docker volume, replace host-side `socat` with a lightweight sidecar container sharing the same volume:

```sh
#!/bin/bash
VOL="kli-dk-sock-$$"
trap 'docker rm -f kli.dk-serve kli.dk-socat 2>/dev/null; docker volume rm "$VOL" 2>/dev/null' EXIT

docker build -t kli.dk-local . || { echo "Docker build failed" >&2; exit 1; }
docker volume create "$VOL" >/dev/null

# Start lighttpd (socket created inside the Docker volume)
docker run -d --rm --name kli.dk-serve -v "$VOL:/var/run/lighttpd" kli.dk-local

# Poll for socket readiness via docker exec (not host filesystem)
MAX_ATTEMPTS=300
attempt=0
while ! docker exec kli.dk-serve test -S /var/run/lighttpd/sock 2>/dev/null && [ "$attempt" -lt "$MAX_ATTEMPTS" ]; do
  sleep 0.1
  attempt=$((attempt + 1))
done
if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
  echo "Timed out waiting for socket" >&2; exit 1
fi

echo "http://localhost:3000"

# Bridge socket → TCP via sidecar sharing the same volume
docker run --rm --name kli.dk-socat \
  -v "$VOL:/var/run/lighttpd" \
  -p 3000:3000 \
  alpine sh -c 'apk add --no-cache -q socat && exec socat TCP-LISTEN:3000,fork,reuseaddr UNIX-CONNECT:/var/run/lighttpd/sock'
```

Key differences from the current script:
- **No bind mount** — uses a named Docker volume, so `web:web` ownership is preserved
- **No host `socat` dependency** — socat runs inside an Alpine sidecar container
- **Socket polling via `docker exec`** — since the host can't see into the volume
- **Cleanup** removes both containers and the ephemeral volume

#### 3. `AGENTS.md` — update docs

Update the "Local development" section to remove `socat` from host prerequisites (now only `docker` is required).
