---
name: debug-e2e
description: Debug Playwright E2E test failures from CI or locally
---

## Goal

Identify the failing test, then reproduce it locally using the `browse-coveo` skill.

## Step 1: Identify the Failing Test

From a GitHub Actions URL or test name, extract the test file path, failing test name, and error message.

## Step 2: Read the Test

Read the test file to understand navigation, actions, and assertions.

## Step 3: Reproduce Locally

Load the browse skill: `skill({ name: "browse-coveo" })`

Step through the test manually in the browser.

## Commands

| Task            | Command                                       |
| --------------- | --------------------------------------------- |
| Run single test | `pnpm test:e2e <file>.e2e.spec.ts`            |
| View trace      | `pnpm exec playwright show-trace <trace.zip>` |
