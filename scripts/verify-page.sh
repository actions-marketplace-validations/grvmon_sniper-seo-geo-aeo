#!/usr/bin/env bash
# Fetch one URL and print indexation evidence. Each line is a fact or "nt".
# Exit 0 after a response is saved. Exit 2 on usage or network failure.
set -euo pipefail

USE_GOOGLEBOT=0
USE_OPENAI=0
OUTPUT_FORMAT="plain"
URL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      echo "usage: verify-page.sh [-g|--googlebot] [-o|--openai] [-j|--json] [-r|--report] URL" >&2
      exit 2
      ;;
    -g|--googlebot)
      USE_GOOGLEBOT=1
      shift
      ;;
    -o|--openai)
      USE_OPENAI=1
      shift
      ;;
    -j|--json)
      OUTPUT_FORMAT="json"
      shift
      ;;
    -r|--report)
      OUTPUT_FORMAT="report"
      shift
      ;;
    http://*|https://*)
      if [[ -n "$URL" ]]; then
        echo "usage: verify-page.sh [-g|--googlebot] [-o|--openai] [-j|--json] [-r|--report] URL" >&2
        exit 2
      fi
      URL="$1"
      shift
      ;;
    *)
      echo "usage: URL must start with http:// or https://" >&2
      exit 2
      ;;
  esac
done

if [[ -z "$URL" ]]; then
  echo "usage: verify-page.sh [-g|--googlebot] [-o|--openai] [-j|--json] [-r|--report] URL" >&2
  exit 2
fi

for bin in curl python3; do
  command -v "$bin" >/dev/null 2>&1 || { echo "missing_dependency: $bin" >&2; exit 2; }
done

TMP="$(mktemp -d "${TMPDIR:-/tmp}/sniper-verify.XXXXXX")"
cleanup() {
  if [[ -n "${TMP:-}" && -d "$TMP" ]]; then
    case "$TMP" in
      /tmp/sniper-verify.*|"${TMPDIR:-/tmp}"/sniper-verify.*)
        find "$TMP" -mindepth 1 -delete
        rmdir "$TMP" 2>/dev/null || true
        ;;
    esac
  fi
}
trap cleanup EXIT
if [[ "$USE_GOOGLEBOT" -eq 1 ]]; then
  UA="Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.139 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
elif [[ "$USE_OPENAI" -eq 1 ]]; then
  UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.4; +https://openai.com/searchbot"
else
  UA="verify-page/1.0 (+https://github.com/grvmon/sniper-seo-geo-aeo)"
fi

if ! curl -sS -L --proto =http,https --proto-redir =http,https --max-redirs 5 --max-time 30 -A "$UA" \
  -D "$TMP/headers" -o "$TMP/body" \
  -w '%{url_effective}\n%{http_code}\n%{num_redirects}\n' \
  "$URL" > "$TMP/meta"; then
  echo "fetch_error: curl failed for $URL" >&2
  exit 2
fi

python3 - "$URL" "$TMP" "$UA" "$OUTPUT_FORMAT" << 'PY'
import json, re, sys, html, gzip, io, os, urllib.error, urllib.request
from collections import defaultdict
from html.parser import HTMLParser
from urllib.parse import urljoin, urlparse

page_url, tmp, ua = sys.argv[1], sys.argv[2], sys.argv[3]
out_format = sys.argv[4] if len(sys.argv) > 4 else "plain"

output_lines = []
_real_print = print

def log_print(*args, **kwargs):
    if kwargs.get("file") is not None:
        _real_print(*args, **kwargs)
        return
    sep = kwargs.get("sep", " ")
    end = kwargs.get("end", "\n")
    line = sep.join(str(a) for a in args)
    output_lines.append(line)
    if out_format == "plain":
        _real_print(line, end=end)

print = log_print
meta = open(f"{tmp}/meta", encoding="utf-8").read().splitlines()
final_url, status, redirects = meta[0], meta[1], meta[2]
body = open(f"{tmp}/body", encoding="utf-8", errors="replace").read()
raw_headers = open(f"{tmp}/headers", encoding="utf-8", errors="replace").read()

class _SafeRedirect(urllib.request.HTTPRedirectHandler):
    max_redirections = 5

    def redirect_request(self, req, fp, code, msg, headers, newurl):
        if urlparse(newurl).scheme not in ("http", "https"):
            raise urllib.error.URLError(f"redirect to unsupported scheme: {urlparse(newurl).scheme}")
        return super().redirect_request(req, fp, code, msg, headers, newurl)

def fetch_url(url, binary=False):
    """Return (status, headers_text, body). status is the last hop, or error:reason."""
    empty = b"" if binary else ""
    if urlparse(url).scheme not in ("http", "https"):
        return "error: unsupported scheme", "", empty
    def _headers(hdr):
        if not hdr:
            return ""
        return "".join(f"{k}: {v}\n" for k, v in hdr.items())
    def _body(data):
        if data is None:
            return empty
        if binary:
            return data if isinstance(data, (bytes, bytearray)) else data.encode("utf-8", "replace")
        return data.decode("utf-8", "replace") if isinstance(data, (bytes, bytearray)) else data
    try:
        req = urllib.request.Request(url, headers={"User-Agent": ua})
        opener = urllib.request.build_opener(_SafeRedirect)
        with opener.open(req, timeout=30) as resp:
            return str(resp.getcode()), _headers(resp.headers), _body(resp.read())
    except urllib.error.HTTPError as e:
        try:
            data = e.read()
        except Exception:
            data = b""
        return str(e.code), _headers(e.headers), _body(data)
    except Exception as e:
        err = str(e).replace("\n", " ")[:180]
        return f"error: {err}", "", empty

