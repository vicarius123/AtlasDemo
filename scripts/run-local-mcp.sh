#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

export ASPNETCORE_URLS="${ASPNETCORE_URLS:-http://127.0.0.1:${ATLAS_MCP_PORT:-5391}}"
export DOTNET_ENVIRONMENT="${DOTNET_ENVIRONMENT:-Production}"
export ATLAS_POSTGRES_CONNECTION="${ATLAS_POSTGRES_CONNECTION:-Host=127.0.0.1;Port=${ATLAS_POSTGRES_PORT:-5432};Database=${POSTGRES_DB:-atlascursedlab};Username=${POSTGRES_USER:-atlas};Password=${POSTGRES_PASSWORD:-atlas}}"

cd "${ROOT_DIR}/artifacts/Atlas.McpServer"
exec dotnet Atlas.McpServer.dll
