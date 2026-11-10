#!/usr/bin/env bash
# Fixture tests for scripts/verify-page.sh. Usage: bash tests/run.sh
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VP="$DIR/scripts/verify-page.sh"
PASS=0; FAIL=0
ok() { PASS=$((PASS+1)); echo "ok   $1"; }
bad() { FAIL=$((FAIL+1)); echo "FAIL $1"; [[ -n "${2:-}" ]] && echo "$2" | sed 's/^/     /'; }

# scenario MODE PATH NAME REGEX...  (every regex must match a line of output)
scenario() {
  local mode="$1" path="$2" name="$3"; shift 3
  local pf; pf="$(mktemp)"; rm -f "$pf"
  python3 "$DIR/tests/fixture_server.py" "$mode" "$pf" & local pid=$!
  for _ in $(seq 50); do [[ -s "$pf" ]] && break; sleep 0.1; done
  local out; out="$(bash "$VP" "http://127.0.0.1:$(cat "$pf")$path" 2>&1)"; local rc=$?
  kill "$pid" 2>/dev/null; wait "$pid" 2>/dev/null; rm -f "$pf"
  [[ $rc -eq 0 ]] || { bad "$name (exit $rc)" "$out"; return; }
  for re in "$@"; do
    grep -Eq -- "$re" <<<"$out" || { bad "$name: missing /$re/" "$out"; return; }
  done
  ok "$name"
}

scenario blankline /page "robots blank line inside group" $'^robots_agent: GPTBot\ttraining\tgroup=GPTBot\tdisallow'
scenario multiua /page "robots multiple UAs then blank lines" $'^robots_agent: CCBot\ttraining\tgroup=CCBot\tdisallow' $'^robots_agent: Googlebot\tsearch\tgroup=\\*\tallow'
scenario tie /page "robots allow/disallow tie -> allow" $'^robots_agent: Googlebot\tsearch\tgroup=\\*\tallow'
scenario bom /page "robots BOM stripped" $'^robots_agent: Googlebot\tsearch\tgroup=\\*\tdisallow'
scenario norobots /page "no robots.txt -> allow all" '^robots_txt_status: 404' $'^robots_agent: GPTBot\ttraining\tgroup=none\tallow' '^in_sitemap: nt'
scenario twosm /page "two sitemaps, page in second" '^sitemap_files_read: 2' '^in_sitemap: yes'
scenario gz /page "gz sitemap" '^in_sitemap: yes'
scenario index /page "sitemap index expanded" '^sitemap_files_read: 2' '^in_sitemap: yes'
scenario loop /page "sitemap index loop terminates" '^sitemap_files_read: 2' '^in_sitemap: no'
scenario x /hop "redirect-hop noindex ignored" '^hop_status: 301 200' '^x_robots_tag: \(none\)' '^indexability: pass'
scenario x /gb "googlebot meta noindex" '^indexability: fail'
scenario x /xrt-other "other-bot XRT reported, not judged" '^x_robots_other_agent: otherbot' '^indexability: pass'
scenario x /xrt-google "googlebot-scoped XRT judged" '^indexability: fail'
scenario x /404 "404 page fails" '^http_check: fail' '^indexability: fail'
scenario x /403 "403 is nt, not fail" '^http_check: fail' '^indexability: nt' '^index_note: status 403'
scenario x /dupcanon "identical canonicals count once" '^canonical_unique_count: 1' '^canonical_differs: none'
scenario x /shell "JS shell flagged" '^js_shell_suspect: yes'
scenario x /page "normal page not a shell" '^js_shell_suspect: no'
scenario x /label "plain label prefix flagged" '^first_p_label_prefix: yes' '^schema_answer_texts: 2' '^schema_answer_label_prefix: 1'
scenario x /eyebrow "styled eyebrow not flagged" '^first_p_label_prefix: no' '^schema_answer_label_prefix: 0'
scenario x "/canq?b=2" "canonical differs by query" '^canonical_matches_final: no' '^canonical_differs: query'
scenario x "/canq?a=1" "canonical with same query matches" '^canonical_matches_final: yes' '^canonical_differs: none'
scenario x /img "image and title/meta checks" '^img_count: 2' '^img_missing_alt: 1' '^img_lazy_count: 1' '^title_status: pass' '^meta_description_status: pass'
scenario x /viewport "viewport tag passes" '^viewport: width=device-width' '^viewport_status: pass'
scenario x /soft404 "soft 404 flagged on 200 page" '^soft_404_suspect: yes'
scenario x /aicliche "ai cliche detected" '^ai_cliche_count: 3' '^humanize_status: warn: 3 AI cliché phrase\(s\) detected'

