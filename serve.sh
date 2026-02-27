#! /bin/bash
SOCK_DIR=$(mktemp -d)
docker build -t kli.dk-local . \
  && docker run --rm -v "$SOCK_DIR:/tmp" kli.dk-local &
sleep 1
socat TCP-LISTEN:3000,fork,reuseaddr UNIX-CONNECT:"$SOCK_DIR/lighttpd.sock"
