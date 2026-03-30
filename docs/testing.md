# Testing

This repository keeps lightweight workflow-oriented tests around skill discovery, hook behavior, and workflow contracts.

## Main Test Suites

- `tests/skill-triggering/` checks whether natural prompts trigger the intended research skills.
- `tests/claude-code/` checks that Claude can describe the core workflow and skill expectations.
- `tests/hooks/` checks deterministic hook behavior such as active-workflow context injection.
- `tests/workflow/` checks static workflow contracts across skills, commands, and shared files.

## Typical Commands

```bash
./tests/skill-triggering/run-all.sh
./tests/claude-code/run-skill-tests.sh
./tests/hooks/test-session-start.sh
./tests/workflow/test-workflow-contracts.sh
```

## Codex Smoke Checks

Codex uses native skill discovery, so the main automated coverage in this repository is documentation and contract oriented.

For a manual Codex smoke check, open a project that contains a `.superpowers/workflows/` directory and try:

```text
continue current workflow
workflow status
workflow summary
```

The assistant should prefer the active workflow instead of asking you to paste the previous stage again.
