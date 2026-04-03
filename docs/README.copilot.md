# Superpowers DL for Copilot (VS Code)

Guide for using the workflow-oriented deep learning research fork of Superpowers with GitHub Copilot in VS Code.

## Quick Install

```bash
# Clone to a stable location
git clone https://github.com/ziangbuchu/mysuperpowers.git ~/.copilot/superpowers

# Set up in your research project
bash ~/.copilot/superpowers/scripts/setup-copilot.sh /path/to/your/project
```

Restart VS Code after setup.

For step-by-step details, see [.github/INSTALL.copilot.md](../.github/INSTALL.copilot.md).

## How It Works

Copilot discovers skills from `.github/skills/` in each workspace. The setup script
creates symlinks pointing to the Superpowers skills:

```text
<project>/.github/skills/superpowers-experiment-design/ -> ~/.copilot/superpowers/skills/experiment-design/
<project>/.github/skills/superpowers-shared/            -> ~/.copilot/superpowers/skills/_shared/
...
```

The setup script also appends a session bootstrap block to
`.github/copilot-instructions.md` so Copilot checks for an active workflow
at the start of every conversation.

## Recommended Prompts

### Start from the right stage

```text
请为这个问题选择合适的 superpowers skill，并从最早的有效阶段开始。
```

Or in English:

```text
Please choose the right superpowers skill for this problem and start from the earliest valid stage.
```

### Continue a previous workflow

```text
continue current workflow
```

Or use the slash prompt: `/continue-workflow`

### Inspect the current workflow

```text
workflow status
workflow summary
```

Or `/workflow-status` and `/workflow-summary`.

When a workflow summary concludes that code should be kept and the workflow has
enough Git metadata, the flow continues into branch selection, commit drafting,
and explicit confirmation.

### Jump directly to a stage

Use the slash prompts:

```text
/design-experiment
/plan-experiment
/run-experiment
/debug-training
/analyze-results
/close-experiment
/reproduce-paper
/check-reproducibility
/experiment-reviewer
```

## Workflow State

Workflow state is stored in the current project, not in the Superpowers repository:

```text
.superpowers/workflows/ACTIVE
.superpowers/workflows/<workflow_id>/workflow.json
.superpowers/workflows/<workflow_id>/stages/<stage>.md
.superpowers/workflows/<workflow_id>/final-summary.md
```

Human-readable experiment docs:

```text
docs/experiments/specs/
docs/experiments/plans/
docs/experiments/results/
docs/experiments/results/assets/
```

## Differences from Claude Code / Codex

| Feature               | Claude Code              | Codex                        | Copilot (VS Code)               |
|-----------------------|--------------------------|------------------------------|---------------------------------|
| Skills discovery      | Plugin system            | `~/.agents/skills/` symlink  | `.github/skills/` per project   |
| Session bootstrap     | `SessionStart` hook      | Skill auto-load at startup   | `copilot-instructions.md`       |
| Slash commands        | `commands/*.md`          | Natural language shortcuts   | `.github/prompts/*.prompt.md`   |
| Tool names            | Claude Code native       | See `codex-tools.md`         | See `copilot-tools.md`          |

## Common Issues

### Skills not appearing in Copilot Chat

1. Verify symlinks exist: `ls -la .github/skills/superpowers-*`
2. Reload VS Code window (Ctrl+Shift+P → "Developer: Reload Window")
3. Ensure you are using Agent mode in Copilot Chat

### Workflow state not detected

1. Make sure you are in the project root where `.superpowers/workflows/ACTIVE` exists
2. Try: `workflow status` — this triggers the skill to check explicitly

## Updating

```bash
cd ~/.copilot/superpowers && git pull
```

Skills update instantly through the symlinks.
