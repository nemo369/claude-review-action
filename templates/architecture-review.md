## 🏗️ Architecture

This review is advisory. It does not approve the pull request or request changes.

Write one line per item in the guide below, in that order. Do not skip an item. Do not add an item that is not in the guide. Do not put the same problem on two lines.

Each line is one of:
- `- <name> — <what is wrong> at file:line. <smallest fix>.`
- `- <name> — Inherited: <what is wrong> at file:line. <smallest fix>.`
- `- <name> — none`

`none` means you looked and there is nothing on that axis. For Reuse and Duplication, looking means Grep outside the diff, not only the lines in the pull request. `none` without that search is a miss. A pre-existing pattern this diff extends is still a finding: start that line with Inherited.

A correctness bug is not this review. Leave it off.

### What to look for

@@CLAUDE_REVIEW_ARCHITECTURE_GUIDE@@

Output only the section above. No other headers.
