# Atlas Demo

Source-free demo distribution for Atlas `v1.0.0`.

This repository is meant for demos, reviews, and lightweight local trials. It contains compiled Atlas binaries and deployment helpers, but it does not contain the Atlas source tree.

## What Is Included

- `artifacts/Atlas.McpServer/` - compiled Atlas MCP server
- `artifacts/Atlas.Cli/` - compiled Atlas CLI
- Docker Compose stack with Postgres + pgvector
- runtime-only Dockerfile
- Codex MCP config helper
- smoke-test scripts

## What Is Not Included

- C# source files
- project or solution files
- debug symbols / PDB files
- private local database contents
- API keys or secrets

The binaries are standard .NET assemblies. This package is source-free for demo distribution, not an anti-reverse-engineering system.

## Requirements

Docker path:

- Docker Desktop or Docker Engine with Compose v2
- free local port `5391`
- free local Postgres port `5432`, or change `ATLAS_POSTGRES_PORT`

Local CLI path:

- .NET runtime `10.x`
- Postgres reachable through `ATLAS_POSTGRES_CONNECTION`

## Quick Start

```bash
cp .env.example .env
scripts/deploy-demo.sh
scripts/smoke-demo.sh
```

Atlas will be available at:

- `http://127.0.0.1:5391/health`
- `http://127.0.0.1:5391/version`
- `http://127.0.0.1:5391/cockpit`
- `http://127.0.0.1:5391/mcp`

The cockpit is read-only and shows health, memory state, queue state, checkpoints, proposals, contradictions, claims, and browser-generated context packs.

Stop the demo:

```bash
scripts/stop-demo.sh
```

Remove containers and the database volume:

```bash
scripts/stop-demo.sh -v
```

## Configure Codex

```bash
scripts/install-codex-atlas-mcp.sh
```

Then use `atlas_context` or `atlas_engineering_context` from Codex.

## CLI

```bash
scripts/atlas-cli.sh health
scripts/atlas-cli.sh frame --task "demo Atlas memory"
scripts/atlas-cli.sh context-pack --repo demo --task "inspect a repo"
```

## Local Runtime Without Docker

For a quick binary-only local run, point Atlas at an existing Postgres database:

```bash
export ATLAS_POSTGRES_CONNECTION="Host=127.0.0.1;Port=5432;Database=atlascursedlab;Username=atlas;Password=atlas"
scripts/run-local-mcp.sh
```

The local MCP server uses `http://127.0.0.1:5391` by default.

## Demo Safety

This demo stores data in a local Docker volume named `atlas-demo-postgres-data`.

Do not put private production secrets into `.env`. The default credentials are demo-only.
