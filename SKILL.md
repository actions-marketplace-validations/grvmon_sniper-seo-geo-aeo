---
name: sniper-seo-geo-aeo
description: The definitive modern SEO, GEO (Generative Engine Optimization), and AEO (Answer Engine Optimization) master skill. Unifies traditional Google/Bing ranking factors with AI answer engine citation mechanics (Google AI Overviews, ChatGPT Search, Perplexity, Gemini, Claude). Covers algorithmic ranking levers (Information Gain, NavBoost dwell signals, E-E-A-T entity graphs), the Content Humanizer (writing for real humans, plain English, conversational empathy, anti-AI cadence), technical crawlability & AI crawler permissions, /llms.txt, full Schema @graph generation, 45-word extractable answer passages, platform-specific GEO matrices, and regression drift detection.
---

# Sniper SEO + GEO + AEO Master Operating System

> **The Modern Search Law (2026):**
> What ranks #1 on Google is precisely what AI answer engines (ChatGPT Search, Perplexity, Claude, Gemini, Google AI Overviews) synthesize and cite. Both demand the exact same foundation: machine-readable infrastructure, verified entity knowledge graphs, high information gain, and direct, extractable answers.

---

## 1. The 7 Algorithmic Ranking Levers

Every audit, content brief, or technical recommendation must satisfy these 7 algorithmic and behavioral mechanics:

```
                            THE 2026 RANKING ALGORITHM
 ┌──────────────────────────────────────┬──────────────────────────────────────┐
 │     TRADITIONAL SERP (GOOGLE)        │       AI ANSWER ENGINES (AEO/GEO)    │
 ├──────────────────────────────────────┼──────────────────────────────────────┤
 │ 1. Information Gain Score (Patent)   │ 5. Passage Extractability & RAG      │
 │ 2. NavBoost & Click Satisfaction     │ 6. Entity Consensus & Co-occurrence  │
 │ 3. Deep E-E-A-T & Knowledge Graph    │ 7. High Fact-to-Token Density        │
 │ 4. PageRank & Anchor Equity Flow     │                                      │
 └──────────────────────────────────────┴──────────────────────────────────────┘
```

### Lever 1: Information Gain Score (Google Patent)
- **The Mechanic:** Google detects whether a page merely summarizes existing top-10 SERP results. Duplicate sentiment or rephrased consensus receives an Information Gain penalty.
- **The Rule:** Every page must include at least **two novel data points**: proprietary calculations, original survey statistics, dedicated diagrams, verified local statutory references, or direct expert verdict quotes.

### Lever 2: NavBoost & Searcher Task Accomplishment (STA)
- **The Mechanic:** User interaction signals (click satisfaction, dwell time, and absence of pogo-sticking back to the SERP) govern rank retention.
- **The Rule:** Time-to-Answer must be under **5 seconds**. The primary search answer must appear above the fold. Never force the user to scroll through introductory filler or "What is X?" before answering a transactional or navigational query.

### Lever 3: Deep Entity Disambiguation (Knowledge Graph)
- **The Mechanic:** Search engines index *entities*, not keyword strings. Ambiguous organizations or pseudonymous authors receive low trust scores.
- **The Rule:** Real `Person` author schemas linked via `sameAs` to credible external profiles (LinkedIn, Wikipedia, Wikidata, ORCID). Author entities must declare explicit topic competence (`knowsAbout`).

### Lever 4: Passage Extractability & RAG Chunking
- **The Mechanic:** LLMs chunk web pages into 100–300 token passages. Vector similarity selects passages that are 100% self-contained and answer questions directly.
- **The Rule:** The **45-Word Answer Box**: immediately beneath each question-based `<h2>` or `<h3>`, provide a 40–55 word direct, factual declaration. No opening conjunctions ("However", "So"), no pronouns without antecedents.

### Lever 5: Search Intent to Layout Mapping (SXO)
- **The Mechanic:** Matching the exact visual layout Google and AI engines expect for the target query type:
  - *Comparison / Alternative queries:* Mandatory responsive HTML/Markdown comparison table.
  - *Calculation queries:* Interactive calculator tool above the fold + worked formula example.
  - *Process / How-to queries:* Numbered ordered lists with bold action verbs.
  - *Definitional queries:* Inverted-pyramid glossary callout box.

