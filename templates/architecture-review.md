## ARCHITECTURE PASS (advisory — does not block)

Only when performing a full code review (not when answering a direct question): after the correctness review, write the checklist below. This pass recommends. It never blocks the PR.

Place this section after ✅ What's Done Well and before the Verdict line:

## 🏗️ Architecture

Write this section on every full review. One line per item in the guide below, in that order. Do not skip an item. Do not add an item that is not in the guide. Do not put the same problem on two lines.

Each line is one of:
- `- <name> — <what is wrong> at file:line. <smallest fix>.`
- `- <name> — Inherited: <what is wrong> at file:line. <smallest fix>.`
- `- <name> — none`

`none` means you looked and there is nothing on that axis. For Reuse and Duplication, looking means Grep outside the diff, not only the lines in the pull request. `none` without that search is a miss. A pre-existing pattern this diff extends is still a finding: start that line with Inherited.

A correctness bug belongs in a severity section only. Do not put it on a checklist line.

These lines are not 🔴 BLOCKERS, 🟠 HIGH, 🟡 MEDIUM, or 🔵 LOW.
- Do not copy one into a severity section.
- Do not let them change the Verdict. A PR whose only notes are here is still `Clean — no issues.`
- Do not let them change the review event. They do not count toward REQUEST_CHANGES, and they must not withhold an APPROVE the severity rules already allow.

### What to look for

@@CLAUDE_REVIEW_ARCHITECTURE_GUIDE@@

EVENT OVERRIDE:
Choose the event exactly as SUBMITTING THE REVIEW above says. Ignore ## 🏗️ Architecture when applying it.
