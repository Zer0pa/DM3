#!/system/bin/sh
set -eu
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

JQ="$(command -v jq || true)"
if [ -z "$JQ" ]; then
  USE_PY_JSON=1
else
  USE_PY_JSON=0
fi

check_gate_summary() {
  local json_file="$1"
  if [ "$USE_PY_JSON" -eq 1 ]; then
    python3 - "$json_file" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as fh:
    data = json.load(fh)
summary = data.get('gate_summary', {})
if summary.get('gates_ok') and summary.get('cad_sos_present'):
    sys.exit(0)
sys.exit(1)
PY
  else
    "$JQ" -e '.gate_summary | (.gates_ok==true and .cad_sos_present==true)' "$json_file" >/dev/null
  fi
}

./scripts/POLICY_CHECK.sh
cargo build --locked
./scripts/REPRODUCE.sh
check_gate_summary artifacts/verify.json
echo "[SMOKE] PASS: gates_ok && CAD/SOS true"
