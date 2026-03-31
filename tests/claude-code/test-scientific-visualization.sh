#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: scientific-visualization skill ==="

output=$(run_claude "In the scientific-visualization skill, what should the agent do when result-analysis has structured metrics and seed results? Keep it brief." 60)
assert_contains "$output" "figure\\|plot\\|chart\\|图" "Mentions generating visual evidence"
assert_contains "$output" "png\\|pdf\\|assets" "Mentions saved figure artifacts"
assert_contains "$output" "result-analysis\\|workflow summary\\|workflow.json" "Mentions workflow integration"

echo "=== scientific-visualization tests passed ==="
