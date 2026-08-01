///|
/// Jump Point Search — grid-optimized A* that skips symmetric paths.
/// Significantly faster than A* on large open grids with uniform costs.

// Direction vectors: N, S, W, E, NW, NE, SW, SE
let dirs_jps : Array[(Int, Int)] = [
  (-1, 0),
  (1, 0),
  (0, -1),
  (0, 1),
  (-1, -1),
  (-1, 1),
  (1, -1),
  (1, 1),
]

///|
/// Check if a cell position is passable.
fn passable(grid : @graph.Grid, row : Int, col : Int) -> Bool {
  if row < 0 || row >= grid.height || col < 0 || col >= grid.width {
    return false
  }
  grid.is_passable(grid.pos_to_id(row, col))
}

///|
/// Check whether a node has forced neighbors in the given direction.
/// A forced neighbor exists when moving in a direction would cut off
/// an alternative optimal path due to obstacles.
fn has_forced(
  grid : @graph.Grid,
  row : Int,
  col : Int,
  dr : Int,
  dc : Int,
) -> Bool {
  if dr != 0 && dc != 0 {
    // Diagonal move: check the two adjacent cells that would be pruned
    if dr == -1 && dc == -1 {
      // Moving NW
      let block_n = !passable(grid, row - 1, col)
      let block_w = !passable(grid, row, col - 1)
      if (
          block_n &&
          passable(grid, row, col - 1) &&
          passable(grid, row - 1, col - 1)
        ) ||
        (
          block_w &&
          passable(grid, row - 1, col) &&
          passable(grid, row - 1, col - 1)
        ) {
        return true
      }
    } else if dr == -1 && dc == 1 {
      // Moving NE
      let block_n = !passable(grid, row - 1, col)
      let block_e = !passable(grid, row, col + 1)
      if (
          block_n &&
          passable(grid, row, col + 1) &&
          passable(grid, row - 1, col + 1)
        ) ||
        (
          block_e &&
          passable(grid, row - 1, col) &&
          passable(grid, row - 1, col + 1)
        ) {
        return true
      }
    } else if dr == 1 && dc == -1 {
      // Moving SW
      let block_s = !passable(grid, row + 1, col)
      let block_w = !passable(grid, row, col - 1)
      if (
          block_s &&
          passable(grid, row, col - 1) &&
          passable(grid, row + 1, col - 1)
        ) ||
        (
          block_w &&
          passable(grid, row + 1, col) &&
          passable(grid, row + 1, col - 1)
        ) {
        return true
      }
    } else if dr == 1 && dc == 1 {
      // Moving SE
      let block_s = !passable(grid, row + 1, col)
      let block_e = !passable(grid, row, col + 1)
      if (
          block_s &&
          passable(grid, row, col + 1) &&
          passable(grid, row + 1, col + 1)
        ) ||
        (
          block_e &&
          passable(grid, row + 1, col) &&
          passable(grid, row + 1, col + 1)
        ) {
        return true
      }
    }
  } else if dr != 0 {
    // Vertical move (N or S): check left and right forward diagonals
    if !passable(grid, row, col - 1) && passable(grid, row + dr, col - 1) {
      return true
    }
    if !passable(grid, row, col + 1) && passable(grid, row + dr, col + 1) {
      return true
    }
  } else if dc != 0 {
    // Horizontal move (W or E): check up and down forward diagonals
    if !passable(grid, row - 1, col) && passable(grid, row - 1, col + dc) {
      return true
    }
    if !passable(grid, row + 1, col) && passable(grid, row + 1, col + dc) {
      return true
    }
  }
  false
}

///|
/// Jump recursively in the given direction, returning the next jump point if found.
fn do_jump(
  grid : @graph.Grid,
  row : Int,
  col : Int,
  dr : Int,
  dc : Int,
  goal_r : Int,
  goal_c : Int,
) -> (Int, Int)? {
  let nr = row + dr
  let nc = col + dc
  if !passable(grid, nr, nc) {
    return None
  }
  if nr == goal_r && nc == goal_c {
    return Some((nr, nc))
  }
  if has_forced(grid, nr, nc, dr, dc) {
    return Some((nr, nc))
  }
  // Diagonal: check horizontal and vertical sub-jumps
  if dr != 0 && dc != 0 {
    match do_jump(grid, nr, nc, dr, 0, goal_r, goal_c) {
      Some(_) => return Some((nr, nc))
      None => ()
    }
    match do_jump(grid, nr, nc, 0, dc, goal_r, goal_c) {
      Some(_) => return Some((nr, nc))
      None => ()
    }
  }
  do_jump(grid, nr, nc, dr, dc, goal_r, goal_c)
}

