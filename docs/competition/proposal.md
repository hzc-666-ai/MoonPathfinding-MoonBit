# MoonPathfinding 项目申报书

| 项目 | 内容 |
|---|---|
| 项目名称 | MoonPathfinding：MoonBit 路径查找算法库 |
| 发布模块 | `hzc-666-ai/moonpathfinding`（版本 `0.1.2`） |
| GitHub | https://github.com/hzc-666-ai/MoonPathfinding-MoonBit |
| GitLink | https://gitlink.org.cn/hzc666/moonpathfinding |
| 项目方向 | MoonBit 基础库 / 图算法与路径规划 |
| 项目性质 | 原创实现，依据经典算法定义与公开伪代码设计，MIT 许可证 |

## 项目简介与场景
MoonPathfinding 是纯 MoonBit 实现的路径查找库，面向游戏寻路、网格路径规划、加权图路线计算和算法教学。项目提供 9 种搜索算法、Graph trait 与 4 种具体图结构、3 种迷宫生成器、路径处理工具、Benchmark 及 ASCII/HTML 可视化。

## 核心功能
- 8 种基于 `Graph` trait 的通用算法：BFS、DFS、Dijkstra、A*、Greedy BFS、Bidirectional BFS、Bellman-Ford、IDA*。
- 1 种 `Grid` 专用算法：JPS，用于八方向、均匀移动代价网格的跳点剪枝搜索。
- 图抽象：Graph trait、AdjacencyList、Grid、WeightedGrid、HexGrid；路径工具：`smooth_path`、`simplify_path`、`expand_path`、`decimate_path`。
- Bellman-Ford 支持负权边并检测从起点可达的负环；双向 BFS 支持有向图；Greedy 与 JPS 返回连续路径和完整路径代价。

## 实现与交付
1. 已完成算法、图结构、迷宫、可视化、Benchmark、CLI、README、MIT 许可证和 GitHub/GitLink 双仓库。
2. MoonBit 源码 2,262 行、测试 757 行，合计 3,019 行；74 个测试在 wasm、wasm-gc、JavaScript、native 四后端通过。
3. CI 执行 `moon check`、`moon fmt --check`、`moon info`、`moon test`；74 个测试已在四后端验证，当前共 21 次提交。
4. 已发布 `hzc-666-ai/moonpathfinding@0.1.2`，预期交付物均已完成并可通过 README 命令复现。
