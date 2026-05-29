# Atlas Team Version

This document describes the intended team-oriented architecture for Atlas.

The current demo package runs Atlas as a local service with a local or directly configured Postgres database. The team version changes Atlas into a centralized continuity service that can be shared safely by multiple engineers, repositories, and coding agents.

## Objective

The team version should let a software team use Atlas as a shared engineering continuity layer without giving every client direct database access.

The product should support:

- centralized memory and checkpoint storage
- repository-aware context packs
- authenticated CLI and MCP access
- team and project isolation
- audit trails for memory mutations
- review workflows for proposed memories
- read-only and administrative cockpit views
- safe source-free deployment

The goal is not to replace Git, issue trackers, observability tools, documentation, or CI. Atlas should provide governed continuity around those systems and help coding agents start with the right context.

## Target Architecture

```text
Codex / IDE / CLI / Cockpit
          |
          v
Central Atlas Server
          |
          v
Postgres + pgvector
```

The central server owns all database access. Clients call Atlas over HTTP, MCP, or a remote CLI transport.

### Components

- Atlas Server: hosts MCP endpoints, HTTP APIs, authentication, authorization, audit logging, and cockpit endpoints.
- Postgres: stores engineering memory, checkpoints, proposals, claim ledger rows, contradictions, users, teams, roles, and audit events.
- pgvector: stores embeddings for semantic recall when enabled.
- Atlas CLI: supports both local database mode and remote server mode.
- Atlas Cockpit: provides read-only operator views and administrative review flows.
- Codex MCP Integration: connects coding agents to the central Atlas server.

## Client Modes

### Local Mode

Local mode is useful for demos, individual engineers, and offline testing.

```text
Atlas CLI / MCP Server -> Postgres
```

In this mode, the CLI or MCP server uses `ATLAS_POSTGRES_CONNECTION` directly.

### Remote Team Mode

Remote mode is the preferred team architecture.

```text
Atlas CLI / Codex / Cockpit -> Atlas Server -> Postgres
```

In this mode, clients use:

- `ATLAS_SERVER_URL`
- `ATLAS_API_TOKEN` or an interactive login flow
- optional workspace, project, and repository defaults

The server enforces permissions and records audit events.

## Memory Ownership And Shared Recall

Team Atlas should distinguish ownership from recall scope.

Every important continuity row should carry a username or actor identity:

- memory rows
- memory proposals
- task checkpoints
- claim ledger rows
- contradiction cases
- hygiene runs
- audit events

This allows Atlas to answer:

- who recorded this memory
- who proposed it
- who approved, rejected, or changed it
- who created the checkpoint
- which user or agent relied on a memory during a task
- which memories are personal working style and which are shared engineering knowledge

Username is provenance, not an automatic visibility boundary. Repository-scoped engineering memories should still be available to the whole authorized team when they are useful.

Example:

```text
Alice fixed a Docker startup failure last week.
Bob later asks Atlas about a similar Docker startup failure.
Atlas may recall Alice's fix because it belongs to the repository's engineering history, while still showing that Alice recorded or fixed it.
```

This is important because coding agents should learn from the team's accumulated work, not only from the current user's private session.

Recommended first provenance columns:

- `Username`: human-readable actor name for local/demo mode.
- `ActorId`: stable user or agent id for team mode.
- `ActorType`: `user`, `agent`, `service`, or `system`.
- `Scope`: `personal`, `repository`, `project`, `team`, or `organization`.

For the first implementation, `Username` is enough for local and source-free demos. The team server should later resolve it from authenticated identity instead of trusting client-provided text.

Recall policy should work like this:

- Personal preferences are recalled only for that user unless promoted.
- Repository engineering facts are recalled for anyone with repository access.
- Project or team conventions are recalled across repositories only when explicitly scoped that way.
- Audit records remain searchable by authorized maintainers and admins.
- Context packs may include provenance such as `by=Alice` when it helps the agent reason about prior work.

## Tenancy Model

Atlas should support a simple hierarchy:

```text
Organization
  Team
    Project
      Repository
```

Recommended entities:

- Organization: billing, ownership, global settings, retention policy.
- Team: group of users who share project access.
- Project: logical product or codebase group.
- Repository: specific Git repository identity and memory scope.
- User: human operator.
- Agent: tool or automation identity, such as Codex.
- Token: scoped API credential for users, agents, CI, or automation.

Repository scope should remain explicit. A memory for one repository should not silently appear as authority for another repository unless it is promoted into a shared project or organization scope.

## Roles

Recommended first roles:

- Owner: full organization control.
- Admin: manage teams, users, tokens, projects, and server settings.
- Maintainer: approve memories, resolve contradictions, run hygiene, manage repository settings.
- Contributor: read context, propose memories, create checkpoints.
- Reader: read context and cockpit views only.
- Agent: scoped automation identity with narrowly configured permissions.

## Permission Model

Permission checks should apply to every mutating operation.

Examples:

- Read context pack: reader or above.
- Recall memory: reader or above.
- Propose memory: contributor or above.
- Create checkpoint: contributor or above.
- Approve or reject memory proposals: maintainer or above.
- Quarantine, downgrade, forget, or promote memory: maintainer or above.
- Run destructive hygiene: maintainer or admin, depending on scope.
- Manage users and tokens: admin or owner.

