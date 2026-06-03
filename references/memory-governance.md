# Memory Governance

Atlas memory is governed guidance. It is not a source of truth.

## Store Or Propose

Store or propose:

- source-backed architecture decisions
- stable repo facts
- service contracts
- recurring failure modes
- verified fixes
- important test commands
- deployment or runtime conventions
- task checkpoints and handoffs
- useful project-map discoveries

Prefer `atlas_engineering_propose` unless:

- the operator explicitly asked for a direct write
- the fact is clearly source-backed and intentional
- a checkpoint is needed for continuity

## Do Not Store

Never store:

- secrets, tokens, passwords, private keys, credential files, or `.env` contents
- raw private logs
- unsupported guesses
- one-off jokes or temporary moods
- large chat transcripts
- full file dumps
- personal information unless explicitly required and approved
- claims contradicted by current source or runtime evidence

## Contradictions

If memory conflicts with current source, tests, logs, or runtime evidence:

1. Trust the current evidence.
2. Avoid silently overwriting the old memory.
3. Use `atlas_engineering_contradict` when a stored memory is materially misleading.
4. Resolve contradiction cases only with explicit evidence or operator decision.

## Hygiene

Use hygiene as a review path, not a blind cleanup path.

- Dry-run first.
- Apply only when asked.
- Quarantine weak, stale, or risky memory instead of promoting it.
- Keep task memory from becoming durable architecture canon by accident.

## Claim Ledger

Use `atlas_engineering_claim` when a memory materially influenced a coding decision. Validate or invalidate claims when later evidence shows whether that memory helped or misled.
