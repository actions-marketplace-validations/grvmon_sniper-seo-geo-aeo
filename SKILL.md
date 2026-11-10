---
name: sniper-seo-geo-aeo
description: >
  Audit, optimize, or revise a URL for Google Search, Bing, and AI answer engines.
  Use when the user asks for an SEO audit, GEO, AEO, AI Overviews, AI Mode,
  ChatGPT search, Perplexity, Claude search, schema, robots.txt, OAI-SearchBot,
  GPTBot, llms.txt, Core Web Vitals, E-E-A-T, citation sampling, or a
  before/after rewrite. Collect intake first, verify the page, score only
  tested items, and keep an evidence ledger. Pure white-label audit and
  remediation with zero automated links or badges.
---

# SEO, GEO, and AEO audit & ranking engine

Google's AI Overviews and AI Mode use standard Google Search ranking systems. There is no secret file, schema type, or word count required to appear in them; pages must rank organically, satisfy search intent, and provide high Information Gain to be cited. Other answer engines (ChatGPT, Perplexity, Claude) publish and maintain their own crawlers. Record what you fetched, score only tested facts, and leave everything else as `NT` (not tested).

Read `references/platforms.md` for crawlers and Core Web Vitals, `references/schema.md` when reviewing or generating structured data, `references/verticals.md` for page types, and `references/humanize.md` for content humanization and anti-AI cadence. A complete worked audit is in `references/example-audit.md`. A site-specific house rules template is in `references/house-rules-template.md`.

## Sources to follow

