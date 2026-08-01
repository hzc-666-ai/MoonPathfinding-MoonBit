///|
/// Hexagonal grid for pathfinding. Uses axial coordinates internally,
/// with odd-q offset layout for string representation.
///
/// Layout (odd-q): odd rows are shifted right by half a cell.
///   Row 0:  0 1 2
///   Row 1:   3 4 5
///   Row 2:  6 7 8
pub(all) struct HexGrid {
  width : Int
  height : Int
  cells : Array[Bool]
  // Precomputed neighbor offsets for odd-q layout
  // For even rows: different offsets than odd rows
}

///|
let hex_dirs_even : Array[(Int, Int, Int)] = [
  (-1, 0, 10),
  (1, 0, 10),
  (0, -1, 10),
  (0, 1, 10),
  (-1, -1, 10),
  (-1, 1, 10),
]

///|
let hex_dirs_odd : Array[(Int, Int, Int)] = [
  (-1, 0, 10),
  (1, 0, 10),
  (0, -1, 10),
  (0, 1, 10),
  (1, -1, 10),
  (1, 1, 10),
]

///|
pub fn HexGrid::new(width : Int, height : Int, cells : Array[Bool]) -> HexGrid {
  { width, height, cells }
}

///|
pub fn HexGrid::from_strings(lines : Array[String]) -> HexGrid? {
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
      cells.push(ch != "#")
    }
  }
  Some({ width, height, cells })
}

///|
pub fn HexGrid::pos_to_id(self : HexGrid, row : Int, col : Int) -> Int {
  row * self.width + col
}

///|
pub fn HexGrid::id_to_pos(self : HexGrid, id : Int) -> (Int, Int) {
  (id / self.width, id % self.width)
}

///|
pub fn HexGrid::is_passable(self : HexGrid, id : Int) -> Bool {
  id >= 0 && id < self.cells.length() && self.cells[id]
}

///|
pub impl Graph for HexGrid with fn node_count(self) -> Int {
  self.width * self.height
}

///|
pub impl Graph for HexGrid with fn neighbors(self, node : Int) -> Array[
  (Int, Int),
] {
  let result : Array[(Int, Int)] = []
  let (row, col) = self.id_to_pos(node)
  let dirs = if row % 2 == 0 { hex_dirs_even } else { hex_dirs_odd }
  for i = 0; i < 6; i = i + 1 {
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
pub impl Graph for HexGrid with fn heuristic(self, from : Int, to : Int) -> Int {
  let (r1, c1) = self.id_to_pos(from)
  let (r2, c2) = self.id_to_pos(to)
  let dr = if r1 > r2 { r1 - r2 } else { r2 - r1 }
  let dc = if c1 > c2 { c1 - c2 } else { c2 - c1 }
  (dr + dc) * 10
}
