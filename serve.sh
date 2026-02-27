#! /bin/bash
SOCK_DIR=$(mktemp -d)
trap 'docker stop kli.dk-serve 2>/dev/null; rm -rf "$SOCK_DIR"' EXIT

docker build -t kli.dk-local . || {
  echo "Docker build failed" >&2
  exit 1
}

docker run --rm --name kli.dk-serve -v "$SOCK_DIR:/var/run/lighttpd" kli.dk-local &

MAX_ATTEMPTS=300  # 30 seconds at 0.1s intervals
attempt=0
while [ ! -S "$SOCK_DIR/sock" ] && [ "$attempt" -lt "$MAX_ATTEMPTS" ]; do
  sleep 0.1
  attempt=$((attempt + 1))
done

if [ ! -S "$SOCK_DIR/sock" ]; then
  echo "Timed out waiting for $SOCK_DIR/sock to be created" >&2
  exit 1
fi
socat TCP-LISTEN:3000,fork,reuseaddr UNIX-CONNECT:"$SOCK_DIR/sock"