blocks = re.split(r"\r?\n\r?\n", raw_headers)
hops = []  # (status, [header lines])
for block in blocks:
    lines = [ln for ln in block.splitlines() if ln.strip()]
    if not lines or not lines[0].startswith("HTTP/"):
        continue
    parts = lines[0].split(None, 2)
    code = parts[1] if len(parts) > 1 else lines[0]
    reason = parts[2].lower() if len(parts) > 2 else ""
    if code.startswith("1") or (code == "200" and "connection established" in reason):
        continue  # interim or proxy CONNECT response, not a hop
    hops.append((code, lines[1:]))
hop_statuses = [c for c, _ in hops]
final_headers = hops[-1][1] if hops else []
last_modified = "(none)"
etag = "(none)"
for ln in final_headers:
    low_ln = ln.lower()
    if low_ln.startswith("last-modified:"):
        last_modified = ln.split(":", 1)[1].strip()
    elif low_ln.startswith("etag:"):
        etag = ln.split(":", 1)[1].strip()
XR_DIRECTIVES = {"all", "noindex", "nofollow", "none", "nosnippet", "indexifembedded",
                 "notranslate", "noimageindex", "unavailable_after", "max-snippet",
                 "max-image-preview", "max-video-preview", "noarchive", "nocache", "index", "follow"}
JUDGED = {"googlebot", "bingbot"}
xrobots, xrobots_other = [], []
for ln in final_headers:
    if not ln.lower().startswith("x-robots-tag:"):
        continue
    val = ln.split(":", 1)[1].strip()
    m = re.match(r"^\s*([A-Za-z0-9_.-]+)\s*:(.*)$", val)
    if m and m.group(1).lower() not in XR_DIRECTIVES:
        agent = m.group(1).lower()
        (xrobots if agent in JUDGED else xrobots_other).append(val)
    else:
        xrobots.append(val)

