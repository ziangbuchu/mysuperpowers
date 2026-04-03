# Release Notes

## 6.2.0

Added GitHub Copilot (VS Code) support alongside existing Claude Code and Codex platforms.

### Added

- `.github/copilot-instructions.md` — session bootstrap replacing Claude's `SessionStart` hook
- `.github/prompts/*.prompt.md` — 12 slash prompts mirroring `commands/` for Copilot Agent Chat
- `.github/skills` symlink for Copilot skill auto-discovery
- `.github/INSTALL.copilot.md` — installation guide for Copilot
- `scripts/setup-copilot.sh` — one-command setup for research projects
- `skills/using-superpowers/references/copilot-tools.md` — tool name mapping for VS Code
- `docs/README.copilot.md` — usage guide for Copilot

### Changed

- `skills/using-superpowers/SKILL.md` — Platform Adaptation section now includes Copilot
- `README.md` — core changes section now mentions Copilot support

## 6.1.0

Workflow-oriented release focused on cross-skill handoff and active workflow continuation.

### Added

- shared workflow protocol, templates, and state example under `skills/_shared/`
- project-local workflow state directories under `docs/experiments/`
- workflow-aware Claude commands for continue, status, summary, planning, debugging, reproducibility, and paper reproduction
- hook guidance for active workflow continuation
- workflow contract and hook tests

### Changed

- `using-superpowers` now acts as a workflow router, not just a skill-first reminder
- all core research skills now define workflow entry and exit contracts
- Codex docs now document `continue current workflow`, `workflow status`, and `workflow summary`

## 6.0.0

This repository was reset from a generic software engineering workflow into a deep learning research workflow.

### Removed

- software-engineering planning and implementation skills
- old code-review and worktree workflow assets
- old design-first companion flow
- software-engineering specific tests and docs

### Added

- `experiment-design`
- `experiment-planning`
- `experiment-execution`
- `training-debugging`
- `result-analysis`
- `reproducibility-check`
- `paper-to-implementation`
- research-oriented docs and trigger tests
