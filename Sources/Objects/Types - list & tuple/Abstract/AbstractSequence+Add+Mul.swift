import BigInt

private enum MulCount {
  case value(BigInt)
  case notImplemented
}

extension AbstractSequence {

  // MARK: - Add

  internal static func abstract__add__(_ py: Py,
                                       zelf: PyObject,
                                       other: PyObject,
                                       isTuple: Bool) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__add__")
    }

    guard let other = Self.castAsSelf(py, other) else {
      let selfType = Self.abstractPythonTypeName
      let otherType = other.typeName
      let message = "can only concatenate \(selfType) (not '\(otherType)') to \(selfType)"
      return .typeError(py, message: message)
    }

    // Tuples are immutable, so we can do some minor performance improvements.
    if isTuple {
      if zelf.isEmpty {
        return .value(other.asObject)
      }

      if other.isEmpty {
        return .value(zelf.asObject)
      }
    }

    var elements = Elements()
    elements.reserveCapacity(zelf.count + other.count)
    elements.append(contentsOf: zelf.elements)
    elements.append(contentsOf: other.elements)

    let result = Self.newSelf(py, elements: elements)
    return .value(result.asObject)
  }

  // MARK: - Mul

  internal static func abstract__mul__(_ py: Py,
                                       zelf: PyObject,
                                       other: PyObject,
                                       isTuple: Bool) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__mul__")
    }

    return Self.mul(py, zelf: zelf, other: other, isTuple: isTuple)
  }

  internal static func abstract__rmul__(_ py: Py,
                                        zelf: PyObject,
                                        other: PyObject,
                                        isTuple: Bool) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__rmul__")
    }

    return Self.mul(py, zelf: zelf, other: other, isTuple: isTuple)
  }

  private static func mul(_ py: Py,
                          zelf: Self,
                          other: PyObject,
                          isTuple: Bool) -> PyResult<PyObject> {
    let count: BigInt
    switch Self.parseMulCount(py, object: other) {
    case .value(let int): count = int
    case .notImplemented: return .notImplemented(py)
    }

    if count <= 0 {
      // For tuple: it will return interned 'py.emptyTuple'.
      let empty = Self.newSelf(py, elements: [])
      return .value(empty.asObject)
    }

    let elements = zelf.elements
    var result = elements

    if count == 1 {
      // Tuples are immutable, so we can just return 'zelf'.
      let result = isTuple ? zelf : Self.newSelf(py, elements: result)
      return .value(result.asObject)
    }

    let capacityBig = BigInt(elements.count) * count
    if let capacity = Int(exactly: capacityBig) {
      result.reserveCapacity(capacity)
    }
    // else: we are in deep trouble, but we will let it crash

    // We already have '1' copy in the result (the initial one)
    let remainingCount = count - 1

    for _ in 0..<remainingCount {
      result.append(contentsOf: elements)
    }

    let resultSelf = Self.newSelf(py, elements: result)
    return .value(resultSelf.asObject)
  }

  private static func parseMulCount(_ py: Py, object: PyObject) -> MulCount {
    guard let int = py.cast.asInt(object) else {
      return .notImplemented
    }

    let result = Swift.max(int.value, 0)
    return .value(result)
  }
}
