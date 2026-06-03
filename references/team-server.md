# Team Server Runtime

Primary Atlas MCP endpoint:

```text
http://<atlas-host>:5391/mcp
```

Health and cockpit:

```text
http://<atlas-host>:5391/health
http://<atlas-host>:5391/cockpit
```

## Username Attribution

Resolve the current actor before Atlas calls:

- Windows Codex host: `$env:USERNAME`
- Linux/macOS: `$USER` or `whoami`

Pass the actor as `atlas_username` whenever the MCP schema accepts it.

`ATLAS_USERNAME` on the server/container is only the fallback for older clients or tools that do not send per-call provenance.
