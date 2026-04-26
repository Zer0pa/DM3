from __future__ import annotations

import json
from pathlib import Path

from zpe_dm3.cli import check_surface, surface_payload


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"


def _section_text(heading: str) -> str:
    text = README.read_text()
    start = text.index(heading)
    next_index = text.find("\n## ", start + len(heading))
    if next_index == -1:
        return text[start:]
    return text[start:next_index]


def test_canonical_readme_headings_are_present_in_order() -> None:
    text = README.read_text()
    headings = [
        "## What This Is",
        "## Key Metrics",
        "## What We Prove",
        "## What We Don't Claim",
        "## Commercial Readiness",
        "## Tests and Verification",
        "## Proof Anchors",
        "## Repo Shape",
        "## Quick Start",
    ]
    positions = [text.index(heading) for heading in headings]
    assert positions == sorted(positions)


def test_key_metrics_has_exactly_four_rows() -> None:
    section = _section_text("## Key Metrics")
    rows = [
        line
        for line in section.splitlines()
        if line.startswith("|")
        and "Metric" not in line
        and "---" not in line
    ]
    assert len(rows) == 4


def test_proof_anchor_paths_exist() -> None:
    anchor_paths = [
        "validation/results/repo_surface_preflight.json",
        "proofs/manifests/CURRENT_AUTHORITY_PACKET.md",
        "repo_stage/CLAIMS.md",
        "repo_stage/IS_AND_IS_NOT.md",
        "repo_stage/CHARACTERIZATION_REPORT.md",
        "repo_stage/SESSION6_REVIEW_PACK.md",
        "docs/restart/DM3_SESSION7_PRD_v2.md",
    ]
    for relative_path in anchor_paths:
        assert (ROOT / relative_path).exists(), relative_path


def test_repo_surface_preflight_matches_readme_source() -> None:
    payload = json.loads((ROOT / "validation/results/repo_surface_preflight.json").read_text())
    assert payload["verdict"] == "STAGED"
    assert payload["confidence_percent"] == 70


def test_surface_cli_reports_expected_paths() -> None:
    payload = surface_payload()
    assert payload["authority_packet"] == "proofs/manifests/CURRENT_AUTHORITY_PACKET.md"
    assert payload["preflight"] == "validation/results/repo_surface_preflight.json"


def test_surface_check_passes() -> None:
    status, missing = check_surface()
    assert status == 0
    assert missing == []
