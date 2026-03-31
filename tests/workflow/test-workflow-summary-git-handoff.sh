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

echo "=== Test: workflow summary git handoff ==="

require_contains "skills/_shared/workflow-protocol.md" "continue current branch and commit"
require_contains "skills/_shared/workflow-protocol.md" "create a new branch and commit"
require_contains "skills/_shared/workflow-protocol.md" "continue on main and commit"
require_contains "skills/_shared/workflow-protocol.md" "draft commit only"
require_contains "skills/_shared/workflow-protocol.md" 'For workflows that do not yet record `branch_policy`, ask again'
require_contains "skills/_shared/workflow-protocol.md" "Chinese subject summary"
require_contains "skills/_shared/workflow-protocol.md" '`背景`, `变更`, `验证`, `证据`'

require_contains "commands/workflow-summary.md" 'clean `main`'
require_contains "commands/workflow-summary.md" 'dirty `main`'
require_contains "commands/workflow-summary.md" "asking for explicit confirmation before creating the commit"

require_contains "skills/using-superpowers/SKILL.md" "produce the cumulative summary without advancing stages"
require_contains "skills/using-superpowers/SKILL.md" "Git handoff only when the workflow is Git-ready"

require_contains "docs/README.codex.md" "branch choice"
require_contains "docs/README.codex.zh-CN.md" "分支策略"
require_contains "docs/testing.md" "branch-aware Git handoff"

echo "=== workflow summary git handoff tests passed ==="
