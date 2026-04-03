#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Log a DM3 run manifest to Comet."
    )
    parser.add_argument(
        "--manifest",
        required=True,
        help="Path to the JSON manifest describing the run.",
    )
    parser.add_argument(
        "--workspace",
        help="Override Comet workspace. Defaults to manifest or COMET_WORKSPACE.",
    )
    parser.add_argument(
        "--project",
        help="Override Comet project. Defaults to manifest or COMET_PROJECT_NAME.",
    )
    parser.add_argument(
        "--experiment-key",
        help="Resume or target a specific Comet experiment key.",
    )
    parser.add_argument(
        "--mode",
        choices=["create", "get_or_create", "get"],
        help="Comet start mode. Defaults to create for new runs, get_or_create when an experiment key is provided.",
    )
    parser.add_argument(
        "--offline",
        action="store_true",
        help="Log offline to a local Comet run bundle.",
    )
    parser.add_argument(
        "--write-key-file",
        help="Optional file path where the resolved experiment key will be written.",
    )
    return parser.parse_args()


def load_manifest(path: str) -> dict[str, Any]:
    manifest_path = Path(path)
    if not manifest_path.is_file():
        raise SystemExit(f"Manifest not found: {manifest_path}")

    with manifest_path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)

    if not isinstance(payload, dict):
        raise SystemExit("Manifest root must be a JSON object.")

    return payload


def resolve_value(
    override: str | None,
    manifest: dict[str, Any],
    manifest_key: str,
    env_key: str,
    default: str | None = None,
) -> str | None:
    if override:
        return override
    manifest_value = manifest.get(manifest_key)
    if isinstance(manifest_value, str) and manifest_value:
        return manifest_value
    env_value = os.getenv(env_key)
    if env_value:
        return env_value
    return default


def normalize_mapping(value: Any) -> dict[str, Any]:
    if value is None:
        return {}
    if isinstance(value, dict):
        return value
    raise SystemExit("Expected a JSON object for parameters or others.")


def normalize_metrics(value: Any) -> list[dict[str, Any]]:
    if value is None:
        return []
    if isinstance(value, list):
        return value
    if isinstance(value, dict):
        return [{"name": key, "value": metric} for key, metric in value.items()]
    raise SystemExit("Expected metrics to be a list or object.")


def normalize_assets(value: Any) -> list[dict[str, Any]]:
    if value is None:
        return []
    if isinstance(value, list):
        return value
    raise SystemExit("Expected assets to be a list.")


def get_comet():
    try:
        import comet_ml  # type: ignore
    except ImportError as exc:  # pragma: no cover
        raise SystemExit(
            "comet_ml is not installed. Run `pip install -r requirements.txt` first."
        ) from exc

    return comet_ml


def start_experiment(
    comet_ml: Any,
    workspace: str | None,
    project_name: str | None,
    experiment_key: str | None,
    mode: str,
    offline: bool,
):
    start_kwargs: dict[str, Any] = {
        "workspace": workspace,
        "project_name": project_name,
        "online": not offline,
        "mode": mode,
    }
    if experiment_key:
        start_kwargs["experiment_key"] = experiment_key
    return comet_ml.start(**start_kwargs)


def log_parameters(experiment: Any, parameters: dict[str, Any]) -> None:
    for key, value in parameters.items():
        experiment.log_parameter(key, value)


def log_metrics(experiment: Any, metrics: list[dict[str, Any]]) -> None:
    for metric in metrics:
        name = metric.get("name")
        if not isinstance(name, str) or not name:
            raise SystemExit("Each metric entry must include a non-empty string `name`.")
        experiment.log_metric(name, metric.get("value"), step=metric.get("step"))


def log_others(experiment: Any, others: dict[str, Any]) -> None:
    for key, value in others.items():
        experiment.log_other(key, value)


def log_dataset(experiment: Any, dataset: Any) -> None:
    if dataset is None:
        return
    if not isinstance(dataset, dict):
        raise SystemExit("`dataset` must be a JSON object.")
    experiment.log_dataset_info(
        name=dataset.get("name"),
        version=dataset.get("version"),
        path=dataset.get("path"),
    )


def log_assets(experiment: Any, assets: list[dict[str, Any]]) -> None:
    for asset in assets:
        path = asset.get("path")
        if not isinstance(path, str) or not path:
            raise SystemExit("Each asset entry must include a non-empty string `path`.")
        asset_path = Path(path)
        if not asset_path.exists():
            raise SystemExit(f"Asset not found: {asset_path}")
        experiment.log_asset(
            str(asset_path),
            step=asset.get("step"),
            overwrite=asset.get("overwrite"),
            context=asset.get("context"),
        )


def resolved_key(experiment: Any) -> str | None:
    getter = getattr(experiment, "get_key", None)
    if callable(getter):
        return getter()
    key_value = getattr(experiment, "id", None)
    if isinstance(key_value, str) and key_value:
        return key_value
    return None


def write_key_file(path: str | None, experiment_key: str | None) -> None:
    if not path or not experiment_key:
        return
    key_path = Path(path)
    key_path.parent.mkdir(parents=True, exist_ok=True)
    key_path.write_text(f"{experiment_key}\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    manifest = load_manifest(args.manifest)

    workspace = resolve_value(
        args.workspace, manifest, "workspace", "COMET_WORKSPACE", default="zer0pa"
    )
    project_name = resolve_value(
        args.project, manifest, "project_name", "COMET_PROJECT_NAME", default="dm3"
    )
    experiment_key = args.experiment_key or manifest.get("experiment_key")
    mode = args.mode or ("get_or_create" if experiment_key else "create")

    comet_ml = get_comet()
    experiment = start_experiment(
        comet_ml=comet_ml,
        workspace=workspace,
        project_name=project_name,
        experiment_key=experiment_key,
        mode=mode,
        offline=args.offline,
    )

    name = manifest.get("name")
    if isinstance(name, str) and name:
        experiment.set_name(name)

    tags = manifest.get("tags")
    if isinstance(tags, list) and tags:
        experiment.add_tags([str(tag) for tag in tags])

    log_parameters(experiment, normalize_mapping(manifest.get("parameters")))
    log_metrics(experiment, normalize_metrics(manifest.get("metrics")))
    log_others(experiment, normalize_mapping(manifest.get("others")))
    log_dataset(experiment, manifest.get("dataset"))
    log_assets(experiment, normalize_assets(manifest.get("assets")))

    key_value = resolved_key(experiment)
    write_key_file(args.write_key_file, key_value)

    if key_value:
        print(f"COMET_EXPERIMENT_KEY={key_value}")
    url_value = getattr(experiment, "url", None)
    if isinstance(url_value, str) and url_value:
        print(f"COMET_EXPERIMENT_URL={url_value}")

    experiment.end()
    return 0


if __name__ == "__main__":
    sys.exit(main())
