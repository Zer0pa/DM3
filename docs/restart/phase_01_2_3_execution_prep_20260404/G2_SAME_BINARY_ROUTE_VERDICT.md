# G2 Same-Binary Route Verdict

## Decision

- `phase_outcome=PASS`
- `route_outcome=FAIL`
- `route_branch=retirement_only`
- `approved_route_tuple=null`
- `new_same_binary_attempt=false`

Artifact root:

`/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_g2_invocation_archaeology_20260404T201849Z`

## Frozen Inputs

- route decision object:
  `/Users/Zer0pa/DM3/restart/docs/restart/G2_ROUTE_DECISION_OBJECT.md`
- retained Plan `01` audit bundle:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404`
- official Phase `01.2.2` smoke control:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_2_non_stub_attempt_20260403`

## Exact Retirement Basis

1. The frozen decision object already sets `decision.status=no_candidate`,
   `approved_route_tuple=null`, and `plan_02_branch=retirement_only`. Under the
   plan contract, that forbids any second same-binary route probe.
2. The official Phase `01.2.2` control command
   `./dm3_runner --task exp_g2_readout --mode inference --adj SriYantraAdj_v1.bin --tags RegionTags_v2.json`
   still exits `0` but prints only:
   `Initializing DM3 Transformer Mesh V1...`, `State initialized. Vertices: 380`,
   `Running T1: Contraction...`, and `T1 Complete. Receipt logged.`
   Its normalized receipt remains
   `d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9`.
3. The retained Plan `01` comparison table shows all eight justified
   same-binary inference surfaces normalize to the same `d3e721...` smoke
   canonical with `run_id=t1_contraction`. That includes the explicit
   supplement probes `infer_boundary_alignment` and `infer_boundary_power`.
4. The only live non-smoke routes on the current binary are
   `train+holography` and `train+harmonic`. They are real, but they are not the
   preserved bundled `G2 Boundary Readout / R2Contrastive` family.
5. The task names that matter for the preserved bundled `G2` family remain
   train-side guarded on the same binary:
   `Error: Unknown task: exp_g2_readout`,
   `Error: Unknown task: boundary_alignment`, and
   `Error: Unknown task: boundary_power`.
6. The parser/help surface still lists only `holography` and `harmonic`, and
   Plan `01` found no surviving wrapper or environment candidate that could
   justify a new same-semantics probe.

## Verdict

The preserved bundled `G2` family is retired on the current callable binary.
This is an exact same-binary retirement proof, not an abstention and not a
scope-widening narrative.

Plan `02` therefore closes negatively but successfully:

- `phase_outcome=PASS` because the phase gate was answered exactly
- `route_outcome=FAIL` because no approved same-binary non-smoke `G2` route
  survives on `/data/local/tmp/dm3/dm3_runner`

## Redevelopment Boundary

Further progress would require one of the following, neither of which is
allowed inside this plan:

- recovering an adjacent historical launcher generation that is not evidenced on
  the current device surface
- replacing missing router or wrapper logic through redevelopment

The narrowest honest adjacent question is therefore not "which second route
should we try?" It is whether the historical bundled `G2` residue belongs to a
neighboring launcher generation that must be treated as a separate recovery
problem.