class Page(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.title = []
        self.in_title = False
        self.skip = 0
        self.canonical = []
        self.robots = []
        self.robots_other = []
        self.meta_desc = []
        self.viewport = None
        self.hreflang = 0
        self.headings = []  # (level, text)
        self.h_level = 0
        self.h_buf = []
        self.after = []  # text chunks collected under current h2 until next heading
        self.capture_after = False
        self.h2_seen = 0
        self.h2_follow = []  # list of text after each of first 8 h2
        self.cur_follow = []
        self.paras = []
        self.first_p = None
        self.in_p = False
        self.p_buf = []
        self.links = set()
        self.ld = []
        self.in_ld = False
        self.ld_buf = []
        self.img_count = 0
        self.img_missing_alt = 0
        self.img_lazy = 0
        self.img_missing_dims = 0
        self.img_sources = []
        self.og_title = None
        self.og_desc = None
        self.og_image = None

    def handle_starttag(self, tag, attrs):
        a = {k.lower(): (v or "") for k, v in attrs}
        if tag in ("script", "style"):
            self.skip += 1
            if tag == "script" and a.get("type", "").lower() == "application/ld+json":
                self.in_ld = True
                self.ld_buf = []
            return
        if self.skip:
            return
        if tag == "title":
            self.in_title = True
        if tag == "p":
            self.in_p = True
            self.p_buf = []
        if tag in ("h1", "h2", "h3", "h4", "h5", "h6"):
            if self.capture_after and self.h2_seen <= 8:
                self.h2_follow.append(re.sub(r"\s+", " ", "".join(self.cur_follow)).strip())
                self.capture_after = False
            self.h_level = int(tag[1])
            self.h_buf = []
        if tag == "link" and "canonical" in a.get("rel", "").lower():
            self.canonical.append(a.get("href", ""))
        if tag == "link" and "alternate" in a.get("rel", "").lower() and a.get("hreflang"):
            self.hreflang += 1
        if tag == "meta":
            name = a.get("name", "").lower()
            prop = a.get("property", "").lower() or name
            if name == "viewport":
                self.viewport = a.get("content", "").strip()
            elif name in ("robots", "googlebot", "bingbot"):
                self.robots.append(f"{name}: {a.get('content', '')}")
            elif name in ("googlebot-news", "slurp", "duckduckbot", "yandex", "baiduspider"):
                self.robots_other.append(f"{name}: {a.get('content', '')}")
            elif name == "description":
                self.meta_desc.append(a.get("content", ""))
            if prop == "og:title":
                self.og_title = a.get("content", "").strip()
            elif prop == "og:description":
                self.og_desc = a.get("content", "").strip()
            elif prop == "og:image":
                self.og_image = a.get("content", "").strip()
        if tag == "a" and a.get("href"):
            self.links.add(a["href"])
        if tag == "img":
            self.img_count += 1
            alt = a.get("alt")
            if alt is None or not alt.strip():
                self.img_missing_alt += 1
            if "lazy" in a.get("loading", "").lower():
                self.img_lazy += 1
            src = a.get("src") or a.get("data-src") or ""
            if src:
                self.img_sources.append(src)
            has_w = bool(a.get("width", "").strip())
            has_h = bool(a.get("height", "").strip())
            style_str = a.get("style", "").lower()
            has_aspect = "aspect-ratio" in style_str
            if not ((has_w and has_h) or has_aspect):
                self.img_missing_dims += 1

    def handle_endtag(self, tag):
        if tag in ("script", "style"):
            if tag == "script" and self.in_ld:
                self.ld.append("".join(self.ld_buf))
                self.in_ld = False
            if self.skip:
                self.skip -= 1
            return
        if self.skip:
            return
        if tag == "title":
            self.in_title = False
        if tag == "p" and self.in_p:
            text = re.sub(r"\s+", " ", "".join(self.p_buf)).strip()
            if self.first_p is None and text:
                self.first_p = text
            if len(text.split()) >= 20:
                self.paras.append(text)
            self.in_p = False
        if tag in ("h1", "h2", "h3", "h4", "h5", "h6") and self.h_level:
            text = re.sub(r"\s+", " ", "".join(self.h_buf)).strip()
            self.headings.append((self.h_level, text))
            if tag == "h2":
                self.h2_seen += 1
                if self.h2_seen <= 8:
                    self.capture_after = True
                    self.cur_follow = []
            self.h_level = 0

    def handle_data(self, data):
        if self.in_ld:
            self.ld_buf.append(data)
            return
        if self.skip:
            return
        if self.in_title:
            self.title.append(data)
        if self.h_level:
            self.h_buf.append(data)
        if self.in_p:
            self.p_buf.append(data)
        if self.capture_after:
            self.cur_follow.append(data)

    def close(self):
        super().close()
        if self.capture_after:
            self.h2_follow.append(re.sub(r"\s+", " ", "".join(self.cur_follow)).strip())

page = Page()
page.feed(body)
page.close()

def visible_text(raw):
    t = re.sub(r"(?is)<script[\s\S]*?</script>", " ", raw)
    t = re.sub(r"(?is)<style[\s\S]*?</style>", " ", t)
    t = re.sub(r"(?s)<[^>]+>", " ", t)
    t = html.unescape(t)
    return re.sub(r"\s+", " ", t).strip()

text = visible_text(body)
host = urlparse(final_url).netloc.lower()

def same_host(href):
    absu = urljoin(final_url, href)
    p = urlparse(absu)
    if p.scheme not in ("http", "https"):
        return None
    if p.netloc.lower() != host:
        return None
    return absu.split("#")[0]

internal = sorted({u for u in (same_host(h) for h in page.links) if u})

def norm(u):
    p = urlparse(u)
    path = p.path or "/"
    if path != "/" and path.endswith("/"):
        path = path[:-1]
    q = f"?{p.query}" if p.query else ""
    return f"{p.scheme.lower()}://{p.netloc.lower()}{path}{q}"

def canonical_diff(c, f):
    a, b = urlparse(c), urlparse(f)
    if (a.scheme.lower(), a.netloc.lower()) != (b.scheme.lower(), b.netloc.lower()):
        return "scheme_or_host"
    pa, pb = a.path or "/", b.path or "/"
    if pa != pb:
        return "trailing_slash" if pa.rstrip("/") == pb.rstrip("/") else "path"
    if a.query != b.query:
        return "query"
    return "none"

print(f"requested_url: {page_url}")
print(f"final_url: {final_url}")
print(f"http_status: {status}")
print(f"redirects: {redirects}")
print("hop_status: " + (" ".join(hop_statuses) if hop_statuses else "nt"))
print("http_check: " + ("pass" if status.startswith("2") else "fail"))
print("x_robots_tag: " + (" | ".join(xrobots) if xrobots else "(none)"))
if xrobots_other:
    print("x_robots_other_agent: " + " | ".join(xrobots_other))
print("meta_robots: " + (" | ".join(page.robots) if page.robots else "(none)"))
if page.robots_other:
    print("meta_robots_other_agent: " + " | ".join(page.robots_other))

rules = " ".join(xrobots + page.robots).lower()
status_blocked = status in ("401", "403", "429") or status.startswith("5")
if not status.startswith("2") and not status_blocked:
    rules += " noindex"  # 3xx loop, 404, 410 and other non-2xx are not indexable
if status_blocked:
    indexability = "nt"
    print(f"index_note: status {status} may be bot blocking or an outage for this user agent; confirm with URL Inspection")
elif "noindex" in rules or re.search(r"\bnone\b", rules):
    indexability = "fail"
elif not xrobots and not page.robots:
    indexability = "pass"
    print("index_follow_meta: absent; Google default is index,follow (explicit tag is optional)")
else:
    indexability = "pass"
    if any(re.search(r"\bindex\b", r, re.I) for r in page.robots):
        print("index_follow_meta: present; explicit index,follow is optional")
print(f"indexability: {indexability}")

canon_unique = list(dict.fromkeys(urljoin(final_url, c) for c in page.canonical))
print(f"canonical_count: {len(page.canonical)}")
print(f"canonical_unique_count: {len(canon_unique)}")
for i, c in enumerate(page.canonical, 1):
    abs_c = urljoin(final_url, c)
    print(f"canonical_{i}: {abs_c}")
if len(canon_unique) == 1:
    abs_c = canon_unique[0]
    c_status, _, _ = fetch_url(abs_c)
    diff = canonical_diff(abs_c, final_url)
    matches_final = norm(abs_c) == norm(final_url)
    if not c_status.startswith("2"):
        canonical_status = f"fail: fetch status {c_status}"
    elif not matches_final:
        canonical_status = f"warn: canonical differs ({diff})"
    else:
        canonical_status = "pass"
    print(f"canonical_status: {canonical_status}")
    print(f"canonical_fetch_status: {c_status}")
    print(f"canonical_matches_final: {'yes' if matches_final else 'no'}")
    print(f"canonical_differs: {diff}")
elif len(canon_unique) == 0:
    canonical_status = "warn: no canonical declared"
    print(f"canonical_status: {canonical_status} (Google will choose one itself)")
    print("canonical_fetch_status: nt")
    print("canonical_matches_final: nt")
    print("canonical_differs: nt")
else:
    canonical_status = f"warn: multiple canonical tags declared ({len(canon_unique)})"
    print(f"canonical_status: {canonical_status}")
    print("canonical_fetch_status: nt")
    print("canonical_matches_final: nt")
    print("canonical_differs: nt")

title_text = re.sub(r"\s+", " ", "".join(page.title)).strip()
print(f"title: {title_text}")
print(f"title_chars: {len(title_text)}")
if len(title_text) == 0:
    t_status = "fail: empty title"
elif len(title_text) < 30:
    t_status = "warn: under 30 chars (under-descriptive)"
elif len(title_text) > 65:
    t_status = "warn: over 65 chars (SERP truncation risk)"
else:
    t_status = "pass"
print(f"title_status: {t_status}")

desc_text = re.sub(r"\s+", " ", page.meta_desc[0]).strip() if page.meta_desc else ""
print(f"meta_description_count: {len(page.meta_desc)}")
print(f"meta_description_chars: {len(desc_text)}")
if len(page.meta_desc) == 0 or len(desc_text) == 0:
    d_status = "warn: missing meta description"
elif len(desc_text) < 70:
    d_status = "warn: under 70 chars (short snippet)"
elif len(desc_text) > 160:
    d_status = "warn: over 160 chars (SERP truncation risk)"
else:
    d_status = "pass"
print(f"meta_description_status: {d_status}")

og_t = page.og_title or ""
og_d = page.og_desc or ""
og_img = page.og_image or ""
print(f"og_title: {og_t if og_t else '(none)'}")
print(f"og_description: {og_d if og_d else '(none)'}")
print(f"og_image: {og_img if og_img else '(none)'}")
if og_t:
    print(f"og_title_matches_title: {'yes' if og_t == title_text else 'no'}")

h1s = [t for lvl, t in page.headings if lvl == 1]
h1_count = len(h1s)
if h1_count == 0:
    h1_status = "warn: missing h1"
elif h1_count == 1:
    h1_status = "pass"
else:
    h1_status = f"warn: multiple h1 tags ({h1_count})"

skipped_levels = []
prev_lvl = 0
for lvl, t in page.headings:
    if prev_lvl > 0 and lvl > prev_lvl + 1:
        skipped_levels.append(f"h{prev_lvl}->h{lvl}")
    prev_lvl = lvl

if not page.headings:
    heading_hierarchy = "warn: no headings declared"
elif skipped_levels:
    heading_hierarchy = f"warn: skipped levels ({', '.join(skipped_levels[:3])})"
else:
    heading_hierarchy = "pass"

print(f"h1_count: {h1_count}")
print(f"h1_status: {h1_status}")
print(f"heading_hierarchy: {heading_hierarchy}")
for t in h1s[:3]:
    print(f"h1: {t}")
print(f"hreflang_count: {page.hreflang}")
print(f"initial_html_text_chars: {len(text)}")
words_list = text.split()
print(f"visible_words: {len(words_list)}")
MODERN_IMG_EXTS = {".webp", ".avif", ".svg"}
LEGACY_IMG_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".bmp", ".tiff", ".ico"}

