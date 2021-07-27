import BigInt

// swiftlint:disable empty_count

// swiftlint:disable:next type_name
internal enum AbstractSequence_MulCount {
  case value(BigInt)
  case notImplemented
}

extension AbstractSequence {

  // MARK: - Add

  /// We can't handle the whole `__add__` operation in an abstract way,
  /// because there are some special cases for empty tuples.
  ///
  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _handleAddArgument(object: PyObject) -> PyResult<Self> {
    guard let objectAsSelf = Self._asSelf(object: object) else {
      let selfType = Self._pythonTypeName
      let objectType = object.typeName
      let msg = "can only concatenate \(selfType) (not '\(objectType)') to \(selfType)"
      return .typeError(msg)
    }

    return .value(objectAsSelf)
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _add(other: Self) -> Self {
    var elements = Elements()
    elements.reserveCapacity(self._length + other._length)
    elements.append(contentsOf: self.elements)
    elements.append(contentsOf: other.elements)
    return Self._toSelf(elements: elements)
  }

  // MARK: - Mul

  /// We can't handle the whole `__mul__` operation in an abstract way,
  /// because there are some special cases for tuples (for example when count
  /// is `0` or `1`).
  ///
  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _handleMulArgument(object: PyObject) -> AbstractSequence_MulCount {
    guard let int = PyCast.asInt(object) else {
      return .notImplemented
    }

    let result = Swift.max(int.value, 0)
    return .value(result)
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _mul(elements: inout Elements, count: BigInt) {
    assert(count >= 0)

    if count == 0 {
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
      // orginal 'elements'.
      for i in 0..<initialElementCount {
        let e = elements[i]
        elements.append(e)
      }
    }
  }
}
