# RM10 Capability Falsifier Verdict

Plan: `01.2.3.4.1.1-06`

Falsifier verdict: `COLLAPSES`

## Apparent Effect Under Test

After cleanup, the cleaned RM10 `F1` lane still ran and the Wave 2 perturbation
battery changed raw `verify.json` and `solve_h2.json` hashes. Wave 6 tests
whether that was any real retained capability or only a package of hygiene,
proxy, and downstream-story illusions.

## Short Answer

The package survives the hygiene attacks. It does not survive the capability
attack.

- Wave 1 proved the lane was genuinely cleaned rather than replaying stale path
  state.
- Wave 2 then showed that the only apparent variation was raw hash churn.
- Once the receipts were normalized semantically, all six rows collapsed to one
  semantic family.
- Wave 3, Wave 4, and Wave 5 then closed every route that could have turned the
  package back into a real property, handoff, or lane story.

The only still-open doubt is hidden fallback inside the prebuilt-backed
`genesis_cli`. That remains mechanistically unresolved, but it does not rescue
the surfaced capability claim because no second retained response family ever
appeared.

## Attack Matrix

| Attack line | Decisive evidence | Result |
| --- | --- | --- |
| stale-path illusion | Wave 1 quarantined `62` stale root-surface entries and `12` prior `F1` audit entries, then reran the cleaned lane from `/data/local/tmp/SoC_runtime/workspace`. | `survived` |
| validator illusion | Cleanup and all six Wave 2 rows stayed `default_validate=1` and `explicit_validate=0`; the verdict was driven by receipt semantics, not validator-default behavior. | `survived` |
| output contamination | Cleanup used a fresh audit leaf and Wave 2 used fresh row-specific audit leaves; no cited packet reused quarantined output paths. | `survived` |
| logging illusion | Wave 2 produced four distinct raw hash pairs across perturbations, but every row normalized to semantic digest `53d477f605117a935285716029129a225c9497c15d373e289658d90ee29d675a` and all `36/36` pairwise comparisons report `same_semantic_digest=true`. | `killed` |
| thermal confound | Every retained Wave 2 row held battery temperature at `34.0 C -> 34.0 C` with thermal status `0 -> 0`. | `killed` |
| hidden fallback | The live `F1` lane still runs through prebuilt-backed `genesis_cli`, so hidden internal fallback cannot be excluded by path cleanup alone. | `unresolved` |
| residue-family contamination | Wave 2 explicitly excluded raw-workspace, `F2`, and bundled archaeology surfaces; Wave 5 separately rejected any `F1`-versus-`F2` splice as cross-family or unstable. | `survived` |
| handoff illusion | Wave 4 found no mapped property to carry and therefore no admissible same-family handoff battery or packet. | `killed` |
| lane illusion | Wave 5 found no usable lane: the only accelerator-bearing path is cross-family or unstable, and hardware presence or speed were rejected as behavior. | `killed` |

## Decisive Kill Shot

The decisive attack line is the logging and semantic normalization attack:
Wave 2 already showed that the perturbations changed only raw receipt hashes.
Once direct config echo and timestamp noise were stripped, the entire battery
collapsed to one semantic family. That removes the only candidate effect that
survived cleanup.

Everything after that is closure, not rescue:

- Wave 3: no property map opens
- Wave 4: no same-family handoff test opens
- Wave 5: no interpretable lane contrast opens

## What Still Remains True

- The branch now has one genuinely cleaned `F1` control lane.
- The branch also has a separate `F2` engineering problem.
- Neither of those truths is a retained capability result for this reset line.

## Net Verdict

Net falsifier verdict: `the apparent capability collapses`

Why:

1. the cleaned lane is real enough to rule out stale-path theatre
2. the only candidate signal reduces to one semantic family
3. no downstream property, handoff, or lane route reopens honestly
4. the remaining hidden-fallback uncertainty is mechanism-only and does not
   surface as behavior on this contract

Packet:

- `artifacts/phase_01_2_3_4_1_1_falsifier_20260405T211759Z/`
