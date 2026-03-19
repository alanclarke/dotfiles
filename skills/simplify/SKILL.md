---
name: simplify
description: Refactor code, configs, or docs for clarity and maintainability. Use when asked to simplify, clean up, or reduce complexity.
---

## Principles

- Every line should have a clear purpose — remove what doesn't directly contribute to solving the problem
- Readability over cleverness; clarity over brevity
- Only add abstractions when they genuinely reduce complexity

## What to look for

- Deeply nested conditionals or loops → early returns / guard clauses
- Functions doing too many things → break into focused units
- Complex boolean logic → extract into well-named functions
- Unused code, parameters, or imports → remove
- Redundant code or repeated patterns → DRY up
- Nested ternaries → `if`/`else` or `switch`
- Verbose prose → cut filler words, use bullets/tables

## Process

1. Read the target fully before changing anything
2. Focus on recently modified code unless told otherwise
3. Simplify one pass at a time; show before/after for significant changes
4. Verify functionality is preserved (run tests/build if available)
5. Never remove functionality without asking; never change public API
6. Commit simplifications separately from feature work