///|
/// Get successors for JPS by jumping in all 8 directions from a node.
fn jps_neighbors(
  grid : @graph.Grid,
  row : Int,
  col : Int,
  goal_r : Int,
  goal_c : Int,
) -> Array[(Int, Int)] {
  let result : Array[(Int, Int)] = []
  for i = 0; i < dirs_jps.length(); i = i + 1 {
    let (dr, dc) = dirs_jps[i]
    match do_jump(grid, row, col, dr, dc, goal_r, goal_c) {
      Some((nr, nc)) => result.push((nr, nc))
      None => ()
    }
  }
  result
}

///|
/// Compute the full cost of a straight or diagonal jump segment.
fn jump_cost(from_r : Int, from_c : Int, to_r : Int, to_c : Int) -> Int {
  let row_steps = (to_r - from_r).abs()
  let col_steps = (to_c - from_c).abs()
  let diagonal_steps = if row_steps < col_steps { row_steps } else { col_steps }
  let straight_steps = (row_steps - col_steps).abs()
  diagonal_steps * 14 + straight_steps * 10
}

///|
fn step_direction(delta : Int) -> Int {
  if delta < 0 {
    -1
  } else if delta > 0 {
    1
  } else {
    0
  }
}

///|
/// Expand jump-point segments into adjacent grid cells.
fn expand_jump_path(
  grid : @graph.Grid,
  parent : Array[Int],
  goal : Int,
) -> Array[Int] {
  let jump_points = rebuild_path(parent, goal)
  if jump_points.length() <= 1 {
    return jump_points
  }
  let result : Array[Int] = [jump_points[0]]
  for i = 1; i < jump_points.length(); i = i + 1 {
    let (initial_row, initial_col) = grid.id_to_pos(jump_points[i - 1])
    let mut row = initial_row
    let mut col = initial_col
    let (target_row, target_col) = grid.id_to_pos(jump_points[i])
    let dr = step_direction(target_row - row)
    let dc = step_direction(target_col - col)
    while row != target_row || col != target_col {
      row = row + dr
      col = col + dc
      result.push(grid.pos_to_id(row, col))
    }
  }
  result
}

///|
/// Octile distance (for 8-directional grids, diagonal cost = sqrt(2)).
fn octile(r1 : Int, c1 : Int, r2 : Int, c2 : Int) -> Int {
  let dr = if r1 > r2 { r1 - r2 } else { r2 - r1 }
  let dc = if c1 > c2 { c1 - c2 } else { c2 - c1 }
  if dr < dc {
    dr * 14 + (dc - dr) * 10
  } else {
    dc * 14 + (dr - dc) * 10
  }
}

///|
/// JPS pathfinding on a grid.
/// Uses 8-directional movement with octile distance heuristic.
pub fn jps(grid : @graph.Grid, start : Int, goal : Int) -> @graph.PathResult {
  if start == goal {
    return @graph.PathResult::{ path: [start], cost: 0, nodes_visited: 1 }
  }
  let (goal_r, goal_c) = grid.id_to_pos(goal)
  let (start_r, start_c) = grid.id_to_pos(start)

  let n = grid.width * grid.height
  let dist = Array::make(n, -1)
  let parent = Array::make(n, -1)
  let heap = MinHeap::new()
  dist[start] = 0
  let h0 = octile(start_r, start_c, goal_r, goal_c)
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
          return @graph.PathResult::{
            path: expand_jump_path(grid, parent, goal),
            cost: dist[goal],
            nodes_visited: nodes,
          }
        }
        let (r, c) = grid.id_to_pos(node)
        let nbs = jps_neighbors(grid, r, c, goal_r, goal_c)
        for i = 0; i < nbs.length(); i = i + 1 {
          let (nr, nc) = nbs[i]
          let nb = grid.pos_to_id(nr, nc)
          let step_cost = jump_cost(r, c, nr, nc)
          let new_g = dist[node] + step_cost
          let nb_d = dist[nb]
          if nb_d < 0 || new_g < nb_d {
            dist[nb] = new_g
            parent[nb] = node
            let f_val = new_g + octile(nr, nc, goal_r, goal_c)
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
