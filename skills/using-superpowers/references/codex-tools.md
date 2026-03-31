# Codex Tool Mapping

Skills use Claude Code tool names. In Codex, map them like this:

| Skill references | Codex equivalent |
|-----------------|------------------|
| `Skill` | Skills load natively in session startup rules |
| `TodoWrite` | `update_plan` |
| `Task` | Use subagents only if your Codex setup supports collab |
| `Read`, `Write`, `Edit` | Native file tools |
| `Bash` | Native shell tool |
| `WebSearch`, `WebFetch` | Native web tools |

Use subagents for independent experiment support work only when the platform can isolate context cleanly.

## Workflow Notes

- Superpowers workflow state lives in the current project under `.superpowers/workflows/`.
- For continuation and summary flows, prefer natural-language prompts such as:
  - `continue current workflow`
  - `workflow status`
  - `workflow summary`
- When `workflow summary` finds a keep-ready workflow with enough Git metadata, it may continue into branch selection, commit drafting, and explicit commit confirmation in the same flow.
- Use native file and shell tools to inspect workflow state; do not rely on chat memory when the state files already exist.
