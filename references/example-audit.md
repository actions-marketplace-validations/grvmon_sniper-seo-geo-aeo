# Worked example: audit of a live page

This is a complete worked audit of an enterprise SaaS platform page (`https://example.com/platform/data-pipeline/`). It demonstrates the end-to-end workflow: intake, technical verification with `scripts/verify-page.sh`, citability scoring, an evidence ledger, and draft remediation code to improve the page for Google and AI answer engines.

> **Illustrative only.** `example.com` is a placeholder. No figure below was measured, and the retrieval dates and `verified` statuses show the format, not real evidence.

---

## 1. Intake

| Field | Value |
| --- | --- |
| **URL** | `https://example.com/platform/data-pipeline/` |
| **Market** | Global, English (US / EMEA). B2B Data Engineering & DevOps leads. |
| **Intent** | Commercial Landing Page (SERP format match not checked: `NT`). Primary query: "real-time data pipeline architecture". The user is evaluating architecture patterns and platform capabilities. |
| **Competitors** | `https://competitor-a.com/data-pipeline/`, `https://competitor-b.com/stream-processing/` |
| **Access** | Public URL, live HTTP response, Google Search Console (read access), Bing Webmaster Tools (read access). Server logs: NT. |
| **Baseline** | Google Search Console: 1,420 monthly clicks, average position 8.4 on primary keyword. Zero AI Overview citations detected in weekly citation sampling. |
| **Training crawlers** | `undecided`. `robots.txt` currently allows search bots and defers training crawlers to site policy. |
| **Corrections policy** | Visible at `https://example.com/editorial-policy/` with a dated change log. |

---

## 2. Technical checks

Verified with `bash scripts/verify-page.sh 'https://example.com/platform/data-pipeline/'`.

| Check | Result | Evidence |
| --- | --- | --- |
| **HTTP status / redirects** | pass | `http_status: 200`, `redirects: 0`, `hop_status: 200`. Single clean 200 response with no redirect chains. |
| **Rendered HTML** | pass | `initial_html_text_chars: 28450`, `js_shell_suspect: no`. Core body text, code samples, and headings are fully present in initial server response. |
| **robots / X-Robots-Tag** | pass | `meta_robots: (none)` (defaults to index, follow). `x_robots_tag: (none)`. `Googlebot` and `Bingbot` allowed in `robots.txt`. |
| **Canonical** | pass | `canonical_1: https://example.com/platform/data-pipeline/`, `canonical_unique_count: 1`, `canonical_fetch_status: 200`, `canonical_matches_final: yes`. |
| **Sitemap** | pass | Declared in `robots.txt`, status 200, URL count: 412, `in_sitemap: yes`. |
| **Schema matches visible text** | fail | JSON-LD `@graph` parses (`Organization`, `WebSite`, `WebPage`, `SoftwareApplication`, `FAQPage`). FAQ contains 2 questions not visible in page body; phone number in `Organization` node is missing from visible footer. |
| **Internal links / orphans** | pass | `internal_outlinks: 34`. Page receives 18 inbound links from docs and solution hubs. Not an orphan. |
| **Image SEO** | pass | `img_count: 6`, `img_missing_alt: 0`, all diagrams have descriptive alt text and explicit `width`/`height` attributes. |

Crawler access summary from `scripts/verify-page.sh`:

| Token | Job | Group | Status | Note |
| --- | --- | --- | --- | --- |
| **Googlebot, Bingbot** | Search | `*` | allow | Eligible for Google Search, AI Overviews, and Bing Copilot. |
| **OAI-SearchBot, Claude-SearchBot, PerplexityBot** | Search | own group | allow | Eligible for ChatGPT search, Claude search, and Perplexity indexation. |
| **ChatGPT-User, Claude-User, Perplexity-User** | User | own group | allow | Permitted to fetch on direct user prompt. |
| **GPTBot, Google-Extended, ClaudeBot** | Training | `*` | allow (implicit) | No group of their own, so they inherit `*`. Record the owner's choice as `undecided` until they decide. |

