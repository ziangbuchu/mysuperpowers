---
mode: agent
description: Continue the active Superpowers workflow in the current project
---

Tell your human partner you are resolving the active Superpowers workflow in the current project.

Load the `superpowers:using-superpowers` skill for the full workflow protocol. Then inspect `.superpowers/workflows/ACTIVE` in the project root and do exactly one of these:

- continue the recorded `next_stage`
- surface pending approval or missing evidence
- or explain that no active workflow exists yet

Then follow the relevant `superpowers:*` skill.