### Lever 6: Internal Link Equity & Crawl Depth
- **The Mechanic:** Click depth > 3 from the root domain diminishes crawl frequency and PageRank transfer.
- **The Rule:** Hub-and-Spoke cluster architecture. Contextual in-content anchors with natural descriptive phrases (never generic "click here" or over-optimized exact-match keyword stuffing).

### Lever 7: Anti-AI Footprint / Quality Filter
- **The Mechanic:** Google's Helpful Content System penalizes synthetic boilerplate, predictable rhythm, and conversational chatbot filler.
- **The Rule:** Purge AI conversational residue ("In today's fast-paced digital world", "Delve into", "A tapestry of", "Crucial to remember"). Maintain active voice, numerical precision, and varied sentence lengths.

---

## 2. Pillar 1: Technical & AI Crawler Infrastructure

### A. Dual-Engine Crawler Permissions (`robots.txt`)
Ensure both search engine indexers and AI foundation crawlers are explicitly managed.

```txt
# Traditional Search Crawlers
User-agent: Googlebot
User-agent: Bingbot
User-agent: Slurp
User-agent: DuckDuckBot
Allow: /

# AI Search & Answer Engine Crawlers (Essential for GEO)
User-agent: GPTBot
User-agent: ChatGPT-User
User-agent: ClaudeBot
User-agent: PerplexityBot
User-agent: Applebot-Extended
User-agent: Google-Extended
User-agent: Cohere-ai
Allow: /

# Sitemaps and AI Discovery
Sitemap: https://yourdomain.com/sitemap_index.xml
```

### B. Standard `/llms.txt` and `/llms-full.txt`
Every modern website must provide an `/llms.txt` file at the root to declare site hierarchy, key documentation, and structured entity entry points for LLMs.

**Structure of `/llms.txt`:**
```markdown
# [Brand / Website Name]
> [One-sentence declarative mission & entity description]

## Core Hubs & Products
- [Product / Tool Name](https://yourdomain.com/tools/slug/): Exact purpose and target query.
- [Key Guide Title](https://yourdomain.com/guides/slug/): Definitive guide with statistics and benchmarks.

## Structured APIs & Feeds
- [Full Text Feed](https://yourdomain.com/llms-full.txt): Complete markdown compilation.
- [Sitemap](https://yourdomain.com/sitemap.xml): XML sitemap.
```

### C. Core Web Vitals & Delivery Thresholds
- **Largest Contentful Paint (LCP):** ≤ 2.0s (Critical for mobile rankings).
- **Interaction to Next Paint (INP):** ≤ 200ms (Replaces FID).
- **Cumulative Layout Shift (CLS):** ≤ 0.05.
- **Time to First Byte (TTFB):** ≤ 400ms globally (Edge CDN caching required).
- **Mobile Viewport:** Clean responsive CSS, `width=device-width, initial-scale=1.0`, zero horizontal overflow.
- **Server Side Rendering (SSR):** Never rely purely on client-side JavaScript hydration for core text, headings, or structured data.

### D. Multi-Region & International (Hreflang)
- Self-referential hreflang tag required on every language/region variant.
- Complete bidirectional return tags across all versions.
- Default fallback specified via `hreflang="x-default"`.

---

## 3. Pillar 2: Semantic Entity Schema Architecture (`@graph`)

Do **not** output fragmented, disconnected schema blocks. Always generate a single, unified JSON-LD script using `@graph` notation. This establishes entity relationships between Organization, Website, Webpage, Author, and Content.

