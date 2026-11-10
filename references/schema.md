# Structured data & entity optimization

Use this file when writing, reviewing, or validating Schema.org structured data. Rich result eligibility is distinct from standard ranking. While schema does not directly boost ranking positions, it enables rich snippets, establishes clear entity graphs for AI crawlers, and ensures search engines interpret the author, publisher, and main topics without ambiguity.

A full worked audit demonstrating linked JSON-LD is in `example-audit.md`.

---

## 1. Core principles

- **Visible content fidelity:** Only mark up information that human visitors can read on the page. Hidden facts, spoofed credentials, or off-page data must never be placed in JSON-LD.
- **Accurate representation:** Structured data must be a truthful representation of on-page content. Never invent an address, telephone number, credential, product price, or testimonial.
- **Canonical entity IDs:** Anchor key business entities using permanent URI identifiers (e.g., `"@id": "https://example.com/#organization"` and `"@id": "https://example.com/#website"`).
- **Authoritative profile links (`sameAs`):** Add `sameAs` URLs only after manually verifying that the destination profile belongs to the exact same organization or individual (e.g., official LinkedIn, GitHub, or verified registry).
- **FAQPage status:** Google Search stopped supporting FAQ rich results on 7 May 2026. Do not add `FAQPage` expecting search snippet enhancements. If retained for AI crawlers, ensure every Q&A pair is visible in full on the page.

---

## 2. Universal `@graph` template: Article, author & publisher

This pattern connects the author (`Person`), publisher (`Organization`), website (`WebSite`), and content page (`TechArticle` / `Article`) in a single JSON-LD block.

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "Acme Technologies Inc.",
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
      "name": "Distributed System Architecture: Core Patterns & Latency Benchmarks",
      "headline": "Distributed System Architecture: Core Patterns & Latency Benchmarks",
      "description": "A deep-dive technical guide examining distributed system architecture, consensus algorithms, and throughput benchmarks with reproducible examples.",
      "isPartOf": { "@id": "https://example.com/#website" },
      "about": { "@id": "https://example.com/#organization" },
      "author": {
        "@type": "Person",
        "name": "Alex Smith",
        "jobTitle": "Principal Systems Engineer",
        "sameAs": "https://www.linkedin.com/in/alex-smith-example"
      },
      "publisher": { "@id": "https://example.com/#organization" },
      "datePublished": "2026-03-10",
      "dateModified": "2026-11-10"
    }
  ]
}
</script>
```

---

## 3. Local business & professional service template

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ProfessionalService",
  "@id": "https://example.com/#service",
  "name": "Apex Advisory Group",
  "url": "https://example.com/",
  "telephone": "+1-555-019-2834",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "100 Market Street, Suite 400",
    "addressLocality": "San Francisco",
    "addressRegion": "CA",
    "postalCode": "94105",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 37.7937,
    "longitude": -122.3965
  },
  "areaServed": "San Francisco Bay Area",
  "sameAs": [
    "https://www.linkedin.com/company/apex-advisory"
  ]
}
</script>
```

---

## 4. BreadcrumbList template

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://example.com/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Engineering Guides",
      "item": "https://example.com/guides/"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "Distributed System Architecture"
    }
  ]
}
</script>
```
