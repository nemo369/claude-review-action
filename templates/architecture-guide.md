Review the diff, plus surrounding code when you need it to judge reuse. State a finding this diff introduced, made worse, or copied forward. A pre-existing pattern this diff extends is still a finding: label it Inherited and write it in full, so the owner can decide.

1. Separation of concerns — one unit decides and also does the work. Name the two jobs and where the seam belongs.
2. Reuse — new code repeats something that already exists. Name the existing thing when you have it. If you have not opened the original, still state the duplicate and say so.
3. Duplication — the same logic in two or more places. Name both locations.
4. Extensibility — the next likely change has to be repeated in several places. Name that change.

A comment that explains a shortcut does not erase the finding. State the structure and mention the shortcut.
