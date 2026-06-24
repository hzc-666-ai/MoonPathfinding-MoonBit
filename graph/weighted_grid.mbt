/// Weighted grid with 8-direction movement and per-cell terrain costs.

pub(all) struct WeightedGrid {
  width : Int
  height : Int
  cells : Array[Bool]
  costs : Array[Int]
  diagonal : Bool
  diagonal_cost : Int
}

pub fn WeightedGrid::new(
  width : Int, height : Int, cells : Array[Bool], costs : Array[Int], diagonal : Bool
) -> WeightedGrid {
  { width, height, cells, costs, diagonal, diagonal_cost: 14 }
}

pub fn WeightedGrid::new_with_diag(
  width : Int, height : Int, cells : Array[Bool], costs : Array[Int],
  diagonal : Bool, diagonal_cost : Int
) -> WeightedGrid {
  { width, height, cells, costs, diagonal, diagonal_cost }
}

fn terrain_cost(ch : String) -> Int {
  if ch == "," { 2 } else if ch == ";" { 3 } else if ch == "=" { 5 }
  else if ch == "~" { 8 } else if ch == "*" { 10 } else { 1 }
}

pub fn WeightedGrid::from_strings(lines : Array[String], diagonal : Bool) -> WeightedGrid? {
  let height = lines.length()
  if height == 0 { return None }
  let width = lines[0].length()
  let cells : Array[Bool] = []
  let costs : Array[Int] = []
  for i = 0; i < height; i = i + 1 {
    let line = lines[i]
    if line.length() != width { return None }
    for j = 0; j < width; j = j + 1 {
      let ch = line[j:j + 1].to_string()
      cells.push(ch != "#" && ch != "1")
      costs.push(terrain_cost(ch))
    }
  }
  Some(WeightedGrid::new(width, height, cells, costs, diagonal))
}

pub fn WeightedGrid::pos_to_id(self : WeightedGrid, row : Int, col : Int) -> Int {
  row * self.width + col
}

pub fn WeightedGrid::id_to_pos(self : WeightedGrid, id : Int) -> (Int, Int) {
  (id / self.width, id % self.width)
}

pub fn WeightedGrid::is_passable(self : WeightedGrid, id : Int) -> Bool {
  id >= 0 && id < self.cells.length() && self.cells[id]
}

pub fn WeightedGrid::cell_cost(self : WeightedGrid, id : Int) -> Int {
  if id >= 0 && id < self.costs.length() { self.costs[id] } else { 1 }
}

pub impl Graph for WeightedGrid with node_count(self) -> Int {
  self.width * self.height
}

pub impl Graph for WeightedGrid with neighbors(self, node : Int) -> Array[(Int, Int)] {
  let result : Array[(Int, Int)] = []
  let (row, col) = self.id_to_pos(node)
  let card = [(-1, 0), (1, 0), (0, -1), (0, 1)]
  for i = 0; i < card.length(); i = i + 1 {
    let (dr, dc) = card[i]
    let nr = row + dr
    let nc = col + dc
    if nr >= 0 && nr < self.height && nc >= 0 && nc < self.width {
      let nid = self.pos_to_id(nr, nc)
      if self.cells[nid] {
        result.push((nid, self.costs[nid] * 10))
      }
    }
  }
  if self.diagonal {
    let diag = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
    for i = 0; i < diag.length(); i = i + 1 {
      let (dr, dc) = diag[i]
      let nr = row + dr
      let nc = col + dc
      if nr >= 0 && nr < self.height && nc >= 0 && nc < self.width {
        let nid = self.pos_to_id(nr, nc)
        if self.cells[nid] && self.cells[self.pos_to_id(row, nc)] && self.cells[self.pos_to_id(nr, col)] {
          result.push((nid, self.costs[nid] * self.diagonal_cost))
        }
      }
    }
  }
  result
}

pub impl Graph for WeightedGrid with heuristic(self, from : Int, to : Int) -> Int {
  let (r1, c1) = self.id_to_pos(from)
  let (r2, c2) = self.id_to_pos(to)
  let dr = if r1 > r2 { r1 - r2 } else { r2 - r1 }
  let dc = if c1 > c2 { c1 - c2 } else { c2 - c1 }
  if self.diagonal {
    if dr < dc { dr * self.diagonal_cost + (dc - dr) * 10 }
    else { dc * self.diagonal_cost + (dr - dc) * 10 }
  } else {
    (dr + dc) * 10
  }
}
