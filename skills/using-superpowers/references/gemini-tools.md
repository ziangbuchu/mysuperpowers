# Gemini CLI Tool Mapping

Skills use Claude Code tool names. In Gemini CLI, map them like this:

| Skill references | Gemini CLI equivalent |
|-----------------|----------------------|
| `Read` | `read_file` |
| `Write` | `write_file` |
| `Edit` | `replace` |
| `Bash` | `run_shell_command` |
| `TodoWrite` | `write_todos` |
| `Skill` | `activate_skill` |
| `WebSearch` | `google_web_search` |
| `WebFetch` | `web_fetch` |

Gemini CLI has no true subagent equivalent. Execute experiment workflows in one session unless your environment provides a safe parallel mechanism.
