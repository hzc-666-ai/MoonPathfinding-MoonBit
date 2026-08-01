///|
/// Tests for pathfinding algorithms.
fn make_simple_graph() -> @graph.AdjacencyList {
  let graph = @graph.AdjacencyList::new(3)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, 2)
  graph.add_edge(0, 2, 10)
  graph
}

///|
test "bfs uses the fewest edges" {
  let result = @algo.bfs(make_simple_graph(), 0, 2)
  assert_eq(result.path, [0, 2])
  assert_eq(result.cost, 1)
}

///|
test "bfs start equals goal" {
  let result = @algo.bfs(make_simple_graph(), 1, 1)
  assert_eq(result.path, [1])
  assert_eq(result.cost, 0)
}

///|
test "bfs reports no path" {
  let result = @algo.bfs(@graph.AdjacencyList::new(2), 0, 1)
  assert_eq(result.path, [])
  assert_eq(result.cost, 0)
}

///|
test "dfs finds a valid directed path" {
  let graph = @graph.AdjacencyList::new(3)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, 1)
  let result = @algo.dfs(graph, 0, 2)
  assert_eq(result.path, [0, 1, 2])
  assert_eq(result.cost, 2)
}

///|
test "dijkstra uses weighted cost" {
  let result = @algo.dijkstra(make_simple_graph(), 0, 2)
  assert_eq(result.path, [0, 1, 2])
  assert_eq(result.cost, 3)
}

///|
test "astar uses weighted cost" {
  let result = @algo.astar(make_simple_graph(), 0, 2)
  assert_eq(result.path, [0, 1, 2])
  assert_eq(result.cost, 3)
}

///|
test "greedy reports full selected path cost" {
  let graph = @graph.AdjacencyList::new(3)
  graph.add_edge(0, 1, 7)
  graph.add_edge(1, 2, 11)
  let result = @algo.greedy_bfs(graph, 0, 2)
  assert_eq(result.path, [0, 1, 2])
  assert_eq(result.cost, 18)
}

///|
test "bidirectional bfs supports directed graphs" {
  let graph = @graph.AdjacencyList::new(4)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, 1)
  graph.add_edge(2, 3, 1)
  let result = @algo.bidirectional_bfs(graph, 0, 3)
  assert_eq(result.path, [0, 1, 2, 3])
  assert_eq(result.cost, 3)
}

///|
test "bidirectional bfs respects edge direction" {
  let graph = @graph.AdjacencyList::new(3)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, 1)
  let result = @algo.bidirectional_bfs(graph, 2, 0)
  assert_eq(result.path, [])
}

///|
test "bidirectional bfs chooses the shortest meeting path" {
  let graph = @graph.AdjacencyList::new(7)
  graph.add_edge(0, 1, 1)
  graph.add_edge(0, 2, 1)
  graph.add_edge(1, 3, 1)
  graph.add_edge(3, 4, 1)
  graph.add_edge(4, 6, 1)
  graph.add_edge(2, 5, 1)
  graph.add_edge(5, 6, 1)
  let result = @algo.bidirectional_bfs(graph, 0, 6)
  assert_eq(result.path, [0, 2, 5, 6])
  assert_eq(result.cost, 3)
}

///|
test "bellman ford shortest path" {
  let result = @algo.bellman_ford(make_simple_graph(), 0, 2)
  assert_eq(result.path, [0, 1, 2])
  assert_eq(result.cost, 3)
}

///|
test "bellman ford preserves negative distances" {
  let graph = @graph.AdjacencyList::new(5)
  graph.add_edge(0, 1, 6)
  graph.add_edge(0, 2, 7)
  graph.add_edge(1, 2, 8)
  graph.add_edge(1, 3, 5)
  graph.add_edge(1, 4, -4)
  graph.add_edge(2, 3, -3)
  graph.add_edge(2, 4, 9)
  graph.add_edge(3, 1, -2)
  graph.add_edge(4, 3, 7)
  graph.add_edge(4, 0, 2)
  let result = @algo.bellman_ford(graph, 0, 4)
  assert_eq(result.path, [0, 2, 3, 1, 4])
  assert_eq(result.cost, -2)
}

///|
test "bellman ford rejects a reachable negative cycle" {
  let graph = @graph.AdjacencyList::new(4)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, -2)
  graph.add_edge(2, 1, -2)
  graph.add_edge(2, 3, 1)
  let result = @algo.bellman_ford(graph, 0, 3)
  assert_eq(result.path, [])
  assert_eq(result.cost, 0)
}

///|
test "bellman ford checks a negative cycle when start equals goal" {
  let graph = @graph.AdjacencyList::new(2)
  graph.add_edge(0, 1, -1)
  graph.add_edge(1, 0, -1)
  let result = @algo.bellman_ford(graph, 0, 0)
  assert_eq(result.path, [])
}

///|
test "bellman ford ignores an unreachable negative cycle" {
  let graph = @graph.AdjacencyList::new(5)
  graph.add_edge(0, 1, 2)
  graph.add_edge(1, 4, 3)
  graph.add_edge(2, 3, -2)
  graph.add_edge(3, 2, -2)
  let result = @algo.bellman_ford(graph, 0, 4)
  assert_eq(result.path, [0, 1, 4])
  assert_eq(result.cost, 5)
}
