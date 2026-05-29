#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env.team"

cd "${ROOT_DIR}"
if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker CLI was not found. Nothing to stop through Docker Compose.\n' >&2
  exit 127
fi

if [ -f "${ENV_FILE}" ]; then
  docker compose --env-file "${ENV_FILE}" -f docker-compose.team.yml down "$@"
else
  docker compose -f docker-compose.team.yml down "$@"
fi

