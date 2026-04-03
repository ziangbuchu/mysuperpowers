# Superpowers DL — Copilot Session Bootstrap

You have Superpowers DL workflow skills for deep learning research.
Your available skills are listed at the top of your system prompt.

## Session Bootstrap

At the start of every conversation that may involve a research task, experiment,
model change, training failure, or paper reproduction:

1. Load the `superpowers:using-superpowers` skill — it defines skill routing,
   workflow conventions, and the complete research stage order.
2. Resolve the project root: run `git rev-parse --show-toplevel`, fallback to cwd.
3. Check `<project_root>/.superpowers/workflows/ACTIVE`.
   - If it exists, read `<project_root>/.superpowers/workflows/<id>/workflow.json`.
   - Report the active workflow (id, status, current_stage, next_stage, problem)
     before your first substantive response.
   - Remind the user of the continue phrases:
     `continue current workflow` · `workflow status` · `workflow summary`
   - If ACTIVE does not exist, do not mention it unless the user asks.

This replaces the Claude Code `SessionStart` hook on this platform.

## Platform Notes

- Use `run_in_terminal` for shell commands (e.g. `git`, training scripts).
- Use `read_file` / `replace_string_in_file` for workflow state and experiment files.
- Use `vscode_askQuestions` when you need the user to choose between options.
- For tool name mapping from skill files, read `skills/using-superpowers/references/copilot-tools.md`.

## Slash Prompts

Available via `/` in Copilot Agent Chat (from `.github/prompts/`):

| Prompt                    | Action                                     |
|---------------------------|--------------------------------------------|
| `/continue-workflow`      | Continue the active workflow               |
| `/workflow-status`        | Show current workflow state                |
| `/workflow-summary`       | Summarize and optionally commit            |
| `/design-experiment`      | Enter experiment-design stage              |
| `/plan-experiment`        | Enter experiment-planning stage            |
| `/run-experiment`         | Enter experiment-execution stage           |
| `/debug-training`         | Enter training-debugging stage             |
| `/analyze-results`        | Enter result-analysis stage                |
| `/close-experiment`       | Enter experiment-closeout stage            |
| `/reproduce-paper`        | Enter paper-to-implementation stage        |
| `/check-reproducibility`  | Enter reproducibility-check stage          |
| `/experiment-reviewer`    | Launch the experiment reviewer agent       |
