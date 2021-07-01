extension AbstractString {

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _replace(old: PyObject,
                         new: PyObject,
                         count countObject: PyObject?) -> PyResult<SwiftType> {
    guard let oldElements = Self._getElements(object: old) else {
      return .typeError("old must be \(Self._pythonTypeName), not \(old.typeName)")
    }

    guard let newElements = Self._getElements(object: new) else {
      return .typeError("new must be \(Self._pythonTypeName), not \(new.typeName)")
    }

    var count: Int
    switch self._parseCount(count: countObject) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    let builder = self._replace(old: oldElements, new: newElements, count: count)
    let result = builder.finalize()
    let resultObject = Self._toObject(result: result)
    return .value(resultObject)
  }

  private func _replace(old: Elements, new: Elements, count: Int) -> Builder {
    // swiftlint:disable:next empty_count
    if count == 0 {
      return Builder(elements: self.elements)
    }

    let capacity = self._approximateCapacity(old: old, new: new, count: count)
    var builder = Builder(capacity: capacity)

    var index = self.elements.startIndex
    var remainingCount = count

    self._wouldBeBetterWithRandomAccessCollection()
    while index != self.elements.endIndex {
      let s = self.elements[index...]
      let startsWithOld = s.starts(with: old)

      if startsWithOld {
        builder.append(contentsOf: new)
        index = self.elements.index(index, offsetBy: old.count)

        remainingCount -= 1
        if remainingCount <= 0 {
          builder.append(contentsOf: self.elements[index...])
          break
        }
      } else {
        let element = self.elements[index]
        builder.append(element: element)

        self.elements.formIndex(after: &index)
      }
    }

    return builder
  }

  private func _approximateCapacity(old: Elements, new: Elements, count: Int) -> Int {
    func clamp(_ value: Int, min: Int, max: Int) -> Int {
      return Swift.min(max, Swift.max(min, value))
    }

    let countDiff = clamp(new.count - old.count, min: -10, max: 10)
    let expectedChangeCount = clamp(count, min: -10, max: 10)
    return self.elements.count + countDiff * expectedChangeCount
  }

  // MARK: - Count

  private func _parseCount(count: PyObject?) -> PyResult<Int> {
    guard let count = count else {
      return .value(Int.max)
    }

    guard let pyInt = PyCast.asInt(count) else {
      return .typeError("count must be int, not \(count.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("count is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}
