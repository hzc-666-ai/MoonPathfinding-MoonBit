///|
/// Whitebox tests for internal invariants.
test "grid pos roundtrip" {
  let cells = Array::make(12, true)
  let g = @graph.Grid::new(4, 3, cells)
  for id = 0; id < 12; id = id + 1 {
    let (r, c) = g.id_to_pos(id)
    assert_eq(g.pos_to_id(r, c), id)
  }
}
