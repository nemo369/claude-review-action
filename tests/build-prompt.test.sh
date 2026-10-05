#!/usr/bin/env bash
# Self-check for the prompt size cap: bash tests/build-prompt.test.sh
set -uo pipefail
cd "$(dirname "$0")/.."
T=$(mktemp -d); trap 'rm -rf "$T" /tmp/claude-prompt.md /tmp/pr-diff.txt /tmp/pr-description.txt /tmp/review-guide.md /tmp/truncated-files.txt' EXIT
mkdir -p "$T/bin"; printf '#!/usr/bin/env bash\necho "$*" >> "%s/gh.log"\n' "$T" > "$T/bin/gh"; chmod +x "$T/bin/gh"
for v in $(grep -oE '\$\{?[A-Z_]+' scripts/build-prompt.sh | sed 's/[${]//g' | sort -u); do export "$v="; done
export PATH="$T/bin:$PATH" ACTION_PATH="$PWD" REPO=x PR_NUMBER=1 EVENT_TYPE=pull_request REVIEW_AUTHORITY=comment-only GITHUB_RUN_ID=1
: > /tmp/review-guide.md; : > /tmp/truncated-files.txt; : > /tmp/user-comment.txt
fail() { echo "FAIL: $*"; exit 1; }
run() { : > "$T/out"; : > "$T/gh.log"; GITHUB_OUTPUT="$T/out" MAX_PROMPT_BYTES="$1" bash scripts/build-prompt.sh > /dev/null; }

printf 'diff --git a/x b/x\n+```\n+secret-line\n' > /tmp/pr-diff.txt; echo "desc" > /tmp/pr-description.txt
run 120000 || fail "small: exit"
grep -q '^+secret-line$' /tmp/claude-prompt.md && grep -q '^```diff$' /tmp/claude-prompt.md || fail "small: diff not inlined"
grep -q '@@CLAUDE_REVIEW_PR_DIFF@@' /tmp/claude-prompt.md && fail "small: marker left"

for i in $(seq 100); do echo "+padding line $i of the big diff"; done >> /tmp/pr-diff.txt
run 4000 || fail "big diff: exit"
grep -q 'secret-line' /tmp/claude-prompt.md && fail "big diff: diff still inlined"
grep -q '/tmp/pr-diff.txt' /tmp/claude-prompt.md || fail "big diff: no pointer"
grep -q 'secret-line' "$T/out" && fail "big diff: diff in output"
[ "$(wc -c < /tmp/claude-prompt.md)" -le 4000 ] || fail "big diff: prompt over cap"

head -c 5000 /dev/zero | tr '\0' d > /tmp/pr-description.txt
run 4000 && fail "huge description: should exit non-zero"
grep -q 'review skipped' "$T/gh.log" || fail "huge description: no PR comment"
printf 'diff --git a/x b/x\n+one\n' > /tmp/pr-diff.txt; printf 'desc\n(PR diff)\nmore\n' > /tmp/pr-description.txt
run 120000 || fail "fake placeholder: exit"
[ "$(grep -c '^+one$' /tmp/claude-prompt.md)" = 1 ] || fail "fake placeholder: diff spliced twice"

printf 'diff --git a/x b/x\n' > /tmp/pr-diff.txt; for i in $(seq 120); do printf '+\t\t\t"q"\t"q"\n'; done >> /tmp/pr-diff.txt; echo desc > /tmp/pr-description.txt
RAW=$(( $(wc -c < /tmp/pr-diff.txt) + 1600 )); run $(( RAW + 400 )) || fail "escaped: exit"
grep -q '/tmp/pr-diff.txt' /tmp/claude-prompt.md || fail "escaped: raw fits but escaped does not — should use pointer"
printf 'what does $(whoami) do?\n' > /tmp/user-comment.txt
EVENT_TYPE=issue_comment run 120000 || fail "comment: exit"
grep -qF 'what does $(whoami) do?' /tmp/claude-prompt.md || fail "comment: not in prompt verbatim"

printf 'diff --git a/x b/x\n+one\n' > /tmp/pr-diff.txt
echo desc > /tmp/pr-description.txt
EVENT_TYPE=pull_request INCLUDE_ARCHITECTURE_REVIEW=false EXTRA_PROMPT= run 120000 || fail "arch off: exit"
grep -q 'ARCHITECTURE PASS (advisory' /tmp/claude-prompt.md && fail "arch off: pass leaked into prompt"
EVENT_TYPE=pull_request INCLUDE_ARCHITECTURE_REVIEW=true EXTRA_PROMPT='EXTRA_PROMPT_SENTINEL' run 120000 || fail "arch on: exit"
grep -q 'not when answering a direct question' /tmp/claude-prompt.md || fail "arch on: question skip missing"
grep -q 'Choose the event exactly as SUBMITTING THE REVIEW above says' /tmp/claude-prompt.md || fail "arch on: event override missing"
grep -q 'Choose REQUEST_CHANGES / APPROVE / COMMENT from the severity sections only' /tmp/claude-prompt.md && fail "arch on: override restates the event rules"
grep -q 'If you have an accurate structural finding, write it' /tmp/claude-prompt.md || fail "arch on: must require stating an accurate finding"
grep -q 'No named existing thing, drop it' /tmp/claude-prompt.md && fail "arch on: reuse drop rule must be gone"
grep -q 'not a thing to fix here' /tmp/claude-prompt.md && fail "arch on: inherited must not be dismissed"
grep -q 'close to the turn limit' /tmp/claude-prompt.md && fail "arch on: turn-limit skip must be gone"
ARCH_LINE=$(grep -n 'ARCHITECTURE PASS (advisory' /tmp/claude-prompt.md | head -1 | cut -d: -f1)
SUBMIT_LINE=$(grep -n 'SUBMITTING THE REVIEW' /tmp/claude-prompt.md | head -1 | cut -d: -f1)
EXTRA_LINE=$(grep -n 'EXTRA_PROMPT_SENTINEL' /tmp/claude-prompt.md | head -1 | cut -d: -f1)
[ -n "$ARCH_LINE" ] && [ -n "$SUBMIT_LINE" ] && [ "$ARCH_LINE" -gt "$SUBMIT_LINE" ] || fail "arch on: pass must follow SUBMITTING THE REVIEW"
[ -n "$EXTRA_LINE" ] && [ "$EXTRA_LINE" -gt "$ARCH_LINE" ] || fail "arch on: extra-prompt must stay last"
echo PASS
