/// Binary min-heap storing (priority, cost, node) triples.

priv struct MinHeap {
  data : Array[(Int, Int, Int)]
}

fn MinHeap::new() -> MinHeap {
  { data: [] }
}

fn MinHeap::is_empty(self : MinHeap) -> Bool {
  self.data.length() == 0
}

fn MinHeap::push(self : MinHeap, item : (Int, Int, Int)) -> Unit {
  self.data.push(item)
  let mut i = self.data.length() - 1
  while i > 0 {
    let p = (i - 1) / 2
    let a = self.data[i]
    let b = self.data[p]
    if a.0 < b.0 {
      self.data[i] = b
      self.data[p] = a
      i = p
    } else {
      break
    }
  }
}

fn MinHeap::pop(self : MinHeap) -> (Int, Int, Int)? {
  if self.data.length() == 0 {
    return None
  }
  let result = self.data[0]
  match self.data.pop() {
    Some(last) => {
      let n = self.data.length()
      if n == 0 {
        return Some(result)
      }
      self.data[0] = last
      let mut i : Int = 0
      while true {
        let mut smallest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        if left < n && self.data[left].0 < self.data[smallest].0 {
          smallest = left
        }
        if right < n && self.data[right].0 < self.data[smallest].0 {
          smallest = right
        }
        if smallest != i {
          let tmp = self.data[i]
          self.data[i] = self.data[smallest]
          self.data[smallest] = tmp
          i = smallest
        } else {
          break
        }
      }
      Some(result)
    }
    None => None
  }
}
