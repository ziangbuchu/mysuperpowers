---
name: scientific-visualization
description: Use when experiment summaries need figures, ablation results need visual comparison, or result-analysis should turn runs and metrics into publication-style visual evidence
---

# Scientific Visualization

Turn structured experiment evidence into clear, conservative figures.

This skill is for result interpretation, not decoration. Use it when text alone is too hard to scan and the evidence supports a plot.

## When To Use

- `result-analysis` has baseline, ablation, seed, or cost numbers that should become figures
- `workflow summary` should reuse existing figures instead of only restating metrics
- an experiment note needs a compact visual comparison of runs
- a user explicitly asks for charts, plots, figures, or a more visual explanation of results

## When Not To Use

- there is no structured evidence to plot yet
- the request is for conceptual diagrams or AI-generated schematics
- a decorative chart would hide uncertainty or overstate a claim

## Workflow Integration

When used inside the research workflow:

1. Read `../_shared/workflow-protocol.md`.
2. Reuse `workflow.json`, result notes, and saved comparison context instead of rebuilding figures from memory.
3. Write figures under `docs/experiments/results/assets/<workflow_id>/`.
4. Export static artifacts as both `png` and `pdf` by default.
5. Record each figure in `workflow.json.artifacts.result_figures` with:
   - `path`
   - `kind`
   - `caption`
   - `source`
6. If figures already exist and no new evidence was added, reuse them in `workflow summary` or `experiment-closeout` instead of regenerating them.

## Figure Priority

Default to 1 to 3 figures, in this order:

1. Baseline vs ablation comparison
   - Prefer mean + error bar when multiple seeds exist.
   - If only one run exists, use a point or point-line comparison and state the single-seed limitation.
2. Curve or cost view
   - Add training or validation curves when convergence or stability matters.
   - Add metric-vs-cost, wall-clock, or memory comparison when the conclusion depends on efficiency tradeoffs.
3. Matrix view
   - Use heatmaps only when the evidence is naturally matrix-shaped.

## Output Rules

- Prefer `matplotlib` and static outputs.
- Use colorblind-safe palettes and keep grayscale readability.
- Every figure needs a one-line caption plus a one- or two-line statement of what it supports.
- Do not plot cherry-picked runs against averaged baselines.
- If no honest plot is possible, say so plainly and keep the analysis textual.

## Resources

- Plot defaults: `scripts/style_presets.py`
- Export helpers: `scripts/figure_export.py`
- Palette helpers: `assets/color_palettes.py`
- Plot selection guidance: `references/result-figure-patterns.md`
- Export and accessibility checklist: `references/publication-guidelines.md`
- Journal width and DPI defaults: `references/journal-requirements.md`
