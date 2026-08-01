/// Path smoothing and expansion utilities.

///|
/// Remove waypoints using a caller-provided line-of-sight predicate.
/// The predicate must return true when the two nodes can be connected directly.
pub fn smooth_path(
  path : Array[Int],
  line_of_sight : (Int, Int) -> Bool,
) -> Array[Int] {
  if path.length() <= 2 {
    return path
  }
  let result : Array[Int] = [path[0]]
  let mut anchor = 0
  while anchor < path.length() - 1 {
    let mut furthest = anchor + 1
    let mut candidate = path.length() - 1
    while candidate > anchor + 1 {
      if line_of_sight(path[anchor], path[candidate]) {
        furthest = candidate
        break
      }
      candidate = candidate - 1
    }
    result.push(path[furthest])
    anchor = furthest
  }
  result
}

///|
fn path_range_passable(
  path : Array[Int],
  from : Int,
  to : Int,
  is_passable : (Int) -> Bool,
) -> Bool {
  for i = from; i <= to; i = i + 1 {
    if !is_passable(path[i]) {
      return false
    }
  }
  true
}

///|
/// Compatibility helper for callers that only have a node-passability predicate.
/// For geometric smoothing, prefer smooth_path and provide line-of-sight checks.
pub fn simplify_path(
  path : Array[Int],
  is_passable : (Int) -> Bool,
) -> Array[Int] {
  if path.length() <= 2 {
    return path
  }
  let result : Array[Int] = [path[0]]
  let mut anchor = 0
  while anchor < path.length() - 1 {
    let mut furthest = anchor + 1
    let mut candidate = path.length() - 1
    while candidate > anchor + 1 {
      if path_range_passable(path, anchor, candidate, is_passable) {
        furthest = candidate
        break
      }
      candidate = candidate - 1
    }
    result.push(path[furthest])
    anchor = furthest
  }
  result
}

///|
/// Remove nodes that are closer than min_dist to the previous kept node.
pub fn decimate_path(path : Array[Int], min_dist : Int) -> Array[Int] {
  if path.length() <= 1 {
    return path
  }
  let result : Array[Int] = [path[0]]
  let mut last = path[0]
  for i = 1; i < path.length(); i = i + 1 {
    let dist = (path[i] - last).abs()
    if dist >= min_dist {
      result.push(path[i])
      last = path[i]
    }
  }
  let final_node = path[path.length() - 1]
  if result[result.length() - 1] != final_node {
    result.push(final_node)
  }
  result
}

///|
fn index_of_node(nodes : Array[Int], target : Int) -> Int {
  for i = 0; i < nodes.length(); i = i + 1 {
    if nodes[i] == target {
      return i
    }
  }
  -1
}

///|
fn connect_waypoints(
  start : Int,
  goal : Int,
  neighbors : (Int) -> Array[(Int, Int)],
) -> Array[Int] {
  if start == goal {
    return [start]
  }
  let queue : Array[Int] = [start]
  let discovered : Array[Int] = [start]
  let parent : Array[Int] = [-1]
  let mut head = 0
  let mut found = false
  while head < queue.length() && !found {
    let node = queue[head]
    head = head + 1
    for edge in neighbors(node) {
      let (next, _) = edge
      if index_of_node(discovered, next) == -1 {
        discovered.push(next)
        parent.push(node)
        queue.push(next)
        if next == goal {
          found = true
        }
      }
    }
  }
  if !found {
    return []
  }

  let reversed : Array[Int] = [goal]
  let mut current = goal
  while current != start {
    let index = index_of_node(discovered, current)
    if index == -1 || parent[index] == -1 {
      return []
    }
    current = parent[index]
    reversed.push(current)
  }
  let segment : Array[Int] = []
  let mut i = reversed.length() - 1
  while i >= 0 {
    segment.push(reversed[i])
    i = i - 1
  }
  segment
}

///|
/// Expand every waypoint pair into a continuous shortest unweighted segment.
/// Returns an empty path if any pair cannot be connected by neighbors.
pub fn expand_path(
  path : Array[Int],
  neighbors : (Int) -> Array[(Int, Int)],
) -> Array[Int] {
  if path.length() <= 1 {
    return path
  }
  let result : Array[Int] = [path[0]]
  for i = 1; i < path.length(); i = i + 1 {
    let segment = connect_waypoints(path[i - 1], path[i], neighbors)
    if segment.length() == 0 {
      return []
    }
    for j = 1; j < segment.length(); j = j + 1 {
      result.push(segment[j])
    }
  }
  result
}

///|
/// Count direction changes in a path represented by integer node ids.
pub fn count_turns(path : Array[Int]) -> Int {
  if path.length() <= 2 {
    return 0
  }
  let mut turns = 0
  let mut previous_direction = path[1] - path[0]
  for i = 2; i < path.length(); i = i + 1 {
    let direction = path[i] - path[i - 1]
    if direction != previous_direction {
      turns = turns + 1
      previous_direction = direction
    }
  }
  turns
}

///|
/// Compute the total Manhattan distance of a path.
pub fn path_length_manhattan(
  path : Array[Int],
  id_to_pos : (Int) -> (Int, Int),
) -> Int {
  if path.length() <= 1 {
    return 0
  }
  let mut total = 0
  for i = 1; i < path.length(); i = i + 1 {
    let (x1, y1) = id_to_pos(path[i - 1])
    let (x2, y2) = id_to_pos(path[i])
    total = total + (x1 - x2).abs() + (y1 - y2).abs()
  }
  total
}
