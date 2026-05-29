---
name: atlas
description: Use Atlas local engineering continuity memory through its MCP server and CLI. Use when Codex needs repo/task context, handoff checkpoints, memory governance, source-backed engineering recall, proposal review, contradiction handling, or a compact context pack before coding.
---

# Atlas Skill

Atlas is a local engineering continuity framework for coding agents.

Use this skill when working in a repository where durable engineering context matters: architecture decisions, repo facts, service contracts, known failure modes, test conventions, commands, incidents, past fixes, checkpoints, and handoffs.

Atlas memory is guidance, not authority. Source code, Git state, tests, logs, runtime behavior, and explicit operator direction always win.

## Primary Workflow

Before meaningful work:

1. Get an Atlas engineering context pack for the current repository and task.
2. Inspect local source and Git state.
3. Use recalled memories selectively.
4. Verify claims against source when behavior matters.

After meaningful work:

1. Run the narrowest relevant checks.
2. Record an Atlas checkpoint with summary, branch, commit, changed files, tests, failures, and next steps.
3. Propose durable memories only when they are source-backed or clearly reusable.

## MCP Usage

Prefer MCP tools when available.

Recommended first call:

```text
atlas_engineering_context
```

Use it with:

- `repo`: repository name, for example `AtlasDemo`
- `task`: current task, for example `debug Docker deployment`

## Tool Decision Guide

Use this guide literally. When uncertain, choose the safest read-only tool first.

| Situation | Tool | Rule |
| --- | --- | --- |
| Starting or resuming non-trivial coding work in a repository | `atlas_engineering_context` | Use this first before editing files. It returns repo facts, architecture decisions, known failures, checkpoints, proposals, claim warnings, and suggested checks. |
| You only need the user's general working preferences or collaboration frame | `atlas_context` | Use this for collaboration style and task posture, not repo-specific engineering facts. |
| You need a specific past fix, command, decision, incident, or failure mode | `atlas_engineering_recall` | Use this after `atlas_engineering_context` when the context pack is not specific enough. |
| You changed code, config, docs, packaging, deployment, or tests in a meaningful way | `atlas_engineering_autocheckpoint` | Use this after verification. Include repo root, summary, tests, failures, and next step. |
| You need to leave a manual handoff without reading Git state | `atlas_engineering_checkpoint` | Use this when auto-checkpoint is not possible or when the handoff is conceptual. |
| You learned a reusable source-backed fact but are not 100% sure it should become durable memory | `atlas_engineering_propose` | Prefer this over direct memory writes. Proposals can be reviewed later. |
| The user explicitly asks to store a confirmed engineering memory | `atlas_engineering_remember` | Use direct writes only when the user asked or the fact is clearly source-backed and stable. |
| You want to know whether a candidate memory is safe to store | `atlas_engineering_why_not_remember` | Use before storing ambiguous, broad, risky, personal, or weakly supported claims. |
| Retrieved memory seems surprising, stale, or too influential | `atlas_engineering_why_recall` | Use before trusting the memory. Source code still wins. |
| The user asks to review pending memory proposals | `atlas_engineering_review_proposals` | Use this before approving or rejecting anything. |
| The user asks to approve a specific proposal | `atlas_engineering_approve_proposal` | Mutating tool. Use only with explicit user intent or clear operator workflow. |
| The user asks to reject a specific proposal | `atlas_engineering_reject_proposal` | Mutating tool. Use only with explicit user intent or clear operator workflow. |
| You need to inspect existing memory rows | `atlas_engineering_memories` | Read-only. Useful for audits and debugging recall. |
| You need memory health counters | `atlas_engineering_health` | Read-only. Use when diagnosing memory quality or drift. |
| You need recent writes, checkpoints, claims, proposals, contradictions, and hygiene runs together | `atlas_engineering_receipt` | Read-only. Use after memory-heavy work or before handoff. |
| You need to inspect claim ledger entries | `atlas_engineering_claims` | Read-only. Use when checking which memories influenced decisions. |
| You need to record that a memory influenced a decision | `atlas_engineering_claim` | Mutating tool. Use for audit trails when a memory materially shaped work. |
| You need to validate claim ledger entries | `atlas_engineering_validate_claims` | Defaults to dry-run. Pass apply only when the user asks or the workflow requires mutation. |
| You need to inspect contradiction cases | `atlas_engineering_contradictions` | Read-only. Use when source and memory disagree. |
| You need to open a contradiction case | `atlas_engineering_contradict` | Mutating tool. Use when a stored memory conflicts with current source/runtime evidence. |
| You need to resolve a contradiction case | `atlas_engineering_resolve_contradiction` | Mutating tool. Use only with explicit decision/evidence. |
| You need lifecycle cleanup suggestions | `atlas_engineering_hygiene` | Defaults to dry-run. Do not apply destructive hygiene unless asked. |
| You need to delete, quarantine, promote, downgrade, or curate memory | `atlas_engineering_forget`, `atlas_engineering_quarantine`, `atlas_engineering_promote`, `atlas_engineering_downgrade`, `atlas_engineering_curate` | Mutating governance tools. Use only when the user asks or during an explicit memory maintenance task. |

