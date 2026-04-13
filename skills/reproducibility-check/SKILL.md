---
name: reproducibility-check
description: Use before claiming an experiment improved results, before sharing numbers, or when another person needs to rerun or trust the outcome
---

# Reproducibility Check

No performance claim without attached evidence.

## Workflow Integration

Before stage-specific checking:

1. Read `../_shared/workflow-protocol.md`.
2. Resolve or create the active workflow in the current project root.
3. Read `workflow.json`, prior stage summaries, result notes, and run evidence.
4. Reuse saved evidence paths and comparison context before asking for more.

This stage writes:

- `.superpowers/workflows/<workflow_id>/stages/reproducibility-check.md`
- `.superpowers/workflows/<workflow_id>/final-summary.md`
- updated `workflow.json`

## Claim Gate

Before saying "this is better" or "the bug is fixed", verify:

1. exact command or launcher entrypoint
2. config path or config diff
3. seed or seed set
4. commit hash
5. dataset version or split
6. checkpoint or artifact path
7. metric table that supports the claim

Read `references/evidence-checklist.md` when you need the full checklist.

## Rules

- Single-run improvements are provisional unless the user explicitly accepts single-run evidence.
- If the comparison is not apples-to-apples, say so plainly.
- If you cannot reproduce the exact setup, do not present the number as established.
- Include uncertainty, not just the best score.
- Update `workflow.json` with `claim_status`, `missing_evidence`, `what_changed`, `what_stayed_fixed`, and `supporting_runs`.
- Write the stage summary using `../_shared/stage-summary-template.md`.
- Refresh `final-summary.md` when this stage closes the workflow.

## Minimum Reporting Standard

State:

- what changed
- what stayed fixed
- what metric moved
- how many runs or seeds support it
- what still needs confirmation

## Exit State

- `current_stage=reproducibility-check`
- `next_stage=none`
- `status=done` when claim evidence is sufficient, otherwise `status=awaiting_input`; when evidence is missing, ask only for the exact missing artifact or metadata, and in Codex use `ask_user`
- include the exact continue phrase `continue current workflow`
