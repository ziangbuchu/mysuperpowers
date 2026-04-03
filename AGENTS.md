# 全局 Agent 规则（深度学习研究适配版）

本文件约束自动化代理在深度学习研究工作区中的默认工作方式，以 Superpowers DL 为主工作流体系按需激活。

> 适配自通用 AGENTS.md；聚焦论文复现、模型改动、训练调试、ablation 对比与结果核查场景。

## 指令优先级

1. 当前会话中用户的明确要求
2. 仓库自身规则、文档与约定（含 `docs/experiments/specs/`）
3. 本 `AGENTS.md`
4. 相关 Superpowers DL skill 流程定义

- 默认以 **Superpowers DL** 作为主工作流体系，但不默认启用 full Superpowers。
- 只读分析任务可不进入完整实现流程，但结论必须清晰、可追溯、有证据。
- 若用户明确要求 `continue nonstop`，默认持续推进，直到满足验收标准或出现真实阻塞。

---

## 默认原则

### 假设先行与最短路径

- 默认采用"满足研究质量要求的最短路径"。
- **假设必须先于代码**：在明确 hypothesis / baseline / metric 之前，不改代码，不改 config，不提交 run。
- 默认先判断任务是否适合并行；适合则优先并行，不适合再串行。
- 能直接完成并验证的单点修复，不升级为更重实验流程。
- 能用轻量 design 解决的探索性问题，不升级为完整 experiment-planning 流程。

### 轻量任务默认策略

**轻量任务**：单文件或小范围修改、config 调整、日志 / 评估脚本修复、非核心辅助工具改动、局部文档更新。

- 默认可跳过完整 `experiment-design` 卡片和 `experiment-planning` 文档，直接实现并做定向验证。
- 仅在关键不确定且无法从当前对话、项目上下文或现有代码回答时才提问。
- 轻量任务首次最多问 1 个关键问题；中任务优先一次性给出 2–3 个方案与推荐。
- 以下任务仍必须走完整 DL skill 流程：模型结构、loss、数据增强、训练策略、评估协议的任何改动。

### 流程升级 / 降级

- **升级**：任何涉及模型、loss、数据、训练策略、评估协议的改动；影响边界超出初始判断；需求不清晰；验证覆盖不足。
- **降级**：改动局部且边界清晰；不涉及模型行为；验证直接；补文档或补工具脚本。

---

## 任务分流模型

### 只读 / 分析任务

适用：论文阅读、实验结果解读、代码走读、配置对比、日志分析、纯信息型问答。

- 可直接处理，无需进入完整实验流程。
- 真实训练故障排查但尚未进入修改时，优先使用 `training-debugging`。
- 结论必须可追溯：引用具体 run / config / commit / metric。

### 实验代码任务与质量门禁

适用：模型结构修改、loss 设计、数据增强、训练策略调整、评估协议变更、重构、ablation 实现。

**默认流程**：

```
experiment-design → experiment-planning → experiment-execution
```

轻量版 planning 最小集合至少明确：hypothesis、baseline、metric、sanity check 步骤、keep-or-revert 判断标准。

- Review 使用 `experiment-reviewer` agent。
- 完成前执行 `reproducibility-check`。
- 宣称改进前必须通过 `reproducibility-check`。

---

## 推进与验证

### Step by Step Reasoning Workflow

- 需求模糊时，先澄清 hypothesis、baseline、metric、数据假设、算力预算。
- 多步任务维护可见任务列表；任一时刻仅保留一个 `in_progress`。
- 回答时优先给结论，再补背景、依据与权衡。
- 遇到新信息主动修正之前判断。

### Environment

- 环境初始化优先遵循仓库文档与项目级 AGENTS。
- 若无明确要求，仅做当前任务所需的最小准备（优先 CPU / 单 GPU sanity check，再跑全量）。

### Command Verification Rules

- 不得虚构已运行命令、退出码、训练 metric 或验证结果。
- 关键验证无法执行时，必须明确说明原因。
- 没有验证证据，不得声称"通过""改进成立""可提交""可汇报"。

### Change Delivery Gate

在声明完成、准备 `commit`、准备 `push`、准备发起 PR、准备汇报结果之前，应满足：

1. 已完成与本次改动直接相关的验证（至少 sanity check），并如实报告结果
2. 已完成对应质量门禁（见下文）
3. 若改动影响 baseline 或对比公平性，已完成 `reproducibility-check`
4. 若关键验证无法执行，明确说明原因，并降低完成度表述

### Commit 规范

- 格式：`<type>(scope): <summary>`
- `scope` 可选
- `summary` 使用中文、动词开头、长度 ≤ 50 字、不加句号
- 常用 `type`：`feat` / `fix` / `refactor` / `docs` / `test` / `chore` / `exp`（实验性改动）

### 实验验证策略与质量门禁

是否需要完整实验验证，按"行为影响、共享范围、宣称风险、可复现性"显式判定：

- **Level 0**：定向验证——局部、低风险、非模型行为改动（config 格式、日志修复等）
- **Level 1**：Sanity Check——前向传播形状、loss 非 NaN、梯度非零、单 batch overfit
- **Level 2**：最小可证伪实验——新功能、行为变更、任何模型 / loss / 数据改动
- **Level 3**：Experiment Review——使用 `experiment-reviewer` agent 审查设计与结果
- **Level 4**：Reproducibility Check——宣称改进、对外汇报、合并到主干前

---

## 工程实践

### 快速上手

