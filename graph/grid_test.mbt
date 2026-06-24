/// Tests for Grid.

test "grid new" {
  let cells = Array::make(4, true)
  let g = @graph.Grid::new(2, 2, cells)
  assert_eq(@graph.Graph::node_count(g), 4)
}

test "grid pos_to_id" {
  let cells = Array::make(6, true)
  let g = @graph.Grid::new(3, 2, cells)
  assert_eq(g.pos_to_id(0, 0), 0)
  assert_eq(g.pos_to_id(0, 2), 2)
  assert_eq(g.pos_to_id(1, 0), 3)
}

test "grid id_to_pos" {
  let cells = Array::make(4, true)
  let g = @graph.Grid::new(2, 2, cells)
  assert_eq(g.id_to_pos(0), (0, 0))
  assert_eq(g.id_to_pos(1), (0, 1))
  assert_eq(g.id_to_pos(2), (1, 0))
  assert_eq(g.id_to_pos(3), (1, 1))
}

test "grid is_passable" {
  let cells = [true, false, true, true]
  let g = @graph.Grid::new(2, 2, cells)
  assert_true(g.is_passable(0))
  assert_false(g.is_passable(1))
  assert_true(g.is_passable(2))
  assert_false(g.is_passable(-1))
  assert_false(g.is_passable(100))
}

test "grid neighbors center" {
  let cells = Array::make(9, true)
  let g = @graph.Grid::new(3, 3, cells)
  let nbs = @graph.Graph::neighbors(g, 4)
  assert_eq(nbs.length(), 4)
}

test "grid neighbors corner" {
  let cells = Array::make(9, true)
  let g = @graph.Grid::new(3, 3, cells)
  let nbs = @graph.Graph::neighbors(g, 0)
  assert_eq(nbs.length(), 2)
}

test "grid neighbors blocked" {
  let cells = Array::make(9, true)
  cells[1] = false
  cells[3] = false
  let g = @graph.Grid::new(3, 3, cells)
  let nbs = @graph.Graph::neighbors(g, 0)
  assert_eq(nbs.length(), 0)
}

test "grid manhattan heuristic" {
  let cells = Array::make(9, true)
  let g = @graph.Grid::new(3, 3, cells)
  assert_eq(@graph.Graph::heuristic(g, 0, 8), 4)
  assert_eq(@graph.Graph::heuristic(g, 0, 2), 2)
}

test "grid from_strings" {
  let lines = ["S.#", "...", "#.E"]
  match @graph.Grid::from_strings(lines) {
    Some(g) => {
      assert_eq(@graph.Graph::node_count(g), 9)
      assert_true(g.is_passable(0))
      assert_false(g.is_passable(2))
      assert_true(g.is_passable(8))
    }
    None => assert_true(false)
  }
}

test "grid from_strings invalid" {
  let lines = ["ab", "c"]
  match @graph.Grid::from_strings(lines) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "grid find marker" {
  let lines = ["S.#", "...", "#.E"]
  assert_eq(@graph.Grid::find_marker(lines, "S"), Some((0, 0)))
  assert_eq(@graph.Grid::find_marker(lines, "E"), Some((2, 2)))
  assert_eq(@graph.Grid::find_marker(lines, "X"), None)
}
