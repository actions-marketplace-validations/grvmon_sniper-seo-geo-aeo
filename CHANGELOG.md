# Changelog

All notable changes to this skill are documented here. The package version follows [Semantic Versioning](https://semver.org/).

## 1.4.0 - 2026-11-11

- Feat(images): added built-in Image Optimization Engine to `scripts/verify-page.sh`.
- Feat(images): checks format modernization (`img_modern_formats` for WebP, AVIF, SVG vs `img_legacy_formats` for PNG, JPG, GIF).
- Feat(images): audits layout stability and Cumulative Layout Shift (CLS) prevention (`img_missing_dims` and `img_dim_status` verifying width/height and inline aspect ratios).
- Feat(images): lightweight file size inspection flags oversized images exceeding 200 KB (`img_oversized_count`).
- Feat(report): added dedicated "Image Optimization & Layout Stability" table in Markdown executive summary (`-r`).
- Feat(json): expanded JSON output schema under `"images"` with dimensions, formats, and file size checks.
- Tests: added fixture server endpoints and 2 new automated test scenarios for image optimization (56 tests passing).

## 1.3.0 - 2026-11-11

- Feat(cli): added `-j` / `--json` flag to `scripts/verify-page.sh` for structured JSON output.
- Feat(cli): added `-r` / `--report` flag to `scripts/verify-page.sh` to generate an executive Markdown summary report.
- Feat(headings): added DOM heading hierarchy audit across `h1` through `h6` (`h1_status` and `heading_hierarchy`), detecting missing H1s, multiple H1s, and skipped heading levels.
- Feat(citability): added direct answer passage evaluation (`first_p_words`, `first_p_chars`, and `first_p_answer_ready` for optimal 35–65 word snippets).
- Feat(actions): updated `action.yml` to accept `format: 'plain' | 'json' | 'report'`.
- Feat(distribution): added `"bin": { "sniper-seo": "./scripts/verify-page.sh" }` for direct CLI execution via `npx @grvmon/sniper-seo-geo-aeo`.
- Feat(brew): added Homebrew formula template (`formula/sniper-seo.rb`).
- Tests: added 6 new automated test scenarios covering heading hierarchy, direct answer passage readiness, `--json` schema validation, and `--report` Markdown formatting (54 tests passing).

## 1.2.0 - 2026-11-10

- Docs: removed unsourced claims (mobile demotions, AI-phrase filters, "primary discriminators"); `answer`, `contain` and `original` are marked rater-judged.
- Aligned remediation template with the checker: title 30-65 chars, meta 70-160 chars; removed the 40-60 word answer target; `sameAs` is left blank until verified.
- humanize.md now says 19 phrases (not 30).
- Fix: robots rules are matched against path plus query string, so `Disallow: /*?sessionid=` now applies to URLs with that query (previously reported `allow`).
- Added `canonical_status: warn` when no canonical is declared.
- AI-phrase scanner now covers every phrase in humanize.md except the stacked-connector row.
- Tests: 12 new fixtures (robots query, named-group override, case-insensitive tokens, `$` anchor, longest match, crawl-delay between agents, 5xx robots, missing canonical, extended phrases); `FIXTURE_ROBOTS` raw-body mode in the fixture server.
- CI: shellcheck at warning level.
- README: removed ranking promises and the "Page 1 = what is cited" claim; replaced the static test badge with the CI badge.
- CHANGELOG 1.1.0 test-matrix note corrected to Python 3.9-3.13 (matches CI).

## 1.1.0 - 2026-11-10

- **100% White-Label:** Removed all badge and attribution links from audit outputs and documentation.
- **Universal & Brand-Agnostic Rewrite:** Removed all brand-specific references; added `references/example-audit.md` (worked enterprise SaaS audit) and `references/house-rules-template.md` (customizable house style template).
- **Content Humanizer:** Added `references/humanize.md` containing 19 listed AI clichés, sentence rhythm/burstiness benchmarks, and a 2-pass humanization protocol.
- **AI Cliché Scanner:** Enhanced `scripts/verify-page.sh` to automatically detect formulaic generative phrases in visible text and report `ai_cliche_count` and `humanize_status`.
- **Googlebot Smartphone Emulation:** `scripts/verify-page.sh` accepts `-g` / `--googlebot` to fetch pages using the official Googlebot Smartphone User-Agent.
- **Mobile-First Indexing & Viewport Check:** Inspects `<meta name="viewport">` for `width=device-width` compliance to flag mobile usability risk.
- **Soft 404 Detection:** Detects deceptive HTTP 200 OK responses with error/missing text or thin boilerplate (< 25 words).
- **Image SEO & CWV Asset Checks:** Audits total images, missing `alt` text, and lazy loading presence.
- **Snippet Health & SERP Display:** Reports `title_status` (30–65 chars) and `meta_description_status` (70–160 chars) against Google SERP display cutoffs.
- **Crawl Caching & Freshness:** Extracts `Last-Modified` and `ETag` headers for HTTP conditional crawl budget efficiency.
- **Production-Ready Remediation Deliverable:** Reports now generate copy-paste Title, Meta description, AI lead answer block with CSS eyebrow, and connected Schema.org `@graph`.
- **Answer blocks:** Standalone answer under the title, no plain-text label prefixes; clean `acceptedAnswer.text`. Script reports `first_p_label_prefix`, `schema_answer_texts`, and `schema_answer_label_prefix`.
- **Automated Test Suite:** Expanded `tests/run.sh` to 32 automated fixture tests passing; CI covers Python 3.9 through 3.13.

- verify-page.sh runs on Python 3.9+ (no backslash in f-string expressions).
- robots.txt parsing follows RFC 9309: blank lines do not end a group, matching groups merge, BOM stripped, 4xx means allow all, sitemap URLs resolved.
- Only the final hop's `X-Robots-Tag` counts; `googlebot`/`bingbot` meta and scoped headers are judged; other bots reported only.
- New `http_check`, `canonical_differs`, `title_chars`, and `meta_description_*` lines; non-2xx pages are not indexable.
- Reads all declared sitemaps, expands indexes with loop protection, unzips `.gz`, up to 20 files; `nt` when incomplete.
- curl is limited to http/https; exits 2 when curl or python3 is missing.
- 401/403/429/5xx give `indexability: nt` with an `index_note` instead of `fail`.
- Identical repeated canonical tags count as one (`canonical_unique_count`).
- New `script_tags` and `js_shell_suspect` lines (under 500 visible characters with scripts).
- Added `tests/run.sh` fixture suite.
- Docs: `WebSite` node in the schema example, Gemini CLI path `~/.gemini/skills/`, `bash <skill-dir>/scripts/verify-page.sh`, HTTP status check, `sourced` is `NT` with no claims, Top 3 fixes in the report.

- README release, license, and topics badges use shields.io URLs that return an SVG.
- Wiki guides: Home, Installation, Usage, Supported Engines, FAQ, and Contributing.

## 1.0.0 - 2026-11-08

- First packaged release of the Sniper SEO, GEO, and AEO agent skill.
- Publish `@grvmon/sniper-seo-geo-aeo` to GitHub Packages when a GitHub Release is published, and on manual workflow dispatch.
- Repository docs: install, usage, supported engines, contributing, security, and code of conduct.
- Opt-in attribution. The audit offers a visible credit line and does not insert it. Hidden links are forbidden. The site owner must approve.