---

## 3. Citability score

Sample is the first 8 H2 headings and the first 8 body paragraphs of at least 20 words.

| Category | Points | Weight | Evidence / Calculation |
| --- | :---: | :---: | --- |
| **answer** | 8/10 | 30 | 6 of 8 H2s lead with an explicit conclusion in the first sentence. `floor(10 × 6 / 8 + 0.5) = 8`. |
| **contain** | 8/10 | 20 | 6 of 8 sampled paragraphs are self-contained with explicit referents (no dangling pronouns). `floor(10 × 6 / 8 + 0.5) = 8`. |
| **structure** | 8/10 | 20 | Single H1, logical nesting, architectural comparison table present, bulleted step list for setup. Subtracted 2 points for one skipped heading level (H2 to H4). |
| **sourced** | 7/10 | 15 | 5 of 7 benchmark metrics cite primary datasets (Kafka throughput specs, AWS latency figures, public benchmark repo). `floor(10 × 5 / 7 + 0.5) = 7`. |
| **original** | 10/10 | 15 | Includes proprietary benchmark latency graph and reproducible GitHub test repo absent from all competitor pages. |

```
raw = (8/10 × 30) + (8/10 × 20) + (8/10 × 20) + (7/10 × 15) + (10/10 × 15)
    = 24.0 + 16.0 + 16.0 + 10.5 + 15.0 = 81.5
coverage = 30 + 20 + 20 + 15 + 15 = 100
overall = floor(100 × 81.5 / 100 + 0.5) = 82
```

`answer`, `contain` and `original` are rater-judged proxies. Compare scores only across runs that use the same method.

---

## 4. Top 3 fixes to win rankings & citations

| Rank | Fix | Impact | Effort | Evidence ID |
| :---: | --- | :---: | :---: | :---: |
| **1** | **Rewrite Title & Meta for Search Intent:** Current title is 22 chars ("Data Pipeline Platform") and does not name the primary query. Rewrite it at 60 chars with the keyword up front ("Real-Time Data Pipeline Architecture: 2026 Engineering Guide") so the snippet says what the page covers. | High | Low | L1, L8 |
| **2** | **Direct Answer Snippet Block:** Add a standalone answer paragraph (about 44 words) under the H1 in a `#direct-answer` container so the page states its conclusion in a quotable passage. | High | Low | L2, L9 |
| **3** | **Clean JSON-LD Schema Discrepancies:** Remove 2 unrendered FAQ nodes and synchronize `Organization` phone/address with visible footer text so the markup matches what readers see. | Med | Low | L3, L4 |

---

## 5. Evidence ledger

| Id | Claim | Evidence | Source | Retrieved | Status |
| --- | --- | --- | --- | --- | --- |
| **L1** | Page returns 200, is self-canonical, and is in sitemap | `http_status: 200`, `canonical_matches_final: yes`, `in_sitemap: yes` | `scripts/verify-page.sh` | 2026-11-10 | verified |
| **L2** | Citability overall score is 82 with coverage 100 | Arithmetic detailed in Citability section | Audit pass | 2026-11-10 | verified |
| **L3** | 2 of 5 `FAQPage` questions in JSON-LD are absent from visible body text | JSON-LD compared with visible HTML by hand | Manual review | 2026-11-10 | verified |
| **L4** | Phone number `+1-800-555-0199` in JSON-LD does not exist in visible footer | Visible footer compared with Organization schema by hand | Manual review | 2026-11-10 | verified |
| **L5** | Robots.txt allows all major search and answer engine crawlers | `robots_agent` output for Googlebot, Bingbot, OAI-SearchBot, PerplexityBot | `https://example.com/robots.txt` | 2026-11-10 | verified |
| **L6** | Google Search Console baseline: 1,420 monthly clicks, position 8.4 | Search Performance report (last 28 days) | Google Search Console | 2026-11-10 | verified |
| **L7** | Core Web Vitals meet official good thresholds (LCP: 1.8s, INP: 85ms, CLS: 0.02) | Chrome UX Report (CrUX) 75th percentile field data | Google Search Console | 2026-11-10 | verified |
| **L8** | Title is 22 chars, under the 30-char lint minimum, and does not name the primary query | `title_chars: 22`, `title_status: warn` | `scripts/verify-page.sh` | 2026-11-10 | verified |
| **L9** | Lead answer paragraph contains no plain-text label prefix | `first_p_label_prefix: no` | `scripts/verify-page.sh` | 2026-11-10 | verified |
| **L10** | Original benchmark methodology is published on GitHub with MIT license | Visible repository link on page | `https://github.com/example/stream-benchmarks` | 2026-11-10 | verified |

