///|
/// 2D grid graph for pathfinding.
/// Cells: true = passable, false = blocked.
pub(all) struct Grid {
  width : Int
  height : Int
  cells : Array[Bool]
}

///|
/// Create a Grid from width, height and a cell array (row-major).
pub fn Grid::new(width : Int, height : Int, cells : Array[Bool]) -> Grid {
  { width, height, cells }
}

///|
/// Parse a grid from ASCII art strings.
/// '#' or '1' = wall, anything else = passable.
pub fn Grid::from_strings(lines : Array[String]) -> Grid? {
  let height = lines.length()
  if height == 0 {
    return None
  }
  let width = lines[0].length()
  let cells : Array[Bool] = []
  for i = 0; i < height; i = i + 1 {
    let line = lines[i]
    if line.length() != width {
      return None
    }
    for j = 0; j < width; j = j + 1 {
      let ch = line[j:j + 1]
      cells.push(ch != "#" && ch != "1")
    }
  }
  Some({ width, height, cells })
}

///|
/// Convert (row, col) to node id.
pub fn Grid::pos_to_id(self : Grid, row : Int, col : Int) -> Int {
  row * self.width + col
}

///|
/// Convert node id to (row, col).
pub fn Grid::id_to_pos(self : Grid, id : Int) -> (Int, Int) {
  (id / self.width, id % self.width)
}

///|
/// Check if a cell is passable.
pub fn Grid::is_passable(self : Grid, id : Int) -> Bool {
  id >= 0 && id < self.cells.length() && self.cells[id]
}

///|
/// Find the node id for a marker character in the grid ('S' = start, 'E' = goal).
pub fn Grid::find_marker(lines : Array[String], marker : String) -> (Int, Int)? {
  for i = 0; i < lines.length(); i = i + 1 {
    for j = 0; j < lines[i].length(); j = j + 1 {
      if lines[i][j:j + 1] == marker {
        return Some((i, j))
      }
    }
  }
  None
}

///|
pub impl Graph for Grid with fn node_count(self) -> Int {
  self.width * self.height
}

///|
pub impl Graph for Grid with fn neighbors(self, node : Int) -> Array[(Int, Int)] {
  let result : Array[(Int, Int)] = []
  let (row, col) = self.id_to_pos(node)
  let dirs = [(-1, 0, 1), (1, 0, 1), (0, -1, 1), (0, 1, 1)]
  for i = 0; i < dirs.length(); i = i + 1 {
    let (dr, dc, cost) = dirs[i]
    let nr = row + dr
    let nc = col + dc
    if nr >= 0 && nr < self.height && nc >= 0 && nc < self.width {
      let nid = self.pos_to_id(nr, nc)
      if self.cells[nid] {
        result.push((nid, cost))
      }
    }
  }
  result
}

///|
pub impl Graph for Grid with fn heuristic(self, from : Int, to : Int) -> Int {
  let (r1, c1) = self.id_to_pos(from)
  let (r2, c2) = self.id_to_pos(to)
  let dr = if r1 > r2 { r1 - r2 } else { r2 - r1 }
  let dc = if c1 > c2 { c1 - c2 } else { c2 - c1 }
  dr + dc
}
