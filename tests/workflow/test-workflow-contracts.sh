#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

require_file() {
    local path="$1"
    if [ ! -f "$REPO_ROOT/$path" ]; then
        echo "[FAIL] Missing file: $path"
        exit 1
    fi
}

require_contains() {
    local path="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$REPO_ROOT/$path"; then
        echo "[FAIL] $path does not contain: $pattern"
        exit 1
    fi
}

echo "=== Test: workflow contracts ==="

require_file "skills/_shared/workflow-protocol.md"
require_file "skills/_shared/stage-summary-template.md"
require_file "skills/_shared/final-summary-template.md"
require_file "skills/_shared/workflow-state-example.json"
require_file "skills/scientific-visualization/SKILL.md"
require_file "tests/workflow/test-workflow-summary-git-handoff.sh"
require_file "tests/workflow/test-codex-ask-user-contracts.sh"
require_file "docs/experiments/specs/.gitkeep"
require_file "docs/experiments/plans/.gitkeep"
require_file "docs/experiments/results/.gitkeep"
require_file "docs/experiments/results/assets/.gitkeep"

for skill in \
    skills/using-superpowers/SKILL.md \
    skills/experiment-design/SKILL.md \
    skills/experiment-planning/SKILL.md \
    skills/experiment-execution/SKILL.md \
    skills/training-debugging/SKILL.md \
    skills/result-analysis/SKILL.md \
    skills/experiment-closeout/SKILL.md \
    skills/reproducibility-check/SKILL.md \
    skills/paper-to-implementation/SKILL.md
do
    require_contains "$skill" "workflow-protocol.md"
done

for skill in \
    skills/experiment-design/SKILL.md \
    skills/experiment-planning/SKILL.md \
    skills/experiment-execution/SKILL.md \
    skills/training-debugging/SKILL.md \
    skills/result-analysis/SKILL.md \
    skills/experiment-closeout/SKILL.md \
    skills/reproducibility-check/SKILL.md \
    skills/paper-to-implementation/SKILL.md
do
    require_contains "$skill" "continue current workflow"
    require_contains "$skill" "workflow.json"
done

for command in \
    commands/continue-workflow.md \
    commands/workflow-status.md \
    commands/workflow-summary.md \
    commands/plan-experiment.md \
    commands/debug-training.md \
    commands/check-reproducibility.md \
    commands/reproduce-paper.md
do
    require_file "$command"
done

require_contains "skills/using-superpowers/SKILL.md" "workflow status"
require_contains "skills/using-superpowers/SKILL.md" "workflow summary"
require_contains "skills/_shared/workflow-protocol.md" "git_ready"
require_contains "skills/_shared/workflow-protocol.md" "result_figures"
require_contains "skills/_shared/workflow-protocol.md" "docs/experiments/results/assets"
require_contains "skills/_shared/workflow-protocol.md" "branch_strategy"
require_contains "skills/_shared/workflow-protocol.md" "commit_status"
require_contains "skills/_shared/workflow-protocol.md" "branch_policy"
require_contains "skills/_shared/workflow-protocol.md" "背景"
require_contains "skills/_shared/workflow-protocol.md" "证据"
require_contains "skills/_shared/workflow-protocol.md" "ask_user"
require_contains "skills/_shared/workflow-state-example.json" "\"git\""
require_contains "skills/_shared/workflow-state-example.json" "\"result_figures\": \\[\\]"
require_contains "skills/_shared/workflow-state-example.json" "\"commit_status\": \"not_ready\""
require_contains "skills/result-analysis/SKILL.md" "scientific-visualization"
require_contains "skills/result-analysis/SKILL.md" "docs/experiments/results/assets/<workflow_id>/"
require_contains "skills/experiment-closeout/SKILL.md" "saved figures"
require_contains "skills/experiment-execution/SKILL.md" "branch policy"
require_contains "skills/experiment-execution/SKILL.md" 'dirty `main`'
require_contains "skills/experiment-closeout/SKILL.md" "ask_user"
require_contains "commands/workflow-summary.md" "git_ready"
require_contains "commands/workflow-summary.md" "artifacts.result_figures"
require_contains "commands/workflow-summary.md" "staging only the intended experiment changes"
require_contains "skills/using-superpowers/references/codex-tools.md" "ask_user"
require_contains "hooks/session-start" "continue current workflow"
require_contains "docs/testing.md" "test-codex-ask-user-contracts"

echo "=== workflow contracts tests passed ==="
