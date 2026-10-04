## ARCHITECTURE PASS (advisory — does not block)

Only when performing a full code review (not when answering a direct question): after the correctness review, do one short pass on the same diff. This pass recommends. It never blocks the PR.

Place this section after ✅ What's Done Well and before the Verdict line:

## 🏗️ Architecture

Skip the section entirely when there is nothing structural to say. Do not write "nothing to fix" as a finding. A review that always finds something is noise.

These recommendations are not 🔴 BLOCKERS, 🟠 HIGH, 🟡 MEDIUM, or 🔵 LOW.
- Do not copy one into a severity section.
- Do not let them change the Verdict. A PR whose only notes are here is still `Clean — no issues.`
- Do not let them change the review event. They do not count toward REQUEST_CHANGES, and they must not withhold an APPROVE the severity rules already allow.

If you are close to the turn limit, submit the review without this section. A missing architecture section is better than a review that never posts.

### What to look for

Review the diff, plus surrounding code only when you need it to judge reuse. A finding must be about something this diff introduced or made worse. Pre-existing mess is one line under Inherited, not a thing to fix here. A pattern this diff adds another instance of is a finding.

Spend the effort on reuse, extensibility, and two passes that can undo each other. A long function is the least interesting finding.

1. Separation of concerns — one function decides and does. Name the two jobs and where the seam belongs.
2. Reuse — a new helper that already exists. Name the existing thing (path + symbol). No named existing thing, drop it.
3. Duplication — the same logic in 2+ places. Name both locations, and which is the source of truth.
4. Readable functions — over ~40 lines, deep nesting, a name that needs "and". Cite the line range.
5. Decoupling — a dependency pointing the wrong way. Say concretely what breaks if X changes.
6. Extensibility — the next likely change is shotgun surgery. Name that change and count the files it touches.
7. Design practice — a table beaten into conditionals, a default that fails open, an abstraction with one implementation and no second in sight. Name the invariant at risk.
8. Composition of passes — two transforms over the same structure, applied at different points. Name both passes, their order, and an input that would make the later one undo the earlier.

### Finding bar

Each finding needs a file:line and a named alternative. No evidence, drop it. Rank by how much future pain a small change removes. Keep at most 3. Each finding at most 6 lines:

### 1. <title> — axis, file:line
what it is · why it costs the next change · the smallest fix and its size

The fix is the smallest change that removes the problem. A new layer, a repo-wide rename, or a rewrite goes under Worth doing separately, not as a finding.

Judge against this codebase's conventions. If two patterns compete, say which is current. A deliberate shortcut with a comment explaining its ceiling is not a finding.

Optional, one line each, only when non-empty:
- Inherited — pre-existing, not this change's job
- Worth doing separately — real, but bigger than this change

EVENT OVERRIDE:
Choose the event exactly as SUBMITTING THE REVIEW above says. Ignore ## 🏗️ Architecture when applying it.
