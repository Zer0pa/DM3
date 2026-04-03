RECOVERY_ROOT ?= ../recovery

.PHONY: bootstrap-recovery check-legacy smoke-comet

bootstrap-recovery:
	./tools/bootstrap_recovery.sh

check-legacy:
	DM3_RECOVERY_ROOT=$(RECOVERY_ROOT) ./tools/check_legacy_october.sh

smoke-comet:
	COMET_OFFLINE_DIRECTORY=.cometml-runs .venv/bin/python tools/comet_manifest_logger.py --manifest examples/comet/run_manifest.example.json --offline
