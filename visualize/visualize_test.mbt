/// Tests for visualization module.

test "ascii render no path" {
  let cells = Array::make(9, true)
  let g = @graph.Grid::new(3, 3, cells)
  let empty : @graph.PathResult = @graph.PathResult::{ path: [], cost: 0, nodes_visited: 0 }
  let ascii = @visualize.ascii_render(g, empty, 0, 8)
  assert_true(ascii.length() > 0)
}

test "result summary not found" {
  let empty : @graph.PathResult = @graph.PathResult::{ path: [], cost: 0, nodes_visited: 5 }
  let s = @visualize.result_summary("BFS", empty)
  assert_eq(s[0:3], "BFS")
}
