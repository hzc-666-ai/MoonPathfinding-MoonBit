# MoonPathfinding

A comprehensive pathfinding library for MoonBit, featuring **9 algorithms**, **5 graph types**, **maze generators**, and **ASCII/HTML visualization**.

[![CI](https://github.com/hzc-666-ai/MoonPathfinding-MoonBit/actions/workflows/ci.yml/badge.svg)](https://github.com/hzc-666-ai/MoonPathfinding-MoonBit/actions/workflows/ci.yml)

## Features

### Algorithms (9)

| Algorithm | Type | Optimal | Weighted | Notes |
|-----------|------|---------|----------|-------|
| BFS | Uninformed | Yes (unweighted) | No | Queue-based |
| DFS | Uninformed | No | No | Stack-based |
| Dijkstra | Uninformed | Yes | Yes | Priority queue |
| A* | Informed | Yes | Yes | f = g + h |
| Greedy BFS | Informed | No | Yes | f = h only |
| Bidirectional BFS | Uninformed | Yes (unweighted) | No | Two-end search |
| Bellman-Ford | Uninformed | Yes | Yes (neg. OK) | DP-based |
| IDA* | Informed | Yes | Yes | Memory-efficient |
| JPS | Informed | Yes | Uniform grid | Jump point pruning |

### Graph Types (5)

- **AdjacencyList** — General-purpose directed/undirected graph
- **Grid** — 2D grid with 4-direction movement
- **WeightedGrid** — Grid with per-cell terrain costs and 8-direction support
- **HexGrid** — Hexagonal grid (odd-q offset layout)
- **Graph trait** — Implement your own graph types

### Maze Generators (3)

- DFS recursive backtracker
- Prim's algorithm
- Random obstacle placement

### Visualization

- **ASCII** — Terminal-friendly path rendering
- **HTML** — CSS-styled grid table export

## Installation

```bash
moon add hzc666/moonpathfinding
```

## Quick Start

```moonbit
// Grid pathfinding with A*
let lines = [
  "S....",
  ".###.",
  ".....",
  ".###.",
  "....E",
]
let grid = @graph.Grid::from_strings(lines).unwrap()
let start = grid.pos_to_id(0, 0)  // 'S' position
let goal = grid.pos_to_id(4, 4)   // 'E' position

let result = @algo.astar(grid, start, goal)
println(@visualize.ascii_render(grid, result, start, goal))
// S····
// *###·
// *****
// ·###*
// ····E
```

```moonbit
// General graph
let g = @graph.AdjacencyList::new(4)
g.add_edge_undirected(0, 1, 5)
g.add_edge_undirected(1, 2, 3)
g.add_edge_undirected(2, 3, 1)

let r = @algo.dijkstra(g, 0, 3)
// r.cost = 9, r.path = [0, 1, 2, 3]
```

```moonbit
// Generate and solve a maze
let maze = @maze.dfs_maze(15, 15, 42)
let grid = @graph.Grid::from_strings(maze).unwrap()
let r = @algo.astar(grid, 0, grid.width * grid.height - 1)
println(@visualize.ascii_render(grid, r, 0, grid.width * grid.height - 1))
```

```moonbit
// Compare all algorithms
let report = @bench.maze_benchmark()
println(report)
```

## Project Structure

```
moonpathfinding/
├── graph/       # Graph trait, AdjacencyList, Grid, WeightedGrid, HexGrid
├── algo/        # 9 algorithms + MinHeap
├── visualize/   # ASCII and HTML renderers
├── maze/        # Maze generators (DFS, Prim, random)
├── bench/       # Performance benchmarks
├── cmd/main/    # CLI demo (moon run cmd/main)
└── docs/        # Competition documents
```

## API Overview

### Algorithms

```moonbit
@algo.bfs(graph, start, goal)              -> PathResult
@algo.dfs(graph, start, goal)              -> PathResult
@algo.dijkstra(graph, start, goal)         -> PathResult
@algo.astar(graph, start, goal)            -> PathResult
@algo.greedy_bfs(graph, start, goal)       -> PathResult
@algo.bidirectional_bfs(graph, start, goal)-> PathResult
@algo.bellman_ford(graph, start, goal)     -> PathResult
@algo.idastar(graph, start, goal)          -> PathResult
@algo.jps(grid, start, goal)              -> PathResult
```

### Graph Trait

```moonbit
pub trait Graph {
  node_count(Self) -> Int
  neighbors(Self, Int) -> Array[(Int, Int)]   // (node_id, edge_cost)
  heuristic(Self, Int, Int) -> Int             // estimated cost
}
```

### PathResult

```moonbit
pub(all) struct PathResult {
  path : Array[Int]    // ordered node IDs
  cost : Int           // total path cost
  nodes_visited : Int  // exploration count
}
```

### Visualization

```moonbit
@visualize.ascii_render(grid, result, start, goal) -> String
@visualize.html_render(grid, result, start, goal, title) -> String
@visualize.result_summary(algo_name, result) -> String
```

## Run CLI Demo

```bash
moon run cmd/main
```

## Run Tests

```bash
moon test
```

## License

MIT

## Links

- GitHub: https://github.com/hzc-666-ai/MoonPathfinding-MoonBit
- GitLink: https://gitlink.org.cn/hzc666/moonpathfinding
- MoonBit 2026 Open Source Competition
