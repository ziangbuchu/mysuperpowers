#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

WORKFLOW_ID="2026-03-30-test-workflow"
STATE_DIR="$TEST_DIR/.superpowers/workflows/$WORKFLOW_ID"
mkdir -p "$STATE_DIR"

cat > "$TEST_DIR/.superpowers/workflows/ACTIVE" <<EOF
$WORKFLOW_ID
EOF

cat > "$STATE_DIR/workflow.json" <<'EOF'
{
  "id": "2026-03-30-test-workflow",
  "status": "active",
  "current_stage": "experiment-planning",
  "next_stage": "experiment-execution",
  "problem_summary": "Test the session-start hook workflow guidance."
}
EOF

output=$(
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    CLAUDE_PROJECT_DIR="$TEST_DIR" \
    bash "$REPO_ROOT/hooks/session-start"
)

echo "=== Test: session-start hook ==="

echo "$output" | grep -q '"hookEventName": "SessionStart"'
echo "$output" | grep -q 'Active workflow detected'
echo "$output" | grep -q '2026-03-30-test-workflow'
echo "$output" | grep -q 'experiment-planning'
echo "$output" | grep -q 'experiment-execution'
echo "$output" | grep -q 'continue current workflow'

echo "=== session-start hook tests passed ==="