1. 阅读相关实验卡片（`docs/experiments/specs/`）、近期 commit 和已知 baseline 指标。
2. 若用户提供 `plan2go=<path>`，将该文件视为当前执行来源并保持同步。
3. 需要理解架构、数据流、训练入口与依赖关系时，优先使用代码搜索工具进行上下文检索。

### 文档维护

- 每轮实验后同步更新 `docs/experiments/specs/` 对应卡片（结果、结论、keep-or-revert 决定）。
- 对反复证明有价值的 debug 经验，沉淀到项目级 AGENTS 或 `skills/training-debugging/references/`。

### 执行原则

1. 假设先于代码；baseline 先于对比；sanity check 先于全量 run。
2. 优先最小可证伪实验，避免一次改多个变量。
3. 若训练出现异常，及时升级到 `training-debugging`，不靠直觉乱猜。
4. 若任务已收敛为单点配置或脚本修复，及时降级流程。

### 深度学习代码规范

- 函数 ≤ 50 行、文件 ≤ 300 行、嵌套 ≤ 3、禁止魔法数字（尤其是 lr、weight_decay、seed）。
- 训练入口 / config / 数据预处理 / 评估逻辑互相解耦；各模块独立可测。
- Seed 必须显式设置并记录；不同 seed 的结果差异必须报告。
- 不得在代码里硬编码数据路径、实验名或远程 checkpoint URL。

### Safety Rules

- 不要运行破坏性命令（如 `git reset --hard`），除非用户明确要求。
- 不要在未保存 checkpoint 的情况下覆盖已有训练结果。
- 不要 cherry-pick 单次好运 run 作为最终结论，必须报告 variance。
- 不要在对比中悄悄更改评估协议——evaluation 变更必须独立标注。
- 不要在未记录 config / seed / commit 的情况下宣称指标改进。
- 不要将 API Key、数据库凭证或远程存储密钥硬编码进源码或 config 文件。
- 避免危险删除命令，除非范围明确限制在临时产物（如 `__pycache__`、临时 log）。
- 除非用户明确要求，否则不要终止非当前任务启动的训练进程。

---

## 沟通与输出

### 沟通风格

- 默认使用简体中文回答，可混用英文技术术语。
- 代码标识符使用英文；代码注释优先简体中文，保持简洁清晰。
- 默认使用纯文本标题与字段名，不使用表情符号或 emoji；除非用户明确要求。

#### 模式 A：执行进度式

适用：代码修改、实验实现、训练调试、多步任务、文件操作

```
任务：一句话描述当前任务

执行计划：
- 已完成
- 进行中
- 待执行

当前进度：当前正在做什么，已完成什么

风险/阻塞：潜在问题、注意点、阻塞因素

参考：file:line 或 run/config/commit
```

#### 模式 B：分析回答式

适用：实验结果解读、方案对比、架构分析、论文拆解、训练问题诊断

```
结论：1-2 句直接回答核心问题

关键分析：
1. 核心观点
2. 依据（引用 metric / log / config）
3. 权衡

深入剖析：（可选）
方案 / Ablation 对比：（可选）
实施建议：（可选）
风险与置信度：（可选，标注 High/Medium/Low）
```

### 技术内容规范

- 多行代码、config、日志优先使用带语言标识的 Markdown 代码块。
- metric 对比必须注明 baseline 来源、seed 数量、是否多次 rerun。

---

## 多代理与并行协作

### 并行准入

- 仅当任务可自然拆为 2–4 个边界清晰、可独立验证且无同文件写冲突的子任务时，才适合并行。
- 以下情况默认不适合并行：改动集中在核心训练文件、涉及共享 model / loss / eval 定义、根因未明的训练故障。

### Ownership / Blocked

- 默认禁止两个子任务修改同一文件、同一 config 源、同一 shared model / loss / eval 定义。
- 子任务若发现写冲突、验证失败且根因超界，必须停止并上报。

### 收尾整合

- 所有子任务完成后统一收尾：汇总改动、检查 config 一致性、运行最终 sanity check、确认实验卡片已更新。

---

## 技能（Skills）

DL 主干工作流：

```
paper-to-implementation
  → experiment-design
  → experiment-planning
  → experiment-execution
  → training-debugging（如有训练故障）
  → result-analysis
  → experiment-closeout
  → reproducibility-check（宣称改进前必须执行）
```

| 技能 | 触发时机 |
|---|---|
| `using-superpowers` | 每次会话开始时，路由到合适的研究流程 |
| `paper-to-implementation` | 复现论文或将论文想法映射到本地代码 |
| `experiment-design` | 在改动模型 / loss / 数据 / 评估之前 |
| `experiment-planning` | hypothesis 确认后，实现之前 |
| `experiment-execution` | 按计划执行实验，控制变量，保留证据 |
| `training-debugging` | NaN / 发散 / OOM / 指标异常 / 任何训练故障 |
| `result-analysis` | run 结束后，比较 baseline / ablation / rerun |
| `experiment-closeout` | run 结束后，决定代码保留还是回滚 |
| `reproducibility-check` | 宣称改进、对外汇报、合并主干之前 |
| `experiment-reviewer` (agent) | 需要独立审查实验设计或结果时 |

会话收尾：完成一轮实验后更新实验卡片，记录结论与 keep-or-revert 决定。

---

## 平台适配

本 AGENTS.md 跨平台共享。各平台工具名映射参见：

- **Codex**：`skills/using-superpowers/references/codex-tools.md`
- **Copilot (VS Code)**：`skills/using-superpowers/references/copilot-tools.md`
- **Claude Code**：使用原生工具名