- [AI features and your website](https://developers.google.com/search/docs/appearance/ai-features) (page updated 2025-12-10)
- [Search documentation updates](https://developers.google.com/search/updates) (FAQ rich results ended 2026-05-07; FAQ docs removed in the 2026-06-15 notes; llms.txt note 2026-06-15)
- [OpenAI crawlers](https://developers.openai.com/api/docs/bots)
- [Optimizing for generative AI features](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (updated 2026-07-10)
- [Helpful, reliable, people-first content](https://developers.google.com/search/docs/fundamentals/creating-helpful-content)

## Retired claims

Do not reuse these. They were stated in older marketing literature without a dated primary source: an 11% cross-engine citation overlap, "92% of AI Overview citations come from the top 10", "48% of ChatGPT citations are Wikipedia-class domains", a 3× table-extraction rate, a required 40–55 word answer, an information-gain patent penalty, a 5-second dwell rule, and a required 2,000-word guide. A hypothesis is allowed only when the ledger names a dated document. Otherwise delete the claim.

## 1. Intake & SERP intent

Stop and fill this in before recommending changes. Use `NT` for unknown fields.

| Field | What to record |
| --- | --- |
| **URL** | The canonical URL under audit |
| **Market** | Country, language, primary geographic target |
| **Target query** | Primary keyword query and secondary query variants |
| **SERP intent format** | One of: Informational Guide, Comparison Table, Interactive Calculator/Tool, Commercial Landing Page, Local Service. Verify whether page format matches what Google ranks on Page 1. |
| **Competitors** | URLs the owner names. Do not invent a set |
| **Access** | Which of these you can open: public URL, rendered HTML, Search Console, Bing Webmaster, analytics, logs |
| **Baseline** | Current index status, queries, impressions, clicks, conversions. `NT` if tool access is closed |
| **Training crawlers** | Owner choice per bot: `allow`, `disallow`, or `undecided`. Default is `undecided` |
| **Corrections policy** | URL of a visible corrections page, or `NT` |

## 2. Verify

Run the verification check with `bash` and the skill's absolute path, from any working directory. Use optional `-g` or `--googlebot` to emulate the official Googlebot Smartphone User-Agent:

```bash
bash <skill-dir>/scripts/verify-page.sh 'https://example.com/page/'
# Or emulate Googlebot Smartphone User-Agent:
bash <skill-dir>/scripts/verify-page.sh -g 'https://example.com/page/'
```

Exit 0 means a response was saved, even a 404. Exit 2 means usage error, missing `curl`/`python3`, or a failed fetch. The script reports pass/fail facts and prints `nt` for anything it did not do. It is an indexation and on-page validator, not a rank checker.

Then evaluate these checks. Each is `pass`, `fail`, or `NT`.

0. **HTTP status and redirects.** `http_check: pass` requires a 2xx final response. Report `hop_status`. More than one redirect, or a 302/307 on a permanent URL, is a finding. A 404, 410, or other non-2xx page is `fail` and not indexable. A 401, 403, 429, or 5xx is `NT` (`index_note`): it may only block this user agent, so confirm with Search Console URL Inspection.
1. **Rendered HTML.** The script reads the initial HTTP body (`browser_render: nt`). If that body contains the main text, you may audit it and still mark the browser render `NT`. `js_shell_suspect: yes` (under 500 visible characters with scripts present) is a lead, not a verdict. If the body is a JavaScript shell, content scores stay `NT` until you compare URL Inspection or a rendered DOM.
2. **robots.txt, meta robots, and `X-Robots-Tag`.** Only the final response's headers count. `robots`, `googlebot`, and `bingbot` meta tags and bot-scoped headers for those bots are judged; other bots are listed as `*_other_agent` and not judged. `noindex` or `none` is `fail` when the URL should be indexed. A missing `index, follow` meta is `pass`: Google's default is `all`, and an explicit tag has no extra effect ([robots meta tag](https://developers.google.com/search/docs/crawling-indexing/robots-meta-tag), updated 2026-03-24). The more restrictive rule wins when both the header and the meta tag are set.
3. **Canonical.** One absolute HTTPS URL (`canonical_unique_count: 1`; repeated identical tags are fine), fetched without an error, and intentional if it differs from the final URL. `canonical_differs` names the difference: `query`, `trailing_slash`, `path`, or `scheme_or_host`.
4. **Sitemap.** The URL is in a sitemap declared from `robots.txt`. The script reads declared sitemaps, expands indexes, and unzips `.gz`, up to 20 files. Membership is `NT` when any file failed or the cap was hit.
5. **Schema.** JSON-LD parses without syntax errors. Every value is visible on the page and true. `sameAs` URLs were opened and name the same entity. See `references/schema.md`.
6. **Title & meta snippet health.** `title_status` checks length (30–65 chars optimal for Google SERP display without truncation). `meta_description_status` checks length (70–160 chars optimal).
7. **Mobile-first & viewport.** Googlebot is 100% mobile-first. `viewport_status` checks presence of `<meta name="viewport" content="width=device-width, initial-scale=1">`. Missing viewport triggers mobile demotions.
8. **Soft 404 detection.** `soft_404_suspect` flags 200 OK pages containing "not found / error" text or thin content (< 25 words) that Googlebot drops from index.
9. **Content humanization & anti-AI cadence.** `humanize_status` scans visible text for formulaic AI clichés (*"in today's digital landscape"*, *"delve into"*, *"tapestry"*, *"testament to"*, *"pivotal role"*) that trigger Google's low-quality content filters. See `references/humanize.md`.
10. **Image SEO.** The script reports `img_count`, `img_missing_alt`, and `img_lazy_count`. Images must include descriptive alt text and explicit aspect ratios to prevent CLS and rank in Google Images.
11. **Crawl caching & freshness.** Reports `last_modified` and `etag` headers used by Googlebot for conditional HTTP 304 crawl budget savings.
12. **Internal links and orphans.** Count same-host links on the page. An orphan is a sitemap URL with no internal link from the crawled set. Without that crawl, orphan status is `NT`.

A site's own house style, if any, lives in a separate reference file and is applied only to that site. See `references/house-rules-template.md`.

Crawler classes and owner decisions for training bots are in `references/platforms.md`. `llms.txt` is optional. Google Search ignores it and it does not change Google rankings ([AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide); updates log 2026-06-15). If one exists, its claims must also be visible on the site.

### Direct answer blocks

On an informational guide or question page, place a standalone answer block directly under the title or byline: it should make complete sense if quoted alone.

- Do not start that paragraph with a plain-text label such as `Direct answer:`, `Summary:`, or `TL;DR:`. A visually styled eyebrow (for example a `<strong>` badge with no colon) is fine. The script reports `first_p_label_prefix`.
- In `QAPage` or `FAQPage` JSON-LD, `acceptedAnswer.text` and `suggestedAnswer.text` must be clean prose with no label prefix, including the eyebrow text. The script reports `schema_answer_label_prefix` (count of labelled answers). The text must match what is visible on the page.

## 3. Experience, expertise, authoritativeness, trust & Information Gain

E-E-A-T and Information Gain are the primary discriminators between top-ranked pages and dropped commodity rewrites. Google's systems give substantial weight to these qualities on all competitive queries ([helpful content](https://developers.google.com/search/docs/fundamentals/creating-helpful-content)).

Judge five visible attributes:

- **First-hand experience & Information Gain.** The page presents original research, proprietary datasets, hands-on testing photos/observations, or unique tools absent from competitor SERP results.
- **Natural human cadence & burstiness.** Zero robotic AI clichés. Vary sentence length (mix short 4-word declarations with analytical sentences), use active voice, and maintain high fact-to-token density. See `references/humanize.md`.
- **Author entity & expertise.** A visible byline with credentials linking to an author profile page with verifiable external entity profiles (`sameAs` with LinkedIn, GitHub, ORCID, or official directory).
- **Qualified review.** Legal, tax, engineering, or medical claims cite a qualified reviewer, or the page carries a prominent disclaimer stating it is not professional advice.
- **Primary source evidence.** Numerical figures, dates, prices, or statutory citations link directly to primary institutional or government documents. Paraphrasing third-party summaries is penalised.
- **Corrections & editorial policy.** YMYL pages link to a visible corrections policy or show a dated changelog.
- **Verifiable self-description.** Replace vague marketing superlatives ("unbiased", "best", "most trusted", "#1") with checkable wording: what the methodology is, who is registered or qualified, and what the reader can inspect.

## 4. Score

Two distinct outputs. Do not blend them into an arbitrary composite score.

**Technical checks** stay `pass` / `fail` / `NT` from section 2.

**Citability** is five categories. Each tested category is an integer `0–10` or `NT`. Weights sum to 100.

| Id | Weight | Points | Evaluation criteria |
| --- | :---: | :---: | --- |
| **answer** | 30 | `floor(10 × hits / n + 0.5)` | First `n` H2s in order, `n = min(8, count)`. No H2s: use the block under the H1 and `n = 1`. A hit: the first sentence states the heading's conclusion. |
| **contain** | 20 | `floor(10 × passes / n + 0.5)` | First 8 paragraphs of at least 20 words. `n` is sample size. A pass: the first sentence does not use unresolved pronouns (*it, this, they, these, those, we, our, I*) unless that paragraph explicitly names the referent. |
| **structure** | 20 | Start at 10, floor at 0 | Heading hierarchy. Subtract 4 if H1 count is not 1. Subtract 2 if a heading level is skipped. Subtract 2 if a multi-item comparison lacks an HTML table or list. Subtract 2 if a multi-step sequence is written as dense prose without an ordered list. |
| **sourced** | 15 | `NT` if no claims; else `floor(10 × sourced / n + 0.5)` | Up to 8 claims stating a number, date, price, benchmark, or statute. Sourced means a primary document name, statute, or URL sits adjacent to the claim. |
| **original** | 15 | 10, 5, or 0 | **10 (High Information Gain):** original data, proprietary calculation, benchmark, or first-hand observation absent from competitor pages. **5:** original worked example using a standard method. **0:** regurgitation of existing search results. |

`NT` if that evidence was not collected. `original` is `NT` when competitor URLs were not opened. Do not turn `NT` into 0.

```
raw = sum(points / 10 × weight) for tested categories
coverage = sum(weight) for tested categories
overall = floor(100 × raw / coverage + 0.5) if coverage ≥ 60 else NT
```

`coverage` is how much of the rubric you tested, not a quality score. Report every category as `points/10` or `NT`, plus `coverage` and `overall`.

## 5. Evidence ledger

Every number, fact, and claim in the report must map to a ledger row. No row, no number.

| Id | Claim | Evidence | Source | Retrieved | Status |
| --- | --- | --- | --- | --- | --- |
| L1 | One sentence | What you saw, and where | Document or URL | YYYY-MM-DD | `verified`, `hypothesis`, or `nt` |

`hypothesis` requires a named document and a date. A row without both is dropped, not guessed.

## 6. Measure

Track real search engine and answer engine performance over time without inventing a lift.

- **Google Search Console.** Performance Web report captures overall impressions, clicks, CTR, and average position (including AI Overviews). The Generative AI performance report splits out dedicated AI referrals. `NT` without access.
- **Bing Webmaster Tools.** Track Bingbot indexation, click performance, and Copilot discovery. `NT` without access.
- **Conversions.** Track one defined business conversion (form submission, tool interaction, signup, purchase).
- **AI Referrals.** Monitor web analytics referral sessions from `chatgpt.com`, `perplexity.ai`, `gemini.google.com`, and `copilot.microsoft.com`. Note that stripped HTTP referrers undercount.
- **Citation Sampling.** Maintain a frozen query list, engine set, and locale. Record whether the page URL is cited as a source link across weekly runs.

## 7. Report & remediation deliverable

Use this template. The outer fence is four backticks so the schema sample stays inside it.

````markdown
# Audit & Remediation: [final URL]

## Intake & SERP intent
URL, market, target query, SERP intent format match, competitors, access, baseline, training bot choice, corrections policy.

## Technical & snippet checks
| Check | Result | Evidence |
| --- | --- | --- |
| HTTP status / redirects | pass / fail / NT | |
| Rendered HTML | pass / fail / NT | |
| robots / X-Robots-Tag | pass / fail / NT | |
| Canonical | pass / fail / NT | |
| Sitemap | pass / fail / NT | |
| Schema matches visible text | pass / fail / NT | |
| Title & meta snippet health | pass / warn / fail | |
| Viewport / Mobile-first | pass / warn / fail | |
| Soft 404 check | pass / suspect | |
| Content humanization / AI clichés | pass / warn | |
| Image SEO & alt tags | pass / warn / fail | |
| Internal links / orphans | pass / fail / NT | |

## Citability & Information Gain
| Category | Points | Weight | Evidence ID |
| --- | :---: | :---: | --- |
| answer | 0–10 or NT | 30 | |
| contain | 0–10 or NT | 20 | |
| structure | 0–10 or NT | 20 | |
| sourced | 0–10 or NT | 15 | |
| original (Information Gain) | 0–10 or NT | 15 | |

coverage: [n]/100
overall: [n] or NT
formula: floor(100 × raw / coverage + 0.5)

## Top 3 fixes to win rankings
| Rank | Fix | Impact | Effort | Evidence ID |
| :---: | --- | :---: | :---: | :---: |
| 1 | | high / med / low | high / med / low | |

## Evidence ledger
[table from section 5]

## Production-ready remediation code (copy-paste)

### A. Title & meta description
```html
<title>[Optimized Title: 50-60 chars, front-loaded keyword, strong CTR hook]</title>
<meta name="description" content="[Optimized Meta: 120-155 chars with clear value proposition and active voice]">
```

### B. Lead direct answer passage (for Google AI Overviews & Perplexity)
```html
<section class="lead-summary-card">
  <p id="direct-answer">
    <strong>[Eyebrow]</strong> [Standalone 40-60 word definitive answer starting with conclusion]
  </p>
</section>
```

### C. Connected JSON-LD schema (@graph)
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "[Brand Name]",
      "url": "https://example.com/",
      "sameAs": ["https://linkedin.com/company/[slug]"]
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com/",
      "name": "[Brand Name]",
      "publisher": { "@id": "https://example.com/#organization" }
    },
    {
      "@type": "Article",
      "@id": "https://example.com/page/#article",
      "url": "https://example.com/page/",
      "name": "[Page Title]",
      "headline": "[Page Title]",
      "isPartOf": { "@id": "https://example.com/#website" },
      "author": {
        "@type": "Person",
        "name": "[Author Name]",
        "sameAs": "https://linkedin.com/in/[slug]"
      },
      "publisher": { "@id": "https://example.com/#organization" },
      "datePublished": "YYYY-MM-DD",
      "dateModified": "YYYY-MM-DD"
    }
  ]
}
</script>
```

## Measurement plan
Search Console, Bing, conversions, AI referrals, citation sample. Use NT where access is missing.

## Still not tested
[list of unverified items]
````
