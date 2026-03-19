---
name: request-temporary-access
description: Request temporary access to a Coveo organization via the admin UI
---

## Prerequisites

1. Load `skill({ name: "coveo-auth" })` - authenticate with the correct environment (see Environment Detection)
2. Load `skill({ name: "browse-coveo" })`

## Usage

Requires:
- `organizationId` - the Coveo organization ID
- `reason` - the access reason (or prompt user with `question` tool if not provided)

## URL Patterns by Region

Organizations exist in different regions. Use the correct regional URL:

| Region | URL |
|--------|-----|
| US (default) | `https://platform.cloud.coveo.com/admin/#/{organizationId}/organization/temporary-access` |
| EU (Ireland) | `https://platform-eu.cloud.coveo.com/admin/#/{organizationId}/organization/temporary-access` |
| AU (Australia) | `https://platform-au.cloud.coveo.com/admin/#/{organizationId}/organization/temporary-access` |

**Tip:** If the org ID contains region hints like `eu`, `au`, or was created for EU/AU customers, try the regional URL first.

## Workflow

1. Authenticate with `prod` environment (see coveo-auth)
2. Set token in localStorage and navigate to the temporary access URL
3. Click "Request temporary access" button
4. In the duration/reason dialog:
   - Duration "3 days" is typically pre-selected (default)
   - Enter the reason in the text field
5. Click "Next"
6. In the privileges selection dialog ("Choose the minimum privileges you need"):
   - Default "Custom" template is usually sufficient
   - Click "Send request"
7. Confirm success:
   - Alert appears: "Temporary access has been granted! This page will reload automatically."
   - User appears in the table with "Active" status

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Organization not found" or blank page | Try a different regional URL (EU/AU instead of US) |
| Request button not visible | Check if you already have active access in the table |
| Dialog doesn't open | Refresh page and re-authenticate |
