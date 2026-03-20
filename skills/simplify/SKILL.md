---
name: simplify
description: Reduce complexity, minimise specificity, and improve clarity in code.
---

## Principles

- Every line should have a clear purpose — remove what doesn't contribute
- Readability over cleverness; clarity over brevity
- Prefer fewer concepts, fewer branches, fewer moving parts

## What to look for

- Deeply nested conditionals or loops → early returns / guard clauses
- Complex boolean logic → extract into well-named predicates
- Unused code, parameters, or imports → remove
- Nested ternaries → `if`/`else` or `switch`
- Over-specified types or config → leverage defaults
- Overly defensive code for impossible states → trust internal guarantees

## Process

Follow the `refactor` skill process. Focus on recently modified code unless told otherwise.
