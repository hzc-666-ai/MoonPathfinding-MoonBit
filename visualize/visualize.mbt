/// Visualization: ASCII terminal output and HTML export for grid pathfinding.

/// Render a grid with path as ASCII art.
/// Symbols: S=start, E=goal, *=path, ·=passable, #=wall
pub fn ascii_render(grid : @graph.Grid, result : @graph.PathResult, start : Int, goal : Int) -> String {
  let n = grid.node_count()
  let in_path = Array::make(n, false)
  for i = 0; i < result.path.length(); i = i + 1 {
    in_path[result.path[i]] = true
  }

  let mut out : String = ""
  for row = 0; row < grid.height; row = row + 1 {
    for col = 0; col < grid.width; col = col + 1 {
      let id = grid.pos_to_id(row, col)
      if id == start {
        out = out + "S"
      } else if id == goal {
        out = out + "E"
      } else if in_path[id] {
        out = out + "*"
      } else if grid.is_passable(id) {
        out = out + "·"
      } else {
        out = out + "#"
      }
    }
    if row < grid.height - 1 {
      out = out + "\n"
    }
  }
  out
}

/// Render the grid as an HTML table.
pub fn html_render(grid : @graph.Grid, result : @graph.PathResult, start : Int, goal : Int, title : String) -> String {
  let n = grid.node_count()
  let in_path = Array::make(n, false)
  for i = 0; i < result.path.length(); i = i + 1 {
    in_path[result.path[i]] = true
  }

  let mut html : String = "<!DOCTYPE html>\n<html>\n<head>\n"
  html = html + "<meta charset=\"utf-8\">\n"
  html = html + "<title>" + title + "</title>\n"
  html = html + "<style>\n"
  html = html + "  table { border-collapse: collapse; margin: 20px auto; }\n"
  html = html + "  td { width: 24px; height: 24px; text-align: center; font-size: 14px; border: 1px solid #ddd; }\n"
  html = html + "  .wall { background: #333; }\n"
  html = html + "  .path { background: #4CAF50; color: white; }\n"
  html = html + "  .start { background: #2196F3; color: white; font-weight: bold; }\n"
  html = html + "  .goal { background: #f44336; color: white; font-weight: bold; }\n"
  html = html + "  .empty { background: #fafafa; }\n"
  html = html + "  .info { text-align: center; font-family: monospace; margin: 10px; }\n"
  html = html + "</style>\n</head>\n<body>\n"
  html = html + "<div class=\"info\">" + title + "</div>\n"
  html = html + "<div class=\"info\">Path length: " + result.path.length().to_string()
  html = html + " | Cost: " + result.cost.to_string()
  html = html + " | Nodes visited: " + result.nodes_visited.to_string() + "</div>\n"
  html = html + "<table>\n"

  for row = 0; row < grid.height; row = row + 1 {
    html = html + "  <tr>\n"
    for col = 0; col < grid.width; col = col + 1 {
      let id = grid.pos_to_id(row, col)
      if id == start {
        html = html + "    <td class=\"start\">S</td>\n"
      } else if id == goal {
        html = html + "    <td class=\"goal\">E</td>\n"
      } else if in_path[id] {
        html = html + "    <td class=\"path\">*</td>\n"
      } else if grid.is_passable(id) {
        html = html + "    <td class=\"empty\"></td>\n"
      } else {
        html = html + "    <td class=\"wall\"></td>\n"
      }
    }
    html = html + "  </tr>\n"
  }
  html = html + "</table>\n</body>\n</html>"
  html
}

/// Print a formatted result summary.
pub fn result_summary(algo_name : String, result : @graph.PathResult) -> String {
  if result.path.length() == 0 {
    return algo_name + ": No path found (visited " + result.nodes_visited.to_string() + " nodes)"
  }
  algo_name + ": path length " + result.path.length().to_string() + ", cost " + result.cost.to_string() + ", visited " + result.nodes_visited.to_string() + " nodes"
}
