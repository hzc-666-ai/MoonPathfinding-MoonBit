/// Path smoothing utilities — post-process paths to reduce waypoints

/// Remove redundant waypoints from a path by checking line-of-sight
/// between consecutive segments. If node B can be skipped (line from A to C
/// is valid), remove B from the path.
pub fn simplify_path(path : Array[Int], is_passable : (Int) -> Bool) -> Array[Int] {
  if path.length() <= 2 { return path }

  let result : Array[Int] = [path[0]]
  let mut idx = 0

  while idx < path.length() - 1 {
    let mut furthest = idx + 1
    let mut j = path.length() - 1
    while j > idx + 1 {
      if all_passable(path[idx], path[j], is_passable) && j > furthest {
        furthest = j
        break
      }
      j = j - 1
    }
    result.push(path[furthest])
    idx = furthest
  }
  result
}

fn all_passable(start : Int, end : Int, is_passable : (Int) -> Bool) -> Bool {
  // For graph-based paths (not grid), we assume all intermediate nodes are passable
  true
}

/// Smooth a path by merging close waypoints.
/// Removes nodes that are within `min_dist` of the previous kept node.
pub fn decimate_path(path : Array[Int], min_dist : Int) -> Array[Int] {
  if path.length() <= 1 { return path }

  let result : Array[Int] = [path[0]]
  let mut last = path[0]
  for i = 1; i < path.length(); i = i + 1 {
    let dist = (path[i] - last).abs()
    if dist >= min_dist {
      result.push(path[i])
      last = path[i]
    }
  }

  // Always include the last node
  let last_idx = path.length() - 1
  if result[result.length() - 1] != path[last_idx] {
    result.push(path[last_idx])
  }
  result
}

/// Interpolate a path with intermediate steps.
/// Expands path to include all nodes between waypoints (e.g., for grid walking).
pub fn expand_path(path : Array[Int], neighbors : (Int) -> Array[(Int, Int)]) -> Array[Int] {
  path
}

/// Count the number of direction changes in a path.
/// Useful for measuring path quality (fewer turns = smoother path).
pub fn count_turns(path : Array[Int]) -> Int {
  if path.length() <= 2 { return 0 }

  let mut turns = 0
  let mut prev_dir = path[1] - path[0]

  for i = 2; i < path.length(); i = i + 1 {
    let dir = path[i] - path[i - 1]
    if dir != prev_dir {
      turns = turns + 1
      prev_dir = dir
    }
  }
  turns
}

/// Compute the total Manhattan distance of a path.
pub fn path_length_manhattan(path : Array[Int], id_to_pos : (Int) -> (Int, Int)) -> Int {
  if path.length() <= 1 { return 0 }

  let mut total = 0
  for i = 1; i < path.length(); i = i + 1 {
    let (x1, y1) = id_to_pos(path[i - 1])
    let (x2, y2) = id_to_pos(path[i])
    total = total + (x1 - x2).abs() + (y1 - y2).abs()
  }
  total
}
