# Testing

This repository keeps lightweight tests around skill discovery and Claude Code integration.

## Main Test Suites

- `tests/skill-triggering/` checks whether natural prompts trigger the intended research skills.
- `tests/claude-code/` checks that Claude can describe the key skill expectations.

## Typical Commands

```bash
./tests/skill-triggering/run-all.sh
./tests/claude-code/run-skill-tests.sh
```

Codex uses native skill discovery. This repository does not currently keep a dedicated Codex smoke-test harness.
