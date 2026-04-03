#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RECOVERY_ROOT="${DM3_RECOVERY_ROOT:-${REPO_ROOT}/../recovery}"

mkdir -p "${RECOVERY_ROOT}"

clone_or_fetch() {
  local repo_url="$1"
  local dest_dir="$2"

  if [ -d "${dest_dir}/.git" ]; then
    git -C "${dest_dir}" fetch --all --tags --prune
    git -C "${dest_dir}" pull --ff-only
    return
  fi

  git clone "${repo_url}" "${dest_dir}"
}

clone_or_fetch \
  "https://github.com/Zer0pa/zer0pamk1-DM-3-Oct.git" \
  "${RECOVERY_ROOT}/zer0pamk1-DM-3-Oct"

clone_or_fetch \
  "https://github.com/Zer0pa/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025.git" \
  "${RECOVERY_ROOT}/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025"

printf 'Recovery sources ready under %s\n' "${RECOVERY_ROOT}"
