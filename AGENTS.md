# AGENTS.md — Toolchain & Architecture

## Static site

| What | Detail |
|---|---|
| Generator | [Hugo Extended](https://gohugo.io/) v0.145.0 |
| Content source | `src/` (TOML config, Markdown posts, YAML data) |
| Theme | `src/themes/cactus` — git submodule → `github.com/klinkby/hugo-theme-cactus` |
| Build output | `src/public/` (produced inside Docker, never committed) |

Hugo is invoked with `--minify`. Config lives in `src/config.toml`.

## Container

Multi-stage `Dockerfile` (Alpine 3.22):

1. **builder** — downloads Hugo, copies `src/`, runs `hugo --minify`.
2. **runtime** — installs lighttpd, copies `src/public/` into `/app`, runs as non-root user `web`.

## Web server

[lighttpd](https://www.lighttpd.net/) — config at `lighttpd.conf`.

Key behaviour:
- Binds to a **Unix socket** at `/var/run/lighttpd/sock` (no TCP port inside the container).
- `GET /sitemap.xml` → 301 redirect → `/index.xml` (RSS feed).
- Custom 404 page: `/404/index.html`.
- Security headers: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`.
- Cache-Control: static assets 180 days (`immutable`); HTML/XML/JSON 1 day.

## Protocols & endpoints

| Protocol | Notes |
|---|---|
| HTTP/1.1 | Served by lighttpd; TLS is terminated upstream (reverse proxy / load balancer) |
| RSS 2.0 | `/index.xml` |
| Sitemap redirect | `/sitemap.xml` → `/index.xml` (301) |

## CI/CD

`.github/workflows/docker-image.yml` (GitHub Actions):

- Triggers on push **and** PR to `master`.
- Builds with Docker Buildx; uses GitHub Actions cache (`type=gha`).
- Pushes image `klinkby/kli.dk` to Docker Hub on merge to `master` (skipped for Dependabot).
- Tags: build run number + commit SHA.
- Requires repository secret `DOCKERHUB_PAT`.

## Local development

```sh
./serve.sh
```

Builds the image locally, starts the container with a Docker volume for the Unix socket, polls until the socket is ready, then bridges it to `localhost:3000` via a socat sidecar container. Cleans up on exit.

Requires: `docker`.
