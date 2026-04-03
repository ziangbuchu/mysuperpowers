---
mode: agent
description: Summarize the current Superpowers workflow and optionally commit
---

Tell your human partner you are summarizing the active Superpowers workflow in the current project.

Load the `superpowers:using-superpowers` skill for the full workflow protocol. Then inspect `.superpowers/workflows/ACTIVE`, the matching `workflow.json`, stage summaries, and any formal artifacts, and:

- produce a compact cumulative summary before taking any Git action
- refresh `final-summary.md` if the workflow is closing or closed
- reuse saved visual evidence from `workflow.json.artifacts.result_figures` when available
- if saved figures exist, cite their paths and briefly explain what each figure supports
- if no saved figures exist, say that the summary has no recorded visual evidence
- determine whether the workflow is `git_ready` according to the shared protocol
- if it is not `git_ready`, surface the blocker and stop after the summary
- if it is `git_ready`, continue in the same flow by:
  - inspecting the current branch and working tree
  - offering the protocol-defined branch choices for non-`main`, clean `main`, or dirty `main`
  - drafting a detailed Conventional Commit message with `背景`, `变更`, `验证`, and `证据`
  - staging only the intended experiment changes
  - asking for explicit confirmation before creating the commit
