# Instructions

Primary language: **TypeScript**

## Code

- Never comment inline; use clear, self-documenting code
- Follow YAGNI: don't add features, options, or escape hatches speculatively — only build what is needed right now
- Prefer the simplest in-context solution; remove complexity instead of adding indirection, guards, helper files, or special-case paths unless they are clearly needed
- Avoid duplication; extract reusable code when the pattern is clear
- Prefer type inference; avoid `any` and `unknown`
- Don't increase specificity; leverage defaults to the fullest

## Tests

- Avoid "should" in test descriptions; use declarative statements instead
  - ❌ `it('should render the button')`
  - ✅ `it('renders the button')`

## Tools

- Use **pnpm** (not npm) for all node package commands
- Use **Prettier** for code formatting
- After making code changes, run lint, type-check, and tests on the affected package(s) before considering a task done
- GitHub CLI (`gh`) is installed and authenticated
- For JIRA / Confluence use the atlassian mcp
- For figma links use the figma mcp

## Skills

- When using a skill and hitting friction (wrong steps, missing context, ambiguity), fix the `SKILL.md` if the improvement is obvious
- Keep skills concise: every line should earn its place — cut fluff, merge redundant steps, remove stale info
- Prefer examples over lengthy explanations

## Communication

- When the user asks "why", answer the question directly — don't assume it's rhetorical and skip to a fix

## Git

Never commit unless explicitly asked. Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/): `<type>(scope): description`

Types: `feat` `fix` `docs` `style` `refactor` `perf` `test` `build` `ci` `chore`
