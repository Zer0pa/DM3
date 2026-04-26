"""Small CLI for DM3 repo-surface review."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
REQUIRED_PATHS = (
    "README.md",
    "LICENSE",
    "CITATION.cff",
    "CHANGELOG.md",
    "CONTRIBUTING.md",
    "SECURITY.md",
    "CODE_OF_CONDUCT.md",
    "pyproject.toml",
    "docs/README.md",
    "docs/ARCHITECTURE.md",
    "docs/FAQ.md",
    "docs/SUPPORT.md",
    "docs/LEGAL_BOUNDARIES.md",
    "proofs/manifests/CURRENT_AUTHORITY_PACKET.md",
    "validation/results/repo_surface_preflight.json",
)


def surface_payload() -> dict[str, object]:
    """Return a compact description of the repo surface."""
    return {
        "root": str(ROOT),
        "authority_packet": "proofs/manifests/CURRENT_AUTHORITY_PACKET.md",
        "preflight": "validation/results/repo_surface_preflight.json",
        "engineering_lane": ["docs/restart", "artifacts"],
        "package": "zpe-dm3",
    }


def check_surface() -> tuple[int, list[str]]:
    """Return a status code and the list of missing required paths."""
    missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
    return (0 if not missing else 1, missing)


def main(argv: list[str] | None = None) -> int:
    """Run the DM3 repo-surface CLI."""
    parser = argparse.ArgumentParser(prog="zpe-dm3")
    subparsers = parser.add_subparsers(dest="command", required=True)

    surface_parser = subparsers.add_parser("surface")
    surface_parser.add_argument("--json", action="store_true")

    subparsers.add_parser("check")

    args = parser.parse_args(argv)

    if args.command == "surface":
        payload = surface_payload()
        if args.json:
            print(json.dumps(payload, indent=2, sort_keys=True))
        else:
            for key, value in payload.items():
                print(f"{key}: {value}")
        return 0

    status, missing = check_surface()
    if missing:
        for path in missing:
            print(f"MISSING {path}")
    else:
        print("DM3 repo surface check passed.")
    return status


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
