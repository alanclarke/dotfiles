---
name: debug-deployment
description: Debug Spinnaker/Jenkins deployment failures at Coveo
---

## Goal

Diagnose pipeline failures and provide resolution recommendations.

## Supported Applications

| App                  | Repository           | Spinnaker Application ID             |
| -------------------- | -------------------- | ------------------------------------ |
| Commerce Hub (CMH)   | `admin-ui`           | `commercefrontendcommercehubfs`      |
| Shopify Integration  | `coveo-shopify-app`  | `commercefrontendshopifyintegration` |

Detect app from current repo: `git remote get-url origin`

## Input Formats

### 1. Slack Alert (pasted)

```
Spinnaker Pipeline Failed
Package: admin-ui/commerce-hub-fs/12.549.0_...
Env: dep
Spinnaker Pipeline: https://spinnaker.dep.cloud.coveo.com/#/...
```

### 2. Spinnaker URL

```
https://spinnaker.dep.cloud.coveo.com/#/applications/{app}/executions/details/{executionId}
```

### 3. Jenkins URL

```
https://pipeline-jenkins-{N}.dep.cloud.coveo.com/job/{jobName}/{buildNumber}/
```

## Workflow

### Step 1: Parse Input

Extract Spinnaker URL or Jenkins URL from the input.

### Step 2: Navigate to Spinnaker (if needed)

1. Open the Spinnaker execution URL
2. Wait for Okta SSO (handled automatically by Okta Verify)
3. Find the failed stage (status: `TERMINAL` or `STOPPED`)
4. Click on the failed stage to expand details
5. Extract Jenkins build URL from stage details

### Step 3: Navigate to Jenkins

1. Open the Jenkins build URL
2. Check Build Artifacts for log files (e.g., `*_validate_*.log`)
3. If no artifacts, check Console Output

### Step 4: Extract Failure Details

Look for:

- `[BLOCKING]` messages
- CVE identifiers (e.g., `CVE-2026-XXXXX`)
- Error messages and stack traces
- Fix URLs (e.g., Dependabot links)

### Step 5: Provide Resolution

#### CVE / Dependency Vulnerability

- **Fix URL**: Usually in the log (e.g., `https://github.com/coveo-platform/{repo}/security/dependabot`)
- **Action**: Merge the Dependabot PR, then restart the pipeline

#### Build Failure

- **Action**: Check the error, fix the code, push, and re-trigger

#### Health Check / Certifier Timeout

- **Action**: Check pod logs in Kubernetes, verify resource limits

## Commands

| Task                  | Action                                         |
| --------------------- | ---------------------------------------------- |
| Restart failed stage  | Click "Restart" in Spinnaker stage details     |
| Skip CVE validation   | Use approval override link in stage comments   |
| View full Jenkins log | Click artifact filename then "view"            |

## URLs

- **Spinnaker (CMH)**: https://spinnaker.dep.cloud.coveo.com/#/applications/commercefrontendcommercehubfs
- **Spinnaker (Shopify)**: https://spinnaker.dep.cloud.coveo.com/#/applications/commercefrontendshopifyintegration
- **Jenkins instances**: `pipeline-jenkins-{N}.dep.cloud.coveo.com` (N = 13, 14, etc.)
