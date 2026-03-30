# Workflow Protocol

This repository uses project-local workflow state so skills can be used one at a time or as part of a multi-stage research workflow without manual context copy-paste.

## Project Root

Before reading or writing workflow state:

1. Resolve the project root with `git rev-parse --show-toplevel`.
2. If that fails, use the current working directory.
3. Never write workflow state into the Superpowers skills repository unless it is also the active project.

## State Paths

All workflow state lives under:

- `.superpowers/workflows/ACTIVE`
- `.superpowers/workflows/<workflow_id>/workflow.json`
- `.superpowers/workflows/<workflow_id>/stages/<stage>.md`
- `.superpowers/workflows/<workflow_id>/final-summary.md`

Human-readable experiment outputs still belong in:

- `docs/experiments/specs/`
- `docs/experiments/plans/`
- `docs/experiments/results/`

Create these directories on first use if they do not exist.

## Workflow Identity

- One workflow solves one problem.
- Reuse the active workflow only when the user is continuing the same problem.
- If the user starts a meaningfully different problem, mark the old workflow `paused` and create a new workflow.
- Use `YYYY-MM-DD-<topic-slug>` for `workflow_id`.

## Workflow State

Use `workflow.json` as the canonical machine-readable state. Keep keys stable.

Read `workflow-state-example.json` for the preferred shape.

Minimum required keys:

- `id`
- `topic`
- `project_root`
- `status`
- `entry_stage`
- `current_stage`
- `next_stage`
- `problem_summary`
- `stage_status`
- `docs`
- `decisions`
- `open_questions`
- `evidence`
- `artifacts`
- `pending`

Allowed `status` values:

- `active`
- `awaiting_input`
- `awaiting_approval`
- `paused`
- `closed`
- `done`

Allowed per-stage `stage_status` values:

- `not_started`
- `in_progress`
- `done`
- `skipped`
- `external`

## Entry Contract

Every workflow-aware skill must do this before stage-specific work:

1. Resolve the project root.
2. Check `.superpowers/workflows/ACTIVE`.
3. If the user explicitly named a workflow, use that.
4. If the user asked to continue, status, or summarize, prefer the active workflow.
5. If no workflow exists, create one before doing stage work.
6. Read the existing `workflow.json` plus any relevant docs referenced under `docs`.
7. Ask only for information that cannot be recovered from the project or workflow state.

## Exit Contract

Every workflow-aware skill must do this before ending the turn:

1. Update `workflow.json`.
2. Write or refresh `stages/<stage>.md` using `stage-summary-template.md`.
3. Write any formal stage artifact under `docs/experiments/...` when the stage requires it.
4. Set `current_stage`, `next_stage`, `status`, `open_questions`, and `pending` explicitly.
5. End with a short handoff that includes:
   - `workflow_id`
   - current stage
   - artifact paths
   - recommended next stage
   - the exact phrase `continue current workflow`

## Continue, Status, Summary

When the user asks to continue:

- If `status=awaiting_approval`, surface the pending approval instead of advancing.
- If `status=awaiting_input`, surface the missing input or evidence instead of advancing.
- If `next_stage` exists, continue with that stage.
- If there is no active workflow, say so plainly and ask for the problem to solve.

When the user asks for workflow status:

- Report `workflow_id`, `status`, `current_stage`, `next_stage`, pending approvals, and key artifact paths.

When the user asks for a workflow summary:

- Read `workflow.json`, existing stage summaries, and any formal docs.
- Produce a compact cumulative summary.
- If the workflow is closing or closed, refresh `final-summary.md`.

## Canonical Stage Order

Use this order unless the user intentionally enters a later stage:

1. `paper-to-implementation`
2. `experiment-design`
3. `experiment-planning`
4. `experiment-execution`
5. `training-debugging`
6. `result-analysis`
7. `experiment-closeout`
8. `reproducibility-check`

Notes:

- `training-debugging` may loop back to `experiment-execution`.
- `experiment-design` must stop for approval before `experiment-planning`.
- `experiment-closeout` is the hard close of the experiment loop.
- `reproducibility-check` gates any external performance claim.

## Stage Requirements

Each stage must write these stage-specific facts into `workflow.json`:

- `paper-to-implementation`: `core_intervention`, `hidden_assumptions`, `local_mapping`, `minimal_reproduction`, `ablation_ladder`
- `experiment-design`: `hypothesis`, `baseline`, `metric`, `dataset_split`, `budget`, `first_falsifier`, `approval_required`
- `experiment-planning`: `change_set`, `sanity_checks`, `run_matrix`, `artifact_requirements`, `stop_conditions`
- `experiment-execution`: `start_state`, `touched_files`, `sanity_results`, `runs`, `observed_outcome`
- `training-debugging`: `failure_signature`, `minimal_repro`, `probe_points`, `root_cause`, `fix_or_next_probe`, `verification_runs`
- `result-analysis`: `comparison_table`, `confounders`, `decision`, `recommended_next_step`
- `experiment-closeout`: `retention_decision`, `workspace_state`, `result_note_path`, `final_summary_seed`
- `reproducibility-check`: `claim_status`, `missing_evidence`, `what_changed`, `what_stayed_fixed`, `supporting_runs`

## Reply Footer

End every workflow-aware stage response with this exact structure:

```text
workflow_id: <id>
current_stage: <stage>
artifacts:
- <path>
next_stage: <stage or none>
continue_with: continue current workflow
```

## Guardrails

- Do not rely on chat memory when workflow files can carry the context.
- Do not silently skip the workflow writeback.
- Do not start a new workflow when the user is clearly continuing the current one.
- Do not advance past `experiment-design` approval without explicit user approval.
- Do not declare success after `experiment-closeout` unless `reproducibility-check` passes.
