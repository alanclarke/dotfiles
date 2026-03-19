---
name: snowflake-explore
description: Connect to Snowflake and explore tables and schemas
---

## Install

```bash
command -v snowsql &>/dev/null || brew install --cask snowflake-snowsql
```

## Setup (One-Time)

Add named connections to `~/.snowsql/config`:

```ini
[connections.coveo-dev]
accountname = coveodev.us-east-1.privatelink
username = <your-email>@coveo.com
rolename = ALL_DATABASES_READONLY
authenticator = externalbrowser

[options]
client_store_temporary_credential = True
```

## Query

```bash
snowsql -c coveo-dev -q "<SQL>"
```

Token caching is enabled. After the first SSO auth, subsequent queries reuse the cached token until it expires.

## Environments

| Environment          | Connection       | Account                            |
| -------------------- | ---------------- | ---------------------------------- |
| dev - us-east-1      | `coveo-dev`      | `coveodev.us-east-1.privatelink`   |
| dev - eu-west-1      | `coveo-dev-eu`   | `coveodev.eu-west-1.privatelink`   |
| stg - us-east-2      | `coveo-stg`      | `coveostg.us-east-2.privatelink`   |
| prd - us-east-1      | `coveo-prd`      | `coveo.us-east-1.privatelink`      |
| prd - eu-west-1      | `coveo-prd-eu`   | `coveo.eu-west-1.privatelink`      |
| prd - ca-central-1   | `coveo-prd-ca`   | `coveo.ca-central-1.privatelink`   |
| prd - ap-southeast-2 | `coveo-prd-ap`   | `coveo.ap-southeast-2.privatelink` |

Use `-c <connection>` to switch environments (e.g., `snowsql -c coveo-stg -q "..."`)

## Explore

| Task              | SQL                                                |
| ----------------- | -------------------------------------------------- |
| List databases    | `SHOW DATABASES`                                   |
| List schemas      | `SHOW SCHEMAS IN DATABASE <db>`                    |
| List tables       | `SHOW TABLES IN SCHEMA <db>.<schema>`              |
| List views        | `SHOW VIEWS IN SCHEMA <db>.<schema>`               |
| Describe table    | `DESCRIBE TABLE <db>.<schema>.<table>`             |
| Preview data      | `SELECT * FROM <db>.<schema>.<table> LIMIT 10`     |

## Output Formats

Add `-o output_format=csv` or `-o output_format=json` for structured output.

## Safety

Read-only exploration only. Avoid DML/DDL statements.
