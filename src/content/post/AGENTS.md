# AGENTS.md — Writing blog posts

Guidance for drafting and editing posts under `src/content/post/`. For build/deploy
toolchain, see the root `AGENTS.md`.

## Who's writing

Mads Klinkby — enterprise architect. First person, opinionated, dry humour. The
blog is a personal place to think out loud, not corporate content marketing.

## What agents do here

**Draft from my outline.** I give you an idea, bullets and conslusion; you produce a
full draft *in my voice* for me to edit. Always ask me questions when in doubt on what points to make, 
and suggest related things i forgot to mention. When the outline is thin, ask what I'm trying to say 
before inventing it. Analyze text for possible cross references to my old blog posts.   

## File layout

- One post per folder: `post/<year>/<slug>/index.md` (page bundle).
- Images for the post live alongside `index.md` or under `src/static/images/<year>/`,
  referenced in Markdown as `/images/<year>/<file>` (Hugo serves `src/static/` at the
  site root).
- `slug` is lowercase, hyphenated.

## Front matter (YAML)

```yaml
---
date: "2026-02-28T13:37:00Z"        # RFC3339, UTC
title: "Cloud-native hosting"
description: "One-sentence summary used for SEO and the post list."
images:                              # optional, for social cards
- "/images/2026/example.jpg"
tags:
- Docker
- DevOps
---
```

- The Markdown body starts with an `# H1`. For standalone posts it repeats the
  `title`. For a series, `title` is the catalogue entry (e.g. numbered) while the
  H1 is the reader-facing heading (e.g. "Quality attributes for microservices -
  part 1").
- `tags` are a short list; casing has been inconsistent historically (`www` vs
  `Www`) — pick one per tag and reuse existing tags rather than coining new ones.

## Voice & style

- **Dry and opinionated.** First person. Strong takes are the point — keep the
  jabs ("I'm looking at you, webpack"). Don't sand the personality flat.
- **Story-driven.** Lead with motivation/context, walk the journey, land a
  conclusion. Arc: motivation → what I did / how → conclusion → links & credits.
- **No AI-isms.** Banned: "delve", "in today's fast-paced world", "it's worth
  noting", hype adjectives ("powerful", "seamless", "robust"), em-dash padding,
  and turning prose into bullet soup. Write sentences, not slide decks.
- **Honest, not hype.** Acknowledge trade-offs and limitations. The best posts
  undercut their own thesis where it's due (the cloud-native post ends admitting
  US tech still dominates the stack). Don't oversell.
- Short paragraphs. Plain language over jargon; explain acronyms on first use.
- Link generously to primary sources, repos, and products.
- Close with relevant links, repo, and image/asset credits where due.

## Voice in practice

Lines that sound like me — match this register, don't imitate verbatim:

- "...before new-fangled LEDs was developed." — dry, slightly self-amused.
- "I'm looking at you Angular, React and Vue and webpack." — named, pointed jabs.
- "...decoupling from the power of Trump-flattering US tech giants." — opinion
  stated flatly, no hedging.
- "One small step. Alas, Europe has some way to go." — short, literary kicker to
  end on rather than a summary.
- "_In my humble opinion a good microservice..._" — italic personal aside.

## Post anatomy

Two shapes, picked by depth — don't pad a short idea into the long form:

**Short essay** (e.g. nixie-tube, cloud-native): no subheadings. Open with the
motivation in the first sentence, walk through what I did and why, state the
conclusion plainly ("My conclusion is..."), then links and credits. ~300–500 words.

**Sectioned deep-dive** (e.g. the microservices series): `##` sections, each a
single facet, ending with a `## Conclusion`, then `---`, then `## References` as a
linked list. Series posts open with a `>` blockquote linking the series index and
cross-link prev/next with relative links. 

**Linking series posts**: Publishing a new post in a series means going *back* to
wire the previous post's closing "next post" link and turn the series-index line into a
link — easily forgotten. Leave a post's own "next post" sentence unlinked until that
post exists.

Common to both:

- First sentence establishes context/motivation — never a throat-clearing preamble.
- The takeaway is stated outright, not implied.
- Credit images in the alt text or a closing line ("Parcels photo by George
  Hodan"); link licences. Link repos with their licence (e.g. "MIT licensed").
- Sign-offs vary — a Mastodon link for replies, a wry kicker, a thank-you. Don't
  use a templated outro every time.

## Gold-standard posts

When in doubt, match the tone and shape of these:

- `2023/01-exclusively-owns-logic-and-persistence/index.md` — sectioned deep-dive.
- `2025/nixie-tube-native-web-component/index.md` — short essay, project write-up.
- `2026/cloud-native-hosting/index.md` — short essay, opinion + how-it-works.

## Mechanics

- Markdown indent is 4 spaces (`.editorconfig`); body lines are hard-wrapped.
- Prefer relative links for internal pages, absolute for external. Cross-year internal
  links need `../../<year>/<slug>/` (a series index and a post can live in different years).
- No build step needed to preview prose; run Hugo locally to check rendering.

## Images

- Keep post images small: **~640px wide, under ~100 KB** (existing ones are 44–62 KB).
  Don't ship multi-megabyte originals.
- No ImageMagick or PIL in this environment. Resize with sharp-cli via npx:
  `npx --yes sharp-cli -i <file> -o <dir>/ resize 640 --withoutEnlargement --`
  (it overwrites in place when input and output dir match).
- Source images CC0 / public-domain to match the blog. Wikimedia Commons works well and
  is fetchable; Pixabay/Unsplash pages block automated download (HTTP 403). Credit the
  author in the image alt text, e.g. `![... , photo by Daderot (CC0)](/images/...)`.

## Proofreading

- When editing a post, silently fix obvious typos and spelling slips in the
  surrounding text — e.g. "Lighttd" → "Lighttpd", "Antrophic" → "Anthropic",
  "souce" → "source", a stray trailing `:` in a description.
- Do **not** silently change anything that could be a deliberate choice or a fact:
  product/brand names, version numbers, figures, quotes, code, or claims. Flag
  those and let me decide — a wrong "correction" to a product name is worse than
  the typo.
- Fix typos in place; don't rewrite correct sentences just to restyle them.

## Recurring themes

On-brand topics — steer suggestions here, flag anything that drifts off:

- **.NET & web standards** — C#/.NET, native web components, the browser
  platform, frontend without heavy frameworks.
- **Cloud-native & DevOps** — Docker, Linux, self-hosting, CI/CD, architecture,
  EU tech sovereignty.
- **Security** — appsec, zero-trust, hardening, the security angle on the above.
- **Career & opinion** — the architect role, industry takes, working in tech.
