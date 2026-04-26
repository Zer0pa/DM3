# Outstanding Items And Risks

## Outstanding Engineering Items

### 1. Validator-Default Repair

Still open:

- determine the exact baked-in default target or default-selection rule on the
  live device validator
- decide whether the live Mac tuple should replace that target or whether a
  deeper rule repair is required

### 2. Top-Level `F2` Root-Surface Repair

Still open:

- determine the exact runtime precondition beyond `RegionTags_v1.bin`, if any,
  that causes the top-level root family to stall after resonance start
- repair that top-level root family without silently switching to the legacy
  bundled residue surface

### 3. Official `F2` Outlier Packet

Still open:

- only run the official hardened `F2` packet once the latest retained surface
  probe says `root_cpu_default=callable`

### 4. Heterogeneous Brief Readiness

Still open:

- after the two repairs above, decide whether the branch is ready for a real
  heterogeneous-compute brief
- that brief still requires honesty about current `ABSTAIN` boundaries

## Risks

### Operational Risk

- local changes are not yet committed

### Technical Risk

- the top-level `F2` root family may still hide more than one runtime
  precondition

### Interpretation Risk

- the legacy `/data/local/tmp/dm3/dm3_runner` surface is callable and therefore
  tempting to misuse as a substitute for the top-level root family

### Claim-Risk

- there is still no admissible explicit heterogeneous handoff artifact
- there is still no admissible NPU assist claim

## What Is Not Outstanding

- disk pressure triage
- startup-route cleanup
- branch-state synchronization
- readiness-artifact retention
- blocked-boundary retention on the official `F2` outlier entrypoint
