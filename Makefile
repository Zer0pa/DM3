RECOVERY_ROOT ?= ../recovery
READINESS_PHASE ?= 01.2.3.4.1
PHASE ?= $(READINESS_PHASE)
PLAN ?= f2-outlier-hardened-capture
ARTIFACT_ROOT ?=
READINESS_SUMMARY ?=
RUN_PYTHON := $(if $(wildcard .venv/bin/python),.venv/bin/python,python3)

.PHONY: bootstrap-recovery check-legacy smoke-comet rm10-f1-serious rm10-f2-harmonic rm10-f2-outlier rm10-f1-validator-probe rm10-f2-surface-probe rm10-readiness-gate

bootstrap-recovery:
	./tools/bootstrap_recovery.sh

check-legacy:
	DM3_RECOVERY_ROOT=$(RECOVERY_ROOT) ./tools/check_legacy_october.sh

smoke-comet:
	COMET_OFFLINE_DIRECTORY=.cometml-runs $(RUN_PYTHON) tools/comet_manifest_logger.py --manifest examples/comet/run_manifest.example.json --offline

rm10-f1-serious:
	@TS=$$(date -u +%Y%m%dT%H%M%SZ); \
	$(RUN_PYTHON) tools/rm10_capture.py f1-serious --artifact-root "artifacts/rm10_f1_serious_$$TS" --run-id "rm10_f1_serious_$$TS"

rm10-f2-harmonic:
	@TS=$$(date -u +%Y%m%dT%H%M%SZ); \
	$(RUN_PYTHON) tools/rm10_capture.py f2-harmonic --artifact-root "artifacts/rm10_f2_harmonic_$$TS" --run-prefix "rm10_f2_harmonic_$$TS"

rm10-f2-outlier:
	$(RUN_PYTHON) tools/rm10_f2_outlier_capture.py --phase "$(PHASE)" --plan "$(PLAN)" $(if $(READINESS_SUMMARY),--surface-probe-summary "$(READINESS_SUMMARY)",) $(if $(ARTIFACT_ROOT),--artifact-root "$(ARTIFACT_ROOT)",)

rm10-f1-validator-probe:
	@TS=$$(date -u +%Y%m%dT%H%M%SZ); \
	$(RUN_PYTHON) tools/rm10_engineering_readiness.py validator-probe --phase "$(READINESS_PHASE)" --plan "validator-stale-canonical-probe" --artifact-root "artifacts/rm10_validator_probe_$$TS"

rm10-f2-surface-probe:
	@TS=$$(date -u +%Y%m%dT%H%M%SZ); \
	$(RUN_PYTHON) tools/rm10_engineering_readiness.py f2-surface-probe --phase "$(READINESS_PHASE)" --plan "f2-surface-repair-probe" --artifact-root "artifacts/rm10_f2_surface_probe_$$TS"

rm10-readiness-gate:
	$(MAKE) rm10-f1-validator-probe
	$(MAKE) rm10-f2-surface-probe
