# Atlas

Atlas is a local-first engineering continuity framework for coding agents.

It gives tools such as Codex a governed memory and context layer for software work: repo facts, architecture decisions, service contracts, known failure modes, test commands, task checkpoints, handoffs, memory proposals, contradiction handling, and retrieval explanations.

Atlas is designed for teams or individual engineers who want coding agents to resume work with relevant project context without pasting long chat histories, private notes, or ad hoc markdown files into every session.

This repository is the source-free demo distribution for Atlas `v1.0.0`. It includes compiled runtime artifacts, Docker deployment files, and operator scripts. It does not include the private Atlas source tree.

## What Atlas Does

Atlas provides a structured continuity control plane for engineering work.

At a high level, Atlas helps a coding agent answer these questions before acting:

- What repository am I working in?
- What branch, checkpoint, or task state was last observed?
- Which architecture decisions are already known?
- Which commands and tests should be used?
- What failure modes should I avoid?
- Which memories are trusted, candidate, quarantined, stale, or contradicted?
- Why was a memory recalled for this task?
- What should not be remembered from this work?
- What handoff should be left for the next session?

The goal is not to make the model remember everything. The goal is to give the model a compact, ranked, auditable context packet that helps it start useful work while keeping source code, tests, runtime evidence, and Git state above memory.

## Core Capabilities

### Collaboration Continuity

Atlas stores durable working preferences and operating rules, such as review posture, handoff expectations, verification standards, and project mode. This allows a fresh agent session to start with the right working style without relying on conversational memory.

### Engineering Memory

Atlas stores repo-specific engineering knowledge:

- repository facts
- architecture decisions
- service contracts
- known failure modes
- incidents
- past fixes
- test conventions
- useful commands
- context traces
- task checkpoints

Each memory row carries governance metadata such as trust state, claim kind, confidence, source reliability, source references, reinforcement count, contradiction count, and decay weight.

### Context Packs

Atlas can build a compact context pack for a repository and task. A context pack is intended to be the first thing a coding agent reads before meaningful work.

Context packs include:

- collaboration frame
- project mode and task mode
- task friction and blast-radius guidance
- drift guards
- memory health
- repo facts
- architecture decisions
- service contracts
- failure modes
- incidents and past fixes
- test conventions and commands
- recent checkpoints
- semantic matches
- memory proposals
- claim ledger warnings
- suggested checks
- why-recall and why-not-remember guidance

### Memory Governance

Atlas is built around the idea that memory should be governed, not blindly appended.

Supported governance features include:

- proposal-first memory writes
- trust-state filtering
- quarantine and dangerous/noise exclusions
- contradiction cases
- claim ledger validation
- source reference tracking
- dry-run and apply hygiene passes
- promotion, downgrade, quarantine, and forget controls
- why-recall explanations
- why-not-remember assessments

### Checkpoints And Handoffs

Atlas can record task checkpoints with:

- repository
- root path
- branch
- commit
- changed files
- summary
- tests
- failures
- next steps

This is useful before context compression, handoff to another agent, or returning to work after a long break.

### MCP And CLI Access

Atlas exposes the same core functionality through:

- an MCP server for Codex and other compatible clients
- a command-line interface for terminal workflows
- a read-only local cockpit for operators

## Product Boundary

Atlas is:

- a local engineering memory and context framework
- an MCP server for coding-agent context
- a CLI for memory operations and handoffs
- a governance layer for durable engineering knowledge
- a source-free runtime package in this distribution

Atlas is not:

- a chatbot persona
- an autonomous code mutator
- a replacement for Git, source code, tests, or runtime logs
- a cloud memory SaaS in this distribution
- a secret manager
- a full project-management system

Atlas memory should be treated as guidance. Source code, Git state, tests, logs, and explicit operator direction remain the authority.

## What Is Included

- `artifacts/Atlas.McpServer/` - compiled Atlas MCP server
- `artifacts/Atlas.Cli/` - compiled Atlas CLI
- `docker-compose.yml` - local Postgres and Atlas MCP stack
- `Dockerfile` - runtime-only image using compiled artifacts
- `scripts/deploy-demo.sh` - Docker deployment helper
- `scripts/stop-demo.sh` - Docker stop helper
- `scripts/smoke-demo.sh` - runtime smoke test
- `scripts/install-codex-atlas-mcp.sh` - Codex MCP config helper
- `scripts/run-local-mcp.sh` - local binary runner
- `scripts/atlas-cli.sh` - local CLI wrapper
- `checksums/SHA256SUMS` - package checksums
- `SKILL.md` - Codex skill instructions for using Atlas

