# MoonPathfinding 开发报告

## 开发过程

本项目构建了一个纯 MoonBit 实现的路径查找算法库，覆盖经典图搜索算法、高级寻路算法、多种图结构、迷宫生成和路径可视化。

开发分为三个阶段：
1. **基础架构**：定义 Graph trait 接口、AdjacencyList 图结构、BFS/DFS/Dijkstra/A* 基础算法
2. **高级算法**：实现 Greedy BFS、Bidirectional BFS、Bellman-Ford、IDA*（迭代加深A*）、JPS（跳点搜索）
3. **扩展功能**：Grid/HexGrid/WeightedGrid 多种网格、迷宫生成（DFS/Prim）、可视化输出、性能基准测试

## 架构设计

```
Graph trait (接口抽象)
  ├── AdjacencyList (通用图)
  ├── Grid (二维网格)
  ├── HexGrid (六边形网格)
  └── WeightedGrid (带权网格)

算法层 (algo/)
  ├── 基础：BFS, DFS, Dijkstra, A*, Greedy BFS
  ├── 高级：Bidirectional BFS, Bellman-Ford, IDA*, JPS
  └── 扩展：Theta* (视线优化)

可视化 (visualize/) → ANSI/Unicode 网格渲染
迷宫 (maze/) → DFS/Prim 迷宫生成 + 随机障碍
基准 (bench/) → 算法性能对比
```

所有算法通过 Graph trait 实现泛型化，同一套算法代码可运行在不同图结构上。

## 技术难点

### 1. MoonBit Trait 约束与泛型
MoonBit 的 trait 系统需要显式声明类型约束。算法函数签名 `pub fn[G : @graph.Graph] astar(graph : G, start : Int, goal : Int)` 要求在方括号中声明类型参数和 trait 约束，与 Rust 的泛型语法略有不同。

### 2. JPS（跳点搜索）的剪枝逻辑
JPS 是网格寻路的最优算法，核心在于识别"跳点"（jump points）以避免展开所有格子。实现难点在于方向性剪枝规则的编码，以及对角线方向的自然邻居（natural neighbors）和强制邻居（forced neighbors）的识别逻辑。

### 3. IDA* 的迭代加深
IDA* 使用深度优先搜索 + 递增阈值，避免 A* 的内存爆炸问题。阈值更新的 `next_bound` 计算需要正确处理 `f > bound` 的情况，取最小值作为下一个迭代的阈值。

### 4. 六边形网格坐标系统
HexGrid 使用立方体坐标（axial/cube coordinates），邻居计算与矩形网格完全不同。6 个邻居方向的坐标偏移需要根据列索引的奇偶性确定。

### 5. 可视化输出的跨平台兼容
visualize 模块输出 ANSI 颜色码和 Unicode 字符（如 ■、□、→），需要在不同终端和操作系统上验证显示效果。

## 测试情况

- 62 个测试全部通过
- 覆盖范围：每种算法的基本寻路、无路径情况、起点=终点边界、单点图、大图性能

## 项目统计

| 指标 | 数值 |
|------|------|
| 源码 | 2,172 行 |
| 算法数 | 10+ 种 |
| 图结构 | 4 种 |
| 测试 | 62 |
| 提交 | 19 |

## 不足与展望

1. 动态图更新（增量重规划如 D* Lite）未实现
2. 3D 网格/NavMesh 不支持
3. 多智能体协作寻路（MAPF）未覆盖
4. 路径平滑（Path Smoothing/Funnel Algorithm）待扩展
