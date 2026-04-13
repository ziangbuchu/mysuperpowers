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
| Explicit user clarification or approval | `ask_user` |

Use subagents for independent experiment support work only when the platform can isolate context cleanly.

## User Interaction In Codex

When a skill says to ask the user, stop for approval, or request missing evidence, use `ask_user` in Codex instead of hiding the question inside a normal prose reply.

Use `ask_user` for blocking workflow decisions such as:

- design approval before `experiment-planning`
- missing evidence when the workflow is `awaiting_input`
- branch-policy choice on `main` or when `branch_policy` is missing
- keep or discard decisions in `experiment-closeout`
- final commit confirmation in `workflow summary`

Keep each `ask_user` call narrow:

- one blocking decision or one missing evidence request at a time
- offer concrete choices when the choice set is already known
- wait for the answer before advancing the workflow

## Workflow Notes

- Superpowers workflow state lives in the current project under `.superpowers/workflows/`.
- For continuation and summary flows, prefer natural-language prompts such as:
  - `continue current workflow`
  - `workflow status`
  - `workflow summary`
- When `workflow summary` finds a keep-ready workflow with enough Git metadata, it may continue into branch selection, commit drafting, and explicit commit confirmation in the same flow. In Codex, use `ask_user` for the branch choice and commit confirmation steps.
- Use native file and shell tools to inspect workflow state; do not rely on chat memory when the state files already exist.