# --- robots parser edge cases (raw robots body via FIXTURE_ROBOTS) ---
FIXTURE_ROBOTS=$'User-agent: *\nDisallow: /*?sessionid=\n' scenario rawrobots "/page?sessionid=1" "robots rule on query string is matched" $'^robots_path: /page\\?sessionid=1' $'^robots_agent: GPTBot\ttraining\tgroup=\\*\tdisallow'
FIXTURE_ROBOTS=$'User-agent: *\nDisallow: /*?sessionid=\n' scenario rawrobots "/page?other=1" "query rule does not match other queries" $'^robots_agent: GPTBot\ttraining\tgroup=\\*\tallow'
FIXTURE_ROBOTS=$'User-agent: *\nDisallow: /\n\nUser-agent: Googlebot\nAllow: /\n' scenario rawrobots /page "named group overrides *" $'^robots_agent: Googlebot\tsearch\tgroup=Googlebot\tallow' $'^robots_agent: GPTBot\ttraining\tgroup=\\*\tdisallow'
FIXTURE_ROBOTS=$'User-agent: gptbot\nDisallow: /\n' scenario rawrobots /page "agent token is case-insensitive" $'^robots_agent: GPTBot\ttraining\tgroup=GPTBot\tdisallow'
FIXTURE_ROBOTS=$'User-agent: *\nDisallow: /page$\n' scenario rawrobots /page "dollar anchor matches exact path" $'^robots_agent: GPTBot\ttraining\tgroup=\\*\tdisallow'
FIXTURE_ROBOTS=$'User-agent: *\nDisallow: /page$\n' scenario rawrobots /page/ "dollar anchor does not match longer path" $'^robots_agent: GPTBot\ttraining\tgroup=\\*\tallow'
FIXTURE_ROBOTS=$'User-agent: *\nDisallow: /\nAllow: /page\n' scenario rawrobots /page "longest match wins" $'^robots_agent: GPTBot\ttraining\tgroup=\\*\tallow'
FIXTURE_ROBOTS=$'User-agent: GPTBot\nCrawl-delay: 5\nUser-agent: ClaudeBot\nDisallow: /\n' scenario rawrobots /page "crawl-delay between agents keeps both in group" $'^robots_agent: GPTBot\ttraining\tgroup=GPTBot\tdisallow' $'^robots_agent: ClaudeBot\ttraining\tgroup=ClaudeBot\tdisallow'
FIXTURE_ROBOTS=$'User-agent:   GPTBot   # training\nDisallow: /page # x\n' scenario rawrobots /page "comments and spaces tolerated" $'^robots_agent: GPTBot\ttraining\tgroup=GPTBot\tdisallow'
scenario robots5xx /page "robots 5xx is nt, not allow" '^robots_txt_status: 503' $'^robots_agent: GPTBot\ttraining\tnt'
scenario x /page "missing canonical is a warn" '^canonical_status: warn: no canonical declared'
scenario x /aicliche2 "extended cliche list detected" '^ai_cliche_count: 7' '^humanize_status: warn'

