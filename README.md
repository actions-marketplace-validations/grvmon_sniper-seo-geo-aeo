# Sniper SEO + GEO + AEO

> **Get your pages ranked on Google and cited by ChatGPT, Perplexity, and Claude.**  
> Stop guessing why your traffic dropped or why AI engines aren't quoting your content. Sniper tests your live web pages, uncovers what’s holding them back, and hands you ready-to-use fixes in seconds.

[![CI](https://github.com/grvmon/sniper-seo-geo-aeo/actions/workflows/ci.yml/badge.svg)](https://github.com/grvmon/sniper-seo-geo-aeo/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/grvmon/sniper-seo-geo-aeo)](https://github.com/grvmon/sniper-seo-geo-aeo/releases)
[![License: MIT](https://img.shields.io/github/license/grvmon/sniper-seo-geo-aeo)](https://github.com/grvmon/sniper-seo-geo-aeo/blob/main/LICENSE)

```bash
# Audit any page in 5 seconds (no installation needed):
npx @grvmon/sniper-seo-geo-aeo https://yourwebsite.com/blog-post/

# Or install it into your AI coding assistant:
npx skills add grvmon/sniper-seo-geo-aeo
```

---

### The Plain-English Truth About AI Search

* **Google AI Overviews is still Google Search:** According to [Google Search documentation](https://developers.google.com/search/docs/appearance/ai-features), there is no "secret AI tag" or magic file. Strong technical SEO and genuinely helpful answers are what get you featured.
* **Search traffic vs. AI training are different:** You can let ChatGPT and Perplexity find and quote your website to send you buyers, without letting AI companies scrape your content for free model training. Crawlers are split by purpose (e.g. OpenAI's `OAI-SearchBot` for search vs. `GPTBot` for training).
* **Zero BS, zero fake scores:** Most tools charge $200/month to show made-up "AI visibility percentages." Sniper only tests hard evidence: if something can't be proven by real code, it is marked `NT` (Not Tested)—never guessed.

📖 **Documentation:** [Step-by-Step Tutorial](TUTORIAL.md) • [Full Agent Workflow (`SKILL.md`)](SKILL.md) • [Wiki Guides](https://github.com/grvmon/sniper-seo-geo-aeo/wiki)

---

## What it does

### 1. 🚦 The Bot Check: Can Search & AI Engines Even See You?
Before spending hours rewriting content, make sure bots can actually read your page. We check:
* Are Google, ChatGPT, or Perplexity accidentally blocked from visiting via `robots.txt`?
* Does your page load properly, or are bots hitting a blank screen or a broken redirect?
* Are your search snippet, social preview cards (OpenGraph), and mobile formatting working as intended?

### 2. 🎯 The Citability Test: Will AI Quote You as a Source?
AI engines don't read rambling 3,000-word articles. When someone asks ChatGPT or Perplexity a question, the AI looks for quick, self-contained 45-word answers backed by facts. We score your content on whether it gives AI an easy, credible quote to cite.

### 3. 🧼 The Humanizer: Kills Robotic AI Buzzwords
Nothing destroys buyer trust faster than content that sounds like raw ChatGPT output. We scan your text for 60+ overused AI clichés—words like *"delve"*, *"game changer"*, *"testament to"*, and *"in today's digital landscape"*—so your brand sounds like a real, authoritative human expert.

### 4. 📦 The Fix-It Kit: Copy-Paste Updates in 2 Minutes
We don't just dump a list of technical errors on your desk. You get ready-to-publish assets:
* **Click-worthy Titles & Descriptions** designed to win clicks on Google.
* **Direct-Answer Snippets** crafted for Google AI Overviews and ChatGPT summaries.
* **Structured Data (Schema)** that tells bots exactly who wrote the article and why you're the authority.
* **100% White-Label:** Zero promotional backlinks, no watermarks, and no forced badges.

## Contents

- [What it does](#what-it-does)
- [Features](#features)
- [Supported engines](#supported-engines)
- [Install](#install)
- [Usage](#usage)
- [Tutorial](TUTORIAL.md)
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

### 1. Instant CLI Run via npx (No install required)

Run verification directly in any terminal:

```bash
npx @grvmon/sniper-seo-geo-aeo 'https://example.com/guide/'
# Or emulate Googlebot Smartphone User-Agent:
npx @grvmon/sniper-seo-geo-aeo -g 'https://example.com/guide/'
```

### 2. Agent Skills Manager (`skills.sh`)

The shortest path for AI agents:

```bash
npx skills add grvmon/sniper-seo-geo-aeo
```

### 3. GitHub Actions CI/CD Pipeline

Add automated SEO/GEO verification to your deployment workflows:

```yaml
- name: SEO & AI Audit
  uses: grvmon/sniper-seo-geo-aeo@main
  with:
    url: 'https://preview.example.com/page/'
    googlebot: 'true'
```

### 4. Direct Agent Installation

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

For a complete step-by-step walkthrough covering CLI commands, prompt templates, and remediation code deployment, see [`TUTORIAL.md`](TUTORIAL.md).

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
