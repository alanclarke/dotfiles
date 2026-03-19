---
name: clean-history
description: Reimplement branch with clean git history
---

Reimplement the current branch on a new branch with a clean, narrative-quality git commit history suitable for reviewer comprehension.

## Steps

### 1. Validate the source branch

- Ensure no uncommitted changes: `git status --porcelain`
- Detect base branch: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'` (default: `main`)
- Confirm up to date with base: `git fetch origin && git merge-base --is-ancestor origin/$base HEAD`

### 2. Analyze the diff

Study all changes between the current branch and base:

```bash
git diff origin/$base...HEAD --stat
git diff origin/$base...HEAD
git log origin/$base..HEAD --oneline
```

Form a clear understanding of the final intended state.

### 3. Create the clean branch

```bash
branch=$(git rev-parse --abbrev-ref HEAD)
git branch -m "$branch" "${branch}-backup"
git checkout -b "$branch" "origin/$base"
```

### 4. Plan the commit storyline

Break the implementation into a sequence of self-contained steps. Each step should reflect a logical stage of development—as if writing a tutorial.

Present the plan to the user for confirmation before proceeding.

### 5. Reimplement the work

Recreate the changes in the clean branch, committing step by step according to the plan.

Each commit must:

- Introduce a single coherent idea
- Be functional (not break the build)
- Pass the tests
- Include a clear commit message and description
- Add inline comments when needed to explain intent

### 6. Verify correctness

Confirm that the final state exactly matches the original:

```bash
git diff "$branch".."${branch}-backup"  # Must be empty
```

### 7. Output a pull request description
