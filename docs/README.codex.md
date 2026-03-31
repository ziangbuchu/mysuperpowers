# Superpowers DL for Codex

Guide for using the workflow-oriented deep learning research fork of Superpowers with OpenAI Codex.

Chinese usage tutorial: [README.codex.zh-CN.md](README.codex.zh-CN.md)

## Quick Install

Tell Codex:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/ziangbuchu/mysuperpowers/refs/heads/main/.codex/INSTALL.md
```

## Manual Installation

### Prerequisites

- OpenAI Codex CLI
- Git

### Steps

1. Clone the repo:

   ```bash
   git clone https://github.com/ziangbuchu/mysuperpowers.git ~/.codex/superpowers
   ```

2. Create the skills symlink:

   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/superpowers/skills ~/.agents/skills/superpowers
   ```

3. Restart Codex.

## How It Works

Codex scans `~/.agents/skills/` at startup. Superpowers exposes its skills through one symlink:

```text
~/.agents/skills/superpowers/ -> ~/.codex/superpowers/skills/
```

The `using-superpowers` skill now works as a workflow router. It can:

- choose the earliest valid research stage
- continue the active workflow in the current project
- show workflow status
- summarize the current workflow
- hand off a keep-ready workflow summary into branch selection and commit drafting

Workflow state is stored in the active project under:

```text
.superpowers/workflows/
```

Formal experiment docs are stored under:

```text
docs/experiments/specs/
docs/experiments/plans/
docs/experiments/results/
docs/experiments/results/assets/
```

## Recommended Prompts

### Start from the right stage

```text
Please choose the right superpowers skill for this problem and start from the earliest valid stage.
```

### Continue a previous workflow

```text
continue current workflow
```

### Inspect the current workflow

```text
workflow status
workflow summary
```

When a workflow summary concludes that code should be kept and the workflow has enough Git metadata, the same flow may continue into branch choice, detailed commit drafting, and explicit commit confirmation.

If `result-analysis` saved figures, `workflow summary` should reuse those paths and explain what the visuals support before moving into any branch choice.

### Jump directly to a stage

```text
use experiment-design
use training-debugging
use result-analysis
```

## What Changes Between Stages

You should no longer need to paste the same context into every stage. The workflow protocol saves:

- machine-readable workflow state in `workflow.json`
- per-stage handoff summaries under `stages/`
- final workflow summary in `final-summary.md`

The protocol is defined in [../skills/_shared/workflow-protocol.md](../skills/_shared/workflow-protocol.md).

## Updating

```bash
cd ~/.codex/superpowers && git pull
```

Restart Codex after updating skills.

## Troubleshooting

### Skills not showing up

1. Verify the symlink: `ls -la ~/.agents/skills/superpowers`
2. Check skills exist: `find ~/.codex/superpowers/skills -name SKILL.md`
3. Restart Codex

### Workflow does not continue

1. Confirm the active project contains `.superpowers/workflows/ACTIVE`
2. Confirm the matching `workflow.json` exists
3. Ask `workflow status` before asking to continue
4. If `workflow summary` does not offer Git handoff, check whether the workflow is still awaiting input, approval, or missing execution start-state metadata
