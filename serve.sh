#! /bin/bash
docker build -t kli.dk-local . && docker run --rm -p 3000:3000 kli.dk-local
