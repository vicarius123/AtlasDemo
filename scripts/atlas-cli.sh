#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

export ATLAS_POSTGRES_CONNECTION="${ATLAS_POSTGRES_CONNECTION:-Host=127.0.0.1;Port=${ATLAS_POSTGRES_PORT:-5432};Database=${POSTGRES_DB:-atlascursedlab};Username=${POSTGRES_USER:-atlas};Password=${POSTGRES_PASSWORD:-atlas}}"

exec dotnet "${ROOT_DIR}/artifacts/Atlas.Cli/Atlas.Cli.dll" "$@"
