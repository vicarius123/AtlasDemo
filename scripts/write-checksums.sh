#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${ROOT_DIR}"
mkdir -p checksums
find artifacts -type f -print0 \
  | sort -z \
  | xargs -0 shasum -a 256 > checksums/SHA256SUMS

printf 'Wrote checksums/SHA256SUMS\n'
