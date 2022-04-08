extension AbstractString {

  internal static func abstractReplace(_ py: Py,
                                       zelf _zelf: PyObject,
                                       old oldObject: PyObject,
                                       new newObject: PyObject,
                                       count countObject: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "replace")
    }

    guard let old = Self.getElements(py, object: oldObject) else {
      let message = "old must be \(Self.pythonTypeName), not \(oldObject.typeName)"
      return .typeError(py, message: message)
    }

    guard let new = Self.getElements(py, object: newObject) else {
      let message = "new must be \(Self.pythonTypeName), not \(newObject.typeName)"
      return .typeError(py, message: message)
    }

    var count: Int
    switch Self.parseCount(py, count: countObject) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    let builder = Self.replace(zelf: zelf, old: old, new: new, count: count)
    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  private static func replace(zelf: Self,
                              old: Elements,
                              new: Elements,
                              count: Int) -> Builder {
    // swiftlint:disable:next empty_count
    if count == 0 {
      return Builder(elements: zelf.elements)
    }

    let capacity = Self.approximateCapacity(zelf: zelf, old: old, new: new, count: count)
    var builder = Builder(capacity: capacity)

    var index = zelf.elements.startIndex
    var remainingCount = count

    Self.wouldBeBetterWithRandomAccessCollection()
    while index != zelf.elements.endIndex {
      let s = zelf.elements[index...]
      let startsWithOld = s.starts(with: old)

      if startsWithOld {
        builder.append(contentsOf: new)
        index = zelf.elements.index(index, offsetBy: old.count)

        remainingCount -= 1
        if remainingCount <= 0 {
          builder.append(contentsOf: zelf.elements[index...])
          break
        }
      } else {
        let element = zelf.elements[index]
        builder.append(element: element)

        zelf.elements.formIndex(after: &index)
      }
    }

    return builder
  }

  private static func approximateCapacity(zelf: Self,
                                          old: Elements,
                                          new: Elements,
                                          count: Int) -> Int {
    let countDiff = Self.clamp(new.count - old.count, min: -10, max: 10)
    let expectedChangeCount = Self.clamp(count, min: -10, max: 10)
    return zelf.count + countDiff * expectedChangeCount
  }

  private static func clamp(_ value: Int, min: Int, max: Int) -> Int {
    return Swift.min(max, Swift.max(min, value))
  }

  private static func parseCount(_ py: Py, count: PyObject?) -> PyResultGen<Int> {
    guard let count = count else {
      return .value(Int.max)
    }

    guard let pyInt = py.cast.asInt(count) else {
      return .typeError(py, message: "count must be int, not \(count.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError(py, message: "count is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}