modern_img_count = 0
legacy_img_count = 0

for isrc in page.img_sources:
    try:
        p_path = urlparse(isrc).path.lower()
        _, ext = os.path.splitext(p_path)
        q_str = urlparse(isrc).query.lower()
        if ext in MODERN_IMG_EXTS or any(x in q_str for x in ("format=webp", "format=avif", "fm=webp", "fm=avif", "ext=webp")):
            modern_img_count += 1
        elif ext in LEGACY_IMG_EXTS or any(x in q_str for x in ("format=png", "format=jpg", "format=jpeg", "fm=jpg", "fm=jpeg", "fm=png")):
            legacy_img_count += 1
    except Exception:
        pass

if page.img_count == 0:
    img_dim_status = "none"
    img_format_status = "none"
else:
    if page.img_missing_dims == 0:
        img_dim_status = "pass"
    else:
        img_dim_status = f"warn: {page.img_missing_dims} image(s) missing width/height (CLS risk)"

    if legacy_img_count == 0 and modern_img_count > 0:
        img_format_status = "pass"
    elif legacy_img_count == 0 and modern_img_count == 0:
        img_format_status = "pass"
    else:
        img_format_status = f"warn: {legacy_img_count} legacy image(s) detected (recommend WebP or AVIF)"

img_oversized_count = 0
checked_imgs = set()
for isrc in page.img_sources[:5]:
    if not isrc or isrc.startswith("data:"):
        continue
    img_url = urljoin(final_url, isrc)
    if img_url in checked_imgs:
        continue
    checked_imgs.add(img_url)
    p_img = urlparse(img_url)
    if p_img.scheme not in ("http", "https"):
        continue
    try:
        req = urllib.request.Request(img_url, headers={"User-Agent": ua}, method="HEAD")
        opener = urllib.request.build_opener(_SafeRedirect)
        with opener.open(req, timeout=2.5) as resp:
            clen = resp.headers.get("Content-Length")
            if clen and clen.isdigit():
                if int(clen) > 200 * 1024:
                    img_oversized_count += 1
    except Exception:
        pass

print(f"img_count: {page.img_count}")
print(f"img_missing_alt: {page.img_missing_alt}")
print(f"img_lazy_count: {page.img_lazy}")
print(f"img_missing_dims: {page.img_missing_dims}")
print(f"img_dim_status: {img_dim_status}")
print(f"img_modern_formats: {modern_img_count}")
print(f"img_legacy_formats: {legacy_img_count}")
print(f"img_format_status: {img_format_status}")
print(f"img_oversized_count: {img_oversized_count}")
vp = page.viewport or ""
print(f"viewport: {vp if vp else '(none)'}")
if not vp:
    vp_status = "warn: missing viewport tag (mobile-first risk)"
