---
name: pr-description
description: Generate PR description using template, JIRA context, and code analysis
---

Generate a PR description that follows the repo's template, informed by JIRA ticket context and code changes.

## Step 1: Get PR Template

Read from standard locations:

```bash
for f in .github/PULL_REQUEST_TEMPLATE.md .github/pull_request_template.md .github/PULL_REQUEST_TEMPLATE PULL_REQUEST_TEMPLATE.md; do
  [ -f "$f" ] && cat "$f" && break
done
```

If no template found, warn and use a minimal structure.

## Step 2: Get Current PR Context

```bash
gh pr view --json number,title,body,headRefName,baseRefName
```

Extract JIRA ticket reference from description or branch name:

```bash
# Pattern: PROJECT-123
gh pr view --json body,headRefName -q '[.body, .headRefName] | join(" ")' | grep -oE '[A-Z]+-[0-9]+' | head -1
```

If no JIRA ticket found, warn and continue without JIRA context.

## Step 3: Fetch JIRA Context

Use the Atlassian MCP to get ticket details:

```
mcp_atlassian_jira_get_issue({ issue_key: "<TICKET>" })
```

Extract from the response:

- Summary (title)
- Description (problem statement)
- Acceptance criteria (if present)

Use this to understand the **problem being solved** — do not copy content directly, use it to frame the PR description appropriately.

If MCP fails or is unavailable, warn and continue without JIRA context.

## Step 4: Analyze Code Changes

```bash
# Get base branch
base=$(gh pr view --json baseRefName -q '.baseRefName')

# Overview of changes
git diff "origin/$base"...HEAD --stat

# Commit history
git log "origin/$base"..HEAD --oneline

# Detailed diff (for understanding the implementation)
git diff "origin/$base"...HEAD
```

## Step 5: Generate PR Description

Using the template structure from Step 1:

### Preserve CI-Trigger Syntax

PR templates often contain elements that CI workflows parse. Preserve these exactly:

- **HTML comments** (`<!-- ... -->`) — Never modify or remove these
- **Checkbox states** — Never check (`[x]`) a checkbox that was unchecked (`[ ]`) in the template

### Content to Generate

Fill in sections with placeholder text using JIRA context and code analysis. Keep descriptions concise and reviewer-friendly.

### Output

Output the complete PR description in markdown, ready to be used with:

```bash
gh pr edit --body "$(cat <<'EOF'
<generated description>
EOF
)"
```
