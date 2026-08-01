///|
/// Tests for AdjacencyList.
test "adjacency list new" {
  let g = @graph.AdjacencyList::new(5)
  assert_eq(@graph.Graph::node_count(g), 5)
}

///|
test "adjacency list add edge" {
  let g = @graph.AdjacencyList::new(3)
  g.add_edge(0, 1, 5)
  let nbs = @graph.Graph::neighbors(g, 0)
  assert_eq(nbs.length(), 1)
  assert_eq(nbs[0].0, 1)
  assert_eq(nbs[0].1, 5)
}

///|
test "adjacency list undirected edge" {
  let g = @graph.AdjacencyList::new(3)
  g.add_edge_undirected(0, 1, 3)
  assert_eq(@graph.Graph::neighbors(g, 0).length(), 1)
  assert_eq(@graph.Graph::neighbors(g, 1).length(), 1)
}

///|
test "adjacency list out of bounds" {
  let g = @graph.AdjacencyList::new(3)
  let nbs = @graph.Graph::neighbors(g, 100)
  assert_eq(nbs.length(), 0)
}

///|
test "adjacency list heuristic" {
  let g = @graph.AdjacencyList::new(3)
  assert_eq(@graph.Graph::heuristic(g, 0, 2), 0)
}
