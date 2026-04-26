#!/usr/bin/env bash
set -euo pipefail
jq -e '
  (.merkle_root | length>0) and
  (.artifacts | type=="array" and length>0) and
  (.gates | .geometry=="pass" and .deq=="pass" and .resonance=="pass" and .negative_controls=="pass" and .prosody=="pass") and
  (.sidecars_ok==true) and
  (.pushed_and_verified==true)
' artifacts/summary.json >/dev/null
