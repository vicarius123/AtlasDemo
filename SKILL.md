---
name: atlas
description: Use Atlas engineering continuity through the centralized MCP server. Use when Codex needs repo/task context, GitLab remote project maps, handoff checkpoints, memory governance, source-backed engineering recall, proposal review, contradiction handling, or compact context packs before coding.
---

# Atlas Skill

Atlas is the continuity and context control plane for coding agents. Use it for meaningful engineering work where repo history, task handoffs, project maps, known failures, tests, deployment state, or collaboration posture matter.

Atlas memory is guidance, not authority. Current source, Git state, tests, logs, runtime behavior, and explicit operator direction always win.

## Start Here

1. Resolve the current actor name before Atlas calls: on Windows prefer `$env:USERNAME`; on Linux/macOS prefer `$USER` or `whoami`.
2. Pass that actor as `atlas_username` whenever the MCP tool schema accepts it.
3. Normalize the repository identity before every Atlas call:
   - Prefer `git remote get-url origin`.
   - Take the final repository path segment.
   - Strip a trailing `.git`.
   - Lowercase the result.
   - Use that value as `repo`, for example `atlas-skill`, `example.identityservice`, or `api-gateway`.
   - If no Git remote exists, use the lowercase checkout folder name until the operator provides a canonical name.
   - Never include local paths, container paths, Git URLs, branch names, or display labels in `repo`.
4. Fetch Atlas context before non-trivial work in an existing repo.
5. Verify recalled memory against current source and runtime evidence.
6. Leave an Atlas checkpoint after meaningful verified work.

## Golden Paths

### Existing Repo

1. Call `atlas_engineering_context` with `repo`, `task`, and `atlas_username`.
2. Read current Git state and source files.
3. Use `atlas_engineering_project_map` when you need targeted structure recall for modules, tests, controllers, services, dependencies, or entry points.
4. Code, review, or debug normally.
5. Use `atlas_engineering_record_task` for substantial investigations, important traces, long command outputs, or debugging outcomes.
6. Run focused verification.
7. Call `atlas_engineering_autocheckpoint` when Atlas can access the repo root; otherwise use `atlas_engineering_checkpoint`.
8. Use `atlas_engineering_propose` for durable source-backed lessons.

### New Repo Or Major Shape Change

1. Prefer `atlas_engineering_scan_map` with the canonical `repo` and a Git HTTPS URL or accessible filesystem `root`.
2. Use `atlas_engineering_profile` only when you want basic repo facts and commands in addition to or instead of the structured map.
3. Read source, manifests, entry points, tests, and deployment files.
4. Propose source-backed durable facts with `atlas_engineering_propose`.
5. Verify narrowly.
6. Leave an auto-checkpoint or manual checkpoint.

## Common Tools

| Need | Use |
| --- | --- |
| Repo/task context pack | `atlas_engineering_context` |
| Collaboration frame only | `atlas_context` |
| Search engineering memory | `atlas_engineering_recall` |
| Scan Git remote or local repo into structured map | `atlas_engineering_scan_map` |
| Query stored project map | `atlas_engineering_project_map` |
| Record investigation trace | `atlas_engineering_record_task` |
| Propose durable memory | `atlas_engineering_propose` |
| Direct memory write when operator asked | `atlas_engineering_remember direct=true` |
| Checkpoint with live Git state | `atlas_engineering_autocheckpoint` |
| Manual checkpoint | `atlas_engineering_checkpoint` |
| Review proposals | `atlas_engineering_review_proposals` |
| Explain recall | `atlas_engineering_why_recall` |
| Check if a memory should be stored | `atlas_engineering_why_not_remember` |
| Hygiene dry run | `atlas_engineering_hygiene` |
| Recent writes and governance artifacts | `atlas_engineering_receipt` |

## Non-Negotiables

- Never dump full files, raw chat logs, secrets, tokens, `.env` files, credential files, or private keys into Atlas.
- Never treat Atlas memory as proof.
- Prefer proposals unless the operator explicitly asks for direct writes or the fact is clearly source-backed and intentional.
- Pass `atlas_username` on every Atlas call that accepts it.
- Keep context packs summarized in chat; do not paste full context packs unless asked.
- Do not create spec files, milestone logs, or process-control markdown as a continuity substitute.

## Central Runtime

Primary centralized MCP endpoint:

```text
http://<atlas-host>:5391/mcp
```

Health and console:

```text
http://<atlas-host>:5391/health
http://<atlas-host>:5391/cockpit
```

## References

Read only the reference that matches the current task:

- `references/tools.md` - detailed MCP tool decision guide and examples.
- `references/git-remote-scans.md` - scanning GitLab/Git HTTPS remotes into project maps.
- `references/memory-governance.md` - proposal, direct write, quarantine, contradiction, hygiene, and secret rules.
- `references/team-server.md` - centralized MCP runtime and username attribution.
