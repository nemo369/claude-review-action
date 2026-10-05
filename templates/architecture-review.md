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

Review the diff, plus surrounding code when you need it to judge reuse. State a finding this diff introduced, made worse, or copied forward. A pre-existing pattern this diff extends is still a finding: label it Inherited and write it in full, so the owner can decide.

1. Separation of concerns — one function decides and does. Name the two jobs and where the seam belongs.
2. Reuse — a new helper that already exists. Name the existing thing (path + symbol) when you have it. If you can see the duplicate and have not opened the original, still state it and say the original was not opened.
3. Duplication — the same logic in 2+ places. Name both locations, and which is the source of truth when you know it.
4. Readable functions — over ~40 lines, deep nesting, a name that needs "and". Cite the line range.
5. Decoupling — a dependency pointing the wrong way. Say concretely what breaks if X changes.
6. Extensibility — the next likely change is shotgun surgery. Name that change and count the files it touches.
7. Design practice — a table beaten into conditionals, a default that fails open, an abstraction with one implementation and no second in sight. Name the invariant at risk.
8. Composition of passes — two transforms over the same structure, applied at different points. Name both passes, their order, and an input that would make the later one undo the earlier.

A comment that explains a ceiling does not erase the finding. State the structure and mention the ceiling, so the owner can keep the shortcut on purpose.

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
