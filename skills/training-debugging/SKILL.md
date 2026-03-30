---
name: training-debugging
description: Use when training diverges, produces NaNs, stalls, runs out of memory, shows inconsistent metrics, or otherwise behaves unexpectedly
---

# Training Debugging

Treat model failures like research incidents: isolate, measure, and prove the root cause before changing multiple things.

## Workflow Integration

Before stage-specific debugging:

1. Read `../_shared/workflow-protocol.md`.
2. Resolve or create the active workflow in the current project root.
3. Read `workflow.json`, prior run records, stage summaries, and any existing debug artifacts.
4. Prefer saved run metadata over asking the user to restate commands, configs, or failure symptoms.

This stage writes:

- `.superpowers/workflows/<workflow_id>/stages/training-debugging.md`
- updated `workflow.json`

## First Pass

Reduce the problem:

- one machine if possible
- one seed
- smallest reproducible config
- shortest run that still shows the failure

## Failure Buckets

Classify the issue before fixing it:

1. data or labels
2. model forward path
3. loss or normalization
4. backward or optimizer
5. distributed/runtime/memory
6. evaluation/reporting

Read `references/failure-patterns.md` when you need concrete probes.

## Workflow

1. Reproduce the failure reliably.
2. Add instrumentation at the boundary most likely to be wrong.
3. Compare a good run and bad run at the earliest point they differ.
4. Change one variable at a time.
5. Fix the root cause.
6. Re-run the failing case and the baseline case.
7. Update `workflow.json` with `failure_signature`, `minimal_repro`, `probe_points`, `root_cause`, `fix_or_next_probe`, and `verification_runs`.
8. Write the stage summary using `../_shared/stage-summary-template.md`.
9. Set `next_stage=experiment-execution` if more reruns are needed, otherwise `next_stage=reproducibility-check`.
10. Use `reproducibility-check` before saying the issue is fixed.

## Exit State

- `current_stage=training-debugging`
- `status=active` or `awaiting_input` when key evidence is missing
- include the exact continue phrase `continue current workflow`

## Red Flags

- Raising gradient clip, epsilon, or warmup without evidence
- Changing model and data pipeline in the same debugging pass
- Looking only at final metrics instead of the first broken signal
- Calling an issue fixed after one lucky rerun
