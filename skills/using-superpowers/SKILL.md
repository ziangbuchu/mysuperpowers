---
name: using-superpowers
description: Use when starting any conversation - establishes skill-first discipline for deep learning research tasks such as experiment design, execution, debugging, result analysis, and reproducibility checks
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute one narrow task, skip this skill.
</SUBAGENT-STOP>

## Rule

If there is even a small chance a research skill applies, load it before responding or acting.

User instructions still win. Skills define how to work, not what the human wants.

## Workflow Protocol

Before responding, read `../_shared/workflow-protocol.md`.

Use workflow state, not chat memory, as the default handoff mechanism between stages.

## Platform Adaptation

Skills use Claude Code tool names. In Codex, read:

- `references/codex-tools.md`

## First Router Decision

Handle these workflow intents before choosing a new stage:

- `continue current workflow`
- `workflow status`
- `workflow summary`
- `resume experiment`
- `what's next`

For those requests:

1. Resolve the current project root.
2. Inspect `.superpowers/workflows/ACTIVE`.
3. If an active workflow exists, load `workflow.json`, relevant stage summaries, and any referenced docs.
4. If the workflow is waiting on approval or missing evidence, surface that instead of advancing.
5. If the workflow has a valid `next_stage`, continue with that stage.
6. If no active workflow exists, say so plainly and ask for the problem to solve.

## Reuse Or Create

- Reuse the active workflow when the user is clearly continuing the same problem.
- Create a new workflow when the user starts a different problem.
- If a different active workflow exists, mark it `paused` before switching.
- If the user names a stage directly, still attach that work to workflow state.

## Research Skill Order

Use process skills before doing work:

1. `paper-to-implementation` for a paper idea or reproduction request
2. `experiment-design` before proposing changes to model, loss, data, augmentation, training, or evaluation
3. `experiment-planning` once the hypothesis and design are approved
4. `experiment-execution` when carrying out the plan
5. `training-debugging` for NaNs, divergence, OOMs, metric mismatches, or other failures
6. `result-analysis` when runs finish and you need to compare evidence
7. `experiment-closeout` when a run has ended and you must decide whether to keep or revert the code changes
8. `reproducibility-check` before claiming an improvement or handing results to others

When choosing a stage for a new problem, start from the earliest valid stage instead of jumping ahead.

- `paper-to-implementation` for papers or reproduction requests
- `experiment-design` for proposed model, loss, data, training, or evaluation changes
- `experiment-planning` only after design approval or a fully specified external design
- `experiment-execution` only when a concrete plan already exists
- `training-debugging` only when the main problem is a failure in an existing run
- `result-analysis` only when the main problem is interpreting completed runs
- `experiment-closeout` only when the experiment has ended and code retention is the decision
- `reproducibility-check` only when the user is preparing to claim or share a result

## Red Flags

Stop and load the relevant skill if you catch yourself thinking:

- "I can just change the model and try it."
- "The metrics look better enough."
- "I'll explain the result without checking seeds/configs."
- "This failure is probably just learning rate."
- "I already know how to reproduce a paper."

## What Good Looks Like

- Hypothesis before code
- Baseline and success metric before conclusions
- Smallest falsifiable experiment first
- Explicit keep-or-revert decision after each experiment
- Evidence attached to every claim
- Negative results recorded, not hidden
- A workflow id and saved stage summary after every meaningful stage
- A clear next stage and the exact continue phrase `continue current workflow`
