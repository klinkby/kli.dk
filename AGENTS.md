# AGENTS.md — Toolchain & Architecture

## Static site

| What           | Detail                                                                       |
|----------------|------------------------------------------------------------------------------|
| Generator      | [Hugo Extended](https://gohugo.io/) v0.145.0                                 |
| Content source | `src/` (TOML config, Markdown posts, YAML data)                              |
| Theme          | `src/themes/cactus` — git submodule → `github.com/klinkby/hugo-theme-cactus` |
| Build output   | `src/public/` (produced by the build, never committed)                       |
| Hosting        | GitHub Pages, custom domain `www.kli.dk` (`src/static/CNAME`)                 |

Hugo is invoked with `--minify`. Config lives in `src/config.toml`.

## Commands

```sh
git submodule update --init --recursive          # fetch the cactus theme
hugo -s src server -D                             # dev, localhost:1313
hugo -s src --gc --minify --baseURL "https://www.kli.dk/"   # build to src/public/
```

Hugo Extended is required by the cactus theme. The theme is a git submodule, so
a fresh clone needs `--recursive` (or `git submodule update --init`) before it will build.

## CI/CD

GitHub Actions, mirroring the sanselig pipeline:

- `.github/workflows/build.yml` — builds the site on every PR to `main` (and `workflow_dispatch`).
- `.github/workflows/deploy.yml` — on push to `main` (and `workflow_dispatch`), builds and
  deploys to GitHub Pages via `actions/upload-pages-artifact` + `actions/deploy-pages`.

Both check out submodules recursively and pin `HUGO_VERSION`. No Docker image, no Docker Hub,
no `DOCKERHUB_PAT`.

## Hosting notes

- Custom domain `www.kli.dk` is kept by `src/static/CNAME`; set the same domain (and DNS) once
  in the repo's **Settings → Pages**, and set the Pages source to **GitHub Actions**.
- `/sitemap.xml` is Hugo's native sitemap. `/index.xml` is the RSS 2.0 feed.
- Custom 404 page: `/404/index.html`.
- GitHub Pages does **not** serve custom response headers (the old lighttpd
  `Content-Security-Policy` and `Cache-Control` tuning) or 301 redirects. If those are needed,
  they must be handled by a CDN/proxy in front of Pages.
