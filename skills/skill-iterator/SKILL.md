---
name: skill-iterator
description: Improve a skill iteratively using measurable success criteria and background agents
---

Improve a skill's `SKILL.md` by running test agents, measuring outcomes against defined criteria, and refining until the criteria are met.

**Never invoke the target skill directly.** Always delegate to a background agent.

## Input

- **Skill name**: the skill to improve (e.g. `pr-description`)
- **Success criteria**: measurable conditions that define a "good" run
- **Test scenario**: a concrete prompt to give the test agent
- **Max iterations** _(optional, default: 5)_

## Setup

1. Read the skill: `cat skills/<skill-name>/SKILL.md`
2. Build a binary (pass/fail) rubric from the success criteria — e.g.:
   ```
   [ ] Output contains a "Summary" heading
   [ ] Output references a JIRA ticket number
   ```

## Loop

Repeat up to max iterations:

### 1. Test

Launch a **background agent**. For behavioral criteria (content, formatting, correctness), launch two agents in parallel to check for consistency — a criterion only passes if both agents meet it.

```
task({
  name: "skill-test-<skill-name>-iter-<N>",
  agent_type: "general-purpose",
  mode: "background",
  prompt: `
    Load and execute the \`<skill-name>\` skill.
    Skill file: skills/<skill-name>/SKILL.md
    Test scenario: <test scenario>

    When done, report:
    1. Every step you took
    2. The full output or result
    3. Any errors or unexpected behaviour
    4. Anything the skill instructions were unclear about
  `
})
```

### 2. Score

Check each rubric item against the agent's report. Record the score (`N/M criteria met`).

### 3. Fix or finish

**If all criteria pass** → stop. Report what changed across iterations and why.

**If any criteria fail:**

1. State a specific root cause hypothesis for each failure — confirm it explains the observed output before editing.
2. Use agent-reported unclear instructions as direct input; treat each ambiguity as a potential root cause.
3. When fixing ambiguity, prefer adding explicit instructions over removing steps — fewer steps with vague intent can increase deliberation.

**Stop early if** max iterations reached, or two consecutive iterations produce identical failures (needs human input).

## Output

```
Iterations run: N
Final score: X/Y criteria met
Changes made: <bullet list>
Remaining issues: <unmet criteria with diagnosis>
```
