# Step-by-Step Tutorial: Auditing & Optimizing with Sniper SEO + GEO + AEO

This hands-on guide walks you through using the `sniper-seo-geo-aeo` skill end to end. Whether you are running the verification script directly in your terminal or prompting an AI agent (Google Antigravity, Gemini CLI, Claude Code, or Cursor), this tutorial shows you how to audit a page, score citability, apply remediation code, and track citations.

---

## Table of Contents

- [Module 1: Terminal Quickstart (`verify-page.sh`)](#module-1-terminal-quickstart-verify-pagesh)
- [Module 2: Auditing with an AI Agent](#module-2-auditing-with-an-ai-agent)
- [Module 3: Deploying Remediation Code to Production](#module-3-deploying-remediation-code-to-production)
- [Module 4: Measuring Search & AI Citations](#module-4-measuring-search--ai-citations)
- [Troubleshooting & Common Edge Cases](#troubleshooting--common-edge-cases)

---

## Module 1: Terminal Quickstart (`verify-page.sh`)

The skill includes an executable script, `scripts/verify-page.sh`, that fetches a URL and inspects indexability, crawl rules, schemas, mobile compliance, and content quality. It requires only `curl` and `python3`.

### 1.1 Run a Basic Verification

From your repository root or skills folder, run:

```bash
bash scripts/verify-page.sh 'https://example.com/platform/data-pipeline/'
```

### 1.2 Emulate Googlebot Smartphone

Google indexes the mobile version of websites. Emulate the official Googlebot Smartphone User-Agent by adding `-g` or `--googlebot`:

```bash
bash scripts/verify-page.sh -g 'https://example.com/platform/data-pipeline/'
```

### 1.3 Structured JSON & Markdown Reports

* **Structured JSON (`-j` / `--json`):** Output machine-readable JSON for CI/CD pipelines, monitoring scripts, and agents:
  ```bash
  bash scripts/verify-page.sh -j 'https://example.com/guide/'
  ```
* **Executive Markdown Report (`-r` / `--report`):** Output a formatted Markdown summary table ready for PRs or client deliverables:
  ```bash
  bash scripts/verify-page.sh -r 'https://example.com/guide/'
  ```

### 1.4 How to Read the Output

The script outputs line-by-line factual evidence or `nt` (not tested). Look for these critical signals:

| Output Line | What It Means | Ideal State |
| :--- | :--- | :--- |
| `http_check: pass` | Final response code was 2xx. | `pass` (200 OK) |
| `hop_status: 200` | Shows HTTP status code of each hop. | Single clean `200` (no chains) |
| `robots_agent: [Token] ...` | Evaluates RFC 9309 rules for 15 search, user, and training crawlers. | `allow` for search bots |
| `canonical_matches_final: yes` | Canonical tag matches final fetched URL. | `yes` (`canonical_differs: none`) |
| `title_status: pass` | Title length falls between 30 and 65 characters. | `pass` (prevents SERP truncation) |
| `meta_description_status: pass`| Meta description falls between 70 and 160 characters. | `pass` |
| `og_title_matches_title: yes` | Checks if OpenGraph title matches HTML `<title>`. | `yes` (ensures consistency) |
| `heading_hierarchy: pass` | Evaluates DOM heading structure (H1 through H6) for skipped levels. | `pass` (valid outline) |
| `first_p_answer_ready: yes` | Evaluates lead paragraph for 35–65 word AI summary snippet. | `yes` (optimal answer length) |
| `img_dim_status: pass` | Checks explicit width/height and aspect ratios on images. | `pass` (CLS prevention) |
| `img_format_status: pass` | Evaluates modern formats (WebP/AVIF/SVG) vs legacy files. | `pass` (modern formats) |
| `img_oversized_count: 0` | Flags images exceeding 200 KB in file size. | `0` (optimized asset weight) |
| `viewport_status: pass` | Checks for `width=device-width` viewport tag. | `pass` (mobile readiness) |
| `soft_404_suspect: no` | Flags HTTP 200 responses that are actually error pages. | `no` |
| `ai_cliche_count: 0` | Scans for 19 formulaic generative AI phrases. | `0` (`humanize_status: pass`) |
| `schema_duplicate_types: none` | Checks if root entities (`Organization`) are split across blocks. | `none` (single `@graph`) |
| `llms_txt_status: ...` | Checks `/llms.txt` and flags SPA HTML fallbacks. | `404` or valid `200` markdown |

---

## Module 2: Auditing with an AI Agent

When loaded into an agent (Google Antigravity, Gemini CLI, Claude Code, Cursor, or Windsurf), the skill conducts an intake interview, runs the test script, scores citability, builds an evidence ledger, and writes copy-paste code.

### 2.1 Complete Page Audit Prompt

Paste this prompt to audit any URL:

```markdown
Audit https://example.com/guides/system-architecture/ for Google Search, Google AI Overviews, and ChatGPT Search.
- Target query: "distributed system architecture patterns"
- Market: Global, English
- SERP intent format: Informational Guide
- Competitors: https://competitor-a.com/architecture/, https://competitor-b.com/distributed-systems/
- Access: Public URL only (Search Console: NT)
- Training bots: Undecided (keep search crawlers allowed)

Follow the sniper-seo-geo-aeo procedure: collect intake, verify with verify-page.sh, score citability across the 5 categories, maintain the evidence ledger, and generate production remediation code.
```

### 2.2 Content Humanization Prompt

To audit and rewrite AI-generated prose so it passes Google's Helpful Content standards:

```markdown
Review the visible content of https://example.com/blog/cloud-cost-optimization/ using references/humanize.md.
1. Run verify-page.sh to check ai_cliche_count and humanize_status.
2. Identify and list any banned chatbot phrases ("in today's digital landscape", "delve into", "tapestry").
3. Rewrite the lead direct answer and the first 3 sections using high sentence burstiness, active voice, and concrete data points.
```

### 2.3 Robots.txt & Crawler Review Prompt

To inspect bot access without recommending modifications to on-page content:

```markdown
Review robots.txt for https://example.com/ using references/platforms.md.
Categorize access across:
1. Search crawlers (Googlebot, Bingbot, OAI-SearchBot, PerplexityBot, Claude-SearchBot)
2. User-triggered fetchers (ChatGPT-User, Claude-User, Perplexity-User)
3. Foundation model training crawlers (GPTBot, ClaudeBot, Google-Extended, CCBot)
Recommend an updated robots.txt that allows search while leaving training crawlers undecided.
```

---

## Module 3: Deploying Remediation Code to Production

Every full audit produces copy-paste production code in Section 6. Here is how to apply each deliverable to your codebase or CMS:

### Step 3.1: Update the Title and Meta Description

Paste the optimized title (30–65 characters) and meta description (70–160 characters) directly into your template's `<head>`:

```html
<head>
  <!-- 1. Optimized SERP Title: Front-loaded keyword, under 65 chars -->
  <title>Distributed System Architecture: Latency & Consensus Guide</title>

  <!-- 2. Optimized Meta Description: Accurate summary, 70-160 chars -->
  <meta name="description" content="Explore core distributed system architecture patterns, consensus algorithms, and real-world latency benchmarks with verified implementation examples.">

  <!-- 3. OpenGraph Social Parity -->
  <meta property="og:title" content="Distributed System Architecture: Latency & Consensus Guide">
  <meta property="og:description" content="Explore core distributed system architecture patterns, consensus algorithms, and real-world latency benchmarks with verified implementation examples.">
</head>
```

### Step 3.2: Insert the Direct Answer Card (For Google AI Overviews & Perplexity)

Answer engines extract self-contained passages that state the conclusion upfront. Place a lead direct answer block directly below the `<h1>` or byline:

```html
<main>
  <h1>Distributed System Architecture Patterns</h1>
  
  <!-- Lead Direct Answer Passage -->
  <section class="lead-summary-card" aria-label="Executive Summary">
    <p class="lead-text" id="direct-answer">
      <strong class="eyebrow">Architecture Summary</strong>
      Distributed system architecture partitions computing workloads across independent networked nodes to ensure high availability, fault tolerance, and horizontal scalability. By eliminating single points of failure through consensus protocols, distributed systems maintain data consistency across multi-region deployments.
    </p>
  </section>

  <!-- Body Content -->
</main>
```

Add this minimal CSS to your stylesheet to render a clean eyebrow badge without using plain-text label prefixes (e.g. avoid typing `Direct answer:`):

```css
.lead-summary-card {
  background: var(--bg-surface-secondary, #f8fafc);
  border-left: 4px solid var(--brand-accent, #2563eb);
  padding: 1rem 1.25rem;
  margin: 1.5rem 0;
  border-radius: 0 6px 6px 0;
}

#direct-answer .eyebrow {
  color: var(--brand-accent, #2563eb);
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.08em;
  display: block;
  margin-bottom: 6px;
}
```

### Step 3.3: Deploy Unified JSON-LD Schema (`@graph`)

Consolidate all structured data into a single linked `@graph` in `<head>` or at the end of `<body>`:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "Acme Engineering",
      "url": "https://example.com/",
      "logo": "https://example.com/assets/logo.png",
      "sameAs": [
        "https://www.linkedin.com/company/acme-example",
        "https://github.com/acme-example"
      ]
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com/",
      "name": "Acme Insights",
      "publisher": { "@id": "https://example.com/#organization" }
    },
    {
      "@type": "TechArticle",
      "@id": "https://example.com/guides/system-architecture/#article",
      "url": "https://example.com/guides/system-architecture/",
      "name": "Distributed System Architecture: Latency & Consensus Guide",
      "headline": "Distributed System Architecture: Latency & Consensus Guide",
      "description": "Explore core distributed system architecture patterns, consensus algorithms, and real-world latency benchmarks with verified implementation examples.",
      "isPartOf": { "@id": "https://example.com/#website" },
      "author": {
        "@type": "Person",
        "name": "Alex Smith",
        "jobTitle": "Principal Systems Architect",
        "sameAs": "https://www.linkedin.com/in/alex-smith-example"
      },
      "publisher": { "@id": "https://example.com/#organization" },
      "datePublished": "2026-03-15",
      "dateModified": "2026-11-10"
    }
  ]
}
</script>
```

> [!IMPORTANT]
> Verify that every property inside JSON-LD (author name, organization URL, telephone, pricing) is visible to human readers on the page. Do not include unrendered FAQ questions.

---

## Module 4: Measuring Search & AI Citations

Never guess whether an optimization worked. Measure real signals across search and answer engines:

### 4.1 Google Search Console

1. Navigate to **Search Results > Performance**.
2. Filter by **Page: Exact URL**.
3. Track shifts in:
   - **Average Position:** Check whether the target keyword moved toward the top 3 results.
   - **Total Clicks & Impressions:** Track impression gains after snippet and title updates.
   - **Generative AI Performance:** Monitor the separate AI Overview breakdown if active in your GSC property.

### 4.2 Web Analytics: AI Referral Traffic

Monitor session referrals from major AI answer engines. Filter your analytics referral source for:

- `chatgpt.com` (ChatGPT Search referrals)
- `perplexity.ai` (Perplexity search and citation citations)
- `gemini.google.com` (Direct Gemini user citations)
- `copilot.microsoft.com` (Microsoft Copilot referrals)

*(Note: AI engines often strip referrers, so actual traffic from AI interactions may appear as Direct traffic.)*

### 4.3 Weekly Frozen Citation Sampling

Maintain a consistent citation testing log across weekly runs:

| Date | Engine | Test Query | Cited? | Destination Link |
| :--- | :--- | :--- | :---: | :--- |
| 2026-11-10 | ChatGPT Search | *"What are core distributed system architecture patterns?"* | Yes | `https://example.com/guides/system-architecture/` |
| 2026-11-10 | Perplexity | *"Distributed systems consensus latency benchmarks"* | Yes | `https://example.com/guides/system-architecture/` |
| 2026-11-10 | Google AIO | *"distributed architecture patterns"* | No | Competitor cited |

---

## Troubleshooting & Common Edge Cases

- **SPA Catch-All Route (Soft 404 on `/llms.txt`):** If `verify-page.sh` reports `llms_txt_status: warn: soft_404 (returned html fallback)`, your server is serving an HTML page for missing text files. Return HTTP 404 or upload a real markdown `/llms.txt`.
- **Duplicate Root Entity Warnings:** If `schema_duplicate_types` warns about duplicate `Organization` nodes across multiple blocks, consolidate them into a single `<script type="application/ld+json">` with a `@graph` array.
- **Empty Title or JavaScript Shell (`js_shell_suspect: yes`):** If initial HTML has under 500 characters and contains `<script>` tags, the site is rendering clientside. Use server-side rendering (SSR) or dynamic pre-rendering so search bots receive visible HTML on initial fetch.
