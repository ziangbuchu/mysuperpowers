# Superpowers DL 在 Codex 中的中文使用教程

这不是一个 CLI 子命令工具，而是一组通过 Codex 原生 skills 机制加载的研究 workflow 技能。

这一版的重点是：阶段之间不再默认依赖人工复制上下文，而是通过当前项目里的 workflow state 自动续接。

安装说明见 [README.codex.md](README.codex.md)。

## 开始前

1. 安装或更新 superpowers skills。
2. 重启 Codex，或新开一个会话。
3. 在你要研究的项目目录里开始对话。

## 先记住这 4 条入口

### 1. 不知道该从哪个 skill 开始

```text
请为这个问题选择合适的 superpowers skill，并从最早的有效阶段开始。
```

### 2. 继续上一个实验

```text
continue current workflow
```

### 3. 看当前状态

```text
workflow status
```

### 4. 看当前总结

```text
workflow summary
```

如果当前 workflow 已经明确应保留代码，而且记录了足够的 Git 元数据，这个 summary 还会继续询问分支策略、生成详细 commit 草案，并在你确认后提交。

如果 `result-analysis` 已经保存结果图，`workflow summary` 还应先复用这些图，并简短说明每张图支持什么结论，再进入分支策略与提交流程。

## 现在是怎么续接上下文的

workflow 状态保存在当前项目下：

```text
.superpowers/workflows/
```

固定文件包括：

- `.superpowers/workflows/ACTIVE`
- `.superpowers/workflows/<workflow_id>/workflow.json`
- `.superpowers/workflows/<workflow_id>/stages/<stage>.md`
- `.superpowers/workflows/<workflow_id>/final-summary.md`

正式的实验文档仍然保存在：

- `docs/experiments/specs/`
- `docs/experiments/plans/`
- `docs/experiments/results/`
- `docs/experiments/results/assets/`

这意味着：

- 设计阶段写下来的 hypothesis / baseline / metric 会被后续阶段直接读取
- planning / execution / analysis / closeout 不需要你再手工复制前一阶段内容
- 新会话里也可以通过 `continue current workflow` 续接

## 最常用的起手式

```text
请为这个问题选择合适的 superpowers skill，并从最早的有效阶段开始。

任务：
<你的问题>
```

## 常用场景

### 新想法，还没开始改代码

```text
use experiment-design

我想尝试一个新想法：<你的想法>。
先不要改代码，先把实验设计清楚。
```

### 已经有设计，要产出执行计划

```text
use experiment-planning
```

如果当前 workflow 里已经有设计状态，planning 会直接读取，不需要再贴一遍。

### 已经有计划，继续执行

```text
continue current workflow
```

如果当前 workflow 的 `next_stage` 是 `experiment-execution`，它会直接续上。

### 训练坏了

```text
use training-debugging
```

### 结果不好解释

```text
use result-analysis
```

如果你想把 ablation、seed、收敛曲线或代价对比画成图，也可以直接说：

```text
use scientific-visualization
```

### 实验结束，要做收尾

```text
use experiment-closeout
```

### 准备对外汇报

```text
use reproducibility-check
```

## 如果你只记场景，不记 skill 名

- 还在想实验怎么做：`experiment-design`
- 设计已定，要出执行步骤：`experiment-planning`
- 开始实现和跑实验：`experiment-execution`
- 训练坏了：`training-debugging`
- 结果不好解释：`result-analysis`
- 实验结束，要决定保留还是回滚：`experiment-closeout`
- 准备对外汇报：`reproducibility-check`
- 论文复现：`paper-to-implementation`

## 使用原则

- 不要把它当 shell 子命令系统。
- 优先直接描述研究问题。
- 如果已经有 active workflow，优先说 `continue current workflow`。
- 如果只想知道现在做到哪，优先说 `workflow status`。
- 如果只想拿当前结论，优先说 `workflow summary`。
- 如果 `workflow summary` 没有继续给 Git 选项，优先检查是不是还在等待 approval/input，或 execution 没有记录完整的 start-state。
- 如果任务涉及模型、loss、数据、训练、评估、实验结论，默认应该先走 skill，而不是直接改代码。

## 更新

如果你是按安装文档把仓库 clone 到 `~/.codex/superpowers`，更新方式是：

```bash
cd ~/.codex/superpowers && git pull
```

skills 通过软链接暴露给 Codex；更新仓库内容后，重启 Codex 或新开会话即可重新加载。
