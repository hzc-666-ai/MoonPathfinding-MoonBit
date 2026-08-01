/// IDA* — Iterative Deepening A* search.

///|
/// Result of one depth-bounded DFS step.
priv struct BoundResult {
  found : Bool
  next_bound : Int
  count : Int
}

///|
/// Depth-limited DFS for IDA*. Uses parent array for path reconstruction.
fn[G : @graph.Graph] dfs_bound(
  graph : G,
  node : Int,
  g : Int,
  threshold : Int,
  goal : Int,
  parent : Array[Int],
) -> BoundResult {
  let f = g + @graph.Graph::heuristic(graph, node, goal)

  if f > threshold {
    return { found: false, next_bound: f, count: 0 }
  }

  if node == goal {
    return { found: true, next_bound: 0, count: 0 }
  }

  let nbs = @graph.Graph::neighbors(graph, node)
  let mut best_bound : Int = -1
  let mut total_count : Int = 1

  for i = 0; i < nbs.length(); i = i + 1 {
    let (nb, cost) = nbs[i]
    if parent[nb] != -1 {
      continue
    }
    parent[nb] = node
    let sub = dfs_bound(graph, nb, g + cost, threshold, goal, parent)
    total_count = total_count + sub.count
    if sub.found {
      return { found: true, next_bound: 0, count: total_count }
    }
    parent[nb] = -1
    if best_bound < 0 || sub.next_bound < best_bound {
      best_bound = sub.next_bound
    }
  }

  { found: false, next_bound: best_bound, count: total_count }
}

///|
/// IDA* pathfinding — memory-efficient, good for large state spaces.
pub fn[G : @graph.Graph] idastar(
  graph : G,
  start : Int,
  goal : Int,
) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }

  let n = @graph.Graph::node_count(graph)
  let mut threshold = @graph.Graph::heuristic(graph, start, goal)
  let mut total_nodes : Int = 0

  while threshold >= 0 {
    let parent = Array::make(n, -1)
    parent[start] = -2
    let result = dfs_bound(graph, start, 0, threshold, goal, parent)

    total_nodes = total_nodes + result.count
    if result.found {
      let (path, cost) = rebuild_path_ida_with_cost(graph, parent, start, goal)
      return @graph.PathResult::{ path, cost, nodes_visited: total_nodes }
    }
    if result.next_bound < 0 {
      break
    }
    threshold = result.next_bound
  }

  @graph.PathResult::{ path: [], cost: 0, nodes_visited: total_nodes }
}

///|
fn[G : @graph.Graph] rebuild_path_ida_with_cost(
  graph : G,
  parent : Array[Int],
  start : Int,
  goal : Int,
) -> (Array[Int], Int) {
  let temp : Array[Int] = []
  let mut cur = goal
  while cur != start {
    temp.push(cur)
    cur = parent[cur]
  }
  temp.push(start)
  let path : Array[Int] = []
  let mut i = temp.length() - 1
  while i >= 0 {
    path.push(temp[i])
    i = i - 1
  }
  // Compute cost from edge weights
  let mut cost : Int = 0
  for k = 0; k < path.length() - 1; k = k + 1 {
    let u = path[k]
    let v = path[k + 1]
    let nbs = @graph.Graph::neighbors(graph, u)
    for j = 0; j < nbs.length(); j = j + 1 {
      let (nb, w) = nbs[j]
      if nb == v {
        cost = cost + w
        break
      }
    }
  }
  (path, cost)
}
