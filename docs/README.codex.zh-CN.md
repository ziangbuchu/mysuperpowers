# Superpowers DL 在 Codex 中的中文使用教程

这不是一个要在终端里执行的 CLI 工具，而是一组通过 Codex 原生 skills 机制加载的研究工作流技能。

安装完成后，你的主要用法是在 Codex 对话里直接发 prompt，让它按研究阶段选择和执行合适的 skill。

安装说明见 [README.codex.md](README.codex.md)。

## 开始前

1. 安装或更新 superpowers skills。
2. 重启 Codex，或新开一个会话。
3. 在新会话里确认技能已加载。

可以直接发：

```text
请告诉我这个会话里可用的 superpowers skills。
```

或者：

```text
请为这个任务选择合适的 superpowers skill，并先告诉我你选择了哪个。
```

## 使用原则

- 不要把它当命令行子命令使用。
- 优先直接描述研究任务，而不是先想着 skill 名字。
- 如果你知道自己处于哪个阶段，也可以直接点名 skill。
- 如果任务涉及模型、loss、数据、训练、评估、实验结论，默认应该先走 skill，而不是直接改代码。

最通用的起手式：

```text
请为这个任务选择合适的 superpowers skill。
从最早的有效阶段开始，不要跳过设计和证据检查。
先告诉我：
1. 你选择了哪个 skill
2. 为什么现在应该用它
3. 还缺哪些信息

任务：
<把你的需求写在这里>
```

## 常用流程

完整研究流程通常是：

`paper-to-implementation` -> `experiment-design` -> `experiment-planning` -> `experiment-execution` -> `training-debugging`（如有故障）-> `result-analysis` -> `experiment-closeout` -> `reproducibility-check`

### 1. 新想法，还没开始改代码

```text
use experiment-design

我想在当前仓库里尝试一个新想法：<你的想法>。
先不要改代码，先帮我把实验设计清楚。

请明确：
- 假设是什么
- baseline 是什么
- 指标是什么
- 数据集和划分是什么
- 算力预算是多少
- 第一个最小可证伪实验是什么
```

### 2. 设计已经定了，要落成执行计划

```text
use experiment-planning

这是已经确认的实验设计：
- 假设：...
- baseline：...
- 指标：...
- 数据集/划分：...
- 预算：...

请把它变成具体的实验计划，包括：
- 要改哪些文件
- 需要哪些 sanity check
- 运行命令是什么
- 需要保存哪些产物
- 什么时候应该停止
```

### 3. 开始实现并执行实验

```text
use experiment-execution

请严格按实验计划执行。
在做实验相关改动前，先记录：
- 起始 commit
- 当前分支
- 工作区是否干净
- 预计会改哪些文件

然后先做最小改动，先跑便宜的验证，再跑正式实验。
每次运行都记录命令、配置、seed、commit、数据划分和输出目录。
```

### 4. 训练出问题了

```text
use training-debugging

训练在 <现象> 时出问题了，比如 NaN / 发散 / OOM / 指标异常。
baseline 可以正常工作，但在我加入 <改动> 后出现了问题。

请：
- 先缩小到最小可复现配置
- 判断问题属于哪一类
- 在最可能出错的边界加观测
- 找到正常 run 和异常 run 最早出现差异的位置
- 一次只改一个变量
- 最后证明根因是什么
```

### 5. 结果出来了，但不好解释

```text
use result-analysis

我已经跑完几组实验，但结果不一致。

请你保守分析这些结果：
- 对比 baseline、ablation、rerun
- 统一 metric、选择规则、数据划分和训练预算
- 说明 effect size、波动和混杂因素
- 最后只给出一个明确结论：继续、重跑、先调试、或放弃
```

### 6. 实验结束后，决定保留还是回滚代码

```text
use experiment-closeout

这个实验已经结束了。
请帮我做收尾，并明确决定代码是保留还是回滚。

要求：
- 先整理实验结果和产物
- 记录这次实验为什么成功、失败或不确定
- 明确询问我：保留、丢弃、还是暂停决定
- 如果选择丢弃，确保只回滚实验相关改动，不影响其他已有修改
```

### 7. 准备对外汇报结果

```text
use reproducibility-check

我准备把这个结果告诉团队。
在我宣称“这个改动更好”之前，请检查证据是否足够。

请核对：
- 运行命令
- 配置或配置差异
- seed
- commit
- 数据版本或划分
- checkpoint / artifact
- 支撑结论的指标表

如果证据不够，请直接指出缺什么。
```

### 8. 复现论文

```text
use paper-to-implementation

我想在当前仓库里复现这篇论文/这个方法。

信息如下：
- 论文标题或链接：...
- 想复现的结论：...
- 当前仓库 baseline：...
- 可用算力：...
- 是否有官方代码/权重/数据：...

请先不要改代码。
先帮我：
- 提炼论文真正的核心改动
- 找出隐藏前提
- 映射到当前代码库
- 定义最小忠实复现实验
- 给出 ablation 梯子
```

## 记不住 skill 名时

直接这样说：

```text
这是一个研究任务，请先判断应该使用哪个 superpowers skill。
如果有多个阶段，请从最早的有效阶段开始。
```

或者：

```text
我不记得 skill 名了。请根据我的需求自动选择正确的 superpowers skill，并先告诉我为什么。
```

你也可以只记住场景，而不是记住精确名字：

- 还在想实验怎么做：`experiment-design`
- 设计已定，要出执行步骤：`experiment-planning`
- 开始实现和跑实验：`experiment-execution`
- 训练坏了：`training-debugging`
- 结果不好解释：`result-analysis`
- 实验结束，要决定保留还是回滚：`experiment-closeout`
- 准备对外汇报：`reproducibility-check`
- 论文复现：`paper-to-implementation`

## 万能模板

```text
请为这个任务选择合适的 superpowers skill，并从最早的有效阶段开始。

任务：
<你的需求>

约束：
- baseline：...
- 指标：...
- 数据集/划分：...
- 算力预算：...
- 截止时间：...

先告诉我：
1. 你选了哪个 skill
2. 为什么
3. 还缺什么信息
4. 现在是否应该改代码
```

## 常见误区

- 不要一上来就说“帮我把指标做高”，这会弱化设计阶段。
- 不要把建模变化和评估变化混进同一个实验。
- 不要只跑一次就让 Codex 下结论。
- 不要让失败实验的代码悄悄留在工作区里不收尾。
- 不要在没过 `reproducibility-check` 之前对外说“已经提升”。

## 更新

如果你是按安装文档把仓库 clone 到 `~/.codex/superpowers`，更新方式是：

```bash
cd ~/.codex/superpowers && git pull
```

skills 通过软链接暴露给 Codex；更新仓库内容后，重启 Codex 或新开会话即可重新加载。
