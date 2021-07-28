// swiftlint:disable type_name

/// Substring that remembers it's `start` and `end` index.
internal struct AbstractString_Substring<C: Collection> {

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

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _substring(start: PyObject?,
                           end: PyObject?) -> PyResult<SwiftType> {
    let substringResult = self._substringImpl(start: start, end: end)

    switch substringResult {
    case let .value(substring):
      let value = substring.value
      let object = Self._toObject(elements: value)
      return .value(object)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Implementation

  /// Use this method to extract substring.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _substringImpl(
    start: PyObject?,
    end: PyObject?
  ) -> PyResult<AbstractString_Substring<Elements>> {
    let startIndex: AbstractString_Substring<Elements>.Index?
    switch self._extractIndex(index: start) {
    case let .value(i): startIndex = i
    case let .error(e): return .error(e)
    }

    let endIndex: AbstractString_Substring<Elements>.Index?
    switch self._extractIndex(index: end) {
    case let .value(i): endIndex = i
    case let .error(e): return .error(e)
    }

    let startInt = startIndex?.adjustedInt ?? Int.min
    let endInt = endIndex?.adjustedInt ?? Int.max

    // Something like 'elsa'[1000:5] -> empty
    if startInt >= endInt {
      let start = self.elements.startIndex
      let empty = self.elements[start..<start]
      let result = AbstractString_Substring(value: empty,
                                            start: startIndex,
                                            end: endIndex)

      return .value(result)
    }

    let value = self._substringImpl(start: startIndex, end: endIndex)
    let result = AbstractString_Substring(value: value,
                                          start: startIndex,
                                          end: endIndex)

    return .value(result)
  }

  /// Use this method to extract substring.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _substringImpl(
    start: AbstractString_Substring<Elements>.Index? = nil,
    end: AbstractString_Substring<Elements>.Index? = nil
  ) -> Elements.SubSequence {
    let s = start?.value ?? self.elements.startIndex
    let e = end?.value ?? self.elements.endIndex
    // This is `O(1)` even without `RandomAccessCollection`,
    // but we will mark it anyway.
    self._wouldBeBetterWithRandomAccessCollection()
    return self.elements[s..<e]
  }

  // MARK: - Extract index

  private func _extractIndex(
    index indexObject: PyObject?
  ) -> PyResult<AbstractString_Substring<Elements>.Index?> {
    guard let indexObject = indexObject else {
      return .value(nil)
    }

    if PyCast.isNone(indexObject) {
      return .value(nil)
    }

    switch IndexHelper.int(indexObject, onOverflow: .indexError) {
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

      // This requires 'RandomAccessCollection' to be 'O(1)'
      self._wouldBeBetterWithRandomAccessCollection()
      let index = self.elements.index(self.elements.startIndex,
                                      offsetBy: adjustedInt,
                                      limitedBy: self.elements.endIndex)

      let result = AbstractString_Substring<Elements>.Index(
        value: index ?? self.elements.endIndex,
        int: int,
        adjustedInt: adjustedInt
      )

      return .value(result)

    case let .notIndex(lazyError):
      let e = lazyError.create()
      return .error(e)

    case let .overflow(_, lazyError):
      let e = lazyError.create()
      return .error(e)

    case let .error(e):
      return .error(e)
    }
  }
}
