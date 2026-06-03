# Atlas MCP Tools

Use MCP tools for Atlas access. Do not route agent workflows through the CLI.

Always pass `atlas_username` when the tool accepts it.

Always pass a normalized lower-case repository identity as `repo`. Prefer the Git remote origin basename, strip `.git`, and lowercase it. Keep branch names, URLs, paths, and display labels out of `repo`.

## Read Tools

`atlas_context`
: Collaboration continuity frame for the current task.

`atlas_engineering_context`
: Main starting point for existing repos. Returns collaboration frame plus repo facts, decisions, failures, checkpoints, proposals, claim warnings, project mode, task mode, and suggested checks.

`atlas_engineering_recall`
: Specific memory search after the context pack is not enough.

`atlas_engineering_project_map`
: Read a structured project map. Pass `query` or `task` and `limit` to retrieve relevant entries instead of dumping everything.

`atlas_engineering_memories`
: Inspect stored engineering memory rows.

`atlas_engineering_health`
: Inspect memory quality counters.

`atlas_engineering_receipt`
: Read recent writes, checkpoints, proposals, contradictions, claims, and hygiene runs together.

`atlas_engineering_checkpoints`
: List recent task handoff checkpoints.

`atlas_engineering_why_recall`
: Explain why retrieved memories appeared and what ignoring them changes.

`atlas_engineering_why_not_remember`
: Assess whether a candidate memory should be stored, proposed, quarantined, or rejected.

## Mutating Tools

`atlas_engineering_scan_map`
: Clone/fetch a Git remote or scan an accessible filesystem path and store a project knowledge map.

`atlas_engineering_profile`
: Profile basic repo facts and commands. Use for first onboarding or major repo shape changes.

`atlas_engineering_record_task`
: Record an investigation, debugging session, long output, or important trace without turning raw logs into durable canon.

`atlas_engineering_propose`
: Preferred write path for reusable source-backed facts.

`atlas_engineering_remember`
: Direct write. Use `direct=true` only when the operator asked or the fact is clearly source-backed and intentional.

`atlas_engineering_autocheckpoint`
: Git-backed checkpoint. Requires an explicit `root` the Atlas runtime can access.

`atlas_engineering_checkpoint`
: Manual handoff checkpoint when auto-checkpoint is unavailable or the handoff is conceptual.

`atlas_engineering_claim`
: Record that a memory materially influenced a decision.

## Governance Tools

Use these only with explicit operator intent or a clear memory-maintenance task:

- `atlas_engineering_review_proposals`
- `atlas_engineering_approve_proposal`
- `atlas_engineering_reject_proposal`
- `atlas_engineering_promote`
- `atlas_engineering_quarantine`
- `atlas_engineering_downgrade`
- `atlas_engineering_curate`
- `atlas_engineering_forget`
- `atlas_engineering_contradict`
- `atlas_engineering_resolve_contradiction`

`atlas_engineering_hygiene` and `atlas_engineering_validate_claims` default to dry-run. Pass `apply=true` only when mutation is requested.

## Minimal Examples

Context:

```json
{
  "repo": "example.identityservice",
  "task": "inspect token controller behavior",
  "atlas_username": "<your.username>"
}
```

Manual checkpoint:

```json
{
  "repo": "atlasdemo",
  "summary": "Deployed updated MCP package.",
  "tests": "/health healthy; tools/list returned expected tools.",
  "next": "Run targeted project-map scan.",
  "atlas_username": "<your.username>"
}
```
