/// Core types for pathfinding.

/// Result of a pathfinding search.
pub(all) struct PathResult {
  path : Array[Int]
  cost : Int
  nodes_visited : Int
}

/// Graph abstraction — any graph that can be searched.
pub trait Graph {
  node_count(Self) -> Int
  neighbors(Self, Int) -> Array[(Int, Int)]
  heuristic(Self, Int, Int) -> Int
}

/// Adjacency-list representation for general weighted/unweighted graphs.
pub(all) struct AdjacencyList {
  mut adj : Array[Array[(Int, Int)]]
}

/// Create a new adjacency list with `n` nodes.
pub fn AdjacencyList::new(n : Int) -> AdjacencyList {
  let adj : Array[Array[(Int, Int)]] = Array::make(n, [])
  for i = 0; i < n; i = i + 1 {
    adj[i] = []
  }
  { adj: adj }
}

/// Add a directed edge u -> v with cost.
pub fn AdjacencyList::add_edge(self : AdjacencyList, u : Int, v : Int, cost : Int) -> Unit {
  if u >= 0 && u < self.adj.length() {
    self.adj[u].push((v, cost))
  }
}

/// Add an undirected edge u <-> v with cost.
pub fn AdjacencyList::add_edge_undirected(self : AdjacencyList, u : Int, v : Int, cost : Int) -> Unit {
  self.add_edge(u, v, cost)
  self.add_edge(v, u, cost)
}

pub impl Graph for AdjacencyList with node_count(self) -> Int {
  self.adj.length()
}

pub impl Graph for AdjacencyList with neighbors(self, node : Int) -> Array[(Int, Int)] {
  if node >= 0 && node < self.adj.length() {
    self.adj[node]
  } else {
    []
  }
}

pub impl Graph for AdjacencyList with heuristic(_self, _from : Int, _to : Int) -> Int {
  0
}
