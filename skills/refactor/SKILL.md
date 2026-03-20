---
name: refactor
description: Safe refactoring by applying the architect and simplify skills.
---

When invoked directly, read the target fully then apply `architect` followed by `simplify`.

## Process

Both `architect` and `simplify` follow this process:

1. Read the target fully before changing anything
2. Change one thing at a time; show before/after for significant changes
3. Verify functionality is preserved (run tests/build if available)
4. Never remove functionality without asking; never change public API
5. Commit refactoring separately from feature work
