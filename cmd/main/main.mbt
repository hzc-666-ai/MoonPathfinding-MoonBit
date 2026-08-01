///|
/// CLI demo for MoonPathfinding.
/// Run: moon run cmd/main
fn main {
  let lines = ["S....", ".###.", ".....", ".###.", "....E"]
  let grid = @graph.Grid::from_strings(lines).unwrap()
  let start = @graph.Grid::pos_to_id(grid, 0, 0)
  let goal = @graph.Grid::pos_to_id(grid, 4, 4)

  println("=== MoonPathfinding Demo ===\n")
  println("Grid:")
  println(
    @visualize.ascii_render(
      grid,
      { path: [], cost: 0, nodes_visited: 0 },
      start,
      goal,
    ),
  )
  println("")

  let r_bfs = @algo.bfs(grid, start, goal)
  println(@visualize.result_summary("BFS", r_bfs))
  println(@visualize.ascii_render(grid, r_bfs, start, goal))
  println("")

  let r_dfs = @algo.dfs(grid, start, goal)
  println(@visualize.result_summary("DFS", r_dfs))
  println(@visualize.ascii_render(grid, r_dfs, start, goal))
  println("")

  let r_dij = @algo.dijkstra(grid, start, goal)
  println(@visualize.result_summary("Dijkstra", r_dij))
  println(@visualize.ascii_render(grid, r_dij, start, goal))
  println("")

  let r_astar = @algo.astar(grid, start, goal)
  println(@visualize.result_summary("A*", r_astar))
  println(@visualize.ascii_render(grid, r_astar, start, goal))
  println("")

  let r_gbfs = @algo.greedy_bfs(grid, start, goal)
  println(@visualize.result_summary("Greedy BFS", r_gbfs))
  println(@visualize.ascii_render(grid, r_gbfs, start, goal))
  println("")

  let r_bibfs = @algo.bidirectional_bfs(grid, start, goal)
  println(@visualize.result_summary("Bidirectional BFS", r_bibfs))
  println(@visualize.ascii_render(grid, r_bibfs, start, goal))
  println("")

  let r_bf = @algo.bellman_ford(grid, start, goal)
  println(@visualize.result_summary("Bellman-Ford", r_bf))
  println(@visualize.ascii_render(grid, r_bf, start, goal))
  println("")

  // HTML export
  let html = @visualize.html_render(
    grid, r_astar, start, goal, "MoonPathfinding — A* Demo",
  )
  println("HTML output (" + html.length().to_string() + " chars):")
  println(html[0:200] + "...")
}