elif "width=device-width" in vp.lower():
    vp_status = "pass"
else:
    vp_status = "warn: missing width=device-width"
print(f"viewport_status: {vp_status}")

script_tags = len(re.findall(r"(?i)<script\b", body))
print(f"script_tags: {script_tags}")
print(f"js_shell_suspect: {'yes' if len(text) < 500 and script_tags > 0 else 'no'}")

SOFT_404_RX = re.compile(
    r"\b(page not found|404 not found|404 error|article not found|post not found|product not found|no products found|category not found|item not found|content not found|page doesn'?t exist|page does not exist|could not find the page)\b",
    re.I
)
is_soft_404 = False
if status.startswith("2"):
    title_low = title_text.lower()
    if "404" in title_low or "not found" in title_low:
        is_soft_404 = True
    elif SOFT_404_RX.search(text):
        is_soft_404 = True
    elif len(words_list) < 25 and script_tags == 0:
        is_soft_404 = True
print(f"soft_404_suspect: {'yes' if is_soft_404 else 'no'}")
print(f"last_modified: {last_modified}")
print(f"etag: {etag}")
ua_label = "googlebot_smartphone" if "Googlebot" in ua else ("openai_searchbot" if "OAI-SearchBot" in ua else "default")
print(f"user_agent: {ua_label}")

AI_CLICHE_RX = re.compile(
    r"\b(in today's (fast-paced|ever-evolving|digital)|in this ever-evolving world of|it is important to (remember|keep in mind)|when it comes to|delve into|delving into|a tapestry of|a testament to|beacon of|double-edged sword|crucial role|pivotal role|harness the power of|unleash the potential of|game-changer|revolutionary|nestled in the heart of|embark on a journey|plethora of|needless to say|in conclusion|to wrap up|all in all)\b",
    re.I
)
ai_cliches = [m.group(0).lower() for m in AI_CLICHE_RX.finditer(text)]
print(f"ai_cliche_count: {len(ai_cliches)}")
if ai_cliches:
    uniq_cliches = sorted(set(ai_cliches))
    print(f"ai_cliche_matches: {', '.join(uniq_cliches[:5])}")
    print(f"humanize_status: warn: {len(ai_cliches)} AI cliché phrase(s) detected")
else:
    print("humanize_status: pass")

print("browser_render: nt")
print("rendered_html: nt")

LABEL_RX = re.compile(r"^\s*(direct answer|short answer|quick answer|answer|in short|summary|tl;?dr)\s*[:\-\u2013\u2014]", re.I)
SCHEMA_LABEL_RX = re.compile(r"^\s*(direct answer|short answer|quick answer|answer|in short|summary|tl;?dr)\b", re.I)
first_p = page.first_p or ""
first_p_words = len(first_p.split()) if first_p else 0
first_p_chars = len(first_p) if first_p else 0
if 35 <= first_p_words <= 65:
    first_p_answer_ready = f"yes ({first_p_words} words, optimal 35-65)"
elif first_p_words > 65:
    first_p_answer_ready = f"no ({first_p_words} words, too long for concise snippet)"
elif first_p_words > 0:
    first_p_answer_ready = f"no ({first_p_words} words, too short for self-contained answer)"
else:
    first_p_answer_ready = "no (no paragraph found)"

print(f"first_p_words: {first_p_words}")
print(f"first_p_chars: {first_p_chars}")
print(f"first_p_answer_ready: {first_p_answer_ready}")
print(f"first_p_label_prefix: {'yes' if LABEL_RX.match(first_p) else 'no'}")

def answer_texts(node):
    if isinstance(node, dict):
        for key in ("acceptedAnswer", "suggestedAnswer"):
            ans = node.get(key)
            for a in (ans if isinstance(ans, list) else [ans]):
                if isinstance(a, dict) and isinstance(a.get("text"), str):
                    yield a["text"]
        for v in node.values():
            yield from answer_texts(v)
    elif isinstance(node, list):
        for v in node:
            yield from answer_texts(v)

schema_answers, schema_labelled = 0, 0
type_blocks = defaultdict(list)
print(f"jsonld_blocks: {len(page.ld)}")
for i, raw in enumerate(page.ld, 1):
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as e:
        print(f"jsonld_{i}: parse_fail {e}")
        continue
    nodes = data.get("@graph") if isinstance(data, dict) and isinstance(data.get("@graph"), list) else None
    shape = "@graph" if nodes is not None else ("array" if isinstance(data, list) else "single")
    print(f"jsonld_{i}_shape: {shape}")
    items = nodes if nodes is not None else (data if isinstance(data, list) else [data])
    types = []
    for n in items:
        if isinstance(n, dict):
            t = str(n.get("@type"))
            types.append(t)
            if i not in type_blocks[t]:
                type_blocks[t].append(i)
    print(f"jsonld_{i}_types: {', '.join(types)}")
    for t in answer_texts(data):
        schema_answers += 1
        plain = re.sub(r"<[^>]+>", " ", html.unescape(t))
        if SCHEMA_LABEL_RX.match(plain):
            schema_labelled += 1
print(f"schema_answer_texts: {schema_answers}")
print(f"schema_answer_label_prefix: {schema_labelled}")
dups = [f"{t} (blocks {','.join(map(str, bs))})" for t, bs in sorted(type_blocks.items()) if len(bs) > 1 and t != "None"]
if dups:
    print(f"schema_duplicate_types: warn: {'; '.join(dups)}")
else:
    print("schema_duplicate_types: none")

print(f"internal_outlinks: {len(internal)}")
for u in internal[:30]:
    print(f"internal_link: {u}")
if len(internal) > 30:
    print(f"internal_link_truncated: {len(internal) - 30}")

