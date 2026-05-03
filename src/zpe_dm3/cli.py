"""Command-line interface for zpe-dm3."""
from __future__ import annotations

import argparse


def main() -> None:
    """Entry point for the ``zpe-dm3`` console script."""
    parser = argparse.ArgumentParser(
        prog="zpe-dm3",
        description="Repo-surface utilities for the DM3 structural diagnostic.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("surface", help="Print the DM3 repo surface summary.")
    subparsers.add_parser("check", help="Run surface integrity checks.")

    args = parser.parse_args()

    if args.command == "surface":
        _surface()
    elif args.command == "check":
        _check()


def _surface() -> None:
    print("DM3 structural diagnostic — repo surface summary.")
    print("See README.md, CLAIMS.md, and CHARACTERIZATION_REPORT.md.")


def _check() -> None:
    print("DM3 surface integrity check.")
    print("See validation/results/ for preflight results.")


if __name__ == "__main__":
    main()
