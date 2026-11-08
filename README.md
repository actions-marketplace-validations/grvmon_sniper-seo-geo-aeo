# Modern SEO: The Unified Search & AI Answer Engine Optimization (SEO + GEO + AEO) Skill

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: Agent Skill](https://img.shields.io/badge/Platform-Antigravity%20%7C%20Claude%20%7C%20Cursor-purple.svg)](#installation)
[![Engine: Google + AI Answer Engines](https://img.shields.io/badge/Engines-Google%20%7C%20ChatGPT%20%7C%20Perplexity%20%7C%20Gemini-emerald.svg)](#the-modern-search-law)

> **The Modern Search Law (2026):**  
> What ranks #1 on Google is precisely what AI answer engines (ChatGPT Search, Perplexity, Claude, Gemini, Google AI Overviews) synthesize and cite. Both demand the exact same foundation: machine-readable infrastructure, verified entity knowledge graphs, high information gain, and direct, extractable answers.

`modern-seo` is an open-source, battle-tested AI agent skill that unifies **Traditional SEO**, **Generative Engine Optimization (GEO)**, and **Answer Engine Optimization (AEO)** into one cohesive operating system.

---

## 🚀 Quick Installation

### 1. Google Antigravity & Gemini CLI
Clone directly into your personal agent skills directory:
```bash
git clone https://github.com/grvmon/modern-seo-skill.git ~/.gemini/config/skills/modern-seo
```

### 2. Claude Code & Claude Desktop
Add to your Claude skills directory:
```bash
git clone https://github.com/grvmon/modern-seo-skill.git ~/.claude/skills/modern-seo
```

### 3. Cursor & Windsurf Projects
Drop directly into your project's agent skills directory:
```bash
git clone https://github.com/grvmon/modern-seo-skill.git .cursor/skills/modern-seo
```

Once installed, simply ask your agent:
> *"Audit this page using modern-seo"*  
> *"Optimize this article for Perplexity and Google AI Overviews"*  
> *"Generate a consolidated schema graph for our site"*  
> *"Humanize this content draft to improve dwell time and remove AI cadence"*

---

## 🧠 The 7 Algorithmic Ranking Levers

Every modern search engine (Google, Bing) and AI retrieval system (ChatGPT, Perplexity) relies on these 7 mathematical and behavioral mechanics:

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

1. **Information Gain Score (Google Patent):** Google actively downranks "me-too" summaries. Every page must contain at least **two novel data points**: proprietary calculations, original research, or primary statutory references.
2. **NavBoost & Time-to-Answer:** The primary answer must appear in the viewport within **5 seconds** to prevent pogo-sticking back to the SERP.
3. **Deep Entity Disambiguation:** Authors and organizations must be verified entities linked to Wikidata, Wikipedia, LinkedIn, and official registries using `sameAs` attributes.
4. **Passage Extractability (The 45-Word Answer Box):** Self-contained, 40–55 word direct declarative answers placed immediately below question-based `<h2>` and `<h3>` tags for instant LLM vector retrieval.
5. **Search Intent to Layout (SXO):** Matching exact visual layouts (HTML comparison tables for "Vs" queries, interactive calculators for financial queries, step lists for processes).
6. **Internal Link Equity Flow:** Topic clusters (hub-and-spoke) with descriptive anchor text within ≤ 3 clicks of the root domain.
7. **The Content Humanizer:** Purges formulaic AI cadence, unnatural symmetry, and corporate jargon in favor of conversational empathy and plain English.

---

## 📊 The 0–100 AI Citability Scoring Rubric

AI search engines preferentially extract and cite passages that score high across these 5 objective dimensions:

| Category | Weight | Target Metric |
| :--- | :---: | :--- |
| **1. Answer Block Quality** | **30%** | First 40–55 words beneath H2/H3 provide a direct standalone answer (`"[Subject] is [definition]."`). |
| **2. Passage Self-Containment** | **25%** | Zero unresolved pronouns (`"it"`, `"this"`, `"they"`). The passage can be quoted completely out of context. |
| **3. Structural Readability & Tables** | **20%** | Clean H1 > H2 > H3 hierarchy. Tables used for any comparison of 3+ entities or data points. |
| **4. Statistical & Citation Density** | **15%** | 3 to 5 verified data points, dates, or statutory sources per 500 words. |
| **5. Information Gain / Novelty** | **10%** | Unique benchmarks, calculators, or primary findings not present in top 3 competitors. |

---

## 🎯 Platform-Specific GEO Matrix

Only **11% of domains** are cited by BOTH ChatGPT and Google AI Overviews for the exact same query. Tailor your content for platform-specific retrieval mechanisms:

| AI Platform | Index & Foundation | What Drives Selection & Citation | Core Optimization Requirement |
| :--- | :--- | :--- | :--- |
| **Google AI Overviews (AIO)** | Google Search Index | 92% of citations come from top 10 organic SERP results. Favors directness and clarity. | Rank in top 10 organic. Use 45-word definition blocks directly under PAA-mirrored H2s. |
| **ChatGPT Search** | Bing Search Index | Heavy entity weighting. 48% of cited domains link to Wikipedia, Wikidata, or high-authority press. | Verified Wikidata item + Bing Webmaster Tools setup + comprehensive 2,000+ word guides. |
| **Perplexity AI** | Custom Web Index + Social APIs | Prioritizes community consensus, Reddit discussions, and content updated within the last 6 months. | Clear `dateModified`, active community validation (Reddit, HN, Quora), and primary empirical data. |
| **Google Gemini** | Google Knowledge Graph + YouTube | Weights YouTube transcripts, Google Business Profile (GBP), and Schema `@graph` entity maps heavily. | Embed relevant YouTube video with timestamps/chapters + complete Organization/Person schema graph. |
| **Bing Copilot** | Bing Index + IndexNow | Real-time freshness and rapid crawler discovery. | Instant URL submission via Bing IndexNow protocol upon publication. |

---

## 🏗️ Semantic Entity Schema Architecture (`@graph`)

Never inject fragmented, disconnected schema tags. `modern-seo` enforces a single, unified JSON-LD script using `@graph` notation:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://yourdomain.com/#organization",
      "name": "Your Brand",
      "url": "https://yourdomain.com",
      "sameAs": [
        "https://www.wikidata.org/wiki/QXXXXXX",
        "https://www.linkedin.com/company/yourbrand"
      ]
    },
    {
      "@type": "Person",
      "@id": "https://yourdomain.com/authors/jane-doe/#author",
      "name": "Jane Doe",
      "jobTitle": "Lead Analyst",
      "worksFor": { "@id": "https://yourdomain.com/#organization" },
      "sameAs": "https://www.linkedin.com/in/janedoe",
      "knowsAbout": ["Real Estate Due Diligence", "Financial Modeling"]
    },
    {
      "@type": "WebPage",
      "@id": "https://yourdomain.com/target-page/#webpage",
      "url": "https://yourdomain.com/target-page/",
      "name": "Page Title Matching H1 Exactly",
      "isPartOf": { "@id": "https://yourdomain.com/#website" },
      "author": { "@id": "https://yourdomain.com/authors/jane-doe/#author" },
      "datePublished": "2026-01-15T09:00:00+00:00",
      "dateModified": "2026-03-01T14:30:00+00:00"
    }
  ]
}
</script>
```

---

## ✍️ The Content Humanizer (Writing for Real Humans)

Search engines rank pages for **humans**, not machines. The skill strictly enforces the **6 Humanizer Laws**:

1. **Speak to "You" (1-on-1 Direct Address):** Frame advice as a knowledgeable advisor speaking across a desk over coffee, addressing real anxieties and stakes.
2. **Intuitive Mental Models Over Jargon:** Translate complex statutes into everyday analogies and worked numerical scenarios.
3. **Anti-Monotony Rhythm:** Mix punchy 5-word statements with nuanced 20-word explanations. Never allow three sentences in a row to share the same grammatical structure.
4. **Zero Em Dashes (`—`):** Banned in published web copy as a universal signature of synthetic AI writing.
5. **Purge the Banned AI Vocabulary:** Delete on sight: *delve, tapestry, robust, seamless, leverage, unlock, realm, landscape, crucial, pivotal, game-changer, elevate, embark, testament, "in today's fast-paced world", "let's dive in"*.
6. **The Ear-Test Read-Aloud:** If a sentence wouldn't be spoken aloud to a client or colleague, rewrite it immediately in plain English.

---

## 📄 License

Distributed under the [MIT License](LICENSE). Open-source, free for personal and commercial use. Built for the modern AI and web community.
