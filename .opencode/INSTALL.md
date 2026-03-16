# Installing Superpowers DL for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- Git installed

## Installation

### 1. Clone Superpowers

```bash
git clone https://github.com/ShunyangLiu/superpowers_DL.git ~/.config/opencode/superpowers
```

### 2. Register the Plugin

```bash
mkdir -p ~/.config/opencode/plugins
rm -f ~/.config/opencode/plugins/superpowers.js
ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
```

### 3. Symlink Skills

```bash
mkdir -p ~/.config/opencode/skills
rm -rf ~/.config/opencode/skills/superpowers
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

### 4. Restart OpenCode

After restart, ask for a research task such as:

- "Help me design an ablation for this model"
- "Training diverges after 3k steps"
- "Compare these experiment runs"

## Usage

List skills:

```text
use skill tool to list skills
```

Load a skill explicitly:

```text
use skill tool to load superpowers/experiment-design
```
