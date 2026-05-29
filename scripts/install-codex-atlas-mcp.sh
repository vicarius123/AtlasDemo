#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
CONFIG_FILE="${CODEX_CONFIG_FILE:-${CODEX_HOME}/config.toml}"
MCP_URL="${ATLAS_MCP_URL:-http://127.0.0.1:${ATLAS_MCP_PORT:-5391}/mcp}"

mkdir -p "${CODEX_HOME}"
touch "${CONFIG_FILE}"

if grep -q '^\[mcp_servers\.atlas\]' "${CONFIG_FILE}"; then
  awk -v url="${MCP_URL}" '
    BEGIN { in_atlas = 0; wrote_url = 0 }
    /^\[mcp_servers\.atlas\]/ { in_atlas = 1; wrote_url = 0; print; next }
    /^\[/ && in_atlas {
      if (!wrote_url) {
        print "url = \"" url "\""
      }
      in_atlas = 0
    }
    in_atlas && /^url = / {
      print "url = \"" url "\""
      wrote_url = 1
      next
    }
    { print }
    END {
      if (in_atlas && !wrote_url) {
        print "url = \"" url "\""
      }
    }
  ' "${CONFIG_FILE}" >"${CONFIG_FILE}.tmp"
  mv "${CONFIG_FILE}.tmp" "${CONFIG_FILE}"
else
  {
    printf '\n'
    printf '[mcp_servers.atlas]\n'
    printf 'url = "%s"\n' "${MCP_URL}"
  } >>"${CONFIG_FILE}"
fi

printf 'Configured Codex Atlas MCP server: %s\n' "${MCP_URL}"
printf 'Config file: %s\n' "${CONFIG_FILE}"
