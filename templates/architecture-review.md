## ARCHITECTURE PASS (advisory — does not block)

Only when performing a full code review (not when answering a direct question): after the correctness review, do one short pass on the same diff. This pass recommends. It never blocks the PR.

Place this section after ✅ What's Done Well and before the Verdict line:

## 🏗️ Architecture

If you have an accurate structural finding, write it. Do not drop it, hedge it into "fine until later," or shrink it to "not this PR's job."
Skip the section only when you have no accurate finding. Do not write "nothing to fix" as a finding. Do not invent one to fill the section.

These recommendations are not 🔴 BLOCKERS, 🟠 HIGH, 🟡 MEDIUM, or 🔵 LOW.
- Do not copy one into a severity section. A correctness bug belongs in a severity section and is not repeated here.
- Do not let them change the Verdict. A PR whose only notes are here is still `Clean — no issues.`
- Do not let them change the review event. They do not count toward REQUEST_CHANGES, and they must not withhold an APPROVE the severity rules already allow.

Do not skip this section to save turns. A finding you are sure of is part of the review.

### What to look for

@@CLAUDE_REVIEW_ARCHITECTURE_GUIDE@@

### Finding bar

State every accurate finding. Write at most 3 in full. If there are more, list the rest as one line each in the same section. Do not silently drop any of them.

Each full finding:

### 1. <title> — axis, file:line
what it is · why it costs the next change · the smallest fix, or Inherited / Worth doing separately when the fix is not for this PR

Point at the diff. Give a file:line and a named alternative when you have them. Missing either is not a reason to delete a finding you are sure of. Say what you could not confirm.

A new layer, a repo-wide rename, or a rewrite is still stated. Mark it Worth doing separately. That mark means "bigger than this PR," not "ignore."

Judge against this codebase's conventions. If two patterns compete, say which is current.

Label a finding, only when it applies:
- Inherited — already true before this diff. The owner still decides.
- Worth doing separately — real, and bigger than this change.

EVENT OVERRIDE:
Choose the event exactly as SUBMITTING THE REVIEW above says. Ignore ## 🏗️ Architecture when applying it.
