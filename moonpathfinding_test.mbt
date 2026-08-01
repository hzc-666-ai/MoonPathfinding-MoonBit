///|
/// Blackbox tests for moonpathfinding public API.
test "full pipeline graph" {
  let g = @graph.AdjacencyList::new(4)
  g.add_edge_undirected(0, 1, 1)
  g.add_edge_undirected(1, 2, 2)
  g.add_edge_undirected(2, 3, 1)
  let r = @algo.astar(g, 0, 3)
  assert_eq(r.cost, 4)
  assert_eq(r.path.length(), 4)
}

///|
test "full pipeline grid" {
  match @graph.Grid::from_strings(["S..", ".#.", "..E"]) {
    Some(grid) => {
      let start = grid.pos_to_id(0, 0)
      let goal = grid.pos_to_id(2, 2)
      let r = @algo.astar(grid, start, goal)
      assert_true(r.path.length() > 0)
      assert_eq(r.path[0], start)
      assert_eq(r.path[r.path.length() - 1], goal)
    }
    None => assert_true(false)
  }
}

// --- WeightedGrid integration ---

///|
test "weighted grid diag neighbors" {
  let cells = Array::make(9, true)
  let costs = Array::make(9, 1)
  let g = @graph.WeightedGrid::new(3, 3, cells, costs, true)
  let r = @algo.astar(g, 0, 8)
  assert_true(r.path.length() > 0)
}

///|
test "weighted grid pathfinding" {
  let cells = [true, true, true]
  let costs = [1, 10, 1]
  let g = @graph.WeightedGrid::new(3, 1, cells, costs, false)
  let r = @algo.dijkstra(g, 0, 2)
  // cost = costs[1]*10 + costs[2]*10 = 100+10 = 110
  assert_eq(r.cost, 110)
}

// --- HexGrid integration ---

///|
test "hex grid pathfinding" {
  let cells = Array::make(25, true)
  let g = @graph.HexGrid::new(5, 5, cells)
  let r = @algo.astar(g, 0, 24)
  assert_true(r.path.length() > 0)
}

// --- Maze integration ---

///|
test "dfs maze is solvable" {
  let lines = @maze.dfs_maze(8, 8, 123)
  match @graph.Grid::from_strings(lines) {
    Some(grid) => {
      let start = 0
      let goal = grid.width * grid.height - 1
      if grid.is_passable(start) && grid.is_passable(goal) {
        let r = @algo.astar(grid, start, goal)
        assert_true(r.path.length() > 0)
      }
    }
    None => assert_true(false)
  }
}

// --- JPS integration ---

///|
test "jps finds path in open grid" {
  let cells = Array::make(100, true)
  let g = @graph.Grid::new(10, 10, cells)
  let r = @algo.jps(g, 0, 99)
  assert_true(r.path.length() > 0)
}

///|
test "jps finds path with walls" {
  let lines = ["S..", ".#.", "..E"]
  match @graph.Grid::from_strings(lines) {
    Some(grid) => {
      let start = grid.pos_to_id(0, 0)
      let goal = grid.pos_to_id(2, 2)
      let r = @algo.jps(grid, start, goal)
      assert_true(r.path.length() > 0)
    }
    None => assert_true(false)
  }
}

// --- IDA* integration ---

///|
test "idastar finds path in open grid" {
  let cells = Array::make(100, true)
  let g = @graph.Grid::new(10, 10, cells)
  let r = @algo.idastar(g, 0, 99)
  assert_true(r.path.length() > 0)
}

///|
test "idastar finds path with walls" {
  let lines = ["S..", ".#.", "..E"]
  match @graph.Grid::from_strings(lines) {
    Some(grid) => {
      let start = grid.pos_to_id(0, 0)
      let goal = grid.pos_to_id(2, 2)
      let r = @algo.idastar(grid, start, goal)
      assert_true(r.path.length() > 0)
    }
    None => assert_true(false)
  }
}

// --- Benchmark integration ---

///|
test "benchmark compare all runs" {
  let cells = Array::make(100, true)
  let g = @graph.Grid::new(10, 10, cells)
  let results = @bench.compare_all(g, 0, 99)
  assert_eq(results.length(), 9)
}

///|
test "benchmark maze runs" {
  let report = @bench.maze_benchmark()
  assert_true(report.length() > 0)
}
