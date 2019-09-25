extension PyContext {

  // MARK: - Unary

  public func positive(_ value: PyObject) throws -> PyObject {
    if let signed = value.type as? SignedTypeClass {
      return try signed.positive(value: value)
    }

    throw PyContextError.invalidOperandForUnaryPositive(value)
  }

  public func negative(_ value: PyObject) throws -> PyObject {
    if let signed = value.type as? SignedTypeClass {
      return try signed.negative(value: value)
    }

    throw PyContextError.invalidOperandForUnaryNegative(value)
  }

  public func invert(_ value: PyObject) throws -> PyObject {
    if let type = value.type as? InvertTypeClass {
      return try type.invert(value: value)
    }

    throw PyContextError.invalidOperandForUnaryInvert(value)
  }

  public func abs(_ value: PyObject) throws -> PyObject {
    if let type = value.type as? AbsTypeClass {
      return try type.abs(value: value)
    }

    throw PyContextError.invalidOperandForAbs(value)
  }

  // MARK: - Add, sub

  /// PyObject * PyNumber_Add(PyObject *v, PyObject *w)
  public func add(left: PyObject, right: PyObject) throws -> PyObject {
    // TODO: this will not work for: Int + Double -> Double
    if let additive: AddTypeClass =
      self.getTypeClassOrNil(left: left, right: right) {
      return try additive.add(left: left, right: right)
    }

    if let concatenable: ConcatTypeClass =
      self.getTypeClassOrNil(left: left, right: right) {
      return try concatenable.concat(left: left, right: right)
    }

    throw PyContextError.unsupportedBinaryOperandType(operation: "+",
                                                   left: left,
                                                   right: right)
  }

  public func sub(left: PyObject, right: PyObject) throws -> PyObject {
    let subtractive: SubTypeClass =
      try self.getTypeClass(op: "-", left: left, right: right)

    return try subtractive.sub(left: left, right: right)
  }

  // MARK: - Mul

  public func mul(left: PyObject, right: PyObject) throws -> PyObject {
    if let multiplicative: MulTypeClass =
      self.getTypeClassOrNil(left: left, right: right) {
      return try multiplicative.mul(left: left, right: right)
    }

    // [1] * 2 -> [1, 1] (or you know: [1] * True -> [1], because True is Int)
    if let leftRepeat = left.type as? RepeatTypeClass {
      let count = try self.asRepeatCount(right)
      return try leftRepeat.repeat(value: left, count: count)
    }

    // 2 * [1] -> [1, 1]
    if let rightRepeat = right.type as? RepeatTypeClass {
      let count = try self.asRepeatCount(left)
      return try rightRepeat.repeat(value: right, count: count)
    }

    throw PyContextError.unsupportedBinaryOperandType(operation: "*",
                                                   left: left,
                                                   right: right)
  }

  private func asRepeatCount(_ value: PyObject) throws -> PyInt {
    if let i = value as? PyInt {
      return i
    }
    throw PyContextError.sequenceRepeatWithNonInt(value)
  }

  public func matrixMul(left: PyObject, right: PyObject) throws -> PyObject {
    let multiplicative: MatrixMulTypeClass =
      try self.getTypeClass(op: "@", left: left, right: right)

    return try multiplicative.matrixMul(left: left, right: right)
  }

  // MARK: - Div

  public func div(left: PyObject, right: PyObject) throws -> PyObject {
    let dividable: DivTypeClass =
      try self.getTypeClass(op: "/", left: left, right: right)

    return try dividable.div(left: left, right: right)
  }

  public func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    let dividable: DivFloorTypeClass =
      try self.getTypeClass(op: "//", left: left, right: right)

    return try dividable.divFloor(left: left, right: right)
  }

  public func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    let type: RemainderTypeClass =
      try self.getTypeClass(op: "%", left: left, right: right)

    return try type.remainder(left: left, right: right)
  }

  public func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    let type: DivModTypeClass =
      try self.getTypeClass(op: "divmod()", left: left, right: right)

    return try type.divMod(left: left, right: right)
  }

  // MARK: - Power

  public func pow(left: PyObject, right: PyObject) throws -> PyObject {
    let type: PowTypeClass =
      try self.getTypeClass(op: "** or pow()", left: left, right: right)

    return try type.pow(left: left, right: right)
  }

  // MARK: - Shift

  public func lShift(left: PyObject, right: PyObject) throws -> PyObject {
    let type: ShiftTypeClass =
      try self.getTypeClass(op: "<<", left: left, right: right)

    return try type.lShift(left: left, right: right)
  }

  public func rShift(left: PyObject, right: PyObject) throws -> PyObject {
    let type: ShiftTypeClass =
      try self.getTypeClass(op: ">>", left: left, right: right)

    return try type.rShift(left: left, right: right)
  }

  // MARK: - Binary

  public func and(left: PyObject, right: PyObject) throws -> PyObject {
    let type: BinaryTypeClass =
      try self.getTypeClass(op: "&", left: left, right: right)

    return try type.and(left: left, right: right)
  }

  public func or(left: PyObject, right: PyObject) throws -> PyObject {
    let type: BinaryTypeClass =
      try self.getTypeClass(op: "|", left: left, right: right)

    return try type.or(left: left, right: right)
  }

  public func xor(left: PyObject, right: PyObject) throws -> PyObject {
    let type: BinaryTypeClass =
      try self.getTypeClass(op: "^", left: left, right: right)

    return try type.xor(left: left, right: right)
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
  private func getTypeClassOrNil<TC>(left: PyObject, right: PyObject) -> TC? {
    // Check if left has given operation
    if let op = left.type as? TC {

      // If right also implements this operation and it is a subtype
      // then use overloaded operator
      let isSubtype = left.type !== right.type && right.type.isSubtype(of: left.type)
      if let subOp = right.type as? TC, isSubtype {
        return subOp
      }

      return op
    }

    // Check if right has given operation
    if let op = right.type as? TC {
      return op
    }

    return nil
  }

  /// Returns type which should be used to perform given operation.
  ///
  /// Order operations are tried until either a valid result or error:
  /// 1. `w.op(v,w)[*]`
  /// 2. `v.op(v,w)`
  /// 3. `w.op(v,w)`
  ///
  /// [*] only when: `left.type != right.type`
  /// and `right.type` is a subclass of `left.type`.

  private func getTypeClass<TC>(op: String,
                                left:  PyObject,
                                right: PyObject) throws -> TC {
    if let type: TC = self.getTypeClassOrNil(left: left, right: right) {
      return type
    }

    throw PyContextError.unsupportedBinaryOperandType(operation: op,
                                                   left: left,
                                                   right: right)
  }
}
