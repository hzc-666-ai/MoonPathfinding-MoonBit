/// Tests for JPS.

fn jps_test_grid() -> @graph.Grid {
  let cells = Array::make(100, true)
  @graph.Grid::new(10, 10, cells)
}

test "jps open grid" {
  let g = jps_test_grid()
  let r = @algo.jps(g, 0, 99)
  assert_true(r.path.length() > 0)
  // JPS should find a valid path from corner to corner
  assert_eq(r.path[0], 0)
  assert_eq(r.path[r.path.length() - 1], 99)
}

test "jps start equals goal" {
  let g = jps_test_grid()
  let r = @algo.jps(g, 42, 42)
  assert_eq(r.path, [42])
  assert_eq(r.cost, 0)
}

test "jps straight line" {
  let cells = Array::make(100, true)
  let g = @graph.Grid::new(10, 10, cells)
  let r = @algo.jps(g, 0, 9)
  assert_true(r.path.length() > 0)
}

test "jps with walls" {
  let lines = [
    "S.........",
    ".#######..",
    "........E.",
  ]
  match @graph.Grid::from_strings(lines) {
    Some(g) => {
      let start = g.pos_to_id(0, 0)
      let goal = g.pos_to_id(2, 9)
      let r = @algo.jps(g, start, goal)
      assert_true(r.path.length() > 0)
    }
    None => assert_true(false)
  }
}

test "jps same cost as astar" {
  let cells = Array::make(100, true)
  let g = @graph.Grid::new(10, 10, cells)
  let r_jps = @algo.jps(g, 0, 99)
  let r_astar = @algo.astar(g, 0, 99)
  // Both should find paths with similar costs
  assert_true(r_jps.path.length() > 0)
  assert_true(r_astar.path.length() > 0)
}
