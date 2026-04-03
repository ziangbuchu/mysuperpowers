# Installing Superpowers DL for GitHub Copilot (VS Code)

Enable Superpowers DL workflow skills in GitHub Copilot via project-local skill discovery.

## Prerequisites

- VS Code with the GitHub Copilot and GitHub Copilot Chat extensions
- Git

## Quick Install (research project)

Run the setup script from the Superpowers repo:

```bash
# 1. Clone Superpowers to a stable location
git clone https://github.com/ziangbuchu/mysuperpowers.git ~/.copilot/superpowers

# 2. Run the setup script targeting your research project
bash ~/.copilot/superpowers/scripts/setup-copilot.sh /path/to/your/research-project
```

The script creates:
- `.github/skills/` symlinks to each Superpowers skill
- `.github/prompts/` symlinks to all workflow slash commands
- A `superpowers` block appended to `.github/copilot-instructions.md`

## Manual Installation

### Step 1 — Clone the repository

```bash
git clone https://github.com/ziangbuchu/mysuperpowers.git ~/.copilot/superpowers
```

### Step 2 — Symlink skills into your research project

```bash
SUPERPOWERS=~/.copilot/superpowers
PROJECT=/path/to/your/research-project
mkdir -p "$PROJECT/.github/skills"

# Link each skill (repeat for all skills)
for skill in experiment-design experiment-planning experiment-execution \
             training-debugging result-analysis experiment-closeout \
             paper-to-implementation reproducibility-check scientific-visualization \
             using-superpowers; do
  ln -s "$SUPERPOWERS/skills/$skill" "$PROJECT/.github/skills/superpowers-$skill"
done

# Also link _shared (needed by skill cross-references)
ln -s "$SUPERPOWERS/skills/_shared" "$PROJECT/.github/skills/superpowers-shared"
```

### Step 3 — Symlink prompts into your research project

```bash
mkdir -p "$PROJECT/.github/prompts"
for prompt in "$SUPERPOWERS/.github/prompts"/*.prompt.md; do
  ln -s "$prompt" "$PROJECT/.github/prompts/$(basename "$prompt")"
done
```

### Step 4 — Add session bootstrap to copilot-instructions.md

Append the following block to `$PROJECT/.github/copilot-instructions.md`
(create the file if it does not exist):

```markdown
## Superpowers DL

You have Superpowers DL deep learning research workflow skills (see available skills).

At the start of any research conversation:
1. Load the `superpowers:using-superpowers` skill.
2. Run `git rev-parse --show-toplevel` to resolve the project root.
3. Check `.superpowers/workflows/ACTIVE` in the project root.
   - If found, read the workflow JSON and report status before responding.
   - Key prompts: `continue current workflow` · `workflow status` · `workflow summary`
```

### Step 5 — Restart VS Code

Quit and relaunch VS Code (or reload the window) to pick up the new skills.

## Verify

Open Copilot Chat in Agent mode. The available skills list in the system context
should include entries like `superpowers:using-superpowers`, `superpowers:experiment-design`, etc.

Ask: `workflow status` — Copilot should load the using-superpowers skill and check
for an active workflow in the current project.

## Updating

```bash
cd ~/.copilot/superpowers && git pull
```

Skills update instantly through the symlinks.

## Uninstalling

```bash
# Remove symlinks from your research project
rm -rf /path/to/research-project/.github/skills/superpowers-*
rm -f  /path/to/research-project/.github/prompts/*.prompt.md

# Remove the Superpowers clone (optional)
rm -rf ~/.copilot/superpowers
```

## Differences from Claude / Codex

| Feature               | Claude Code              | Codex                        | Copilot (VS Code)               |
|-----------------------|--------------------------|------------------------------|---------------------------------|
| Skills discovery      | Plugin system            | `~/.agents/skills/` symlink  | `.github/skills/` per project   |
| Session bootstrap     | `SessionStart` hook      | Skill auto-load at startup   | `copilot-instructions.md`       |
| Slash commands        | `commands/*.md`          | Natural language shortcuts   | `.github/prompts/*.prompt.md`   |
| Tool names            | Claude Code native       | See `codex-tools.md`         | See `copilot-tools.md`          |
