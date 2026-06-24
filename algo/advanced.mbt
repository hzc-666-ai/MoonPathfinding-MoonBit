/// Advanced algorithms: Bidirectional BFS, Bellman-Ford.

/// Build a path when bidirectional BFS finds a meeting node.
fn build_bidir_path(
  f_parent : Array[Int],
  b_parent : Array[Int],
  meeting : Int,
  visited : Int
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
  let b_path : Array[Int] = []
  cur = b_parent[meeting]
  while cur != -1 {
    b_path.push(cur)
    cur = b_parent[cur]
  }
  let full : Array[Int] = []
  for j = 0; j < f_path.length(); j = j + 1 {
    full.push(f_path[j])
  }
  for j = 0; j < b_path.length(); j = j + 1 {
    full.push(b_path[j])
  }
  @graph.PathResult::{ path: full, cost: full.length() - 1, nodes_visited: visited }
}

/// Bidirectional BFS — searches from both start and goal simultaneously.
/// Guaranteed shortest path on unweighted graphs, often faster than BFS.
pub fn[G : @graph.Graph] bidirectional_bfs(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let f_visited = Array::make(n, false)
  let b_visited = Array::make(n, false)
  let f_parent = Array::make(n, -1)
  let b_parent = Array::make(n, -1)

  f_visited[start] = true
  b_visited[goal] = true

  let fq : Array[Int] = [start]
  let bq : Array[Int] = [goal]
  let mut f_head : Int = 0
  let mut b_head : Int = 0
  let mut visited : Int = 2

  while f_head < fq.length() && b_head < bq.length() {
    let f_node = fq[f_head]
    f_head = f_head + 1
    let f_nbs = @graph.Graph::neighbors(graph, f_node)
    for i = 0; i < f_nbs.length(); i = i + 1 {
      let (nb, _) = f_nbs[i]
      if !f_visited[nb] {
        f_visited[nb] = true
        f_parent[nb] = f_node
        visited = visited + 1
        if b_visited[nb] {
          return build_bidir_path(f_parent, b_parent, nb, visited)
        }
        fq.push(nb)
      }
    }

    let b_node = bq[b_head]
    b_head = b_head + 1
    let b_nbs = @graph.Graph::neighbors(graph, b_node)
    for i = 0; i < b_nbs.length(); i = i + 1 {
      let (nb, _) = b_nbs[i]
      if !b_visited[nb] {
        b_visited[nb] = true
        b_parent[nb] = b_node
        visited = visited + 1
        if f_visited[nb] {
          return build_bidir_path(f_parent, b_parent, nb, visited)
        }
        bq.push(nb)
      }
    }
  }

  @graph.PathResult::{ path: [], cost: 0, nodes_visited: visited }
}

/// Bellman-Ford algorithm — shortest path with possible negative edge weights.
/// Detects negative cycles reachable from start.
pub fn[G : @graph.Graph] bellman_ford(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let dist = Array::make(n, -1)
  let parent = Array::make(n, -1)
  dist[start] = 0
  let mut nodes : Int = 1

  for k = 0; k < n - 1; k = k + 1 {
    let mut updated = false
    for u = 0; u < n; u = u + 1 {
      let du = dist[u]
      if du < 0 {
        continue
      }
      let nbs = @graph.Graph::neighbors(graph, u)
      for i = 0; i < nbs.length(); i = i + 1 {
        let (v, w) = nbs[i]
        let new_dist = du + w
        let dv = dist[v]
        if dv < 0 || new_dist < dv {
          dist[v] = new_dist
          parent[v] = u
          updated = true
          nodes = nodes + 1
        }
      }
    }
    if !updated {
      break
    }
  }

  let dg = dist[goal]
  if dg < 0 {
    return @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
  }

  @graph.PathResult::{ path: rebuild_path(parent, goal), cost: dg, nodes_visited: nodes }
}
