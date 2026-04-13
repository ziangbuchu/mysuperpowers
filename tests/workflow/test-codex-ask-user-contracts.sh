#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

require_contains() {
    local path="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$REPO_ROOT/$path"; then
        echo "[FAIL] $path does not contain: $pattern"
        exit 1
    fi
}

echo "=== Test: Codex ask_user contracts ==="

require_contains "skills/using-superpowers/references/codex-tools.md" '`ask_user`'
require_contains "skills/_shared/workflow-protocol.md" '`ask_user`'
require_contains "skills/using-superpowers/SKILL.md" '`ask_user`'
require_contains "skills/experiment-design/SKILL.md" '`ask_user`'
require_contains "skills/experiment-planning/SKILL.md" '`ask_user`'
require_contains "skills/experiment-execution/SKILL.md" '`ask_user`'
require_contains "skills/training-debugging/SKILL.md" '`ask_user`'
require_contains "skills/experiment-closeout/SKILL.md" '`ask_user`'
require_contains "skills/reproducibility-check/SKILL.md" '`ask_user`'
require_contains "commands/continue-workflow.md" '`ask_user`'
require_contains "commands/workflow-summary.md" '`ask_user`'
require_contains "docs/README.codex.md" '`ask_user`'
require_contains "docs/README.codex.zh-CN.md" '`ask_user`'
require_contains "README.md" '`ask_user`'

echo "=== Codex ask_user contract tests passed ==="
