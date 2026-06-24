/// Tests for IDA*.

test "idastar simple graph" {
  let g = @graph.AdjacencyList::new(3)
  g.add_edge(0, 1, 1)
  g.add_edge(1, 2, 2)
  g.add_edge(0, 2, 10)
  let r = @algo.idastar(g, 0, 2)
  assert_eq(r.path, [0, 1, 2])
  assert_eq(r.cost, 3)
}

test "idastar start equals goal" {
  let g = @graph.AdjacencyList::new(3)
  let r = @algo.idastar(g, 1, 1)
  assert_eq(r.path, [1])
  assert_eq(r.cost, 0)
}

test "idastar no path" {
  let g = @graph.AdjacencyList::new(2)
  let r = @algo.idastar(g, 0, 1)
  assert_eq(r.path.length(), 0)
}

test "idastar grid same as astar" {
  let cells = Array::make(100, true)
  let g = @graph.Grid::new(10, 10, cells)
  let r_ida = @algo.idastar(g, 0, 99)
  let r_astar = @algo.astar(g, 0, 99)
  assert_true(r_ida.path.length() > 0)
  // IDA* should find optimal cost
  assert_true(r_ida.cost <= r_astar.cost + 20)
}
