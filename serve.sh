#! /bin/bash
SOCK_DIR=$(mktemp -d)
trap 'docker stop kli.dk-serve 2>/dev/null; rm -rf "$SOCK_DIR"' EXIT

docker build -t kli.dk-local . \
  && docker run --rm --name kli.dk-serve -v "$SOCK_DIR:/var/run/lighttpd" kli.dk-local &

until [ -S "$SOCK_DIR/sock" ]; do sleep 0.1; done
socat TCP-LISTEN:3000,fork,reuseaddr UNIX-CONNECT:"$SOCK_DIR/sock"