## What Is Not Included

- C# source files
- project or solution files
- debug symbols
- private local database contents
- API keys or secrets

The binaries are standard .NET assemblies. This package is source-free for controlled distribution and evaluation, not an anti-reverse-engineering system.

## Requirements

Docker path:

- Docker Desktop or Docker Engine with Compose v2
- free local port `5391`
- free local Postgres port `5432`, or set `ATLAS_POSTGRES_PORT`

Local binary path:

- .NET runtime `10.x`
- Postgres reachable through `ATLAS_POSTGRES_CONNECTION`

Codex integration:

- Codex with MCP configuration support
- local network access to the Atlas MCP server

## Quick Start With Docker

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

Stop the demo:

```bash
scripts/stop-demo.sh
```

Remove containers and the database volume:

```bash
scripts/stop-demo.sh -v
```

## Configure Codex

After the MCP server is running:

```bash
scripts/install-codex-atlas-mcp.sh
```

Then restart or reload Codex so it can discover the Atlas MCP server.

Useful first calls from Codex:

- `atlas_context`
- `atlas_engineering_context`
- `atlas_engineering_recall`
- `atlas_engineering_propose`
- `atlas_engineering_autocheckpoint`

## Local Cockpit

Open:

```text
http://127.0.0.1:5391/cockpit
```

The cockpit is read-only. It shows:

- service status
- repository summary
- memory health
- recent checkpoints
- memory proposals
- contradiction cases
- claim ledger rows
- pipeline status
- generated context packs

Mutation operations remain behind explicit MCP or CLI commands.

## CLI Examples

Health:

```bash
scripts/atlas-cli.sh health
```

Collaboration frame:

```bash
scripts/atlas-cli.sh frame --task "resume work on a repository"
```

Engineering context pack:

```bash
scripts/atlas-cli.sh context-pack --repo my-repo --task "implement payment retry handling"
```

Propose a memory:

```bash
scripts/atlas-cli.sh engineering-propose \
  --repo my-repo \
  --kind architecture_decision \
  --content "Payment retries are handled by the billing worker, not the API controller." \
  --evidence "Confirmed by source inspection and tests."
```

Record a checkpoint:

```bash
scripts/atlas-cli.sh engineering-autocheckpoint \
  --repo my-repo \
  --root /path/to/my-repo \
  --summary "Implemented payment retry handling." \
  --tests "dotnet test passed" \
  --next "Watch production logs after deploy."
```

## Local Runtime Without Docker

For a binary-only local run, point Atlas at an existing Postgres database:

```bash
export ATLAS_POSTGRES_CONNECTION="Host=127.0.0.1;Port=5432;Database=atlasdemo;Username=atlas;Password=atlas"
scripts/run-local-mcp.sh
```

The local MCP server uses `http://127.0.0.1:5391` by default.

## Configuration

Docker defaults are intentionally local and demo-safe:

- database: `atlasdemo`
- username: `atlas`
- password: `atlas`
- MCP port: `5391`
- Postgres port: `5432`

Change values in `.env` before deployment if needed.

Do not place production secrets, private keys, or API tokens into `.env`.

## Operating Model

Atlas should be used as a context layer before and after engineering work:

1. Ask Atlas for a context pack.
2. Inspect local source and Git state.
3. Make the code change.
4. Run the narrowest relevant checks.
5. Record a checkpoint with branch, commit, changed files, tests, failures, and next steps.
6. Propose durable memories only when they are source-backed or clearly reusable.

Recommended rule:

```text
Git and source code are authority.
Atlas memory is governed context.
The model is an assistant, not the source of truth.
```

## Safety And Privacy

Atlas should not store:

- credentials
- tokens
- passwords
- private keys
- raw secret files
- one-off jokes or temporary chatter
- unsupported guesses
- large raw chat logs

Use memory proposals and immune checks for anything ambiguous.

## Distribution Notes

This repository is suitable for demos, internal review, and local trials. It is not a hosted service and does not include multi-user authentication, cloud sync, billing, or role-based access control.

For more details, see:

- `docs/DEMO_DISTRIBUTION.md`
- `docs/TEAM_VERSION.md`
- `SOURCE_NOTICE.md`
