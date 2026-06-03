# Git Remote Scans

Use `atlas_engineering_scan_map` to create or refresh a structured project map for a repository. The Atlas server clones or fetches Git remotes into its own cache before scanning.

## Repo Identity

Use one normalized repository identity as `repo`.

Normalization rule:

1. Prefer the Git remote origin URL.
2. Take the final repository path segment.
3. Strip a trailing `.git`.
4. Lowercase the result.
5. Use that value for every Atlas MCP call.

Example:

```text
https://gitlab.example.com/team/Example.IdentityService.git
-> example.identityservice
```

Do not use:

- `G:\Projects\Repo`
- `/app/G:\Projects\Repo`
- `https://gitlab.example/team/repo.git`
- `Example.IdentityService - develop / https://gitlab.example.com/team/Example.IdentityService.git`
- `develop / Example.IdentityService`
- temporary checkout paths
- mixed-case aliases when the normalized lower-case repo identity exists

Record URLs and paths as `root`, `source_refs`, evidence, or metadata, not as repo identity.

## GitLab HTTPS

Central Atlas currently works with GitLab HTTPS token auth. Prefer HTTPS URLs:

```json
{
  "repo": "example.identityservice",
  "root": "https://gitlab.example.com/team/Example.IdentityService.git",
  "atlas_username": "<your.username>"
}
```

SSH URLs require the matching private key inside the MCP container. Public keys alone are not enough.

## Read Back

After scanning, use `atlas_engineering_project_map` with a focused query:

```json
{
  "repo": "example.identityservice",
  "query": "token service controllers tests",
  "limit": 8,
  "atlas_username": "<your.username>"
}
```

Prefer targeted queries over dumping the whole map.

## What Maps Capture

Project maps may include:

- solution files
- projects and dependencies
- modules and capabilities
- key files
- tests
- service/controller areas
- entry points

Project maps are navigation aids. Source still wins.
