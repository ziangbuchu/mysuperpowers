# Copilot (VS Code) Tool Mapping

Skills use Claude Code tool names. In GitHub Copilot (VS Code Agent mode), map them like this:

| Skill references          | Copilot equivalent                              |
|---------------------------|-------------------------------------------------|
| `Skill`                   | Skills load via `.github/skills/`; described in system prompt |
| `TodoWrite`               | Use markdown task lists in the conversation     |
| `Task`                    | No subagent dispatch; handle inline             |
| `Read`                    | `read_file`                                     |
| `Write`                   | `create_file`                                   |
| `Edit`                    | `replace_string_in_file`                        |
| `Bash`                    | `run_in_terminal`                               |
| `WebSearch`, `WebFetch`   | `fetch_webpage` (if available); otherwise ask the user |
| `LS`                      | `list_dir`                                      |
| `Grep`                    | `grep_search`                                   |

## Workflow Notes

- Workflow state lives in `.superpowers/workflows/` in the current project root.
- Use `run_in_terminal` with `git rev-parse --show-toplevel` to resolve the project root.
- Use `read_file` on `.superpowers/workflows/ACTIVE` to check for an active workflow.
- Natural-language prompts that still work in Copilot:
  - `continue current workflow`
  - `workflow status`
  - `workflow summary`
- Slash prompt equivalents (from `.github/prompts/`):
  - `/continue-workflow`, `/workflow-status`, `/workflow-summary`
  - `/design-experiment`, `/plan-experiment`, `/run-experiment`
  - `/debug-training`, `/analyze-results`, `/close-experiment`
  - `/reproduce-paper`, `/check-reproducibility`, `/experiment-reviewer`
- When `workflow summary` finds a keep-ready workflow with enough Git metadata,
  it may continue into branch selection, commit drafting, and explicit confirmation.
- Use native file and shell tools to inspect workflow state; do not rely on chat
  memory when the state files already exist.
