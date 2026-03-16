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
