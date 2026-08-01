///|
/// Strict tests for Jump Point Search.
fn jps_test_grid() -> @graph.Grid {
  @graph.Grid::new(10, 10, Array::make(100, true))
}

///|
fn is_continuous_and_passable(grid : @graph.Grid, path : Array[Int]) -> Bool {
  for i = 1; i < path.length(); i = i + 1 {
    let (previous_row, previous_col) = grid.id_to_pos(path[i - 1])
    let (row, col) = grid.id_to_pos(path[i])
    let row_delta = (row - previous_row).abs()
    let col_delta = (col - previous_col).abs()
    if row_delta > 1 || col_delta > 1 || row_delta + col_delta == 0 {
      return false
    }
    if !grid.is_passable(path[i]) {
      return false
    }
  }
  true
}

///|
fn expanded_path_cost(grid : @graph.Grid, path : Array[Int]) -> Int {
  let mut total = 0
  for i = 1; i < path.length(); i = i + 1 {
    let (previous_row, previous_col) = grid.id_to_pos(path[i - 1])
    let (row, col) = grid.id_to_pos(path[i])
    if row != previous_row && col != previous_col {
      total = total + 14
    } else {
      total = total + 10
    }
  }
  total
}

///|
test "jps expands an open diagonal path" {
  let grid = jps_test_grid()
  let result = @algo.jps(grid, 0, 99)
  assert_eq(result.path, [0, 11, 22, 33, 44, 55, 66, 77, 88, 99])
  assert_eq(result.cost, 126)
  assert_eq(expanded_path_cost(grid, result.path), result.cost)
  assert_eq(is_continuous_and_passable(grid, result.path), true)
}

///|
test "jps start equals goal" {
  let result = @algo.jps(jps_test_grid(), 42, 42)
  assert_eq(result.path, [42])
  assert_eq(result.cost, 0)
}

///|
test "jps expands a straight jump" {
  let grid = jps_test_grid()
  let result = @algo.jps(grid, 0, 9)
  assert_eq(result.path, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  assert_eq(result.cost, 90)
  assert_eq(expanded_path_cost(grid, result.path), result.cost)
  assert_eq(is_continuous_and_passable(grid, result.path), true)
}

///|
test "jps obstacle path stays continuous and passable" {
  let lines = ["S.........", ".#######..", "........E."]
  match @graph.Grid::from_strings(lines) {
    Some(grid) => {
      let start = grid.pos_to_id(0, 0)
      let goal = grid.pos_to_id(2, 8)
      let result = @algo.jps(grid, start, goal)
      assert_eq(result.path.length() > 0, true)
      assert_eq(result.path[0], start)
      assert_eq(result.path[result.path.length() - 1], goal)
      assert_eq(expanded_path_cost(grid, result.path), result.cost)
      assert_eq(is_continuous_and_passable(grid, result.path), true)
    }
    None => fail("valid grid fixture failed to parse")
  }
}