# --- docs consistency: rubric weights, worked-example arithmetic, char counts ---
if doc_out="$(python3 - "$DIR" << 'PY'
import math, re, sys
d = sys.argv[1]
skill = open(d + "/SKILL.md", encoding="utf-8").read()
ex = open(d + "/references/example-audit.md", encoding="utf-8").read()
cats = ["answer", "contain", "structure", "sourced", "original"]
errs = []
sw = {c: int(re.search(r"\| \*\*%s\*\* \| (\d+) \|" % c, skill).group(1)) for c in cats}
ew, ep = {}, {}
for c in cats:
    m = re.search(r"\| \*\*%s\*\* \| (\d+)/10 \| (\d+) \|" % c, ex)
    ep[c], ew[c] = int(m.group(1)), int(m.group(2))
if sw != ew:
    errs.append("weights differ: SKILL %s vs example %s" % (sw, ew))
if sum(sw.values()) != 100:
    errs.append("SKILL weights sum to %d" % sum(sw.values()))
raw = sum(ep[c] / 10 * ew[c] for c in cats)
overall = math.floor(100 * raw / sum(ew.values()) + 0.5)
stated = int(re.search(r"overall = floor\(.*\) = (\d+)", ex).group(1))
ledger = int(re.search(r"overall score is (\d+)", ex).group(1))
if stated != overall or ledger != overall:
    errs.append("overall: computed %d, stated %d, ledger %d" % (overall, stated, ledger))
t = re.search(r"Proposed Title \((\d+) chars.*?<title>(.*?)</title>", ex, re.S)
if int(t.group(1)) != len(t.group(2)):
    errs.append("title claims %s chars, is %d" % (t.group(1), len(t.group(2))))
m = re.search(r"Proposed Meta Description \((\d+) chars.*?content=\"(.*?)\"", ex, re.S)
if int(m.group(1)) != len(m.group(2)):
    errs.append("meta claims %s chars, is %d" % (m.group(1), len(m.group(2))))
for label, n in (("title", len(t.group(2))), ("meta", len(m.group(2)))):
    lo, hi = (30, 65) if label == "title" else (70, 160)
    if not lo <= n <= hi:
        errs.append("%s %d outside lint range %d-%d" % (label, n, lo, hi))
print("\n".join(errs))
sys.exit(1 if errs else 0)
PY
)"
then ok "docs: weights, example arithmetic and char counts are consistent"
else bad "docs consistency check failed" "$doc_out"; fi

# test googlebot smartphone flag
pf="$(mktemp)"; rm -f "$pf"
python3 "$DIR/tests/fixture_server.py" "x" "$pf" & pid=$!
for _ in $(seq 50); do [[ -s "$pf" ]] && break; sleep 0.1; done
out="$(bash "$VP" -g "http://127.0.0.1:$(cat "$pf")/page" 2>&1)"
kill "$pid" 2>/dev/null; wait "$pid" 2>/dev/null; rm -f "$pf"
if grep -q '^user_agent: googlebot_smartphone' <<<"$out"; then
  ok "googlebot flag emulates googlebot smartphone"
else
  bad "googlebot flag failed" "$out"
fi

# usage errors
for args in "" "file:///etc/passwd" "a b"; do
  # shellcheck disable=SC2086
  bash "$VP" $args >/dev/null 2>&1; rc=$?
  [[ $rc -eq 2 ]] && ok "exit 2 for args '$args'" || bad "exit $rc (want 2) for args '$args'"
done

# Python compatibility: compile the embedded program on every python3.x found
PY_SRC="$(mktemp)"; sed -n "/<< 'PY'/,/^PY$/p" "$VP" | sed '1d;$d' > "$PY_SRC"
found=0
for py in $(compgen -c python3. | grep -E '^python3\.[0-9]+$' | sort -u) python3; do
  command -v "$py" >/dev/null || continue
  found=1
  "$py" -c "import sys; compile(open(sys.argv[1]).read(), 'verify', 'exec')" "$PY_SRC" 2>/dev/null \
    && ok "compiles on $($py -V 2>&1)" || bad "SyntaxError on $($py -V 2>&1)"
done
[[ $found -eq 1 ]] || bad "no python3 found"
rm -f "$PY_SRC"

echo "passed: $PASS failed: $FAIL"
[[ $FAIL -eq 0 ]]
