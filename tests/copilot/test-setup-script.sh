#!/usr/bin/env bash
# Test that scripts/setup-copilot.sh correctly sets up a target project
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET="$(mktemp -d)"
trap 'rm -rf "$TARGET"' EXIT

echo "=== Test: setup-copilot.sh ==="

bash "$REPO_ROOT/scripts/setup-copilot.sh" "$TARGET" > /dev/null

pass=0
fail=0

check() {
    local desc="$1"
    shift
    if "$@" 2>/dev/null; then
        pass=$((pass + 1))
    else
        echo "[FAIL] $desc"
        fail=$((fail + 1))
    fi
}

# Skills symlinks created
for skill in experiment-design experiment-planning experiment-execution \
             training-debugging result-analysis experiment-closeout \
             paper-to-implementation reproducibility-check \
             scientific-visualization using-superpowers; do
    check "symlink superpowers-$skill" [ -L "$TARGET/.github/skills/superpowers-$skill" ]
    check "SKILL.md via superpowers-$skill" [ -f "$TARGET/.github/skills/superpowers-$skill/SKILL.md" ]
done

# _shared symlink
check "symlink superpowers-shared" [ -L "$TARGET/.github/skills/superpowers-shared" ]
check "workflow-protocol via shared" [ -f "$TARGET/.github/skills/superpowers-shared/workflow-protocol.md" ]

# Prompt symlinks
for prompt in continue-workflow workflow-status workflow-summary design-experiment \
              plan-experiment run-experiment debug-training analyze-results \
              close-experiment reproduce-paper check-reproducibility experiment-reviewer; do
    check "prompt symlink $prompt" [ -L "$TARGET/.github/prompts/$prompt.prompt.md" ]
done

# copilot-instructions.md bootstrap block
check "instructions file created" [ -f "$TARGET/.github/copilot-instructions.md" ]
check "bootstrap marker present" grep -q "superpowers-copilot-bootstrap" "$TARGET/.github/copilot-instructions.md"
check "using-superpowers reference" grep -q "using-superpowers" "$TARGET/.github/copilot-instructions.md"

# Idempotency: running again should not duplicate
bash "$REPO_ROOT/scripts/setup-copilot.sh" "$TARGET" > /dev/null
count=$(grep -c "^<!-- superpowers-copilot-bootstrap -->" "$TARGET/.github/copilot-instructions.md")
check "idempotent (bootstrap block not duplicated)" [ "$count" -eq 1 ]

echo ""
echo "=== Results: $pass passed, $fail failed ==="

if [ "$fail" -gt 0 ]; then
    exit 1
fi

echo "=== setup-copilot.sh tests passed ==="
