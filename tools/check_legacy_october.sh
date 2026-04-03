#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RECOVERY_ROOT="${DM3_RECOVERY_ROOT:-${REPO_ROOT}/../recovery}"
WORKSPACE_DIR="${RECOVERY_ROOT}/zer0pamk1-DM-3-Oct/snic"

if [ ! -d "${WORKSPACE_DIR}" ]; then
  echo "Missing recoverable October workspace: ${WORKSPACE_DIR}" >&2
  echo "Run ./tools/bootstrap_recovery.sh first." >&2
  exit 1
fi

if ! command -v cargo >/dev/null 2>&1; then
  echo "cargo is required but not installed." >&2
  exit 1
fi

(
  cd "${WORKSPACE_DIR}"
  cargo check --workspace
  cargo test --workspace -- --nocapture
)
