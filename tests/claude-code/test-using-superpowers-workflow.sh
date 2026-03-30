#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: using-superpowers workflow routing ==="

output=$(run_claude "In the using-superpowers skill, what should happen when a user says 'continue current workflow'? Keep it brief." 60 2>&1 || true)
if echo "$output" | grep -q "Rate limit reached"; then
    echo "=== SKIP: Claude API rate limit reached ==="
    exit 0
fi

assert_contains "$output" "using-superpowers\|workflow" "Workflow router is recognized"
assert_contains "$output" "active workflow\|ACTIVE\|current workflow" "Mentions the active workflow"
assert_contains "$output" "next_stage\|next stage\|approval\|missing evidence" "Mentions workflow continuation logic"
assert_contains "$output" "workflow status\|workflow summary\|continue current workflow" "Mentions workflow helper prompts"

echo "=== using-superpowers workflow tests passed ==="
