///|
/// Tests for WeightedGrid.
test "weighted grid pos conversion" {
  let cells = Array::make(9, true)
  let costs = Array::make(9, 1)
  let g = @graph.WeightedGrid::new(3, 3, cells, costs, false)
  assert_eq(g.pos_to_id(0, 0), 0)
  assert_eq(g.pos_to_id(2, 2), 8)
  assert_eq(g.id_to_pos(4), (1, 1))
}

///|
test "weighted grid cell costs" {
  let cells = Array::make(4, true)
  let costs = [1, 5, 3, 2]
  let g = @graph.WeightedGrid::new(2, 2, cells, costs, false)
  assert_eq(g.cell_cost(0), 1)
  assert_eq(g.cell_cost(1), 5)
  assert_eq(g.cell_cost(3), 2)
}

///|
test "weighted grid from strings" {
  let lines = ["..,", ".;="]
  match @graph.WeightedGrid::from_strings(lines, false) {
    Some(g) => {
      assert_eq(g.cell_cost(0), 1)
      assert_eq(g.cell_cost(2), 2)
    }
    None => assert_true(false)
  }
}
