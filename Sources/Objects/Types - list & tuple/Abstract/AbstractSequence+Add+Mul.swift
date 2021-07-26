import BigInt

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
  internal func _mul(count: BigInt) -> Self {
    var elements = [PyObject]()

    let capacityBig = BigInt(self._length) * count
    if let capacity = Int(exactly: capacityBig) {
      elements.reserveCapacity(capacity)
    }
    // else: we are in deep trouble, but we will let it crash

    for _ in 0..<count {
      elements.append(contentsOf: self.elements)
    }

    return Self._toSelf(elements: elements)
  }
}