### Standard Production-Grade JSON-LD Schema:
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://yourdomain.com/#organization",
      "name": "Your Brand Name",
      "url": "https://yourdomain.com",
      "logo": {
        "@type": "ImageObject",
        "@id": "https://yourdomain.com/#logo",
        "url": "https://yourdomain.com/assets/logo.png",
        "caption": "Your Brand Logo"
      },
      "sameAs": [
        "https://www.wikidata.org/wiki/QXXXXXX",
        "https://www.linkedin.com/company/yourbrand",
        "https://en.wikipedia.org/wiki/Your_Brand"
      ]
    },
    {
      "@type": "WebSite",
      "@id": "https://yourdomain.com/#website",
      "url": "https://yourdomain.com",
      "name": "Your Brand Name",
      "publisher": { "@id": "https://yourdomain.com/#organization" },
      "inLanguage": "en-US"
    },
    {
      "@type": "Person",
      "@id": "https://yourdomain.com/authors/jane-doe/#author",
      "name": "Jane Doe, CPA",
      "jobTitle": "Lead Tax & Real Estate Analyst",
      "worksFor": { "@id": "https://yourdomain.com/#organization" },
      "knowsAbout": ["Real Estate Tax", "Stamp Duty Calculation", "Indian Property Law"],
      "sameAs": [
        "https://www.linkedin.com/in/janedoe",
        "https://twitter.com/janedoe"
      ]
    },
    {
      "@type": "WebPage",
      "@id": "https://yourdomain.com/target-page/#webpage",
      "url": "https://yourdomain.com/target-page/",
      "name": "Target Page Title Matching H1 Exactly",
      "isPartOf": { "@id": "https://yourdomain.com/#website" },
      "about": { "@id": "https://yourdomain.com/#organization" },
      "author": { "@id": "https://yourdomain.com/authors/jane-doe/#author" },
      "datePublished": "2026-01-15T09:00:00+00:00",
      "dateModified": "2026-03-01T14:30:00+00:00",
      "breadcrumb": { "@id": "https://yourdomain.com/target-page/#breadcrumb" }
    },
    {
      "@type": "BreadcrumbList",
      "@id": "https://yourdomain.com/target-page/#breadcrumb",
      "itemListElement": [
        {
          "@type": "ListItem",
          "position": 1,
          "name": "Home",
          "item": "https://yourdomain.com/"
        },
        {
          "@type": "ListItem",
          "position": 2,
          "name": "Category Hub",
          "item": "https://yourdomain.com/category/"
        },
        {
          "@type": "ListItem",
          "position": 3,
          "name": "Target Page"
        }
      ]
    },
    {
      "@type": "FAQPage",
      "@id": "https://yourdomain.com/target-page/#faq",
      "isPartOf": { "@id": "https://yourdomain.com/target-page/#webpage" },
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is the exact formula for X?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The exact formula for X is A multiplied by B divided by C. For example, a 50 lakh asset under 5% rate yields 2.5 lakhs."
          }
        }
      ]
    }
  ]
}
</script>
```

---

## 4. Pillar 3: Content Citability Rubric (The 0–100 Score)

AI systems preferentially cite content with high extractability. Score content against these 5 categories:

```
┌─────────────────────────────────────────────────────────────────┐
│              CITABILITY SCORING BREAKDOWN (0-100)               │
├─────────────────────────────────────┬───────────────────────────┤
│ 1. Answer Block Quality             │ 30 Points (P0)            │
│ 2. Passage Self-Containment         │ 25 Points (P0)            │
│ 3. Structural Readability & Tables  │ 20 Points (P1)            │
│ 4. Statistical & Citation Density   │ 15 Points (P1)            │
│ 5. Information Gain / Novel Data    │ 10 Points (P1)            │
└─────────────────────────────────────┴───────────────────────────┘
```

### Category 1: Answer Block Quality (30 Points)
- **90–100 pts:** Every major section opens with a 1–2 sentence direct answer. Uses clear definition formulas (`"[Subject] is [definition]."`). First 40–55 words stand alone as a complete, quotable answer.
- **50–70 pts:** Answers are present but buried beneath background context or filler phrases.
- **0–30 pts:** Pure narrative flow. Zero standalone extractable definitions.

### Category 2: Passage Self-Containment (25 Points)
- Every passage names its subject explicitly.
- **Forbidden:** Beginning paragraphs with unresolved pronouns ("This indicates...", "It also means...", "They believe...").
- **Allowed:** `"In Karnataka, property registration charges are..."`

### Category 3: Structural Readability & Tables (20 Points)
- Heading hierarchy: `H1` (exactly one) > `H2` (core user questions) > `H3` (supporting nuances). Never skip heading levels.
- **Tables:** Mandatory for any comparison of 3+ entities, pricing tiers, statutory rates, or pros/cons. AI engines extract Markdown and HTML tables at a rate 3x higher than prose.
- **Lists:** Ordered `<ol>` for chronological steps; unordered `<ul>` for feature sets.

### Category 4: Statistical & Citation Density (15 Points)
- Target: **3 to 5 verifiable data points** per 500 words.
- Exact numbers, dates, statutory sections, and named institutions (e.g., `"Under Section 54F of the Income Tax Act, 1961..."` rather than `"Under tax laws..."`).

### Category 5: Information Gain / Novelty (10 Points)
- Contains at least 1 original calculation, proprietary data table, or unique counter-consensus analysis not present in top 3 ranking SERP competitors.

---

## 5. Pillar 4: The Content Humanizer (Talking to a Real Human)

Search engines rank pages for **humans**, not machines. If content reads like an AI textbook, corporate brochure, or keyword-stuffed whitepaper, readers bounce within 3 seconds, collapsing your NavBoost engagement score. Content must feel like a trusted, deeply knowledgeable advisor speaking directly to the reader across a desk.

### The 6 Humanizer Laws:

1. **Speak to "You" (1-on-1 Address):**
   - Frame advice directly to the reader. Use second-person ("you", "your loan", "your decision").
   - Acknowledge the human emotional reality: financial stress, fear of making a wrong purchase, time constraints, or regulatory confusion.

2. **Intuitive Mental Models Over Dense Jargon:**
   - Translate complex legal, tax, or technical statutes into everyday analogies and worked scenarios.
   - *Robotic/AI:* "Amortization recalculation ensues post lump-sum principal curtailment, shifting the duration curve."
   - *Humanizer:* "When you prepay ₹5 lakhs on your home loan, you have two choices: keep your EMI unchanged and close your loan 4 years earlier, or lower your monthly payment to free up cash today."

3. **Vary Sentence Cadence & Rhythm (Kill the Monotony):**
   - Break mechanical AI symmetry. Real human speech mixes short, punchy statements with descriptive, thoughtful explanations.
   - Never allow three consecutive sentences to share identical lengths or grammatical structures. Use natural contractions ("you'll", "it's", "don't") where they sound authentic.

4. **Zero Em Dashes in Web Copy:**
   - Do not use em dashes (`—`) in published web copy. They are a universal footprint of AI-generated prose. Use clean periods, commas, or parentheses instead.

5. **The Banned AI & Corporate Vocabulary List (Purge on Sight):**
   - *Banned Openings:* "In today's fast-paced digital world", "When it comes to", "Navigating the complexities of", "Let's dive in", "It is important to remember".
   - *Banned Inflated Buzzwords:* "delve", "tapestry", "robust", "seamless", "leverage", "unlock", "realm", "landscape", "crucial", "pivotal", "game-changer", "elevate", "embark", "testament".
   - Replace every inflated word with the plainest, most concrete term that states the truth.

6. **The Mandatory Ear-Test Read-Aloud:**
   - Before publishing, read every draft aloud. If a sentence makes you pause, sounds pretentious, or is something you would never say out loud to a colleague or client, rewrite it immediately.

### Factual Integrity & Compliance Boundaries:
- Never fabricate personal anecdotes, client results, or track records.
- Preserve mandatory statutory disclaimers verbatim:
  - Tax: `Verify with your CA before acting.`
  - Legal: `Verify with your lawyer before acting.`

---

## 6. Pillar 5: Platform-Specific GEO Optimization Matrix

Different AI answer engines use distinct retrieval and weighting mechanisms:

| AI Platform | Index & Foundation | What Drives Selection & Citation | Mandatory Optimization Requirement |
| :--- | :--- | :--- | :--- |
| **Google AI Overviews (AIO)** | Google Search Index | 92% of citations come from top 10 organic SERP results. Favors directness and clarity. | Rank in top 10 organic. Use 45-word definition blocks directly under PAA-mirrored H2s. |
| **ChatGPT Search** | Bing Search Index | Heavy entity weighting. 48% of cited domains link to Wikipedia, Wikidata, or high-authority press. | Verified Wikidata item + Bing Webmaster Tools setup + comprehensive 2,000+ word guides. |
| **Perplexity AI** | Custom Web Index + Social APIs | Prioritizes community consensus, Reddit discussions, and content updated within the last 6 months. | Clear `dateModified`, active community validation (Reddit, HN, Quora), and primary empirical data. |
| **Google Gemini** | Google Knowledge Graph + YouTube | Weights YouTube transcripts, Google Business Profile (GBP), and Schema `@graph` entity maps heavily. | Embed relevant YouTube video with timestamps/chapters + complete Organization/Person schema graph. |
| **Bing Copilot** | Bing Index + IndexNow | Real-time freshness and rapid crawler discovery. | Instant URL submission via Bing IndexNow protocol upon publication. |

---

## 7. Pillar 6: Specialized Verticals & Page Archetypes

### Archetype A: Competitor Comparison & "Vs" Pages
- **Title Structure:** `[Tool A] vs [Tool B]: 2026 Comparison, Pricing & Verdict`
- **Lead Section:** 45-word direct verdict declaring which tool is superior for which specific use case.
- **Comparison Table:** Full feature matrix with at least 5 dimensions (Pricing, Core Capabilities, Speed/Performance, Integrations, Best For).
- **Schema:** `WebPage` + `FAQPage` + `Table` markup.

### Archetype B: Programmatic Calculators & Interactive Tools
- **Title Structure:** `[Topic] Calculator (2026, [Location/State]) | [Brand]`
- **Lead Section:** 40–50 words stating what it calculates, the mathematical formula in 1 line, and 1 worked numerical example.
- **Viewport Layout:** Interactive input sliders/fields above the fold on mobile. Zero scrolling required to calculate.
- **Legal/Tax Disclaimer:** Explicit required line (e.g., `"Indicative only. Verify with your CA/lawyer before acting."`).
- **Schema:** `SoftwareApplication` + `WebApplication` linked to parent `WebPage`.

### Archetype C: Local Business & Maps (Local SEO)
- **NAP Consistency:** Exact Name, Address, Phone format identical across Website, Google Business Profile, Apple Maps, and local citations.
- **Geo-Coordinates:** Latitude/Longitude declared inside `LocalBusiness` schema.
- **Local Service Schema:** Specific `areaServed` postal codes and neighborhood entities.

### Archetype D: Ecommerce Product Pages
- **Schema:** `Product` with complete `offers` array (`price`, `priceCurrency`, `availability`, `itemCondition`).
- **Merchant Center:** Clear return policy, shipping details, and GTIN/MPN identifiers.
- **Faceted Navigation:** Canonicalized parent category URLs to prevent index bloat from filter parameters.

---

## 8. Pillar 7: SEO Drift & Deployment Quality Control

Whenever code or content is deployed, run the **SEO Drift Protocol** to prevent silent ranking regressions:

```bash
# SEO Drift Verification Checklist:
1. Canonical Tag Check: Verify rel="canonical" is absolute, HTTPS, and non-redirecting.
2. Indexability Check: Ensure <meta name="robots" content="index, follow"> is present (no accidental staging "noindex").
3. Schema Validation: Run schema payload through validator to verify zero broken @id links.
4. Heading Audit: Verify exactly one H1 exists and no heading tags were converted to plain <div> or <span>.
5. Status Code Audit: Verify 200 OK without intermediate 301/302 hops.
6. Core Web Vitals Regression: Test mobile LCP on real throttled mobile connection.
```

---

## 9. Pillar 8: Standardized Audit & Optimization Report

When auditing or optimizing any page, format the findings using this executive template:

```markdown
# Modern SEO & Citability Audit: [Target URL]