low = body.lower()
print(f"table_count: {low.count('<table')}")
print(f"ol_count: {low.count('<ol')}")
print(f"ul_count: {low.count('<ul')}")
print(f"heading_count: {len(page.headings)}")
for lvl, t in page.headings[:40]:
    print(f"h{lvl}: {t}")
for i, follow in enumerate(page.h2_follow, 1):
    snippet = follow[:240]
    print(f"h2_follow_{i}: {snippet}")

for i, para in enumerate(page.paras[:8], 1):
    words = para.split()
    print(f"p{i}: {' '.join(words[:40])}")

# robots.txt
origin = f"{urlparse(final_url).scheme}://{urlparse(final_url).netloc}"
robots_status, _, robots_body = fetch_url(urljoin(origin, "/robots.txt"))
print(f"robots_txt_status: {robots_status}")

class Group:
    def __init__(self):
        self.agents = []
        self.rules = []  # (allow, pattern)

groups = []
sitemaps = []
robots_mode = "parsed" if robots_status == "200" else ("allow_all" if robots_status.startswith("4") else "nt")
if robots_mode == "allow_all":
    print("robots_txt_note: 4xx means no restrictions (RFC 9309 2.3.1.3)")
if robots_mode == "parsed":
    robots_url = urljoin(origin, "/robots.txt")
    g = None
    for raw_line in robots_body.lstrip("\ufeff").splitlines():
        line = raw_line.split("#", 1)[0].strip()
        if not line or ":" not in line:
            continue  # blank lines do not end a group (RFC 9309)
        key, val = line.split(":", 1)
        key, val = key.strip().lower(), val.strip()
        if key == "user-agent":
            if g is None or g.rules:
                g = Group()
                groups.append(g)
            g.agents.append(val)
        elif key in ("allow", "disallow") and g is not None:
            g.rules.append((key == "allow", val))
        elif key == "sitemap" and val:
            sitemaps.append(urljoin(robots_url, val))

def path_of(url):
    u = urlparse(url)
    p = u.path or "/"
    p = p if p.startswith("/") else "/" + p
    return p + ("?" + u.query if u.query else "")  # RFC 9309 matches path plus query

def matches(pattern, path):
    if pattern == "":
        return False
    end = pattern.endswith("$")
    pat = pattern[:-1] if end else pattern
    rx = "^" + re.escape(pat).replace(r"\*", ".*")
    if end:
        rx += "$"
    return re.search(rx, path) is not None

def decision(token, path):
    chosen = [g for g in groups if any(a.lower() == token.lower() for a in g.agents)]
    used = token if chosen else "*"
    if not chosen:
        chosen = [g for g in groups if any(a == "*" for a in g.agents)]
    best = None  # (length, allow)
    for g in chosen:
        for allow, pattern in g.rules:
            if pattern == "" and not allow:
                continue
            if pattern == "" and allow:
                continue
            if matches(pattern, path):
                cand = (len(pattern), allow)
                if best is None or cand[0] > best[0] or (cand[0] == best[0] and allow):
                    best = cand
    if best is None:
        return used, "allow", "no matching rule"
    return used, "allow" if best[1] else "disallow", f"longest pattern length {best[0]}"

agents = [
    ("Googlebot", "search"),
    ("Bingbot", "search"),
    ("OAI-SearchBot", "search"),
    ("Claude-SearchBot", "search"),
    ("PerplexityBot", "search"),
    ("Applebot", "search"),
    ("Amazonbot", "search"),
    ("DuckAssistBot", "search"),
    ("ChatGPT-User", "user"),
    ("Claude-User", "user"),
    ("Perplexity-User", "user"),
    ("Meta-ExternalFetcher", "user"),
    ("MistralAI-User", "user"),
    ("GPTBot", "training"),
    ("Google-Extended", "training"),
    ("ClaudeBot", "training"),
    ("Applebot-Extended", "training"),
    ("CCBot", "training"),
    ("Meta-ExternalAgent", "training"),
    ("Bytespider", "training"),
    ("cohere-ai", "training"),
    ("GrokBot", "training"),
    ("OAI-AdsBot", "ads"),
]
path = path_of(final_url)
print(f"robots_path: {path}")
notes = {
    "ChatGPT-User": "OpenAI: robots.txt may not apply to this user-triggered agent",
    "Perplexity-User": "Perplexity: this user-triggered agent generally ignores robots.txt",
    "Google-Extended": "token only; not a separate HTTP user agent; does not control Google Search",
    "Meta-ExternalFetcher": "Meta: user-initiated fetch in Meta AI and messaging apps",
    "MistralAI-User": "Mistral: user-initiated fetch in Le Chat",
}
for token, kind in agents:
    if robots_mode == "nt":
        print(f"robots_agent: {token}\t{kind}\tnt")
        continue
    if robots_mode == "allow_all":
        print(f"robots_agent: {token}\t{kind}\tgroup=none\tallow\trobots.txt {robots_status}")
        continue
    used, result, why = decision(token, path)
    extra = notes.get(token, "")
    print(f"robots_agent: {token}\t{kind}\tgroup={used}\t{result}\t{why}\t{extra}".rstrip())

locs_n = set()
incomplete = False
fetched = 0

for s in sitemaps:
    print(f"sitemap_declared: {s}")
if not sitemaps:
    print("sitemap_declared: (none)")
    print("in_sitemap: nt")
