#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env.team"
ENV_EXAMPLE="${ROOT_DIR}/.env.team.example"
MCP_PORT="${ATLAS_MCP_PORT:-5391}"
HEALTH_URL="${ATLAS_HEALTH_URL:-http://127.0.0.1:${MCP_PORT}/health}"
VERSION_URL="${ATLAS_VERSION_URL:-http://127.0.0.1:${MCP_PORT}/version}"
BUILD_TIMEOUT_SECONDS="${ATLAS_COMPOSE_BUILD_TIMEOUT_SECONDS:-900}"

cd "${ROOT_DIR}"

if [ ! -f "${ENV_FILE}" ]; then
  cp "${ENV_EXAMPLE}" "${ENV_FILE}"
  printf 'Created %s from .env.team.example\n' "${ENV_FILE}"
  printf 'Edit %s and change POSTGRES_PASSWORD before using this beyond a private test host.\n' "${ENV_FILE}" >&2
fi

if grep -q '^POSTGRES_PASSWORD=change-this-before-use$' "${ENV_FILE}"; then
  printf 'Refusing team deploy with the default POSTGRES_PASSWORD. Edit %s first.\n' "${ENV_FILE}" >&2
  exit 2
fi

if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker CLI was not found. Install Docker Engine with Compose v2, then retry.\n' >&2
  exit 127
fi

if command -v timeout >/dev/null 2>&1; then
  timeout "${BUILD_TIMEOUT_SECONDS}" docker compose --env-file "${ENV_FILE}" -f docker-compose.team.yml build --progress=plain
else
  docker compose --env-file "${ENV_FILE}" -f docker-compose.team.yml build --progress=plain
fi

docker compose --env-file "${ENV_FILE}" -f docker-compose.team.yml up -d

printf 'Waiting for Atlas team health at %s\n' "${HEALTH_URL}"
for _ in $(seq 1 60); do
  if curl -fsS "${HEALTH_URL}" >/dev/null; then
    curl -fsS "${VERSION_URL}"
    printf '\nAtlas team server is healthy.\n'
    printf 'MCP URL for Codex agents: http://<host>:%s/mcp\n' "${MCP_PORT}"
    printf 'Console URL: http://<host>:%s/cockpit\n' "${MCP_PORT}"
    exit 0
  fi

  sleep 2
done

printf 'Atlas team server did not become healthy in time. Recent logs:\n' >&2
docker compose --env-file "${ENV_FILE}" -f docker-compose.team.yml logs --tail=80 atlas-mcp >&2
exit 1
