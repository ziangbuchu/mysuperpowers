# Superpowers DL for Codex

Guide for using the deep learning research fork of Superpowers with OpenAI Codex.

Chinese usage tutorial: [README.codex.zh-CN.md](README.codex.zh-CN.md)

## Quick Install

Tell Codex:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/ziangbuchu/mysuperpowers/refs/heads/main/.codex/INSTALL.md
```

## Manual Installation

### Prerequisites

- OpenAI Codex CLI
- Git

### Steps

1. Clone the repo:

   ```bash
   git clone https://github.com/ziangbuchu/mysuperpowers.git ~/.codex/superpowers
   ```

2. Create the skills symlink:

   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/superpowers/skills ~/.agents/skills/superpowers
   ```

3. Restart Codex.

## How It Works

Codex scans `~/.agents/skills/` at startup. Superpowers exposes its skills through one symlink:

```text
~/.agents/skills/superpowers/ -> ~/.codex/superpowers/skills/
```

The `using-superpowers` skill handles skill-first behavior for research work in this fork.

## Usage

Typical prompts that should trigger a skill:

- "I want to try rotary embeddings in this model"
- "Training goes to NaN after warmup"
- "Compare these ablations and tell me what to run next"
- "Can you help me reproduce this paper fairly?"

You can also mention a skill directly, for example:

- `use experiment-design`
- `use training-debugging`

## Updating

```bash
cd ~/.codex/superpowers && git pull
```

## Troubleshooting

### Skills not showing up

1. Verify the symlink: `ls -la ~/.agents/skills/superpowers`
2. Check skills exist: `find ~/.codex/superpowers/skills -name SKILL.md`
3. Restart Codex