else:
    MAX_FILES, MAX_BYTES = 20, 50 * 1024 * 1024
    queue, seen = list(sitemaps), set()
    while queue:
        sm = queue.pop(0)
        if sm in seen:
            continue
        if fetched >= MAX_FILES:
            incomplete = True
            print(f"sitemap_note: stopped at {MAX_FILES} files")
            break
        seen.add(sm); fetched += 1
        sm_status, _, raw = fetch_url(sm, binary=True)
        if raw[:2] == b"\x1f\x8b":
            try:
                raw = gzip.GzipFile(fileobj=io.BytesIO(raw)).read(MAX_BYTES + 1)
            except OSError:
                raw = b""; sm_status = "error: bad gzip"
            if len(raw) > MAX_BYTES:
                raw = b""; sm_status = "error: gzip over size cap"
        sm_body = raw.decode("utf-8", "replace")
        print(f"sitemap_fetch: {sm} status={sm_status} bytes={len(raw)}")
        if sm_status != "200":
            incomplete = True
            continue
        found = [html.unescape(u.strip()) for u in re.findall(r"(?i)<loc>\s*([^<]+?)\s*</loc>", sm_body)]
        if "<sitemapindex" in sm_body.lower():
            queue.extend(urljoin(sm, u) for u in found if urljoin(sm, u) not in seen)
        else:
            locs_n.update(norm(u) for u in found)
    print(f"sitemap_files_read: {fetched}")
    print(f"sitemap_url_count: {len(locs_n)}")
    if norm(final_url) in locs_n:
        print("in_sitemap: yes")
    else:
        print(f"in_sitemap: {'nt' if incomplete else 'no'}")

print("orphan_check: nt")
llms_status, llms_hdr, llms_body = fetch_url(urljoin(origin, "/llms.txt"))
is_html = "text/html" in llms_hdr.lower() or llms_body.lstrip().lower().startswith(("<!doctype", "<html"))
if llms_status == "200" and is_html:
    print("llms_txt_status: warn: soft_404 (returned html fallback)")
else:
    print(f"llms_txt_status: {llms_status}")
print("llms_txt: optional")

if out_format == "json":
    robots_agents_data = {}
    for token, kind in agents:
        if robots_mode == "nt":
            robots_agents_data[token] = {"kind": kind, "group": None, "decision": "nt", "reason": "robots.txt not fetched"}
        elif robots_mode == "allow_all":
            robots_agents_data[token] = {"kind": kind, "group": "none", "decision": "allow", "reason": f"robots.txt {robots_status}"}
        else:
            used, result, why = decision(token, path)
            robots_agents_data[token] = {"kind": kind, "group": used, "decision": result, "reason": why}

    report_json = {
        "url": page_url,
        "final_url": final_url,
        "http": {
            "status": status,
            "redirects": int(redirects) if str(redirects).isdigit() else 0,
            "hops": hop_statuses,
            "check": "pass" if status.startswith("2") else "fail",
            "last_modified": last_modified,
            "etag": etag
        },
        "metadata": {
            "title": title_text,
            "title_chars": len(title_text),
            "title_status": t_status,
            "description": desc_text,
            "description_chars": len(desc_text),
            "description_status": d_status,
            "canonical": page.canonical,
            "canonical_status": canonical_status,
            "viewport": vp if vp else None,
            "viewport_status": vp_status,
            "opengraph": {
                "title": og_t,
                "description": og_d,
                "image": og_img,
                "title_matches_title": (og_t == title_text) if og_t else None
            }
        },
        "headings": {
            "h1_count": h1_count,
            "h1_status": h1_status,
            "h1": h1s[0] if h1s else None,
            "heading_hierarchy": heading_hierarchy,
            "total_headings": len(page.headings),
            "items": [{"level": lvl, "text": t} for lvl, t in page.headings]
        },
        "content": {
            "visible_words": len(words_list),
            "visible_chars": len(text),
            "first_p": first_p,
            "first_p_words": first_p_words,
            "first_p_char_count": first_p_chars,
            "first_p_answer_ready": first_p_answer_ready,
            "first_p_label_prefix": bool(LABEL_RX.match(first_p)),
            "ai_cliche_count": len(ai_cliches),
            "ai_cliche_matches": uniq_cliches if ai_cliches else [],
            "humanize_status": f"warn: {len(ai_cliches)} AI cliché phrase(s) detected" if ai_cliches else "pass",
            "soft_404_suspect": is_soft_404
        },
        "schema": {
            "jsonld_blocks": len(page.ld),
            "duplicate_types": dups,
            "schema_duplicate_status": f"warn: {'; '.join(dups)}" if dups else "none",
            "schema_answers": schema_answers,
            "schema_answer_label_prefix": schema_labelled
        },
        "robots": {
            "path": path,
            "status": robots_status,
            "agents": robots_agents_data
        },
        "sitemaps": {
            "declared": list(sitemaps),
            "files_read": fetched if sitemaps else 0,
            "url_count": len(locs_n) if sitemaps else 0,
            "in_sitemap": "yes" if norm(final_url) in locs_n else ("nt" if incomplete else "no")
        },
        "images": {
            "total": page.img_count,
            "missing_alt": page.img_missing_alt,
            "lazy": page.img_lazy,
            "missing_dimensions": page.img_missing_dims,
            "dimension_status": img_dim_status,
            "modern_formats": modern_img_count,
            "legacy_formats": legacy_img_count,
            "format_status": img_format_status,
            "oversized_count": img_oversized_count
        },
        "llms_txt": {
            "status": llms_status,
            "is_soft_404": (llms_status == "200" and is_html)
        }
    }
    _real_print(json.dumps(report_json, indent=2))
