extension AbstractString {

  // MARK: - Add

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _add(other: PyObject) -> PyResult<SwiftType> {
    guard let otherElements = Self._getElements(object: other) else {
      let e = self._createAddTypeError(other: other)
      return .error(e)
    }

    let result = self._add(other: otherElements)
    let resultObject = Self._toObject(result: result)
    return .value(resultObject)
  }

  private func _add(other: Elements) -> Builder.Result {
    var builder = Builder(elements: self.elements)
    builder.append(contentsOf: other)
    return builder.finalize()
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _createAddTypeError(other: PyObject) -> PyTypeError {
    let t = Self._pythonTypeName
    let otherType = other.typeName
    let msg = "can only concatenate \(t) (not '\(otherType)') to \(t)"
    return Py.newTypeError(msg: msg)
  }

  // MARK: - Mul

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _mul(count countObject: PyObject) -> PyResult<SwiftType> {
    switch self._parseMulCount(object: countObject) {
    case let .value(count):
      let result = self._mul(count: count)
      let resultObject = Self._toObject(result: result)
      return .value(resultObject)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _parseMulCount(object: PyObject) -> PyResult<Int> {
    guard let pyInt = PyCast.asInt(object) else {
      let t = Self._pythonTypeName
      let msg = "can only multiply \(t) and int (not '\(object.typeName)')"
      return .typeError(msg)
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("repeated string is too long")
    }

    return .value(int)
  }

  private func _mul(count: Int) -> Builder.Result {
    let capacity = self.count * count
    var builder = Builder(capacity: capacity)

    if self.elements.isEmpty {
      return builder.finalize()
    }

    for _ in 0..<max(count, 0) {
      builder.append(contentsOf: self.elements)
    }

    return builder.finalize()
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rmul(count: PyObject) -> PyResult<SwiftType> {
    return self._mul(count: count)
  }
}
