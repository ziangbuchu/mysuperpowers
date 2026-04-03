#!/usr/bin/env bash
# setup-copilot.sh — Install Superpowers DL skills for GitHub Copilot in a research project
#
# Usage:
#   bash scripts/setup-copilot.sh <target-project-path>
#
# What it does:
#   1. Creates .github/skills/ symlinks for each Superpowers skill
#   2. Creates .github/prompts/ symlinks for all workflow slash commands
#   3. Appends a Superpowers bootstrap block to .github/copilot-instructions.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUPERPOWERS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ── Argument ──────────────────────────────────────────────────────────────────

if [[ $# -lt 1 ]]; then
    echo "Usage: bash scripts/setup-copilot.sh <target-project-path>" >&2
    exit 1
fi

TARGET="$(cd "$1" && pwd)"

if [[ ! -d "$TARGET" ]]; then
    echo "Error: target directory does not exist: $TARGET" >&2
    exit 1
fi

echo "Installing Superpowers DL for Copilot"
echo "  Source : $SUPERPOWERS_ROOT"
echo "  Target : $TARGET"
echo ""

# ── 1. Skills symlinks ────────────────────────────────────────────────────────

SKILLS_DIR="$TARGET/.github/skills"
mkdir -p "$SKILLS_DIR"

SKILLS=(
    experiment-design
    experiment-planning
    experiment-execution
    training-debugging
    result-analysis
    experiment-closeout
    paper-to-implementation
    reproducibility-check
    scientific-visualization
    using-superpowers
)

echo "Creating skill symlinks in $SKILLS_DIR ..."
for skill in "${SKILLS[@]}"; do
    src="$SUPERPOWERS_ROOT/skills/$skill"
    dst="$SKILLS_DIR/superpowers-$skill"
    if [[ -e "$dst" || -L "$dst" ]]; then
        echo "  skip (already exists): superpowers-$skill"
    else
        ln -s "$src" "$dst"
        echo "  linked: superpowers-$skill -> $src"
    fi
done

# Also link _shared so skills can cross-reference workflow-protocol.md etc.
SHARED_DST="$SKILLS_DIR/superpowers-shared"
if [[ -e "$SHARED_DST" || -L "$SHARED_DST" ]]; then
    echo "  skip (already exists): superpowers-shared"
else
    ln -s "$SUPERPOWERS_ROOT/skills/_shared" "$SHARED_DST"
    echo "  linked: superpowers-shared -> $SUPERPOWERS_ROOT/skills/_shared"
fi

# ── 2. Prompts symlinks ───────────────────────────────────────────────────────

PROMPTS_DIR="$TARGET/.github/prompts"
mkdir -p "$PROMPTS_DIR"

echo ""
echo "Creating prompt symlinks in $PROMPTS_DIR ..."
for prompt_src in "$SUPERPOWERS_ROOT/.github/prompts"/*.prompt.md; do
    name="$(basename "$prompt_src")"
    dst="$PROMPTS_DIR/$name"
    if [[ -e "$dst" || -L "$dst" ]]; then
        echo "  skip (already exists): $name"
    else
        ln -s "$prompt_src" "$dst"
        echo "  linked: $name"
    fi
done

# ── 3. copilot-instructions.md bootstrap block ────────────────────────────────

INSTRUCTIONS="$TARGET/.github/copilot-instructions.md"
MARKER="<!-- superpowers-copilot-bootstrap -->"

if grep -q "$MARKER" "$INSTRUCTIONS" 2>/dev/null; then
    echo ""
    echo "Superpowers bootstrap block already present in $INSTRUCTIONS — skipping."
else
    mkdir -p "$(dirname "$INSTRUCTIONS")"
    cat >> "$INSTRUCTIONS" <<'BLOCK'

<!-- superpowers-copilot-bootstrap -->
## Superpowers DL

You have Superpowers DL deep learning research workflow skills (see available skills list above).

At the start of any research conversation:
1. Load the `superpowers:using-superpowers` skill.
2. Run `git rev-parse --show-toplevel` (`run_in_terminal`) to resolve the project root.
3. Check `.superpowers/workflows/ACTIVE` in the project root.
   - If found, read the workflow JSON and report active workflow status before responding.
   - Key prompts: `continue current workflow` · `workflow status` · `workflow summary`
<!-- end superpowers-copilot-bootstrap -->
BLOCK
    echo ""
    echo "Appended bootstrap block to $INSTRUCTIONS"
fi

# ── 4. AGENTS.md ──────────────────────────────────────────────────────────────

AGENTS_SRC="$SUPERPOWERS_ROOT/AGENTS.md"
AGENTS_DST="$TARGET/AGENTS.md"

if [[ -f "$AGENTS_SRC" ]]; then
    if [[ -L "$AGENTS_DST" ]]; then
        echo ""
        echo "AGENTS.md symlink already exists in $TARGET — skipping."
    elif [[ -f "$AGENTS_DST" ]]; then
        echo ""
        echo "AGENTS.md (plain file) already exists in $TARGET"
        echo "  To switch to a symlink (auto-updating): rm $AGENTS_DST && run this script again."
    else
        ln -s "$AGENTS_SRC" "$AGENTS_DST"
        echo ""
        echo "Symlinked AGENTS.md in $TARGET -> $AGENTS_SRC"
    fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "Done. Restart VS Code (or reload the window) to pick up the new skills."
echo ""
echo "Verify by opening Copilot Chat in Agent mode and asking: workflow status"
