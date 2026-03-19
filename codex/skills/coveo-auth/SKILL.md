---
name: coveo-auth
description: Authenticate with Coveo Platform and manage access tokens
---

## Install CLI

```bash
command -v coveo &>/dev/null || pnpm add -g @coveo/cli
```

## Get Token

```bash
config=~/.config/@coveo/cli/config.json
target_env="${TARGET_ENV:-dev}"  # Set TARGET_ENV before running, defaults to dev
token=$(jq -r '.accessToken // empty' "$config" 2>/dev/null)
current_env=$(jq -r '.environment // empty' "$config" 2>/dev/null)
config_age=$(( ($(date +%s) - $(stat -f %m "$config" 2>/dev/null || echo 0)) / 86400 ))

if [ -z "$token" ] || [ "$config_age" -ge 1 ] || [ "$current_env" != "$target_env" ]; then
  coveo auth:login --environment="$target_env" --organization=barcasportsmcy01fvu
fi
export COVEO_TOKEN=$(jq -r '.accessToken' "$config")
```

## Environments

| Env  | Command                               |
| ---- | ------------------------------------- |
| Dev  | `coveo auth:login --environment=dev`  |
| Stg  | `coveo auth:login --environment=stg`  |
| Prod | `coveo auth:login --environment=prod` |

## Environment Detection from URL

Determine the required auth environment based on the platform URL:

| URL Contains     | Environment |
| ---------------- | ----------- |
| `localhost`      | dev         |
| `platformdev`    | dev         |
| `platformstg`    | stg         |
| `platform.cloud` | prod        |

## Example Orgs

- **Barca Dev**: `barcasportsmcy01fvu`
- **Barca Prod**: `barcagroupproductionkwvdy6lp`