High-risk operations should create audit events even when they succeed.

## Remote CLI Behavior

The CLI should keep the same user experience while switching transport based on configuration.

Local database mode:

```bash
atlas context-pack --repo AtlasDemo --task "review deployment"
```

Remote server mode:

```bash
atlas context-pack \
  --server https://atlas.example.internal \
  --workspace platform \
  --repo AtlasDemo \
  --task "review deployment"
```

Environment variables:

```bash
ATLAS_SERVER_URL=https://atlas.example.internal
ATLAS_API_TOKEN=...
ATLAS_WORKSPACE=platform
ATLAS_REPO=AtlasDemo
```

The CLI should never require direct database credentials in remote team mode.

## API Surface

The first remote API should cover the same practical surface already exposed through MCP and CLI:

- health and version
- context pack generation
- engineering recall
- memory proposal creation
- memory proposal review
- checkpoint creation
- checkpoint listing
- memory health
- contradiction listing and resolution
- claim ledger listing and validation
- hygiene dry-run and apply
- audit event listing

The API should be designed so MCP tools and CLI commands share the same backend service layer.

## Audit Trail

The team version should record audit events for:

- login and token use
- context pack generation
- memory proposal creation
- direct memory writes
- proposal approval or rejection
- memory promotion, downgrade, quarantine, or forget operations
- contradiction resolution
- hygiene apply operations
- checkpoint creation
- configuration changes
- token creation, rotation, and revocation

Each event should include:

- timestamp
- actor type and actor id
- organization, team, project, and repository scope
- action
- target entity
- request id
- source IP or client id when available
- before and after summary for mutating operations

## Cockpit Requirements

The cockpit should remain safe by default.

Recommended initial cockpit sections:

- service health
- organization and team scope selector
- repository context pack preview
- memory health
- recent checkpoints
- proposal queue
- contradiction cases
- claim ledger
- audit events
- token and integration status

Mutation controls should require authenticated sessions and role checks. Dangerous operations should use explicit confirmation and should be visible in audit logs.

## Deployment Model

The team version should ship as a Docker-ready deployment.

Recommended services:

- `atlas-server`
- `atlas-postgres`
- optional `atlas-vector-worker`
- optional reverse proxy

Production deployments should place TLS, authentication, and network controls in front of Atlas.

The demo Compose file can remain simple. The team Compose file should separate:

- public HTTP port
- internal database port
- persistent Postgres volume
- server configuration
- token or OIDC settings
- optional embedding configuration

## Security And Privacy

The team version must avoid storing secrets and raw private material by default.

Required safeguards:

- no direct database credentials for normal CLI users
- scoped API tokens
- token revocation
- audit events for mutations
- role-based authorization
- configurable retention policy
- proposal-first memory workflow
- explicit handling for quarantined, dangerous, stale, and contradicted memory
- ability to export and delete repository-scoped memory

Recommended future safeguards:

- OIDC or SSO integration
- per-team encryption key support
- secret detection before memory writes
- automated policy checks for memory proposals
- signed deployment artifacts

## Migration From Local Demo

The local demo can evolve into the team version in stages:

1. Keep direct Postgres mode for local demos.
2. Add a remote server API over the existing service layer.
3. Teach the CLI to select local or remote mode.
4. Add users, roles, tokens, and audit events.
5. Move cockpit mutation operations behind authentication.
6. Add team and repository scoping.
7. Harden deployment and package the team Compose stack.

This avoids a rewrite. The current memory, proposal, checkpoint, hygiene, and context-pack logic can remain the core product surface.

## Milestones

### Milestone 1: Server API Foundation

- Add HTTP endpoints for context packs, recall, proposals, checkpoints, and health.
- Keep MCP and CLI behavior compatible.
- Add request ids and structured response envelopes.

### Milestone 2: Remote CLI

- Add `--server`, `--token`, `--workspace`, and `--repo` defaults.
- Support environment-based configuration.
- Preserve local direct-Postgres mode for demos.

### Milestone 3: Identity And Audit

- Add user, agent, token, role, team, project, and repository scope tables.
- Add audit events for all mutating operations.
- Add token creation and revocation.

### Milestone 4: Cockpit For Teams

- Add authenticated cockpit sessions.
- Add scope selector.
- Add proposal review, contradiction review, claim ledger, and audit views.
- Keep destructive operations explicit and logged.

### Milestone 5: Deployment Hardening

- Add team Compose stack.
- Add production configuration examples.
- Add backup and restore documentation.
- Add source-free packaging checks.
- Add smoke tests for server, CLI, MCP, cockpit, and database connectivity.

## Non-Goals For The First Team Version

- hosted SaaS billing
- multi-region replication
- full project-management replacement
- automatic code changes without operator approval
- storing arbitrary private chat history
- storing secrets or credentials
- replacing Git, tests, CI, or observability

## Product Principle

Atlas should centralize engineering continuity without centralizing unchecked authority.

Source code, Git, tests, logs, and explicit operator direction remain the source of truth. Atlas provides governed context, recall, checkpoints, and auditability so humans and coding agents can work with less repeated setup and fewer memory-driven mistakes.
