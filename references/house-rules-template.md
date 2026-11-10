# House rules template (site-specific)

Use this template to document your brand's editorial, template, and compliance standards. House rules are **site-specific** guidelines that supplement generic SEO, GEO, and AEO principles. Apply them only to the designated site with the owner's approval.

---

## 1. Brand conventions

- **Canonical brand spelling:** Define exact casing, punctuation, and legal name (e.g., `Acme`, `Acme Corp`, `Acme Technologies Inc.`).
- **HTML character entities:** Specify encoding standards (e.g., encode `&` as `&amp;` in HTML title tags and meta descriptions).
- **Prohibited superlatives:** Replace unsubstantiated claims ("best in class", "unbiased", "#1 solution", "100% guaranteed") with checkable, verifiable facts and measurable track records.

---

## 2. Page layout & navigation

- **Primary navigation hierarchy:** List official navigation order (e.g., `Solutions` → `Platform` → `Pricing` → `Resources` → `Company`).
- **Footer requirements:** Specify mandatory footer elements:
  - Registered legal corporate entity name.
  - Physical registered office address matching Google Business Profile and local filings.
  - License, regulatory, or corporate registration numbers.
  - Working links to Privacy Policy, Terms of Service, and Editorial/Corrections Policy.

---

## 3. Answer blocks & snippet design

On informational, guide, or FAQ pages, specify house formatting for the direct answer snippet:

- **DOM structure:** Specify the selector or wrapper for the lead answer (e.g., `<p class="lead-answer" id="direct-answer">`).
- **Eyebrow / badge:** Use a clean CSS eyebrow (e.g., `<strong>In Short</strong>` or `<strong>Quick Summary</strong>`) rather than plain-text prefixes like `Direct answer:`.
- **Recommended styling:**

```css
#direct-answer strong:first-child {
  color: var(--brand-accent, #2563eb);
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.08em;
  display: block;
  margin-bottom: 4px;
}
```

- **Schema matching:** In `QAPage` or `FAQPage` JSON-LD, ensure `acceptedAnswer.text` contains clean prose that omits the eyebrow prefix and matches visible on-page text.

---

## 4. Internal linking & interactive tools

- **Tool & resource integration:** Require that each deep-dive guide links to at least one relevant proprietary calculator, tool, or interactive asset using its canonical URL (e.g., `https://example.com/tools/roi-calculator/`).
- **Contextual anchor text:** Never use generic phrases like "click here" or "learn more"; use descriptive anchor text that clearly identifies the target resource.

---

## 5. Regulatory, statutory & YMYL compliance

Specify exact rules for claims requiring qualified review:

- **Industry disclosures:** Define statutory disclaimers (e.g., FINRA/SEC disclaimers for finance, FDA/medical disclaimers for health, FTC affiliate disclosures, legal practice disclaimers).
- **Primary sources:** Direct contributors to cite primary legal, statutory, or scientific texts verbatim with official government or institutional links rather than paraphrasing.
- **Reviewer byline:** Require visible attribution to a verified expert (e.g., "Reviewed by [Name], CPA / JD / MD") on all Your Money or Your Life (YMYL) pages.

---

## 6. Structured data standards

- **Entity identity:** Maintain canonical `@id` URIs (e.g., `https://example.com/#organization`).
- **Authoritative profiles (`sameAs`):** List verified entity profiles (LinkedIn company page, Crunchbase, GitHub, official registry) that may be included in Organization schema. Include only URLs verified by manual inspection.
- **Registry identifiers:** Include official government or professional license numbers in schema only where the same identifier is visible to users on the page.
