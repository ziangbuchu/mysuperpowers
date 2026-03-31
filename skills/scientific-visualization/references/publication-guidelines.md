# Publication And Accessibility Checklist

## Export Defaults

- Use vector output for plots when possible.
- Export `png` and `pdf` by default for workflow artifacts.
- Use at least 300 DPI for raster exports.
- Increase to 600 to 1000 DPI only when journal or figure type needs it.

## Text And Layout

- Prefer sans-serif fonts such as Arial or Helvetica.
- Keep axis labels readable at final size.
- Use sentence case and include units.
- Remove chart junk such as 3D effects, gradients, heavy grids, and shadows.

## Accessibility

- Use colorblind-safe palettes.
- Make the figure interpretable in grayscale.
- Add redundant encodings when color alone is fragile: marker, line style, hatch, annotation.

## Statistical Honesty

- State what uncertainty is shown: SD, SEM, or CI.
- Show sample size in the figure or caption when relevant.
- Do not compare cherry-picked best runs against averaged baselines.
- Do not hide confounders such as changed budget or changed selection rule.
