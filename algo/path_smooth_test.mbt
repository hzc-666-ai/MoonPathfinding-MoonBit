///|
test "count turns is exact" {
  assert_eq(count_turns([0, 1, 2, 5, 8]), 1)
}

///|
test "smooth path uses direct line of sight" {
  let result = smooth_path([0, 1, 2, 3, 4], fn(_, _) { true })
  assert_eq(result, [0, 4])
}

///|
test "smooth path keeps required waypoints" {
  let result = smooth_path([0, 1, 2, 3, 4, 5], fn(from, to) { to - from <= 2 })
  assert_eq(result, [0, 2, 4, 5])
}

///|
test "simplify path compatibility predicate is implemented" {
  let result = simplify_path([0, 1, 2, 3], fn(_) { true })
  assert_eq(result, [0, 3])
}

///|
test "expand path connects every waypoint" {
  let result = expand_path([0, 3, 5], fn(node) {
    let adjacent : Array[(Int, Int)] = []
    if node > 0 {
      adjacent.push((node - 1, 1))
    }
    if node < 5 {
      adjacent.push((node + 1, 1))
    }
    adjacent
  })
  assert_eq(result, [0, 1, 2, 3, 4, 5])
}

///|
test "expand path reports an unreachable segment" {
  let result = expand_path([0, 2], fn(node) {
    if node == 0 {
      [(1, 1)]
    } else {
      []
    }
  })
  assert_eq(result, [])
}

///|
test "decimate path keeps spaced nodes and endpoint" {
  assert_eq(decimate_path([0, 1, 2, 10, 11, 12], 5), [0, 10, 12])
}

///|
test "decimate path handles empty and single paths" {
  assert_eq(decimate_path([], 10), [])
  assert_eq(decimate_path([42], 10), [42])
}

///|
test "manhattan path length sums all segments" {
  let path = [0, 4, 8]
  let length = path_length_manhattan(path, fn(id) { (id / 3, id % 3) })
  assert_eq(length, 4)
}
