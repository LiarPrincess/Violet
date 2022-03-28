/// Substring that remembers it's `start` and `end` index.
internal struct AbstractStringSubstring<C: Collection> {

  internal struct Index {
    internal let value: C.Index
    /// `Int` value exactly as provided by the user.
    /// For example: `0, 1, -5` etc.
    internal let int: Int
    /// `Int` value adjusted to the collection length.
    /// For example: `-5` was replaced by valid index (like `42`).
    internal let adjustedInt: Int
  }

  internal let value: C.SubSequence
  /// Substring start. `nil` it it was not given.
  internal let start: Index?
  /// Substring end. `nil` it it was not given.
  internal let end: Index?
}

extension AbstractString {

  // MARK: - Substring

  internal static func abstractSubstring(
    _ py: Py,
    zelf: Self,
    start: PyObject?,
    end: PyObject?
  ) -> PyResultGen<AbstractStringSubstring<Elements>> {
    let startIndex: AbstractStringSubstring<Elements>.Index?
    switch Self.extractIndex(py, zelf: zelf, index: start) {
    case let .value(i): startIndex = i
    case let .error(e): return .error(e)
    }

    let endIndex: AbstractStringSubstring<Elements>.Index?
    switch Self.extractIndex(py, zelf: zelf, index: end) {
    case let .value(i): endIndex = i
    case let .error(e): return .error(e)
    }

    let value = Self.abstractSubstring(zelf: zelf,
                                       start: startIndex,
                                       end: endIndex)

    let result = AbstractStringSubstring(value: value,
                                         start: startIndex,
                                         end: endIndex)

    return .value(result)
  }

  internal static func abstractSubstring(
    zelf: Self,
    start: AbstractStringSubstring<Elements>.Index?,
    end: AbstractStringSubstring<Elements>.Index?
  ) -> Elements.SubSequence {
    let startIndex = start?.value ?? zelf.elements.startIndex
    let endIndex = end?.value ?? zelf.elements.endIndex

    // Something like 'elsa'[1000:5] -> empty
    if startIndex >= endIndex {
      let emptyIndex = zelf.elements.startIndex
      let empty = zelf.elements[emptyIndex..<emptyIndex]
      return empty
    }

    // This is `O(1)` even without `RandomAccessCollection`,
    // but we will mark it anyway.
    Self.wouldBeBetterWithRandomAccessCollection()
    return zelf.elements[startIndex..<endIndex]
  }

  // MARK: - Extract index

  private static func extractIndex(
    _ py: Py,
    zelf: Self,
    index indexObject: PyObject?
  ) -> PyResultGen<AbstractStringSubstring<Elements>.Index?> {
    guard let indexObject = indexObject else {
      return .value(nil)
    }

    if py.cast.isNone(indexObject) {
      return .value(nil)
    }

    switch IndexHelper.int(py, object: indexObject, onOverflow: .indexError) {
    case let .value(int):
      var adjustedInt = int
      if adjustedInt < 0 {
        adjustedInt += zelf.count

        // >>> 'elsa'[-1234:2]
        // 'el'
        if adjustedInt < 0 {
          adjustedInt = 0
        }
      }

      // This requires 'RandomAccessCollection' to be 'O(1)'
      Self.wouldBeBetterWithRandomAccessCollection()
      let index = zelf.elements.index(zelf.elements.startIndex,
                                      offsetBy: adjustedInt,
                                      limitedBy: zelf.elements.endIndex)

      let result = AbstractStringSubstring<Elements>.Index(
        value: index ?? zelf.elements.endIndex,
        int: int,
        adjustedInt: adjustedInt
      )

      return .value(result)

    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)

    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)

    case let .error(e):
      return .error(e)
    }
  }
}
