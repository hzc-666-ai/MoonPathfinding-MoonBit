///|
/// Tests for HexGrid.
test "hex grid pos conversion" {
  let cells = Array::make(12, true)
  let g = @graph.HexGrid::new(4, 3, cells)
  assert_eq(g.pos_to_id(0, 0), 0)
  assert_eq(g.pos_to_id(1, 2), 6)
  assert_eq(g.id_to_pos(6), (1, 2))
}

///|
test "hex grid is_passable" {
  let cells = [true, false, true, true]
  let g = @graph.HexGrid::new(2, 2, cells)
  assert_true(g.is_passable(0))
  assert_false(g.is_passable(1))
}

///|
test "hex grid from strings" {
  match @graph.HexGrid::from_strings(["...", "...", "..."]) {
    Some(g) => assert_eq(g.pos_to_id(0, 0), 0)
    None => assert_true(false)
  }
}
