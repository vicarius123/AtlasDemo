#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${ROOT_DIR}"
if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker CLI was not found. Nothing to stop through Docker Compose.\n' >&2
  exit 127
fi

docker compose down "$@"
