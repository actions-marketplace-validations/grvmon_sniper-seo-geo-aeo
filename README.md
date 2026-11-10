# Sniper SEO + GEO + AEO

Agent skill for SEO, GEO and AEO audits: it verifies a page with code, scores only what it could test, and drafts fixes for Google and AI answer engines. It does not predict or guarantee a ranking or a citation.

[![CI](https://github.com/grvmon/sniper-seo-geo-aeo/actions/workflows/ci.yml/badge.svg)](https://github.com/grvmon/sniper-seo-geo-aeo/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/grvmon/sniper-seo-geo-aeo)](https://github.com/grvmon/sniper-seo-geo-aeo/releases)
[![License: MIT](https://img.shields.io/github/license/grvmon/sniper-seo-geo-aeo)](https://github.com/grvmon/sniper-seo-geo-aeo/blob/main/LICENSE)

```bash
npx skills add grvmon/sniper-seo-geo-aeo
```

Google's [AI features documentation](https://developers.google.com/search/docs/appearance/ai-features) says AI Overviews and AI Mode use the same Search systems as the rest of Google Search, with no extra technical requirements. The [generative AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (updated 2026-07-10) says there is no special schema and that Google Search ignores `llms.txt`. Other products document their own crawlers. [OpenAI](https://developers.openai.com/api/docs/bots) separates `OAI-SearchBot` (search), `GPTBot` (training), and `ChatGPT-User` (a person asked for a fetch).

Citation overlap across engines depends on the query. This skill records a sampling log or marks overlap `NT`. It does not publish an overlap percentage, and it does not assume the Google top result is what other engines cite.

The procedure is [`SKILL.md`](SKILL.md). Short guides are in the [wiki](https://github.com/grvmon/sniper-seo-geo-aeo/wiki).

## What it does

1. **Verification (`verify-page.sh`):** needs only `curl` and `python3`. Reports status and redirects, robots.txt (RFC 9309 parsing, matched on path plus query) with an allow/disallow line for 15 crawler tokens split into search, user-fetch, training and ads, meta robots and `X-Robots-Tag`, canonical, sitemap membership (index and `.gz` expansion, up to 20 files), schema syntax and duplicate entity detection across blocks, title, meta and OpenGraph tags, viewport, soft-404 heuristics (including SPA `llms.txt` fallbacks), image alt counts, and cache headers. Anything it did not check prints `nt`.
2. **Citability scoring:** five categories, `NT` when untested. `answer`, `contain` and `original` are rater-judged heuristics, not Google signals.
3. **Style lint:** flags the formulaic phrases listed in `references/humanize.md` (except the stacked-connector row). It is an editing aid, not a ranking test.
4. **Draft remediation:** proposes title, meta, a lead answer and linked JSON-LD. A person reviews and publishes; nothing is changed automatically, and no links or badges are inserted.

## Contents

- [What it does](#what-it-does)
- [Features](#features)
- [Supported engines](#supported-engines)
- [Install](#install)
- [Usage](#usage)
- [Examples](#examples)
- [Layout](#layout)
- [FAQ](#faq)
- [Author](#author)
- [License](#license)

## Features

- Intake before any recommendation: URL, market, target query, SERP intent format match, competitors the owner names, access, baseline, and a per-bot training choice.
- `scripts/verify-page.sh` fetches status, redirects, robots, canonical, sitemap, schema syntax and duplicate root entity types, title/meta and OpenGraph snippet health, mobile viewport, soft 404 detection (including SPA `llms.txt` fallbacks), content humanization (AI cliché scanner), image SEO, and outlinks. Supports `-g` / `--googlebot` for Googlebot Smartphone emulation.
- Technical checks stay `pass`, `fail`, or `NT`. A missing `index, follow` meta is not a failure.
- Content humanization & anti-AI cadence: flags formulaic phrases (a style lint, not a ranking test) and gives editing guidance on sentence rhythm and specificity.
- Citability score from five tested categories: Answer, Contain, Structure, Sourced, and Information Gain (Originality). Categories you did not test stay `NT` and are not turned into zero. `overall` is `NT` when coverage is under 60.
- An evidence ledger. A number with no row is dropped.
- Production-ready remediation deliverables: copy-paste Title, Meta description, lead direct answer snippet, and connected Schema.org `@graph`.
- Measurement plan for Search Console, Bing Webmaster, one defined conversion, AI referral hostnames, and a frozen citation sample.
- Schema rules that follow visible, true content. `FAQPage` is not a rich-result tactic after 7 May 2026.
- Official Core Web Vitals at the 75th percentile: LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1.
- 100% white-label: produces audit findings and remediation code with zero inserted backlinks or badges.

## Supported engines

Search, user-triggered fetch, and training are different jobs. Leave every training crawler `undecided` until the owner chooses `allow` or `disallow`. Details and sources are in [`references/platforms.md`](references/platforms.md).

| Engine | What this skill records | What to do |
| --- | --- | --- |
| **Google Search** | `Googlebot` | Allow it when the URL should be indexed. |
| **Google AI Overviews** | Same Search systems as Google. No extra file or schema type. | Keep the page indexed and eligible for a snippet. Spend the effort on first-hand content, not a special markup type. |
| **ChatGPT** | `OAI-SearchBot` for search. `ChatGPT-User` when a person asks for a fetch. `GPTBot` is training, and it is a separate decision. | Allow `OAI-SearchBot` when the page should be findable in ChatGPT search. Do not treat `GPTBot` as that switch. |
| **Perplexity** | `PerplexityBot` for search. `Perplexity-User` for a user fetch. The publisher docs say `PerplexityBot` is not a training crawler. | Allow `PerplexityBot` when the page should be linked from Perplexity search. |
| **Gemini** | `Google-Extended` is a robots.txt token for Gemini training and for grounding in Gemini Apps and Vertex AI. It does not control Google Search ranking. | Decide `Google-Extended` on its own. Do not block `Googlebot` to opt out of Gemini training. |
| **Copilot** | Bing's index via `Bingbot`. [IndexNow](https://www.indexnow.org/documentation) is an optional URL ping. | Allow `Bingbot` when the URL should be findable in Bing and Copilot. IndexNow is not a ranking score. |
| **Claude** | `Claude-SearchBot` (search), `Claude-User` (a person asked), `ClaudeBot` (training). | Set the three tokens separately. |
| **Grok** | No crawler token is documented in this skill. | When the owner wants Grok measured, add it to the citation sample and record the cited URL or "not cited". Do not invent a robots.txt rule. |

## Install

The shortest path on most agents:

```bash
npx skills add grvmon/sniper-seo-geo-aeo
```

### Google Antigravity and Gemini CLI

```bash
git clone https://github.com/grvmon/sniper-seo-geo-aeo.git ~/.gemini/skills/sniper-seo-geo-aeo
```

Gemini CLI also reads `~/.agents/skills/` ([Gemini CLI skills docs](https://geminicli.com/docs/cli/skills/)).

### Claude Code and Claude Desktop

```bash
git clone https://github.com/grvmon/sniper-seo-geo-aeo.git ~/.claude/skills/sniper-seo-geo-aeo
```

### Cursor and Windsurf

```bash
git clone https://github.com/grvmon/sniper-seo-geo-aeo.git .cursor/skills/sniper-seo-geo-aeo
```

### npm (GitHub Packages)

```bash
npm install @grvmon/sniper-seo-geo-aeo
```

Point the `@grvmon` scope at GitHub Packages. In the project `.npmrc`:

```
@grvmon:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
```

`NODE_AUTH_TOKEN` is a GitHub personal access token with `read:packages`. The tarball includes `SKILL.md`, `references/`, `scripts/verify-page.sh`, and these docs. npm delivers the files. It does not register the skill. Copy or link the package into the agent's skills directory using one of the paths above, and keep `scripts/verify-page.sh` executable.

Package page: [github.com/grvmon/sniper-seo-geo-aeo/pkgs/npm/sniper-seo-geo-aeo](https://github.com/grvmon/sniper-seo-geo-aeo/pkgs/npm/sniper-seo-geo-aeo).

## Usage

1. Install the skill with one of the methods above.
2. Ask for an SEO audit, a crawler review, a schema pass, or a before/after rewrite. Name the engine when you care about one.
3. The skill fills the intake first. Unknown fields stay `NT`.
4. It runs `bash <skill-dir>/scripts/verify-page.sh`, then scores only the categories it could test.
5. It returns the report template in [`SKILL.md`](SKILL.md): technical checks, citability, ledger, drafted changes, production remediation code, measurement, and what is still not tested.

## Examples

Audit a URL:

> Audit https://example.com/guides/stamp-duty. Market is India, English. Intent is informational. I have no Search Console access. Leave training crawlers undecided.

The report should show `NT` for Search Console, Bing, and any citability category the fetch could not support. It should not invent an overlap percentage or a rank.

Crawler review:

> Review robots.txt for this site. Separate search, user-triggered, and training tokens. Do not allow GPTBot, ClaudeBot, or Google-Extended unless I say so.

Schema pass:

> Check the JSON-LD on this page. Keep a block only when the value is visible and true. Do not add FAQPage as a rich-result tactic.

Before/after, marked as a draft:

> Quote the current first sentence under the H2, then propose one sentence that states the heading's conclusion. Mark it as a draft. Do not publish it.

## Layout

| File | What it holds |
| --- | --- |
| `SKILL.md` | Triggers, intake, verification, scoring, ledger, measurement, and remediation report template |
| `references/platforms.md` | Search, user, and training crawlers; official Core Web Vitals |
| `references/schema.md` | Visible, true markup; linked blocks; FAQ rich results after 7 May 2026 |
| `references/verticals.md` | Informational guides, comparisons, calculators, professional services, e-commerce, hubs |
| `references/humanize.md` | Content humanization, anti-AI cadence, phrases to cut, and sentence rhythm rules |
| `references/example-audit.md` | Worked audit of a live page. Copy its shape and remediation output. |
| `references/house-rules-template.md` | Customizable template for brand conventions, lead answer styling, and regulatory disclosures. |
| `scripts/verify-page.sh` | Executable fetch of status, robots, canonical, sitemap, schema, title/meta, images, and outlinks |

## FAQ

### What is the difference between SEO, GEO, and AEO?

SEO is being indexed and eligible in Google and Bing. GEO and AEO are the same job seen from an answer engine: the page has to be fetchable by that product's search crawler, and the visible page has to state the fact. Google's own guide says optimizing for its generative AI features is SEO. This skill does not add a second set of ranking rules on top of that.

### Which agents can load it?

Gemini CLI and Google Antigravity, Claude Code and Claude Desktop, and Cursor or Windsurf. Any agent that can read `SKILL.md` from a skills directory can use it. The verify script needs a shell.

### Does the npm package register the skill?

No. npm delivers the files. Copy or link them into the agent's skills directory.

### Will an audit guarantee a ranking or a citation?

No. The skill reports what it could test and drafts changes. It does not predict a rank, and it does not publish a cross-engine citation percentage.

### Does the skill add backlinks or badges to the audited site?

No. The skill is 100% white-label and strictly produces audit findings and production remediation code. It never injects backlinks, badges, or hidden links into audited sites.

### Where do questions and bugs go?

Questions belong in [Discussions](https://github.com/grvmon/sniper-seo-geo-aeo/discussions). Defects and feature requests use the templates in [Issues](https://github.com/grvmon/sniper-seo-geo-aeo/issues). Vulnerabilities use [SECURITY.md](SECURITY.md), not a public issue.

## Author

**Gaurav Mongia**

[LinkedIn](https://www.linkedin.com/in/gaurav-a-mongia)

## License

[MIT](LICENSE).

Contributing: [CONTRIBUTING.md](CONTRIBUTING.md). Conduct: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Security: [SECURITY.md](SECURITY.md). Releases: [CHANGELOG.md](CHANGELOG.md). Citation: [CITATION.cff](CITATION.cff).
