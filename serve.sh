#!/bin/bash
VOL="kli-dk-sock-$$"
trap 'docker rm -f kli.dk-serve kli.dk-socat 2>/dev/null; docker volume rm "$VOL" 2>/dev/null' EXIT

docker build -t kli.dk-local . || {
  echo "Docker build failed" >&2
  exit 1
}

docker volume create "$VOL" >/dev/null

docker run -d --rm --name kli.dk-serve -v "$VOL:/var/run/lighttpd" kli.dk-local

MAX_ATTEMPTS=300  # 30 seconds at 0.1s intervals
attempt=0
while ! docker exec kli.dk-serve test -S /var/run/lighttpd/sock 2>/dev/null && [ "$attempt" -lt "$MAX_ATTEMPTS" ]; do
  sleep 0.1
  attempt=$((attempt + 1))
done

if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
  echo "Timed out waiting for socket" >&2
  exit 1
fi

echo "http://localhost:3000"

docker run --rm --name kli.dk-socat \
  -v "$VOL:/var/run/lighttpd" \
  -p 3000:3000 \
  alpine sh -c 'apk add --no-cache -q socat && exec socat TCP-LISTEN:3000,fork,reuseaddr UNIX-CONNECT:/var/run/lighttpd/sock'
