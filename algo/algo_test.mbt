/// Tests for pathfinding algorithms.

// --- Helper: build a simple graph for testing ---

fn make_simple_graph() -> @graph.AdjacencyList {
  let g = @graph.AdjacencyList::new(3)
  g.add_edge(0, 1, 1)
  g.add_edge(1, 2, 2)
  g.add_edge(0, 2, 10)
  g
}

// --- BFS ---

test "bfs simple graph" {
  let g = make_simple_graph()
  let r = @algo.bfs(g, 0, 2)
  // 0->2 direct edge is shorter (1 edge) than 0->1->2 (2 edges)
  assert_eq(r.path.length(), 2)
  assert_eq(r.path[0], 0)
  assert_eq(r.path[1], 2)
}

test "bfs start equals goal" {
  let g = make_simple_graph()
  let r = @algo.bfs(g, 1, 1)
  assert_eq(r.path, [1])
  assert_eq(r.cost, 0)
}

test "bfs no path" {
  let g = @graph.AdjacencyList::new(2)
  let r = @algo.bfs(g, 0, 1)
  assert_eq(r.path.length(), 0)
}

// --- DFS ---

test "dfs finds path" {
  let g = make_simple_graph()
  let r = @algo.dfs(g, 0, 2)
  assert_true(r.path.length() > 0)
  assert_eq(r.path[0], 0)
  assert_eq(r.path[r.path.length() - 1], 2)
}

test "dfs start equals goal" {
  let g = make_simple_graph()
  let r = @algo.dfs(g, 0, 0)
  assert_eq(r.path, [0])
}

// --- Dijkstra ---

test "dijkstra shortest path weighted" {
  let g = make_simple_graph()
  let r = @algo.dijkstra(g, 0, 2)
  assert_eq(r.path, [0, 1, 2])
  assert_eq(r.cost, 3)
}

// --- A* ---

test "astar shortest path" {
  let g = make_simple_graph()
  let r = @algo.astar(g, 0, 2)
  assert_eq(r.path, [0, 1, 2])
  assert_eq(r.cost, 3)
}

// --- Greedy BFS ---

test "greedy bfs finds path" {
  let g = make_simple_graph()
  let r = @algo.greedy_bfs(g, 0, 2)
  assert_true(r.path.length() > 0)
  assert_eq(r.path[0], 0)
  assert_eq(r.path[r.path.length() - 1], 2)
}

// --- Bidirectional BFS ---

test "bidirectional bfs shortest path" {
  let g = make_simple_graph()
  let r = @algo.bidirectional_bfs(g, 0, 2)
  assert_eq(r.path.length(), 2)
}

// --- Bellman-Ford ---

test "bellman ford shortest path" {
  let g = make_simple_graph()
  let r = @algo.bellman_ford(g, 0, 2)
  assert_eq(r.path, [0, 1, 2])
  assert_eq(r.cost, 3)
}

test "bellman ford negative weights" {
  let g = @graph.AdjacencyList::new(5)
  g.add_edge(0, 1, 6)
  g.add_edge(0, 2, 7)
  g.add_edge(1, 2, 8)
  g.add_edge(1, 3, 5)
  g.add_edge(1, 4, -4)
  g.add_edge(2, 3, -3)
  g.add_edge(2, 4, 9)
  g.add_edge(3, 1, -2)
  g.add_edge(4, 3, 7)
  g.add_edge(4, 0, 2)
  let r = @algo.bellman_ford(g, 0, 4)
  assert_true(r.path.length() > 0)
  assert_eq(r.path[0], 0)
  assert_eq(r.path[r.path.length() - 1], 4)
}