elif out_format == "report":
    md = []
    md.append("# Sniper SEO & AI Verification Report")
    md.append("")
    md.append(f"**Target URL:** `{page_url}`  ")
    md.append(f"**Final URL:** `{final_url}`  ")
    md_ua = "Googlebot Smartphone" if "Googlebot" in ua else ("OpenAI OAI-SearchBot" if "OAI-SearchBot" in ua else "Default")
    md.append(f"**HTTP Status:** `{status}` ({redirects} redirects) | **User-Agent:** `{md_ua}`")
    md.append("")
    md.append("## 1. Technical & Indexation Health")
    md.append("| Audit Element | Result | Details |")
    md.append("| :--- | :--- | :--- |")
    md.append(f"| HTTP Response | {'PASS' if status.startswith('2') else 'FAIL'} | HTTP {status} (hop: {' '.join(hop_statuses) or 'none'}) |")
    md.append(f"| Canonical Parity | {'PASS' if canonical_status == 'pass' else 'WARN'} | {canonical_status} |")
    md.append(f"| Mobile Viewport | {'PASS' if vp_status == 'pass' else 'WARN'} | {vp_status} |")
    g_dec = decision('Googlebot', path)[1] if robots_mode not in ('nt', 'allow_all') else ('allow' if robots_mode == 'allow_all' else 'nt')
    oai_dec = decision('OAI-SearchBot', path)[1] if robots_mode not in ('nt', 'allow_all') else ('allow' if robots_mode == 'allow_all' else 'nt')
    perp_dec = decision('PerplexityBot', path)[1] if robots_mode not in ('nt', 'allow_all') else ('allow' if robots_mode == 'allow_all' else 'nt')
    robots_pass = (robots_status == '200' or robots_mode == 'allow_all') and (g_dec == 'allow' and oai_dec == 'allow')
    md.append(f"| Robots.txt Access | {'PASS' if robots_pass else 'WARN'} | Googlebot: {g_dec} / OAI-SearchBot: {oai_dec} / Perplexity: {perp_dec} |")
    md.append(f"| Sitemap Inclusion | {'PASS' if norm(final_url) in locs_n else 'WARN'} | In sitemap: {'yes' if norm(final_url) in locs_n else ('nt' if incomplete else 'no')} ({len(locs_n)} URLs) |")
    md.append(f"| Soft 404 Guard | {'PASS' if not is_soft_404 else 'FAIL'} | Suspect: {'yes' if is_soft_404 else 'no'} |")
    md.append("")
    md.append("## 2. Headings & AI Citation Structure")
    md.append("| Metric | Status | Finding |")
    md.append("| :--- | :--- | :--- |")
    md.append(f"| H1 Tag | {h1_status.upper()} | {h1s[0] if h1s else '(none)'} |")
    md.append(f"| Heading Hierarchy | {heading_hierarchy.upper()} | {len(page.headings)} total headings across DOM |")
    md.append(f"| Direct Answer Passage | {'YES' if 'yes' in first_p_answer_ready else 'NO'} | {first_p_answer_ready} |")
    md.append(f"| AI Cliché Lint | {'PASS' if not ai_cliches else 'WARN'} | {len(ai_cliches)} cliché phrase(s) detected |")
    md.append(f"| Schema.org Markup | {'PASS' if not dups else 'WARN'} | {len(page.ld)} blocks, duplicate types: {'; '.join(dups) if dups else 'none'} |")
    md.append("")
    md.append("## 3. Snippet & OpenGraph Parity")
    md.append(f"* **Title ({len(title_text)} chars):** `{title_text or '(none)'}` ({t_status})")
    md.append(f"* **Meta Description ({len(desc_text)} chars):** `{desc_text or '(none)'}` ({d_status})")
    if og_t:
        md.append(f"* **OpenGraph Title:** `{og_t}` (matches title: {'yes' if og_t == title_text else 'no'})")
    if og_img:
        md.append(f"* **OpenGraph Image:** `{og_img}`")
    md.append("")
    md.append("## 4. Image Optimization & Layout Stability")
    md.append("| Metric | Status | Finding |")
    md.append("| :--- | :--- | :--- |")
    md.append(f"| Alt Text Coverage | {'PASS' if page.img_missing_alt == 0 else 'WARN'} | {page.img_count} image(s), {page.img_missing_alt} missing alt attribute |")
    md.append(f"| Layout Stability (CLS) | {'PASS' if page.img_missing_dims == 0 else 'WARN'} | {img_dim_status} |")
    md.append(f"| Modern Formats | {'PASS' if legacy_img_count == 0 else 'WARN'} | {modern_img_count} modern (WebP/AVIF/SVG), {legacy_img_count} legacy |")
    md.append(f"| Lazy Loading | {'PASS' if page.img_lazy > 0 or page.img_count == 0 else 'INFO'} | {page.img_lazy} lazy loaded |")
    md.append(f"| File Size Check | {'PASS' if img_oversized_count == 0 else 'WARN'} | {img_oversized_count} oversized (>200 KB) image(s) detected |")
    md.append("")
    md.append("## 5. AI Crawlers & AEO Search Indexing")
    md.append("| Crawler / Engine | Category | robots.txt Access |")
    md.append("| :--- | :--- | :--- |")
    for b_name in ("OAI-SearchBot", "ChatGPT-User", "GPTBot", "Claude-SearchBot", "PerplexityBot", "Meta-ExternalAgent", "Bytespider", "Amazonbot"):
        b_dec = decision(b_name, path)[1] if robots_mode not in ('nt', 'allow_all') else ('allow' if robots_mode == 'allow_all' else 'nt')
        b_cat = "Search (AEO)" if b_name in ("OAI-SearchBot", "Claude-SearchBot", "PerplexityBot", "Amazonbot") else ("User Assistant" if "User" in b_name else "Model Training")
        md.append(f"| `{b_name}` | {b_cat} | {b_dec.upper()} |")
    _real_print("\n".join(md))
PY
