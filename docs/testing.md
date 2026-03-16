# Testing

This repository keeps lightweight tests around skill discovery and trigger coverage.

## Main Test Suites

- `tests/skill-triggering/` checks whether natural prompts trigger the intended research skills.
- `tests/claude-code/` checks that Claude can describe the key skill expectations.
- `tests/opencode/` checks plugin loading and basic OpenCode skill-tool behavior.

## Typical Commands

```bash
./tests/skill-triggering/run-all.sh
./tests/claude-code/run-skill-tests.sh
./tests/opencode/run-tests.sh
```
