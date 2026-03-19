---
name: browse-coveo
description: Browse Coveo Platform UI using Playwright with authentication
---

## Prerequisites

Load authentication first: `skill({ name: "coveo-auth" })`

Use the environment matching the target URL (see coveo-auth for URL-to-environment mapping).

If browsing redirects to a Coveo login page, refresh the token first:

```bash
coveo auth:login --environment=dev --organization=barcasportsmcy01fvu
```

For `localhost` URLs, use the `dev` environment.

## Playwright Auth

Set the token in localStorage before navigation, then navigate directly to the target URL.

```javascript
const token = process.env.COVEO_TOKEN;
await page.context().addInitScript((token) => {
  localStorage.setItem("coveo-access-token", JSON.stringify({ token }));
}, token);
await page.goto(targetUrl, { waitUntil: "networkidle" });
```

After navigation, verify that you did not land on `/login`.
If you did, refresh the token with `coveo auth:login` and retry once.

## Platform URLs

### CMH (Commerce Merchandising Hub)

| Environment | URL                                                    |
| ----------- | ------------------------------------------------------ |
| Local       | `https://localhost:9001/?dev`                          |
| Dev         | `https://platformdev.cloud.coveo.com/commerce-preview` |
| Stg         | `https://platformstg.cloud.coveo.com/commerce-preview` |
| Prod        | `https://platform.cloud.coveo.com/commerce-preview`    |

### Admin Console

| Environment | URL Pattern                                               |
| ----------- | --------------------------------------------------------- |
| Dev         | `https://platformdev.cloud.coveo.com/admin/#/{orgId}/...` |
| Stg         | `https://platformstg.cloud.coveo.com/admin/#/{orgId}/...` |
| Prod        | `https://platform.cloud.coveo.com/admin/#/{orgId}/...`    |

## Browser Rules

- Use `browser_snapshot` for interactions
- Only `browser_take_screenshot` when explicitly requested
- Never use `fullPage: true`
- Wait ~2s for hot reload after edits