## 1. Executive Scorecard
- **Overall Modern Search Score:** [Score]/100
- **Traditional Technical SEO Score:** [Score]/50
- **AI Answer Engine Citability Score:** [Score]/50
- **Indexing Status:** [Indexed / Blocked / Canonical Issue]
- **Primary Keyword / Target Entity:** [Entity Name]

## 2. Critical Blockers (P0 - Fix Immediately)
- [List any indexation, canonical, schema, or crawl issues stopping Google/AI bots]

## 3. Algorithmic Ranking Improvements (P1)
- **Information Gain Additions:** [Specific primary data or calculations to add]
- **Passage Extractability Rewrites:**
  - *Current Section Heading:* "[Heading]"
  - *Before (Uncitabile):* "[Current prose]"
  - *After (Quote-Ready 45-Word Answer):* "[Rewritten 45-word direct answer]"

## 4. Structured Data Payload (@graph)
```html
<script type="application/ld+json">
[Drop complete zero-error JSON-LD @graph snippet here]
</script>
```

## 5. Machine Discovery & AI Crawlers
- [ ] Robots.txt allows GPTBot, ClaudeBot, and PerplexityBot
- [ ] `/llms.txt` entry added and verified
- [ ] Bing IndexNow ping dispatched

## 6. Prioritized Action Checklist
- [ ] [P0] Step 1
- [ ] [P1] Step 2
- [ ] [P2] Step 3
```
