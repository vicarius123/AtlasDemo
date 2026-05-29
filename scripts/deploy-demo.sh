#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"
ENV_EXAMPLE="${ROOT_DIR}/.env.example"
MCP_PORT="${ATLAS_MCP_PORT:-5391}"
HEALTH_URL="${ATLAS_HEALTH_URL:-http://127.0.0.1:${MCP_PORT}/health}"
VERSION_URL="${ATLAS_VERSION_URL:-http://127.0.0.1:${MCP_PORT}/version}"
BUILD_TIMEOUT_SECONDS="${ATLAS_COMPOSE_BUILD_TIMEOUT_SECONDS:-900}"

cd "${ROOT_DIR}"

if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker CLI was not found. Install Docker Desktop or Docker Engine with Compose v2, then retry.\n' >&2
  exit 127
fi

if [ ! -f "${ENV_FILE}" ]; then
  cp "${ENV_EXAMPLE}" "${ENV_FILE}"
  printf 'Created %s from .env.example\n' "${ENV_FILE}"
fi

if command -v timeout >/dev/null 2>&1; then
  timeout "${BUILD_TIMEOUT_SECONDS}" docker compose build --progress=plain
else
  docker compose build --progress=plain
fi

docker compose up -d

printf 'Waiting for Atlas health at %s\n' "${HEALTH_URL}"
for _ in $(seq 1 60); do
  if curl -fsS "${HEALTH_URL}" >/dev/null; then
    curl -fsS "${VERSION_URL}"
    printf '\nAtlas demo is healthy.\n'
    printf 'MCP URL: http://127.0.0.1:%s/mcp\n' "${MCP_PORT}"
    exit 0
  fi

  sleep 2
done

printf 'Atlas demo did not become healthy in time. Recent logs:\n' >&2
docker compose logs --tail=80 atlas-mcp >&2
exit 1