Do not use CLI commands when the equivalent MCP tool is available. MCP is the agent interface. CLI is a fallback for humans, scripts, CI, or cases where MCP is unavailable.

Useful MCP tools:

- `atlas_context` - collaboration continuity frame
- `atlas_engineering_context` - repo/task context pack
- `atlas_engineering_recall` - search engineering memory
- `atlas_engineering_propose` - propose a new memory
- `atlas_engineering_remember` - store memory when direct write is intentional
- `atlas_engineering_why_recall` - explain why memory matters
- `atlas_engineering_why_not_remember` - assess whether a memory should be stored
- `atlas_engineering_autocheckpoint` - record a Git-backed task checkpoint
- `atlas_engineering_checkpoint` - record an explicit handoff checkpoint
- `atlas_engineering_proposals` - list memory proposals
- `atlas_engineering_review_proposals` - review proposal queue
- `atlas_engineering_approve_proposal` - approve a proposal
- `atlas_engineering_reject_proposal` - reject a proposal
- `atlas_engineering_hygiene` - run memory hygiene, dry-run by default
- `atlas_engineering_health` - inspect memory health

Treat mutating tools as explicit operator actions. Do not approve, reject, forget, quarantine, or promote memories unless the user asked for that operation or the task clearly requires it.

## Golden Path For Coding Agents

For ordinary coding work, follow this sequence:

1. Call `atlas_engineering_context` with the repository name and the current task.
2. Inspect local Git state and source files.
3. Use `atlas_engineering_recall` only if you need more specific prior context.
4. Make the change.
5. Run the narrowest relevant verification.
6. Call `atlas_engineering_autocheckpoint` after meaningful verified work.
7. Use `atlas_engineering_propose` for any reusable source-backed lesson learned.

Never treat Atlas memory as proof. If Atlas memory and source code disagree, trust source code and consider opening a contradiction case.

## CLI Fallback

If MCP tools are unavailable, use the packaged CLI wrapper from this repository:

```bash
scripts/atlas-cli.sh context-pack --repo <repo> --task "<task>"
```

Examples:

```bash
scripts/atlas-cli.sh health
scripts/atlas-cli.sh frame --task "resume engineering work"
scripts/atlas-cli.sh context-pack --repo AtlasDemo --task "inspect source-free package"
scripts/atlas-cli.sh engineering-recall --repo AtlasDemo --query "Docker deployment"
scripts/atlas-cli.sh engineering-proposals --repo AtlasDemo
```

Record a checkpoint:

```bash
scripts/atlas-cli.sh engineering-autocheckpoint \
  --repo <repo> \
  --root /path/to/repo \
  --summary "<what changed>" \
  --tests "<checks run>" \
  --next "<next step>"
```

## Local Runtime

Atlas MCP default URL:

```text
http://127.0.0.1:5391/mcp
```

Health:

```text
http://127.0.0.1:5391/health
```

Read-only console:

```text
http://127.0.0.1:5391/cockpit
```

The console can be used to select known repositories, start from task examples, inspect recent memory rows, memory health, checkpoints, proposals, hygiene runs, contradictions, claims, queue state, and generated context packs.

## Team Server Mode

For a centralized team host, configure Codex clients against the shared MCP endpoint instead of direct Postgres:

```bash
ATLAS_MCP_URL="http://<host>:5391/mcp" scripts/install-codex-atlas-mcp.sh
```

Use `ATLAS_USERNAME` for local/demo provenance when running CLI or server-side jobs:

```bash
export ATLAS_USERNAME="<your-name-or-agent-name>"
```

MCP tools also accept optional `atlas_username` for per-call audit provenance. Authenticated reverse proxies can provide the actor through `X-Atlas-Username`, `X-Forwarded-User`, `X-Remote-User`, or equivalent user headers. This provenance value is not authentication. Treat the first team package as trusted-network software unless it is placed behind an authenticated reverse proxy.

## Memory Rules

Store or propose memories for:

- source-backed architecture decisions
- stable repo facts
- service contracts
- recurring failure modes
- verified fixes
- important test commands
- deployment or runtime conventions
- task checkpoints and handoffs

Do not store:

- secrets, tokens, passwords, or keys
- raw private logs
- unsupported guesses
- one-off jokes or temporary moods
- large chat transcripts
- personal information unless explicitly required and approved
- claims contradicted by source or runtime evidence

Use proposal-first writes when in doubt.

## Context Discipline

A good Atlas-assisted turn should:

- fetch context before coding
- keep recalled memory subordinate to source
- use Git to verify branch and dirty state
- name uncertainty when memory and source disagree
- run relevant checks before declaring work done
- leave a checkpoint after meaningful changes

Do not paste entire context packs into user-facing responses unless asked. Summarize the parts that affect the current decision.

## Source-Free Package Notes

This AtlasDemo package contains compiled binaries and scripts only. It does not contain Atlas source code.

Use Docker for the simplest local trial:

```bash
cp .env.example .env
scripts/deploy-demo.sh
scripts/smoke-demo.sh
```

Stop:

```bash
scripts/stop-demo.sh
```

Remove local demo data:

```bash
scripts/stop-demo.sh -v
```
