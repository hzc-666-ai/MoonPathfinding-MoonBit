///|
/// Tests for maze generators.
test "dfs maze dimensions" {
  let lines = @maze.dfs_maze(5, 5, 42)
  assert_eq(lines.length(), 11)
  assert_eq(lines[0].length(), 11)
}

///|
test "prim maze dimensions" {
  let lines = @maze.prim_maze(5, 5, 99)
  assert_eq(lines.length(), 11)
  assert_eq(lines[0].length(), 11)
}

///|
test "random obstacles dimensions" {
  let lines = @maze.random_obstacles(10, 10, 30, 7)
  assert_eq(lines.length(), 10)
  assert_eq(lines[0].length(), 10)
}

///|
test "maze different seeds differ" {
  let a = @maze.dfs_maze(5, 5, 1)
  let b = @maze.dfs_maze(5, 5, 999)
  // Different seeds should produce different mazes
  let mut same = true
  for i = 0; i < a.length(); i = i + 1 {
    if a[i] != b[i] {
      same = false
      break
    }
  }
  assert_false(same)
}

///|
test "maze same seed deterministic" {
  let a = @maze.dfs_maze(5, 5, 42)
  let b = @maze.dfs_maze(5, 5, 42)
  for i = 0; i < a.length(); i = i + 1 {
    assert_eq(a[i], b[i])
  }
}
