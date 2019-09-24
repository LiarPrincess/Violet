public final class PyNumberType {

  public init() { }

  // MARK: - Unary

  public func positive(_ number: PyObject) -> PyObject {
    return number
  }

  public func negative(_ number: PyObject) -> PyObject {
    return number
  }

  public func invert(_ number: PyObject) -> PyObject {
    return number
  }

  // MARK: - Arithmetic

  /// PyObject * PyNumber_Add(PyObject *v, PyObject *w)
  public func add(left: PyObject, right: PyObject) throws -> PyObject {
    let type: AdditiveTypeClass =
      try self.getBinaryOperationOwner(op: "+", left: left, right: right)
    return try type.add(left: left, right: right)
  }

  public func subtract(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func multiply(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func matrixMultiply(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func trueDivide(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func floorDivide(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func remainder(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func power(base: PyObject, exp: PyObject, z: PyObject) -> PyObject {
    return base
  }

  // MARK: - Shift

  public func lShift(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func rShift(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  // MARK: - Binary

  public func and(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func xor(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  public func or(left: PyObject, right: PyObject) -> PyObject {
    return left
  }

  // MARK: - Helpers

  /// Returns type which should be used to perform given operation.
  ///
  /// Order operations are tried until either a valid result or error:
  /// 1. `w.op(v,w)[*]`
  /// 2. `v.op(v,w)`
  /// 3. `w.op(v,w)`
  ///
  /// [*] only when: `left.type != right.type`
  /// and `right.type` is a subclass of `left.type`.
  private func getBinaryOperationOwner<TC>(op: String,
                                           left:  PyObject,
                                           right: PyObject) throws -> TC {
    // Check if left has given operation
    if let op = left.type as? TC {

      // If right also implements this operation and it is a subtype
      // then use overloaded operator
      if let subOp = right.type as? TC,
        left.type !== right.type,
        right.type.isSubtype(of: left.type) {
        return subOp
      }

      return op
    }

    // Check if right has given operation
    if let op = right.type as? TC {
      return op
    }

    throw ObjectError
      .unsupportedBinaryOperandType(operation: op, left: left, right: right)
  }
}
