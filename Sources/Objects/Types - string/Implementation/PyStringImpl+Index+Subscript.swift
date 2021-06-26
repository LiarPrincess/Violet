// MARK: - Subscript/index

extension PyStringImpl {

  internal subscript(index: Index) -> Element {
    return self.scalars[index]
  }

  internal subscript<R: RangeExpression>(
    range: R
  ) -> SubSequence where R.Bound == Index {
    return self.scalars[range]
  }

  internal var startIndex: Index {
    return self.scalars.startIndex
  }

  internal var endIndex: Index {
    return self.scalars.endIndex
  }

  internal func index(after index: Index) -> Index {
    assert(index != self.endIndex)
    var copy = index
    self.formIndex(after: &copy)
    return copy
  }

  internal func formIndex(after i: inout Index) {
    self.scalars.formIndex(after: &i)
  }

  internal func formIndex(after index: inout Self.Index,
                          while predicate: (Self.Index) -> Bool) {
    while index != self.endIndex {
      switch predicate(index) {
      case true:
        self.formIndex(after: &index) // go to the next element
      case false:
        return
      }
    }
  }

  internal func index(before index: Index) -> Index {
    assert(index != self.startIndex)
    var copy = index
    self.formIndex(before: &copy)
    return copy
  }

  internal func formIndex(before i: inout Index) {
    self.scalars.formIndex(before: &i)
  }

  internal func formIndex(before index: inout Self.Index,
                          while predicate: (Self.Index) -> Bool) {
    while index != self.startIndex {
      switch predicate(index) {
      case true:
        self.formIndex(before: &index) // go to the previous element
      case false:
        return
      }
    }
  }

  internal func index(_ i: Index, offsetBy distance: Int) -> Index {
    return self.scalars.index(i, offsetBy: distance)
  }

  internal func index(_ i: Index,
                      offsetBy distance: Int,
                      limitedBy limit: Index) -> Index? {
    return self.scalars.index(i, offsetBy: distance, limitedBy: limit)
  }
}
