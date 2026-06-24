/// Pathfinding algorithms: BFS, DFS, Dijkstra, A*, Greedy BFS.

/// Rebuild the path from start -> goal using parent array.
fn rebuild_path(parent : Array[Int], goal : Int) -> Array[Int] {
  let temp : Array[Int] = []
  let mut cur = goal
  while cur != -1 {
    temp.push(cur)
    cur = parent[cur]
  }
  let path : Array[Int] = []
  let mut i = temp.length() - 1
  while i >= 0 {
    path.push(temp[i])
    i = i - 1
  }
  path
}

/// Breadth-First Search — guaranteed shortest path on unweighted graphs.
pub fn[G : @graph.Graph] bfs(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let visited = Array::make(n, false)
  let parent = Array::make(n, -1)
  let queue : Array[Int] = [start]
  visited[start] = true
  let mut head : Int = 0
  let mut nodes : Int = 1

  while head < queue.length() {
    let node = queue[head]
    head = head + 1
    let nbs = @graph.Graph::neighbors(graph, node)
    for i = 0; i < nbs.length(); i = i + 1 {
      let (nb, _) = nbs[i]
      if !visited[nb] {
        visited[nb] = true
        parent[nb] = node
        nodes = nodes + 1
        if nb == goal {
          return @graph.PathResult::{ path: rebuild_path(parent, goal), cost: rebuild_path(parent, goal).length() - 1, nodes_visited: nodes }
        }
        queue.push(nb)
      }
    }
  }
  @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
}

/// Depth-First Search — not guaranteed to find the shortest path.
pub fn[G : @graph.Graph] dfs(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let visited = Array::make(n, false)
  let parent = Array::make(n, -1)
  let stack : Array[Int] = [start]
  let mut nodes : Int = 0

  while stack.length() > 0 {
    match stack.pop() {
      Some(node) => {
        if visited[node] {
          continue
        }
        visited[node] = true
        nodes = nodes + 1
        if node == goal {
          return @graph.PathResult::{ path: rebuild_path(parent, goal), cost: rebuild_path(parent, goal).length() - 1, nodes_visited: nodes }
        }
        let nbs = @graph.Graph::neighbors(graph, node)
        for i = 0; i < nbs.length(); i = i + 1 {
          let (nb, _) = nbs[i]
          if !visited[nb] {
            parent[nb] = node
            stack.push(nb)
          }
        }
      }
      None => break
    }
  }
  @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
}

/// Dijkstra's algorithm — shortest path on weighted graphs (non-negative weights).
pub fn[G : @graph.Graph] dijkstra(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let dist = Array::make(n, -1)
  let parent = Array::make(n, -1)
  let heap = MinHeap::new()
  dist[start] = 0
  heap.push((0, 0, start))
  let mut nodes : Int = 1

  while !heap.is_empty() {
    match heap.pop() {
      Some((_d, g, node)) => {
        let d = dist[node]
        if g > d && d >= 0 {
          continue
        }
        if node == goal {
          return @graph.PathResult::{ path: rebuild_path(parent, goal), cost: dist[goal], nodes_visited: nodes }
        }
        let nbs = @graph.Graph::neighbors(graph, node)
        for i = 0; i < nbs.length(); i = i + 1 {
          let (nb, cost) = nbs[i]
          let cur_d = dist[node]
          if cur_d < 0 {
            continue
          }
          let new_dist = cur_d + cost
          let nb_d = dist[nb]
          if nb_d < 0 || new_dist < nb_d {
            dist[nb] = new_dist
            parent[nb] = node
            nodes = nodes + 1
            heap.push((new_dist, new_dist, nb))
          }
        }
      }
      None => break
    }
  }
  @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
}

/// A* search — informed shortest path using heuristic.
pub fn[G : @graph.Graph] astar(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let dist = Array::make(n, -1)
  let parent = Array::make(n, -1)
  let heap = MinHeap::new()
  dist[start] = 0
  let h0 = @graph.Graph::heuristic(graph, start, goal)
  heap.push((h0, 0, start))
  let mut nodes : Int = 1

  while !heap.is_empty() {
    match heap.pop() {
      Some((_f, g, node)) => {
        let d = dist[node]
        if g > d && d >= 0 {
          continue
        }
        if node == goal {
          return @graph.PathResult::{ path: rebuild_path(parent, goal), cost: dist[goal], nodes_visited: nodes }
        }
        let nbs = @graph.Graph::neighbors(graph, node)
        for i = 0; i < nbs.length(); i = i + 1 {
          let (nb, cost) = nbs[i]
          let cur_d = dist[node]
          if cur_d < 0 {
            continue
          }
          let new_g = cur_d + cost
          let nb_d = dist[nb]
          if nb_d < 0 || new_g < nb_d {
            dist[nb] = new_g
            parent[nb] = node
            let f_val = new_g + @graph.Graph::heuristic(graph, nb, goal)
            heap.push((f_val, new_g, nb))
            nodes = nodes + 1
          }
        }
      }
      None => break
    }
  }
  @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
}

/// Greedy Best-First Search — uses only heuristic, ignores edge costs.
pub fn[G : @graph.Graph] greedy_bfs(graph : G, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let n = @graph.Graph::node_count(graph)
  let visited = Array::make(n, false)
  let parent = Array::make(n, -1)
  let heap = MinHeap::new()
  visited[start] = true
  let h0 = @graph.Graph::heuristic(graph, start, goal)
  heap.push((h0, 0, start))
  let mut nodes : Int = 1

  while !heap.is_empty() {
    match heap.pop() {
      Some((_h, _g, node)) => {
        if node == goal {
          return @graph.PathResult::{ path: rebuild_path(parent, goal), cost: rebuild_path(parent, goal).length() - 1, nodes_visited: nodes }
        }
        let nbs = @graph.Graph::neighbors(graph, node)
        for i = 0; i < nbs.length(); i = i + 1 {
          let (nb, _) = nbs[i]
          if !visited[nb] {
            visited[nb] = true
            parent[nb] = node
            nodes = nodes + 1
            let h_val = @graph.Graph::heuristic(graph, nb, goal)
            heap.push((h_val, 0, nb))
          }
        }
      }
      None => break
    }
  }
  @graph.PathResult::{ path: [], cost: 0, nodes_visited: nodes }
}
