# Instructions

Primary language: **TypeScript**

## Code

- Never comment inline; use clear, self-documenting code
- Prefer simplicity; remove complexity before adding it
- Avoid duplication; extract reusable code when the pattern is clear
- Prefer type inference; avoid `any` and `unknown`

## Tests

- Avoid "should" in test descriptions; use declarative statements instead
  - ❌ `it('should render the button')`
  - ✅ `it('renders the button')`

## Tools

- Use **pnpm** (not npm) for all node package commands
- Use **Prettier** for code formatting
- Before pushing or opening a PR, run local static analysis, linting, formatting, type-check etc.
- GitHub CLI (`gh`) is installed and authenticated
- For JIRA / Confluence use the atlassian mcp
- For figma links use the figma mcp

## Git

Never commit unless explicitly asked. Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/): `<type>(scope): description`

Types: `feat` `fix` `docs` `style` `refactor` `perf` `test` `build` `ci` `chore`
