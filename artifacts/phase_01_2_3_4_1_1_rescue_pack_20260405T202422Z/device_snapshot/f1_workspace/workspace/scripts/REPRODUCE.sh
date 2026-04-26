#!/system/bin/sh
set -eu
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

./scripts/POLICY_CHECK.sh
cargo run -p io_cli --bin snic_rust -- build-2d --config configs/CONFIG.json
cargo run -p io_cli --bin snic_rust -- lift-3d  --config configs/CONFIG.json
cargo run -p io_cli --bin snic_rust -- solve-h2  --config configs/CONFIG.json
./scripts/VERIFY.sh
