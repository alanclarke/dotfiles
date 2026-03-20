---
name: architect
description: Improve system boundaries, abstraction, separation of concerns, and reduce duplication in code.
---

## Principles

- Each module/function should have one clear responsibility
- Abstractions should reduce complexity, not just hide it
- Boundaries between modules should be explicit and narrow
- Duplication is acceptable until the pattern is clear — then extract

## What to look for

- God functions or classes doing too many things → decompose into focused units
- Leaky abstractions exposing implementation details → tighten the boundary
- Tight coupling between modules → introduce interfaces or invert dependencies
- Duplicated patterns across files → extract shared utilities
- Unclear module responsibilities → rename, reorganise, or split
- Wrong abstraction level — too granular or too coarse

## Process

Follow the `refactor` skill process. Start by mapping the current responsibilities and boundaries.
