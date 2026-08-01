# MoonPathfinding 开发报告

## 项目概述

MoonPathfinding 是一个纯 MoonBit 实现的路径查找算法库，当前发布模块为 `hzc-666-ai/moonpathfinding`，版本为 `0.1.2`。项目包含 9 种搜索算法、Graph trait 与 4 种具体图结构、3 种迷宫生成器、路径处理工具、Benchmark、CLI 以及 ASCII/HTML 可视化。

## 开发过程

1. **基础架构**：定义 `Graph` trait、`PathResult` 和 AdjacencyList/Grid，实现 BFS、DFS、Dijkstra、A*。
2. **算法扩展**：实现 Greedy BFS、Bidirectional BFS、Bellman-Ford、IDA* 和面向 Grid 的 JPS。
3. **工程扩展**：增加 WeightedGrid、HexGrid、DFS/Prim/随机障碍迷宫、可视化、Benchmark 和 CLI。
4. **正确性加固**：修复 Bellman-Ford 负权路径与可达负环检测、有向图双向 BFS、Greedy 完整路径代价、JPS 连续路径和 10/14 代价计算，并实现路径平滑、简化、展开与抽稀工具。

## 架构设计

```text
Graph trait
  ├── AdjacencyList（通用有向/无向图）
  ├── Grid（二维网格）
  ├── WeightedGrid（带权八方向网格）
  └── HexGrid（六边形网格）

algo/
  ├── 8 种通用 Graph 算法：BFS、DFS、Dijkstra、A*、Greedy、Bidirectional BFS、Bellman-Ford、IDA*
  ├── Grid 专用算法：JPS
  └── 路径工具：smooth_path、simplify_path、expand_path、decimate_path
```

这种边界避免把 JPS 错误描述为适用于任意图结构：通用算法通过 `Graph` trait 获取邻接关系和边权，JPS 则依赖规则网格坐标、八方向移动和均匀基础代价。

## 核心实现与修复

### Bellman-Ford
实现支持负权边，并只将“从起点可达的负环”视为当前查询失败。测试覆盖负权最短路、可达负环、不可达负环及起点等于终点时的负环检查。

### Bidirectional BFS
前向搜索使用原图邻接边，反向搜索按入边扩展，因此可用于有向图。测试验证方向约束、最短相遇路径和不可达场景。

### Greedy BFS
启发函数仍决定节点选择顺序，但结果代价按最终选中路径的每条边累加，不再用启发值代替真实路径成本。

### JPS 与路径工具
JPS 用于八方向均匀代价 Grid，通过跳点剪枝减少部分规则网格上的扩展节点；实现会将跳点段展开为相邻格点，确保路径连续，并按直线 10、对角线 14 计算完整代价。路径工具提供视线平滑、共线简化、路径展开和按距离抽稀，但不宣称实现 NavMesh Funnel 等未包含算法。

## 工程质量

- MoonBit 源码：2,262 行；测试：757 行；合计：3,019 行。
- 功能规模：9 种算法，Graph trait + 4 种具体图结构，3 种迷宫生成器。
- 测试规模：74 个测试，wasm、wasm-gc、JavaScript、native 四后端全部通过。
- CI 门禁：`moon check`、`moon fmt --check`、`moon info`、`moon test`；Ubuntu 与 macOS job 均通过，四后端测试结果另行完成验证。
- 仓库历史：21 次提交，GitHub 与 GitLink 默认分支均为 `master`。

## 当前边界与后续方向

1. 尚未实现 D* Lite 等动态增量重规划算法。
2. 尚未支持 3D 网格、NavMesh 和 Funnel 路径平滑。
3. 尚未覆盖多智能体路径规划（MAPF）。
4. 当前 Benchmark 用于项目内算法对比，不据此宣称跨项目或跨语言的绝对性能优势。
