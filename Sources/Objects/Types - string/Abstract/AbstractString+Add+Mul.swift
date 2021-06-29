extension AbstractString {

  // MARK: - Add

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _add(other: PyObject) -> PyResult<Self> {
    guard let otherElements = Self._getElements(object: other) else {
      let t = Self._pythonTypeName
      let otherType = other.typeName
      let msg = "can only concatenate \(t) (not '\(otherType)') to \(t)"
      return .typeError(msg)
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

  // MARK: - Mul

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _mul(count countObject: PyObject) -> PyResult<Self> {
    guard let countPyInt = PyCast.asInt(countObject) else {
      let t = Self._pythonTypeName
      let countType = countObject.typeName
      let msg = "can only multiply \(t) and int (not '\(countType)')"
      return .typeError(msg)
    }

    guard let count = Int(exactly: countPyInt.value) else {
      return .overflowError("repeated string is too long")
    }

    let result = self._mul(count: count)
    let resultObject = Self._toObject(result: result)
    return .value(resultObject)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _rmul(count: PyObject) -> PyResult<Self> {
    return self._mul(count: count)
  }

  private func _mul(count: Int) -> Builder.Result {
    let capacity = self.elements.count * count
    var builder = Builder(capacity: capacity)

    if self.elements.isEmpty {
      return builder.finalize()
    }

    for _ in 0..<max(count, 0) {
      builder.append(contentsOf: self.elements)
    }

    return builder.finalize()
  }
}
