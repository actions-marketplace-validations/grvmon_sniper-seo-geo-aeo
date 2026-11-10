# Page types & vertical search optimization

Match the page layout, content structure, and technical schema to the specific job the search query asks the page to perform. A page that fits the format a query asks for is usually easier for readers to use and for engines to understand. These are editing guidelines, not documented ranking rules.

A full worked audit demonstrating an enterprise page is in `example-audit.md`.

---

## 1. Informational guide & deep-dive article

- **User Intent:** The user wants a comprehensive, reliable answer or technical explanation to solve a problem.
- **Above-the-Fold Direct Answer:** Place an executive summary or standalone answer block immediately beneath the H1 or byline. It must directly answer the central question so answer engines (Google AI Overviews, Perplexity, ChatGPT) can extract it as a standalone passage.
- **Information Gain (this skill's heuristic):** Include proprietary analysis, original diagrams, benchmark data, or firsthand observations that do not exist on competitor pages.
- **Author Entity & E-E-A-T:** Visible byline linking to an author biography with verifiable credentials, professional links (`sameAs`), and an editorial review note.
- **Schema:** Use `Article`, `TechArticle`, or `BlogPosting` within an `@graph` connected to `Person` (author) and `Organization` (publisher).

---

## 2. Comparison & alternatives ("X vs Y")

- **User Intent:** The user is deciding between multiple solutions or looking for alternatives.
- **Lead Verdict:** State which option fits which persona in the opening two sentences (e.g., *"Tool A is best for high-throughput streaming teams, while Tool B is optimal for lightweight batch workloads"*).
- **Comparison Matrix:** Organize 3+ core evaluation dimensions in an HTML `<table>` or structured definition list.
- **Recency & Scope:** Clearly state the date features and pricing were verified.
- **Schema:** Mark up with `WebPage` and `ItemList`. Use `Product` only when explicit product specifications and offers are hosted directly on the page. Note: `FAQPage` is not a rich-result tactic after 7 May 2026.

---

## 3. Interactive calculator & tools

- **User Intent:** The user needs an immediate calculation, estimate, or simulation.
- **Above-the-Fold Utility:** Position the interactive tool and input fields high on the page where mobile and desktop users can interact immediately without scrolling past lengthy filler text.
- **Methodology & Formula Disclosure:** Clearly state the underlying mathematical formula, default input assumptions, data sources, and effective dates.
- **Disclaimers:** State that calculations are estimates and name the qualified professional required to confirm legal, tax, or engineering decisions.
- **Schema:** Use `WebApplication` or `SoftwareApplication` with `applicationCategory` and `operatingSystem: "All"`.

---

## 4. Professional services & local advisory

- **User Intent:** The user is seeking a qualified local or specialized advisory firm to hire.
- **NAP Consistency:** The visible page must display the exact legal business name, physical street address, and telephone number matching official business registries and Google Business Profile.
- **Fee & Incentive Transparency:** Clearly explain how the practice is compensated, fee schedules, and disclosure of any referral or partner commissions.
- **Regulatory Disclosures:** State official license numbers, jurisdiction accreditations, and regulatory registrations where the practice operates.
- **Schema:** Use `LocalBusiness`, `ProfessionalService`, `LegalService`, or `MedicalBusiness` with `address`, `telephone`, `geo`, and `areaServed`. Authoritative registry URLs belong in `sameAs`.

---

## 5. E-commerce & product pages

- **User Intent:** The user is researching or ready to buy a specific physical or digital product.
- **On-Page Data Fidelity:** Price, currency, stock availability, and SKU/GTIN printed in visible text must match structured data exactly.
- **Shipping & Returns:** Explicit links to visible delivery timeframes and refund policies.
- **Faceted Navigation:** Decide how faceted filter URLs (color, size, sorting) are handled: canonicalize to the main URL, or keep crawlers out with robots.txt. Check Google's faceted navigation guidance before choosing.
- **Schema:** Use `Product` and `Offer` with `price`, `priceCurrency`, `availability`, and `hasMerchantReturnPolicy`.

---

## 6. Category, hub & topic listing pages

- **User Intent:** The user wants to explore a cluster of related topics, tools, or products.
- **Introductory Context:** A short original introduction that says what the hub covers and links to its main sub-topics. Length follows the topic; there is no required word count.
- **Pagination & Indexation:** Sub-pages (`?page=2`) must self-canonicalize and link to previous/next items cleanly.
- **Schema:** Use `CollectionPage` with `hasPart` pointing to member resources.
