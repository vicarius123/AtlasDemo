#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MCP_PORT="${ATLAS_MCP_PORT:-5391}"
HEALTH_URL="${ATLAS_HEALTH_URL:-http://127.0.0.1:${MCP_PORT}/health}"
VERSION_URL="${ATLAS_VERSION_URL:-http://127.0.0.1:${MCP_PORT}/version}"
MCP_URL="${ATLAS_MCP_URL:-http://127.0.0.1:${MCP_PORT}/mcp}"

cd "${ROOT_DIR}"

if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker CLI was not found. Install Docker Desktop or Docker Engine with Compose v2, then retry.\n' >&2
  exit 127
fi

docker compose ps --status running | grep -q 'atlas-demo-mcp'
curl -fsS "${HEALTH_URL}" | grep -q 'healthy'
curl -fsS "${VERSION_URL}" | grep -q '1.0.0'

tools_json="$(curl -fsS "${MCP_URL}" \
  -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}')"

printf '%s' "${tools_json}" | grep -q 'atlas_context'
printf '%s' "${tools_json}" | grep -q 'atlas_engineering_context'

curl -fsS "${MCP_URL}" \
  -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"atlas_context","arguments":{"task":"Atlas demo smoke"}}}' >/dev/null

printf 'Atlas demo smoke passed at %s\n' "${MCP_URL}"
