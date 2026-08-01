///|
/// Performance benchmark comparing all pathfinding algorithms.
pub(all) struct BenchResult {
  name : String
  path_len : Int
  cost : Int
  visited : Int
  found : Bool
}

///|
/// Run all algorithms on a grid, return comparison results.
pub fn compare_all(
  grid : @graph.Grid,
  start : Int,
  goal : Int,
) -> Array[BenchResult] {
  let results : Array[BenchResult] = []

  let r = @algo.bfs(grid, start, goal)
  results.push({
    name: "BFS",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.dfs(grid, start, goal)
  results.push({
    name: "DFS",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.dijkstra(grid, start, goal)
  results.push({
    name: "Dijkstra",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.astar(grid, start, goal)
  results.push({
    name: "A*",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.greedy_bfs(grid, start, goal)
  results.push({
    name: "Greedy BFS",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.bidirectional_bfs(grid, start, goal)
  results.push({
    name: "Bidirectional BFS",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.bellman_ford(grid, start, goal)
  results.push({
    name: "Bellman-Ford",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.idastar(grid, start, goal)
  results.push({
    name: "IDA*",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  let r = @algo.jps(grid, start, goal)
  results.push({
    name: "JPS",
    path_len: r.path.length(),
    cost: r.cost,
    visited: r.nodes_visited,
    found: r.path.length() > 0,
  })

  results
}

///|
/// Run benchmarks on DFS-generated mazes of increasing size (5, 10, 20, 30, 50).
pub fn maze_benchmark() -> String {
  let sizes = [5, 10, 20, 30, 50]
  let mut report = "=== MoonPathfinding Benchmark ===\n\n"

  for si = 0; si < sizes.length(); si = si + 1 {
    let size = sizes[si]
    let maze_lines = @maze.dfs_maze(size, size, 42)
    match @graph.Grid::from_strings(maze_lines) {
      Some(grid) => {
        let start = 0
        let goal = grid.width * grid.height - 1
        // Ensure start and goal are passable
        if grid.is_passable(start) && grid.is_passable(goal) {
          report = report +
            "\n--- Maze " +
            size.to_string() +
            "x" +
            size.to_string() +
            " (cells: " +
            (size * size).to_string() +
            ") ---\n"
          let results = compare_all(grid, start, goal)
          report = report + format_table(results)
        }
      }
      None => ()
    }
  }
  report
}

///|
/// Run benchmarks on random obstacle grids at 20%, 30%, 40% fill.
pub fn random_benchmark(width : Int, height : Int) -> String {
  let densities = [20, 30, 40]
  let mut report = "=== Random Obstacle Benchmark (" +
    width.to_string() +
    "x" +
    height.to_string() +
    ") ===\n\n"

  for di = 0; di < densities.length(); di = di + 1 {
    let pct = densities[di]
    let obs_lines = @maze.random_obstacles(width, height, pct, 123)
    match @graph.Grid::from_strings(obs_lines) {
      Some(grid) => {
        let start = 0
        let goal = width * height - 1
        if grid.is_passable(start) && grid.is_passable(goal) {
          report = report + "\n--- " + pct.to_string() + "% obstacles ---\n"
          let results = compare_all(grid, start, goal)
          report = report + format_table(results)
        }
      }
      None => ()
    }
  }
  report
}

///|
fn pad_right(s : String, width : Int) -> String {
  let mut result = s
  while result.length() < width {
    result = result + " "
  }
  result
}

///|
fn pad_left(s : String, width : Int) -> String {
  let mut result = s
  while result.length() < width {
    result = " " + result
  }
  result
}

///|
fn format_table(results : Array[BenchResult]) -> String {
  let mut s = pad_right("Algorithm", 16) +
    " " +
    pad_left("Path Len", 10) +
    " " +
    pad_left("Cost", 8) +
    " " +
    pad_left("Visited", 10) +
    "\n"
  s = s + "----------------------------------------------\n"
  for i = 0; i < results.length(); i = i + 1 {
    let r = results[i]
    if r.found {
      s = s +
        pad_right(r.name, 16) +
        " " +
        pad_left(r.path_len.to_string(), 10) +
        " " +
        pad_left(r.cost.to_string(), 8) +
        " " +
        pad_left(r.visited.to_string(), 10) +
        "\n"
    } else {
      s = s + pad_right(r.name, 16) + " " + pad_left("NO PATH", 10) + "\n"
    }
  }
  s
}

///|
/// Compare optimal vs non-optimal: check which algorithms found the shortest path.
pub fn optimality_check(results : Array[BenchResult]) -> String {
  // Find the minimum cost among algorithms that found a path
  let mut best_cost : Int = -1
  let mut best_algos : Array[String] = []
  for i = 0; i < results.length(); i = i + 1 {
    let r = results[i]
    if r.found {
      if best_cost < 0 || r.cost < best_cost {
        best_cost = r.cost
        best_algos = [r.name]
      } else if r.cost == best_cost {
        best_algos.push(r.name)
      }
    }
  }

  let mut s = "Optimal cost: " + best_cost.to_string() + " (found by "
  for i = 0; i < best_algos.length(); i = i + 1 {
    if i > 0 {
      s = s + ", "
    }
    s = s + best_algos[i]
  }
  s = s + ")\n"

  // Most efficient (fewest visited nodes)
  let mut best_eff : Int = -1
  let mut eff_name = ""
  for i = 0; i < results.length(); i = i + 1 {
    let r = results[i]
    if r.found && r.cost == best_cost {
      if best_eff < 0 || r.visited < best_eff {
        best_eff = r.visited
        eff_name = r.name
      }
    }
  }
  s = s +
    "Most efficient: " +
    eff_name +
    " (" +
    best_eff.to_string() +
    " nodes visited)\n"
  s
}