---

## 6. Production-ready remediation code

### A. Title & Meta Description (Copy-Paste)

```html
<!-- Proposed Title (60 chars, front-loaded keyword) -->
<title>Real-Time Data Pipeline Architecture: 2026 Engineering Guide</title>

<!-- Proposed Meta Description (150 chars, accurate summary of the page) -->
<meta name="description" content="Explore real-time data pipeline architecture patterns, throughput benchmarks, and end-to-end stream processing frameworks with verified code examples.">
```

### B. Lead Answer Block for Google AI Overviews & Perplexity

```html
<section class="lead-summary-card" aria-label="Executive Summary">
  <p class="lead-text" id="direct-answer">
    <strong class="eyebrow">Architecture Summary</strong>
    A real-time data pipeline ingests, transforms, and delivers continuous event streams with sub-second latency using distributed message brokers (such as Apache Kafka), stream processing compute engines, and sink destinations. Compared with batch jobs, it shortens the delay between an event and its availability downstream.
  </p>
</section>
```

### C. Connected JSON-LD Schema (`@graph` format)

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "Example Technologies Inc.",
      "url": "https://example.com/",
      "logo": "https://example.com/assets/logo.png",
      "sameAs": [
        "https://www.linkedin.com/company/example-tech",
        "https://github.com/example"
      ]
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com/",
      "name": "Example Platform",
      "publisher": { "@id": "https://example.com/#organization" }
    },
    {
      "@type": "TechArticle",
      "@id": "https://example.com/platform/data-pipeline/#article",
      "url": "https://example.com/platform/data-pipeline/",
      "name": "Real-Time Data Pipeline Architecture: 2026 Engineering Guide",
      "headline": "Real-Time Data Pipeline Architecture: 2026 Engineering Guide",
      "description": "Explore real-time data pipeline architecture patterns, throughput benchmarks, and end-to-end stream processing frameworks with verified code examples.",
      "isPartOf": { "@id": "https://example.com/#website" },
      "author": {
        "@type": "Person",
        "name": "Jane Doe",
        "jobTitle": "Principal Infrastructure Architect",
        "sameAs": "https://www.linkedin.com/in/jane-doe-example"
      },
      "publisher": { "@id": "https://example.com/#organization" },
      "datePublished": "2026-02-15",
      "dateModified": "2026-11-10"
    }
  ]
}
</script>
```

---

## 7. Measurement plan

- **Google Search Console:** Track Performance > Search Results. Filter by Page URL. Monitor average position shift on "real-time data pipeline architecture" and impressions growth over 30 days.
- **AI Referrals:** Monitor referral traffic from `chatgpt.com`, `perplexity.ai`, `gemini.google.com`, and `copilot.microsoft.com` in web analytics.
- **Citation Sampling:** Perform weekly test queries across ChatGPT, Claude, and Perplexity for:
  - *"What is real-time data pipeline architecture?"*
  - *"Best stream processing architecture patterns 2026"*
  Log whether `https://example.com/platform/data-pipeline/` is cited as a source link.

---

## 8. Still not tested

- Server access logs for Googlebot crawl frequency and HTTP 304 response rates.
- Cross-region CDN edge response times outside US-East.
