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

Read-only cockpit:

```text
http://127.0.0.1:5391/cockpit
```

The cockpit can be used to inspect memory health, checkpoints, proposals, contradictions, claims, queue state, and generated context packs.

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
