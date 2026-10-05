1. Separation of concerns — one function decides and also does the work. Name the two jobs and where the seam belongs.
2. Reuse — this change adds code that should call a function that already exists. Search outside the diff with Read and Grep. Name that path and symbol. If none exists, write none. Two new copies of each other belong on Duplication, not here.
3. Duplication — the same logic appears twice. The other copy may be in this diff or already in the codebase. Search outside the diff. Name both locations and which one is the source of truth.
4. Readable functions — over ~40 lines, deep nesting, or a name that needs "and". Cite the line range.
