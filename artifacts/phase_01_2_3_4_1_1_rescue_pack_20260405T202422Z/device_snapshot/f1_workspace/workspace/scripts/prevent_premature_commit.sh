#!/usr/bin/env bash
set -euo pipefail
if ! scripts/no_stub_guard.sh; then
  echo "Guard: refusing commit/push. Artifacts or gates incomplete."; exit 1
fi
