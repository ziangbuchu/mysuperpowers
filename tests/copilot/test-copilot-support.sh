#!/usr/bin/env bash
# Test that all Copilot support files exist and contain required references
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

pass=0
fail=0

require_file() {
    local path="$1"
    if [ -f "$REPO_ROOT/$path" ] || [ -L "$REPO_ROOT/$path" ]; then
        pass=$((pass + 1))
    else
        echo "[FAIL] Missing file: $path"
        fail=$((fail + 1))
    fi
}

require_link() {
    local path="$1"
    if [ -L "$REPO_ROOT/$path" ]; then
        pass=$((pass + 1))
    else
        echo "[FAIL] Not a symlink: $path"
        fail=$((fail + 1))
    fi
}

require_contains() {
    local path="$1"
    local pattern="$2"
    if grep -q "$pattern" "$REPO_ROOT/$path" 2>/dev/null; then
        pass=$((pass + 1))
    else
        echo "[FAIL] $path does not contain: $pattern"
        fail=$((fail + 1))
    fi
}

echo "=== Test: Copilot support files ==="

# -- .github/skills symlink --
require_link ".github/skills"

# -- copilot-instructions.md --
require_file ".github/copilot-instructions.md"
require_contains ".github/copilot-instructions.md" "using-superpowers"
require_contains ".github/copilot-instructions.md" "SessionStart"
require_contains ".github/copilot-instructions.md" ".superpowers/workflows/ACTIVE"

# -- INSTALL.copilot.md --
require_file ".github/INSTALL.copilot.md"
require_contains ".github/INSTALL.copilot.md" "setup-copilot.sh"

# -- copilot-tools.md --
require_file "skills/using-superpowers/references/copilot-tools.md"
require_contains "skills/using-superpowers/references/copilot-tools.md" "run_in_terminal"
require_contains "skills/using-superpowers/references/copilot-tools.md" "read_file"
require_contains "skills/using-superpowers/references/copilot-tools.md" "replace_string_in_file"

# -- using-superpowers SKILL.md Copilot section --
require_contains "skills/using-superpowers/SKILL.md" "copilot-tools.md"

# -- Prompt files (one per command + experiment-reviewer) --
for prompt in \
    continue-workflow \
    workflow-status \
    workflow-summary \
    design-experiment \
    plan-experiment \
    run-experiment \
    debug-training \
    analyze-results \
    close-experiment \
    reproduce-paper \
    check-reproducibility \
    experiment-reviewer
do
    require_file ".github/prompts/$prompt.prompt.md"
    require_contains ".github/prompts/$prompt.prompt.md" "mode: agent"
done

# -- setup script --
require_file "scripts/setup-copilot.sh"
if [ -x "$REPO_ROOT/scripts/setup-copilot.sh" ]; then
    pass=$((pass + 1))
else
    echo "[FAIL] scripts/setup-copilot.sh is not executable"
    fail=$((fail + 1))
fi

# -- docs --
require_file "docs/README.copilot.md"

# -- Skills accessible through symlink --
for skill in \
    experiment-design \
    experiment-planning \
    experiment-execution \
    training-debugging \
    result-analysis \
    experiment-closeout \
    paper-to-implementation \
    reproducibility-check \
    scientific-visualization \
    using-superpowers
do
    require_file ".github/skills/$skill/SKILL.md"
done

# -- _shared accessible through symlink --
require_file ".github/skills/_shared/workflow-protocol.md"

echo ""
echo "=== Results: $pass passed, $fail failed ==="

if [ "$fail" -gt 0 ]; then
    exit 1
fi

echo "=== Copilot support tests passed ==="
