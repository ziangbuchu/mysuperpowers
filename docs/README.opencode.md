# Superpowers DL for OpenCode

Guide for using the deep learning research fork of Superpowers with OpenCode.

## Quick Install

Tell OpenCode:

```text
Clone https://github.com/ShunyangLiu/superpowers_DL to ~/.config/opencode/superpowers, then create ~/.config/opencode/plugins and ~/.config/opencode/skills, symlink ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js to ~/.config/opencode/plugins/superpowers.js, symlink ~/.config/opencode/superpowers/skills to ~/.config/opencode/skills/superpowers, then restart OpenCode.
```

## Manual Installation

```bash
git clone https://github.com/ShunyangLiu/superpowers_DL.git ~/.config/opencode/superpowers
mkdir -p ~/.config/opencode/plugins ~/.config/opencode/skills
rm -f ~/.config/opencode/plugins/superpowers.js
rm -rf ~/.config/opencode/skills/superpowers
ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

Restart OpenCode after installation.

## Usage

List skills:

```text
use skill tool to list skills
```

Load a specific skill:

```text
use skill tool to load superpowers/experiment-design
```

Natural prompts that should trigger skills:

- "I want to test a better augmentation policy"
- "Validation F1 is higher than train F1 and I don't trust it"
- "These three runs disagree, help me decide what is real"

## Updating

```bash
cd ~/.config/opencode/superpowers
git pull
```
