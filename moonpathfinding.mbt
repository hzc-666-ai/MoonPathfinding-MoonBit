/// MoonPathfinding — pure MoonBit pathfinding library.
///
/// # Modules
/// - `@graph` — Graph trait, AdjacencyList, Grid
/// - `@algo` — 7 algorithms (BFS, DFS, Dijkstra, A*, Greedy BFS, Bidirectional BFS, Bellman-Ford)
/// - `@visualize` — ASCII terminal and HTML visualization
///
/// # Quick Start
/// ```
/// let grid = @graph.Grid::from_strings([
///   "S...#",
///   ".#...",
///   "...#E",
/// ]).unwrap()
/// let result = @algo.astar(grid, 0, 14)
/// @visualize.ascii_render(grid, result, 0, 14).println()
/// ```
