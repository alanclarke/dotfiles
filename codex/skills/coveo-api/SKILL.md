---
name: coveo-api
description: Discover and explore Coveo Platform APIs via OpenAPI specs
---

## Prerequisites

First load authentication: `skill({ name: "coveo-auth" })`

## Swagger UI

| Env | Public UI                                  | Internal UI                                                         |
| --- | ------------------------------------------ | ------------------------------------------------------------------- |
| Dev | `https://platformdev.cloud.coveo.com/docs` | `https://internalproxy-us-east-1.dev.cloud.coveo.com/docs/internal` |
| Stg | `https://platformstg.cloud.coveo.com/docs` | `https://internalproxy-us-east-2.stg.cloud.coveo.com/docs/internal` |

The **internal UI** shows additional endpoints not exposed in the public API.

## Discover Services

```bash
curl -s "https://platformdev.cloud.coveo.com/docs" -H "Authorization: Bearer $COVEO_TOKEN" | \
  grep -oE "API_DOCS_PREFIX \+ '[^']+'" | sed "s/API_DOCS_PREFIX + '//g; s/'//g" | sort -u
```

## Fetch OpenAPI Spec

```bash
# Internal (more endpoints) - use for internal/admin APIs
curl -s "https://internalproxy-us-east-1.dev.cloud.coveo.com/api-docs/{Service}?group=internal"

# Public - use for customer-facing APIs
curl -s "https://platformdev.cloud.coveo.com/api-docs/{Service}?group=public"
```

The `group` parameter controls which endpoints are included. Internal specs contain admin/internal endpoints not available in the public API.

## Query Specs

```bash
jq '.paths | keys[]'                                              # List endpoints
jq '.components.schemas | keys[]'                                 # List schemas
jq '.paths | to_entries[] | select(.key | contains("keyword"))'   # Find by keyword
```

## Environments

| Env | Platform                      | Internal Proxy                                |
| --- | ----------------------------- | --------------------------------------------- |
| Dev | `platformdev.cloud.coveo.com` | `internalproxy-us-east-1.dev.cloud.coveo.com` |
| Stg | `platformstg.cloud.coveo.com` | `internalproxy-us-east-2.stg.cloud.coveo.com` |

## Additional Context

The [platform-client](https://github.com/coveo/platform-client) repository contains the official JavaScript/TypeScript SDK for Coveo APIs. It provides:

- **Type definitions** for all API request/response objects
- **Resource implementations** showing available methods per service
- **Enums** for all API constants (see `src/resources/Enums.ts`)

### Browse SDK Resources

```bash
# List available resource modules
curl -s "https://api.github.com/repos/coveo/platform-client/contents/src/resources" | jq -r '.[] | select(.type == "dir") | .name'

# View a specific resource implementation (e.g., Sources)
curl -s "https://raw.githubusercontent.com/coveo/platform-client/master/src/resources/Sources/Sources.ts"

# View type interfaces for a resource
curl -s "https://raw.githubusercontent.com/coveo/platform-client/master/src/resources/Sources/SourcesInterfaces.ts"
```

Use this when you need:
- Clearer type definitions than what OpenAPI provides
- To understand available methods and their signatures
- Examples of how endpoints are structured
