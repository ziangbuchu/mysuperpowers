# Result Figure Patterns

Use only the smallest set of figures that materially improves interpretation.

## Comparison Figure

Use for baseline vs ablation or multiple variants.

- Multiple seeds: mean + error bar, or scatter + mean marker.
- Single seed: point or point-line comparison with explicit single-run warning.
- Include the exact metric name and evaluation split.
- If selection rules differ, state that in the caption and analysis.

## Curve Figure

Use when the conclusion depends on training dynamics.

- Good fits: training loss, validation metric over epochs, instability, divergence, delayed convergence.
- Prefer one panel per metric family instead of cramming unrelated curves together.
- If smoothing is used, say so.

## Cost Figure

Use when the better metric costs more.

- Good fits: wall-clock, memory, parameter count, FLOPs, throughput.
- Prefer metric-vs-cost scatter or side-by-side bar chart.
- Highlight when the best score is not the best tradeoff.

## Matrix Figure

Use only when the evidence is inherently matrix-shaped.

- Good fits: confusion matrices, per-class deltas, correlation maps.
- Use perceptually uniform colormaps for magnitude.
- Use diverging maps only when a central zero or baseline matters.

## Caption Checklist

Each figure should state:

- what data it summarizes
- the metric and split
- whether bars show SD, SEM, or CI
- whether the plot is single-seed
- any non-matching selection rule or budget caveat

## Refusal Rule

If the available evidence is only anecdotal or not comparable, do not force a plot. Keep the analysis textual and say why visual evidence is not yet trustworthy.
