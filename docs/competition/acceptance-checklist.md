# MoonPathfinding — Competition Acceptance Checklist

## Algorithms (9)

### Uninformed Search
- [x] BFS — Breadth-First Search on unweighted graphs
- [x] DFS — Depth-First Search
- [x] Dijkstra — Shortest path on weighted graphs (non-negative)
- [x] Bellman-Ford — Shortest path with negative weights

### Informed Search
- [x] A* — f = g + h heuristic search
- [x] Greedy BFS — Heuristic-only search
- [x] IDA* — Iterative Deepening A* (memory-efficient)

### Additional Algorithms
- [x] Bidirectional BFS — Shortest-path search on directed and undirected graphs
- [x] JPS — Jump Point Search (orders of magnitude faster on large grids)

## Graph Types (5)

- [x] AdjacencyList — General directed/undirected graph
- [x] Grid — 4-direction 2D grid
- [x] WeightedGrid — 8-direction grid with per-cell terrain costs
- [x] HexGrid — Hexagonal grid (odd-q layout)
- [x] Graph trait — User-extensible graph interface

## Maze Generators (3)

- [x] DFS recursive backtracker
- [x] Prim's algorithm
- [x] Random obstacle placement

## Visualization

- [x] ASCII terminal rendering (S=start, E=goal, *=path, #=wall)
- [x] HTML table export with CSS styling
- [x] Result summary (path length, cost, nodes visited)

## Benchmark

- [x] Compare all 9 algorithms on increasing maze sizes (5x5 to 50x50)
- [x] Random obstacle benchmark at 20%/30%/40% fill
- [x] Optimality check (which algorithms find the shortest path)
- [x] Efficiency comparison (nodes visited)

## Project Quality

- [x] `moon check` passes with 0 errors
- [x] `moon build` succeeds
- [x] `moon test` — 74 tests, all passing on wasm, wasm-gc, JavaScript, and native
- [x] CI configuration (`.github/workflows/ci.yml`)
- [x] README with installation, quick start, and API reference
- [x] MIT License
- [x] CLI demo (`moon run cmd/main`)

## Code Statistics

- algo/ (9 algorithms + path utilities): 1,160 lines
- graph/ (5 types + trait): 458 lines
- maze/ (3 generators): 180 lines
- bench/ (benchmarks): 260 lines
- visualize/ (ASCII + HTML): 123 lines
- cmd/main/ (CLI): 63 lines
- Tests: 757 lines across all modules
- Total MoonBit: 3,019 lines (2,262 source + 757 tests), 21 commits including this update

## Competition Submission

- [x] GitHub repository pushed
- [x] GitLink mirror pushed
- [x] 10-20 meaningful commits (18 total)
- [x] Project proposal PDF generated
