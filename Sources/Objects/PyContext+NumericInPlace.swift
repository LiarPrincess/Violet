extension PyContext {

  // MARK: - Add

  /// PyObject * PyNumber_InPlaceAdd(PyObject *v, PyObject *w)
  public func addInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: AddInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.addInPlace(left: left, right: right)
      return left
    }

    if let type: AddTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      return try type.add(left: left, right: right)
    }

    if let type: ConcatInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.concatInPlace(left: left, right: right)
      return left
    }

    if let type: ConcatTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      return try type.concat(left: left, right: right)
    }

    throw PyContextError
      .unsupportedBinaryOperandType(operation: "+=", left: left, right: right)
  }

  // MARK: - Sub

  /// INPLACE_BINOP(PyNumber_InPlaceSubtract, nb_inplace_subtract, nb_subtract, "-=")
  public func subInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: SubInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.subInPlace(left: left, right: right)
      return left
    }

    return try self.sub(left: left, right: right, op: "-=")
  }

  // MARK: - Mul

  /// PyObject * PyNumber_InPlaceMultiply(PyObject *v, PyObject *w)
  public func mulInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: MulInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.mulInPlace(left: left, right: right)
      return left
    }

    if let type: MulTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      return try type.mul(left: left, right: right)
    }

    // a = [1]
    // a *= 2 -> [1, 1]
    if let leftRepeat = left.type as? RepeatInPlaceTypeClass {
      let count = try self.asRepeatCount(right)
      try leftRepeat.repeatInPlace(value: left, count: count)
      return left
    }

    // [1] * 2 -> [1, 1]
    if let leftRepeat = left.type as? RepeatTypeClass {
      let count = try self.asRepeatCount(right)
      return try leftRepeat.repeat(value: left, count: count)
    }

    // Note that the right hand operand should not be mutated in this case
    // so 'RepeatInPlaceTypeClass' is not used.

    // 2 * [1] -> [1, 1]
    if let rightRepeat = right.type as? RepeatTypeClass {
      let count = try self.asRepeatCount(left)
      return try rightRepeat.repeat(value: right, count: count)
    }

    throw PyContextError
      .unsupportedBinaryOperandType(operation: "*=", left: left, right: right)
  }

  /// PyObject * PyNumber_InPlaceMatrixMultiply(PyObject *v, PyObject *w)
  public func matrixMulInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: MatrixMulInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.matrixMulInPlace(left: left, right: right)
      return left
    }

    return try self.matrixMul(left: left, right: right, op: "@=")
  }

  /// PyObject * PyNumber_InPlacePower(PyObject *v, PyObject *w, PyObject *z)
  public func powInPlace(value: PyObject, exponent: PyObject) throws -> PyObject {
    if let type: PowInPlaceTypeClass = self.getTypeClassOrNil(left: value, right: exponent) {
      try type.powInPlace(value: value, exponent: exponent)
      return value
    }

    return try self.pow(value: value, exponent: exponent, op: "**=")
  }

  // MARK: - Div

  /// PyObject * PyNumber_InPlaceTrueDivide(PyObject *v, PyObject *w)
  public func divInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: DivInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.divInPlace(left: left, right: right)
      return left
    }

    return try self.div(left: left, right: right, op: "/=")
  }

  /// PyObject * PyNumber_InPlaceFloorDivide(PyObject *v, PyObject *w)
  public func divFloorInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: DivFloorInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.divFloorInPlace(left: left, right: right)
      return left
    }

    return try self.divFloor(left: left, right: right, op: "//=")
  }

  /// PyObject * PyNumber_InPlaceRemainder(PyObject *v, PyObject *w)
  public func remainderInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: RemainderInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.remainderInPlace(left: left, right: right)
      return left
    }

    return try self.remainder(left: left, right: right, op: "%=")
  }

  // MARK: - Shift

  /// INPLACE_BINOP(PyNumber_InPlaceLshift, nb_inplace_lshift, nb_lshift, "<<=")
  public func lShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: ShiftInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.lShiftInPlace(left: left, right: right)
      return left
    }

    return try self.lShift(left: left, right: right, op: "<<=")
  }

  /// INPLACE_BINOP(PyNumber_InPlaceRshift, nb_inplace_rshift, nb_rshift, ">>=")
  public func rShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: ShiftInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.rShiftInPlace(left: left, right: right)
      return left
    }

    return try self.rShift(left: left, right: right, op: ">>=")
  }

  // MARK: - Binary

  /// INPLACE_BINOP(PyNumber_InPlaceAnd, nb_inplace_and, nb_and, "&=")
  public func andInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: BinaryInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.andInPlace(left: left, right: right)
      return left
    }

    return try self.and(left: left, right: right, op: "&=")
  }

  /// INPLACE_BINOP(PyNumber_InPlaceOr, nb_inplace_or, nb_or, "|=")
  public func orInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: BinaryInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.orInPlace(left: left, right: right)
      return left
    }

    return try self.or(left: left, right: right, op: "|=")
  }

  /// INPLACE_BINOP(PyNumber_InPlaceXor, nb_inplace_xor, nb_xor, "^=")
  public func xorInPlace(left: PyObject, right: PyObject) throws -> PyObject {
    if let type: BinaryInPlaceTypeClass = self.getTypeClassOrNil(left: left, right: right) {
      try type.xorInPlace(left: left, right: right)
      return left
    }

    return try self.xor(left: left, right: right, op: "^=")
  }
}
