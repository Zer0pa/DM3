# Runbook: XHigh Sub-Agent Orchestration

Last refreshed: `2026-04-05`

## Purpose

Keep the meta-orchestrator lean while extra-high reasoning sub-agents do the
bounded work needed for drift cleanup, engineering completion, and next-brief
readiness.

The orchestrator coordinates, integrates, and decides.
It does not absorb every local analysis task into its own context window.

## Core Rule

Delegate bounded ownership, not vague effort.

Every sub-agent must receive:

- one scoped mission
- one write scope or one read-only question set
- one explicit deliverable
- one boundary describing what it must not decide on its own

## Suggested Wave Structure

### Wave 0: Reality restore

Orchestrator only:

- read branch `STATE.md`
- read current bridge pack
- verify repo status
- verify device startup commands

Do not delegate before the orchestrator knows the current branch truth.

### Wave 1: Parallel discovery

Spawn xhigh sub-agents with disjoint scopes:

1. `authority_and_drift_auditor`
   Scope:
   - startup prompts
   - operating maps
   - README / clone docs
   - branch metadata
   Deliverable:
   - ranked list of active drift sources
   Must not:
   - rewrite evidence docs

2. `rm10_platform_engineer`
   Scope:
   - ADB reality
   - `/data/local/tmp` staging
   - execution paths
   - device manifest truth
   Deliverable:
   - startup reality and path audit
   Must not:
   - widen hardware claims

3. `validator_and_provenance_engineer`
   Scope:
   - validator failures
   - canonical-target ambiguity
   - source-vs-prebuilt boundaries
   Deliverable:
   - validator/provenance gap note
   Must not:
   - claim source parity without direct proof

4. `accelerator_boundary_engineer`
   Scope:
   - `F2` outlier question
   - NPU abstain boundary
   - heterogeneous handoff prerequisites
   Deliverable:
   - accelerator boundary note
   Must not:
   - call residue work bridge progress

5. `ops_and_receipts_engineer`
   Scope:
   - manifests
   - Comet
   - checkpoint identity
   - receipt rules
   Deliverable:
   - operations hardening note
   Must not:
   - simplify receipt requirements for convenience

### Wave 2: Skeptical review

Spawn:

6. `falsifier`
   Deliverable:
   - list of inflated interpretations or hidden assumption failures

7. `overclaim_verifier`
   Deliverable:
   - list of statements that exceed evidence

8. `underclaim_verifier`
   Deliverable:
   - list of places where the branch is already entitled to a bounded negative,
     abstain, or completion statement

These agents are not optional theater.
They prevent the branch from drifting upward or freezing unnecessarily.

### Wave 3: Controlled writing

Only after the factual waves return:

9. `pack_writer`
   Scope:
   - final startup prompt
   - PRD
   - runbooks
   - readiness memo
   Deliverable:
   - merged handover package
   Must not:
   - invent missing facts

## Ownership Map

Use a disjoint ownership table before spawning:

- startup and drift docs: `authority_and_drift_auditor`
- device and staging facts: `rm10_platform_engineer`
- validator and provenance surfaces: `validator_and_provenance_engineer`
- accelerator ceilings and future handoff requirements:
  `accelerator_boundary_engineer`
- manifests and logging: `ops_and_receipts_engineer`
- final prose surfaces: `pack_writer`

If two agents need the same file, make one read-only and one writable.

## Prompt Requirements For Every Sub-Agent

Every sub-agent prompt must include:

- current branch truth floor
- the exact repo root
- the relevant files it must read first
- its write boundary
- explicit forbidden inflation
- the exact output format wanted back

Minimum forbidden-inflation block:

- do not widen `F2` into bridge progress
- do not widen NPU inventory into execution success
- do not widen heterogeneous aspiration into handoff evidence
- do not narrate fresh RM10 lanes as source parity
- do not soften a fail or abstain result

## Integration Rules

The orchestrator must:

1. collect sub-agent outputs
2. remove duplicates
3. reconcile contradictions against live branch authority
4. decide what becomes an updated active surface
5. decide what remains historical

The orchestrator must not:

- restudy already answered bounded questions itself
- ignore sub-agent contradictions because a prettier story exists
- merge unresolved conflicts into vague prose

## Wait Discipline

Wait only when the next integration step is truly blocked.

While agents run, the orchestrator should:

- read the live authority surfaces
- draft the integration structure
- prepare the write plan

Do not busy-poll.

## Final Merge Order

Merge in this order:

1. branch truth floor from `STATE.md` and `01.2.3.2` pack
2. drift audit
3. validator/provenance engineering gaps
4. RM10 platform and logging hardening
5. accelerator boundary decisions
6. final startup prompt and readiness surfaces

This order prevents style from outranking truth.

## Completion Condition

The orchestration run is complete only if:

- every bounded workstream has an owner
- every owner returned a concrete result or explicit blocker
- the orchestrator produced a tighter, more truthful branch package
- the next operator can resume without drifting into old narratives
