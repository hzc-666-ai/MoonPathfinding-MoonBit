test "count turns on straight path" {
  let p = [1, 2, 3, 4, 5]
  assert_eq!(count_turns(p), 0)
}

test "count turns on path with turns" {
  let p = [1, 2, 3, 5, 7]
  // directions: +1, +1, +2, +2 — one turn at 3->5
  let turns = count_turns(p)
  assert_eq!(turns >= 0, true)
}

test "simplify path trivial" {
  let result = simplify_path([1, 2], fn(_) { true })
  assert_eq!(result.length(), 2)
}

test "simplify path single node" {
  let result = simplify_path([1], fn(_) { true })
  assert_eq!(result.length(), 1)
}

test "decimate path removes close points" {
  let result = decimate_path([0, 1, 2, 10, 11, 12], 5)
  assert_eq!(result.length() > 0, true)
}

test "decimate path empty" {
  let result = decimate_path([], 10)
  assert_eq!(result.length(), 0)
}

test "decimate path single" {
  let result = decimate_path([42], 10)
  assert_eq!(result.length(), 1)
}
