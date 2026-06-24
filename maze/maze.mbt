/// Maze generation algorithms: Recursive Backtracker, Prim's, and simple random.

/// Simple linear congruential generator for deterministic randomness.
struct LCG {
  mut state : Int
}

fn LCG::new(seed : Int) -> LCG {
  { state: seed }
}

fn LCG::next(self : LCG) -> Int {
  self.state = (self.state * 1103515245 + 12345) & 0x7fffffff
  self.state
}

/// Shuffle an array in-place using Fisher-Yates.
fn shuffle(arr : Array[Int], rng : LCG) -> Unit {
  let mut i = arr.length() - 1
  while i > 0 {
    let j = rng.next() % (i + 1)
    let tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
    i = i - 1
  }
}

/// Generate a maze using recursive backtracker (DFS).
/// Returns an ASCII string array where '#' = wall, '.' = passage.
pub fn dfs_maze(width : Int, height : Int, seed : Int) -> Array[String] {
  // Grid dimensions: actual maze is (width*2+1) x (height*2+1)
  let gw = width * 2 + 1
  let gh = height * 2 + 1
  let grid = Array::make(gh * gw, false)
  let rng = LCG::new(seed)

  // Mark all as walls initially
  for i = 0; i < gh; i = i + 1 {
    for j = 0; j < gw; j = j + 1 {
      grid[i * gw + j] = true
    }
  }

  // Carve passages with DFS
  let stack : Array[(Int, Int)] = [(0, 0)]
  grid[0] = false

  while stack.length() > 0 {
    let (r, c) = stack[stack.length() - 1]
    // Collect unvisited neighbors (2 cells away)
    let nbs : Array[Int] = []
    let dirs = [(-2, 0), (2, 0), (0, -2), (0, 2)]
    for d = 0; d < dirs.length(); d = d + 1 {
      let (dr, dc) = dirs[d]
      let nr = r + dr
      let nc = c + dc
      if nr >= 0 && nr < gh && nc >= 0 && nc < gw && grid[nr * gw + nc] {
        nbs.push(d)
      }
    }
    if nbs.length() == 0 {
      let _ = stack.pop()
      continue
    }
    let d = nbs[rng.next() % nbs.length()]
    let (dr, dc) = dirs[d]
    let nr = r + dr
    let nc = c + dc
    // Carve the wall between
    grid[(r + dr / 2) * gw + (c + dc / 2)] = false
    // Carve the target cell
    grid[nr * gw + nc] = false
    stack.push((nr, nc))
  }

  // Convert to string array
  let result : Array[String] = []
  for i = 0; i < gh; i = i + 1 {
    let mut line = ""
    for j = 0; j < gw; j = j + 1 {
      if grid[i * gw + j] {
        line = line + "#"
      } else {
        line = line + "."
      }
    }
    result.push(line)
  }
  result
}

/// Generate a maze using Prim's algorithm.
/// Produces mazes with more branching and shorter dead ends.
pub fn prim_maze(width : Int, height : Int, seed : Int) -> Array[String] {
  let gw = width * 2 + 1
  let gh = height * 2 + 1
  let grid = Array::make(gh * gw, false)
  let rng = LCG::new(seed)

  // Initialize all as walls
  for i = 0; i < gh; i = i + 1 {
    for j = 0; j < gw; j = j + 1 {
      grid[i * gw + j] = true
    }
  }

  // Start with cell (0, 0)
  grid[0] = false
  let walls : Array[(Int, Int, Int, Int)] = []
  // Add walls from start cell
  let start_dirs = [(2, 0), (0, 2)]
  for d = 0; d < start_dirs.length(); d = d + 1 {
    let (dr, dc) = start_dirs[d]
    let nr = 0 + dr
    let nc = 0 + dc
    if nr < gh && nc < gw {
      walls.push((0, 0, nr, nc))
    }
  }

  while walls.length() > 0 {
    let idx = rng.next() % walls.length()
    let (r, c, nr, nc) = walls[idx]
    // Remove wall from list
    let last = walls.pop().unwrap()
    if idx < walls.length() {
      walls[idx] = last
    }

    if !grid[nr * gw + nc] {
      continue
    }
    // Carve passage
    grid[(r + (nr - r) / 2) * gw + (c + (nc - c) / 2)] = false
    grid[nr * gw + nc] = false

    // Add new walls
    let dirs = [(-2, 0), (2, 0), (0, -2), (0, 2)]
    for d = 0; d < dirs.length(); d = d + 1 {
      let (dr, dc) = dirs[d]
      let nnr = nr + dr
      let nnc = nc + dc
      if nnr >= 0 && nnr < gh && nnc >= 0 && nnc < gw && grid[nnr * gw + nnc] {
        walls.push((nr, nc, nnr, nnc))
      }
    }
  }

  let result : Array[String] = []
  for i = 0; i < gh; i = i + 1 {
    let mut line = ""
    for j = 0; j < gw; j = j + 1 {
      if grid[i * gw + j] {
        line = line + "#"
      } else {
        line = line + "."
      }
    }
    result.push(line)
  }
  result
}

/// Generate a random obstacle grid (not a maze, just random walls).
pub fn random_obstacles(width : Int, height : Int, fill_pct : Int, seed : Int) -> Array[String] {
  let rng = LCG::new(seed)
  let result : Array[String] = []
  for i = 0; i < height; i = i + 1 {
    let mut line = ""
    for j = 0; j < width; j = j + 1 {
      if rng.next() % 100 < fill_pct {
        line = line + "#"
      } else {
        line = line + "."
      }
    }
    result.push(line)
  }
  result
}
