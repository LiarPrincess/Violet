import BigInt

// swiftlint:disable empty_count

internal enum AbstractSequenceMulCount {
  case value(BigInt)
  case notImplemented
}

extension AbstractSequence {

  // MARK: - Add

  internal static func abstract__add__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other _other: PyObject,
                                       isTuple: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__add__")
    }

    guard let other = Self.downcast(py, _other) else {
      let selfType = Self.pythonTypeName
      let otherType = _other.typeName
      let message = "can only concatenate \(selfType) (not '\(otherType)') to \(selfType)"
      return .typeError(py, message: message)
    }

    // Tuples are immutable, so we can do some minor performance improvements.
    if isTuple {
      if zelf.isEmpty {
        return PyResult(other)
      }

      if other.isEmpty {
        return PyResult(zelf)
      }
    }

    var elements = Elements()
    elements.reserveCapacity(zelf.count + other.count)
    elements.append(contentsOf: zelf.elements)
    elements.append(contentsOf: other.elements)

    let result = Self.newObject(py, elements: elements)
    return PyResult(result)
  }

  // MARK: - Mul

  internal static func abstract__mul__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject,
                                       isTuple: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__mul__")
    }

    return Self.common__mul__(py, zelf: zelf, other: other, isTuple: isTuple)
  }

  internal static func abstract__rmul__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject,
                                        isTuple: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__rmul__")
    }

    return Self.common__mul__(py, zelf: zelf, other: other, isTuple: isTuple)
  }

  private static func common__mul__(_ py: Py,
                                    zelf: Self,
                                    other: PyObject,
                                    isTuple: Bool) -> PyResult {
    let count: BigInt
    switch Self.abstractParseMulCount(py, object: other) {
    case .value(let int): count = int
    case .notImplemented: return .notImplemented(py)
    }

    // Tuples are immutable, so we can just return 'zelf'.
    if isTuple && count == 1 {
      return PyResult(zelf)
    }

    var copy = zelf.elements
    Self.abstractMul(elements: &copy, count: count)

    let result = Self.newObject(py, elements: copy)
    return PyResult(result)
  }

  internal static func abstractParseMulCount(
    _ py: Py,
    object: PyObject
  ) -> AbstractSequenceMulCount {
    guard let int = py.cast.asInt(object) else {
      return .notImplemented
    }

    let result = Swift.max(int.value, 0)
    return .value(result)
  }

  internal static func abstractMul(elements: inout Elements, count: BigInt) {
    if count <= 0 {
      elements = []
      return
    }

    let alreadyHave = BigInt(1)
    if count == alreadyHave {
      return
    }

    let capacityBig = BigInt(elements.count) * count
    if let capacity = Int(exactly: capacityBig) {
      elements.reserveCapacity(capacity)
    }
    // else: we are in deep trouble, but we will let it crash

    let remainingCount = count - alreadyHave
    let initialElementCount = elements.count

    for _ in 0..<remainingCount {
      // We have to do it manually, otherwise we would need to create a copy of
      // original 'elements'.
      for i in 0..<initialElementCount {
        let e = elements[i]
        elements.append(e)
      }
    }
  }
}
