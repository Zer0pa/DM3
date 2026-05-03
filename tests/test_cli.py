"""Smoke tests for the zpe-dm3 CLI."""
from __future__ import annotations

import subprocess
import sys


def test_surface_command() -> None:
    result = subprocess.run(
        [sys.executable, "-m", "zpe_dm3", "surface"],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0
    assert "DM3" in result.stdout


def test_check_command() -> None:
    result = subprocess.run(
        [sys.executable, "-m", "zpe_dm3", "check"],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0
