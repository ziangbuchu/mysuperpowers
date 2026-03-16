#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: experiment-design skill ==="

output=$(run_claude "What does the experiment-design skill do? Keep it brief." 60)
assert_contains "$output" "experiment-design\|Experiment Design" "Skill is recognized"
assert_contains "$output" "hypothesis\|假设" "Mentions hypothesis"
assert_contains "$output" "baseline\|基线" "Mentions baseline"
assert_contains "$output" "metric\|指标\|compute budget\|预算" "Mentions success criteria"

echo "=== experiment-design tests passed ==="
