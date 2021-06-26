// MARK: - Substring

/// Substring that remembers it's `start` and `end` values.
internal struct PyIndexedSubstring<Scalars: BidirectionalCollection>
  where Scalars.Element: Comparable,
        Scalars.Element: Hashable {

  internal struct Index {
    internal let value: Scalars.Index
    /// `Int` value exactly as provided by the user.
    /// For example: `0, 1, -5` etc.
    internal let int: Int
    /// `Int` value adjusted to the collection length.
    /// For example: `-5` was replaced by valid index (like `42`).
    internal let adjustedInt: Int
  }

  internal let value: Scalars.SubSequence
  /// Substring start. `nil` it it was not given.
  internal let start: Index?
  /// Substring end. `nil` it it was not given.
  internal let end: Index?
}

extension PyStringImpl {

  internal typealias IndexedSubSequence = PyIndexedSubstring<Scalars>

  internal func substring(start: PyObject?,
                          end: PyObject?) -> PyResult<IndexedSubSequence> {
    let startIndex: IndexedSubSequence.Index?
    switch self.extractIndex(start) {
    case .value(nil): startIndex = nil
    case .value(let i): startIndex = i
    case .error(let e): return .error(e)
    }

    let endIndex: IndexedSubSequence.Index?
    switch self.extractIndex(end) {
    case .value(nil): endIndex = nil
    case .value(let i): endIndex = i
    case .error(let e): return .error(e)
    }

    let startInt = startIndex?.adjustedInt ?? Int.min
    let endInt = endIndex?.adjustedInt ?? Int.max

    // Handle something like 'elsa'[1000:5]
    guard startInt < endInt else {
      let start = self.startIndex
      let empty = self[start..<start]
      let result = IndexedSubSequence(value: empty,
                                      start: startIndex,
                                      end: endIndex)
      return .value(result)
    }

    let value = self.substring(
      start: startIndex?.value ?? self.startIndex,
      end: endIndex?.value ?? self.endIndex
    )

    let result = IndexedSubSequence(value: value,
                                    start: startIndex,
                                    end: endIndex)

    return .value(result)
  }

  internal func substring(start: Index? = nil,
                          end: Index? = nil) -> SubSequence {
    let s = start ?? self.startIndex
    let e = end ?? self.endIndex
    return self[s..<e]
  }

  private func extractIndex(
    _ value: PyObject?
  ) -> PyResult<IndexedSubSequence.Index?> {
    guard let value = value else {
      return .value(nil)
    }

    if value is PyNone {
      return .value(nil)
    }

    switch IndexHelper.int(value, onOverflow: .indexError) {
    case let .value(int):
      var adjustedInt = int
      if adjustedInt < 0 {
        adjustedInt += self.count

        // >>> 'elsa'[-1234:2]
        // 'el'
        if adjustedInt < 0 {
          adjustedInt = 0
        }
      }

      let value = self.index(self.startIndex,
                             offsetBy: adjustedInt,
                             limitedBy: self.endIndex)

      let result = IndexedSubSequence.Index(value: value ?? self.endIndex,
                                            int: int,
                                            adjustedInt: adjustedInt)

      return .value(result)

    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }
  }
}
