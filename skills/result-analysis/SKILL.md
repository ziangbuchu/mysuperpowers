---
name: result-analysis
description: Use when experiment runs finish, baselines and ablations disagree, or you need to decide what the results actually imply
---

# Result Analysis

Interpret results conservatively. The goal is not to defend the new idea; it is to decide what the evidence supports.

## Workflow Integration

Before stage-specific analysis:

1. Read `../_shared/workflow-protocol.md`.
2. Resolve or create the active workflow in the current project root.
3. Read `workflow.json`, run records, prior stage summaries, and any existing result notes.
4. Reuse the saved comparison context instead of asking the user to restate all runs.

This stage writes:

- `docs/experiments/results/YYYY-MM-DD-<topic>.md`
- `docs/experiments/results/assets/<workflow_id>/`
- `.superpowers/workflows/<workflow_id>/stages/result-analysis.md`
- updated `workflow.json`

## Workflow

1. Gather the comparison set:
   - baseline
   - direct ablations
   - reruns with different seeds if available
2. Normalize the comparison:
   - same metric
   - same selection rule
   - same evaluation split
   - same training budget, or explicitly note differences
3. If the evidence is structured enough to plot, load `../scientific-visualization/SKILL.md` and generate 1 to 3 figures:
   - baseline vs ablation first
   - curve or cost view only when convergence, stability, or efficiency matters
   - matrix view only when the evidence is naturally matrix-shaped
4. Save figures under `docs/experiments/results/assets/<workflow_id>/` as both `png` and `pdf` by default.
5. For every saved figure, record `path`, `kind`, `caption`, and `source` in `workflow.json.artifacts.result_figures`.
6. If no honest plot is possible, say so plainly in the result note and stage summary instead of forcing a chart.
7. Explain the result in terms of effect size, variance, confounders, and what the figures do or do not support.
8. Decide one outcome:
   - keep and extend
   - rerun for confidence
   - debug before trusting
   - reject and move on
9. Write a result note to `docs/experiments/results/YYYY-MM-DD-<topic>.md`.
10. Update `workflow.json` with `comparison_table`, `confounders`, `decision`, and `recommended_next_step`.
11. Write the stage summary using `../_shared/stage-summary-template.md`.
12. Hand off to `experiment-closeout` so the user can decide whether the code changes stay or are reverted.

Use `references/result-summary-template.md` when writing the note.

## Exit State

- `current_stage=result-analysis`
- `next_stage=experiment-closeout`
- `status=active`
- include the exact continue phrase `continue current workflow`

## Guardrails

- Do not compare cherry-picked best runs to average baselines.
- Do not ignore wall-clock, memory, or parameter-count regressions.
- Do not generate decorative plots that hide uncertainty or incomparability.
- Negative results are useful if the setup is documented well.
- Failed experiments should be archived with enough detail to block accidental repetition.
