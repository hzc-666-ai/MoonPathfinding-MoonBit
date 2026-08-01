/// Advanced algorithms: bidirectional BFS and Bellman-Ford.

///|
/// Build a path when bidirectional BFS finds a meeting node.
fn build_bidir_path(
  f_parent : Array[Int],
  b_parent : Array[Int],
  meeting : Int,
  visited : Int,
) -> @graph.PathResult {
  let f_temp : Array[Int] = []
  let mut cur = meeting
  while cur != -1 {
    f_temp.push(cur)
    cur = f_parent[cur]
  }
  let f_path : Array[Int] = []
  let mut i = f_temp.length() - 1
  while i >= 0 {
    f_path.push(f_temp[i])
    i = i - 1
  }
  let full : Array[Int] = []
  for node in f_path {
    full.push(node)
  }
  cur = b_parent[meeting]
  while cur != -1 {
    full.push(cur)
    cur = b_parent[cur]
  }
  @graph.PathResult::{
    path: full,
    cost: full.length() - 1,
    nodes_visited: visited,
  }
}

///|
/// Search from both ends of an unweighted graph.
/// The reverse frontier follows incoming edges, so directed graphs are supported.
pub fn[G : @graph.Graph] bidirectional_bfs(
  graph : G,
  start : Int,
  goal : Int,
) -> @graph.PathResult {
  let n = @graph.Graph::node_count(graph)
  if start < 0 || start >= n || goal < 0 || goal >= n {
    return @graph.PathResult::{ path: [], cost: 0, nodes_visited: 0 }
  }
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }

  let reverse : Array[Array[Int]] = Array::make(n, [])
  for i = 0; i < n; i = i + 1 {
    reverse[i] = []
  }
  for u = 0; u < n; u = u + 1 {
    for edge in @graph.Graph::neighbors(graph, u) {
      let (v, _) = edge
      reverse[v].push(u)
    }
  }

  let f_distance = Array::make(n, -1)
  let b_distance = Array::make(n, -1)
  let f_parent = Array::make(n, -1)
  let b_parent = Array::make(n, -1)
  let forward_queue : Array[Int] = [start]
  let backward_queue : Array[Int] = [goal]
  f_distance[start] = 0
  b_distance[goal] = 0

  let mut head = 0
  while head < forward_queue.length() {
    let node = forward_queue[head]
    head = head + 1
    for edge in @graph.Graph::neighbors(graph, node) {
      let (next, _) = edge
      if f_distance[next] == -1 {
        f_distance[next] = f_distance[node] + 1
        f_parent[next] = node
        forward_queue.push(next)
      }
    }
  }

  head = 0
  while head < backward_queue.length() {
    let node = backward_queue[head]
    head = head + 1
    for predecessor in reverse[node] {
      if b_distance[predecessor] == -1 {
        b_distance[predecessor] = b_distance[node] + 1
        b_parent[predecessor] = node
        backward_queue.push(predecessor)
      }
    }
  }

  let mut meeting = -1
  let mut best_distance = -1
  let mut visited = 0
  for node = 0; node < n; node = node + 1 {
    if f_distance[node] >= 0 || b_distance[node] >= 0 {
      visited = visited + 1
    }
    if f_distance[node] >= 0 && b_distance[node] >= 0 {
      let distance = f_distance[node] + b_distance[node]
      if best_distance == -1 || distance < best_distance {
        meeting = node
        best_distance = distance
      }
    }
  }
  if meeting == -1 {
    return @graph.PathResult::{ path: [], cost: 0, nodes_visited: visited }
  }
  build_bidir_path(f_parent, b_parent, meeting, visited)
}

///|
/// Find a shortest path in a graph that may contain negative edge weights.
/// An empty path is returned if a negative cycle is reachable from the start.
pub fn[G : @graph.Graph] bellman_ford(
  graph : G,
  start : Int,
  goal : Int,
) -> @graph.PathResult {
  let n = @graph.Graph::node_count(graph)
  if start < 0 || start >= n || goal < 0 || goal >= n {
    return @graph.PathResult::{ path: [], cost: 0, nodes_visited: 0 }
  }

  let dist = Array::make(n, 0)
  let reachable = Array::make(n, false)
  let parent = Array::make(n, -1)
  reachable[start] = true
  let mut nodes = 1

  for round = 0; round < n - 1; round = round + 1 {
    let mut updated = false
    for u = 0; u < n; u = u + 1 {
      if !reachable[u] {
        continue
      }
      for edge in @graph.Graph::neighbors(graph, u) {
        let (v, weight) = edge
        let candidate = dist[u] + weight
        if !reachable[v] || candidate < dist[v] {
          if !reachable[v] {
            reachable[v] = true
            nodes = nodes + 1
          }
          dist[v] = candidate
          parent[v] = u
          updated = true
        }
      }
    }
    if !updated {
      break
    }
  }

  for u = 0; u < n; u = u + 1 {
    if !reachable[u] {
      continue
    }
    for edge in @graph.Graph::neighbors(graph, u) {
      let (v, weight) = edge
      if !reachable[v] || dist[u] + weight < dist[v] {
        return @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
      }
    }
  }

  if !reachable[goal] {
    return @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
  }
  @graph.PathResult::{
    path: rebuild_path(parent, goal),
    cost: dist[goal],
    nodes_visited: nodes,
  }
}
