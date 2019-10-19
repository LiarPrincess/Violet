extension PyContext {

  // MARK: - Unary

  /// PyObject * PyNumber_Positive(PyObject *o)
  public func positive(_ value: PyObject) throws -> PyObject {
    return self.unimplemented()
//    if let v = value as? SignedTypeClass {
//      return try v.positive()
//    }
//
//    throw PyContextError.invalidOperandForUnaryPositive(value)
  }

  /// PyObject * PyNumber_Negative(PyObject *o)
  public func negative(_ value: PyObject) throws -> PyObject {
      return self.unimplemented()
//    if let v = value as? SignedTypeClass {
//      return try v.negative()
//    }
//
//    throw PyContextError.invalidOperandForUnaryNegative(value)
  }

  /// PyObject * PyNumber_Invert(PyObject *o)
  public func invert(_ value: PyObject) throws -> PyObject {
    return self.unimplemented()
//    if let v = value as? InvertTypeClass {
//      return try v.invert()
//    }
//
//    throw PyContextError.invalidOperandForUnaryInvert(value)
  }

  /// PyObject * PyNumber_Absolute(PyObject *o)
  public func abs(_ value: PyObject) throws -> PyObject {
    return self.unimplemented()
//    if let v = value as? AbsTypeClass {
//      return try v.abs()
//    }
//
//    throw PyContextError.invalidOperandForAbs(value)
  }

  // MARK: - Add

  /// PyObject * PyNumber_Add(PyObject *v, PyObject *w)
  public func add(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.add(left: left, right: right, op: "+")
  }

  internal func add(left: PyObject, right: PyObject, op: String) throws -> PyObject {
    // TODO: this will not work for: Int + Double -> Double
//    let type: AddTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.sub(left: left, right: right)
//
//
//    if let type: AddTypeClass = self.getTypeClassOrNil(left: left, right: right) {
//      return try type.add(left: left, right: right)
//    }
//
//    if let type: ConcatTypeClass = self.getTypeClassOrNil(left: left, right: right) {
//      return try type.concat(left: left, right: right)
//    }
//
//    throw PyContextError
//      .unsupportedBinaryOperandType(operation: op, left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Sub

  /// BINARY_FUNC(PyNumber_Subtract, nb_subtract, "-")
  public func sub(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.sub(left: left, right: right, op: "-")
  }

  // sourcery: pymethod = __sub__
  internal func sub(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: SubTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.sub(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Mul

  /// PyObject * PyNumber_Multiply(PyObject *v, PyObject *w)
  public func mul(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.mul(left: left, right: right, op: "*")
  }

  // sourcery: pymethod = __mul__
  internal func mul(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    if let type: MulTypeClass = self.getTypeClassOrNil(left: left, right: right) {
//      return try type.mul(left: left, right: right)
//    }
//
//    // [1] * 2 -> [1, 1] (or you know: [1] * True -> [1], because True is Int)
//    if let leftRepeat = left.type as? RepeatTypeClass {
//      let count = try self.asRepeatCount(right)
//      return try leftRepeat.repeat(value: left, count: count)
//    }
//
//    // 2 * [1] -> [1, 1]
//    if let rightRepeat = right.type as? RepeatTypeClass {
//      let count = try self.asRepeatCount(left)
//      return try rightRepeat.repeat(value: right, count: count)
//    }
//
//    throw PyContextError
//      .unsupportedBinaryOperandType(operation: op, left: left, right: right)
    return self.unimplemented()
  }

  internal func asRepeatCount(_ value: PyObject) throws -> PyInt {
    if let i = value as? PyInt {
      return i
    }
    throw PyContextError.sequenceRepeatWithNonInt(value)
  }

  // MARK: - Matrix mul

  /// PyObject * PyNumber_MatrixMultiply(PyObject *v, PyObject *w)
  public func matrixMul(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.matrixMul(left: left, right: right, op: "@")
  }

  internal func matrixMul(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: MatrixMulTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.matrixMul(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Pow

  /// PyObject * PyNumber_Power(PyObject *v, PyObject *w, PyObject *z)
  public func pow(value: PyObject, exponent: PyObject) throws -> PyObject {
    return try self.pow(value: value, exponent: exponent, op: "** or pow()")
  }

  // sourcery: pymethod = __pow__
  internal func pow(value: PyObject, exponent: PyObject, op: String) throws -> PyObject {
//    let type: PowTypeClass = try self.getTypeClass(op: op, left: value, right: exponent)
//    return try type.pow(value: value, exponent: exponent)
    return self.unimplemented()
  }

  // MARK: - Div

  /// PyObject * PyNumber_TrueDivide(PyObject *v, PyObject *w)
  public func div(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.div(left: left, right: right, op: "/")
  }

  internal func div(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: DivTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.div(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Div floor

  /// PyObject * PyNumber_FloorDivide(PyObject *v, PyObject *w)
  public func divFloor(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.divFloor(left: left, right: right, op: "//")
  }

  internal func divFloor(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: DivFloorTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.divFloor(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Remainder

  /// PyObject * PyNumber_Remainder(PyObject *v, PyObject *w)
  public func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.remainder(left: left, right: right, op: "%")
  }

  internal func remainder(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: RemainderTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.remainder(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Div mod

  /// BINARY_FUNC(PyNumber_Divmod, nb_divmod, "divmod()")
  public func divMod(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.divMod(left: left, right: right, op: "divmod()")
  }

  // sourcery: pymethod = __divmod__
  internal func divMod(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: DivModTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.divMod(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Left shift

  /// BINARY_FUNC(PyNumber_Lshift, nb_lshift, "<<")
  public func lShift(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.lShift(left: left, right: right, op: "<<")
  }

  // sourcery: pymethod = __lshift__
  internal func lShift(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: ShiftTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.lShift(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Right shift

  /// BINARY_FUNC(PyNumber_Rshift, nb_rshift, ">>")
  public func rShift(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.rShift(left: left, right: right, op: ">>")
  }

  // sourcery: pymethod = __rshift__
  internal func rShift(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: ShiftTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.rShift(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Binary - and

  /// BINARY_FUNC(PyNumber_And, nb_and, "&")
  public func and(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.and(left: left, right: right, op: "&")
  }

  internal func and(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: BinaryTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.and(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Binary - or

  /// BINARY_FUNC(PyNumber_Or, nb_or, "|")
  public func or(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.or(left: left, right: right, op: "|")
  }

  internal func or(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: BinaryTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.or(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Binary - xor

  /// BINARY_FUNC(PyNumber_Xor, nb_xor, "^")
  public func xor(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.xor(left: left, right: right, op: "^")
  }

  internal func xor(left: PyObject, right: PyObject, op: String) throws -> PyObject {
//    let type: BinaryTypeClass = try self.getTypeClass(op: op, left: left, right: right)
//    return try type.xor(left: left, right: right)
    return self.unimplemented()
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
  internal func getTypeClassOrNil<TC>(left: PyObject, right: PyObject) -> TC? {
    // Check if left has given operation
    if let l = left as? TC {

      // If right also implements this operation and it is a subtype
      // then use overloaded operator
      let isSubtype = left.type !== right.type &&
        self.PyType_IsSubtype(parent: right.type, subtype: left.type)

      if let r = right as? TC, isSubtype {
        return r
      }

      return l
    }

    // Check if right has given operation
    if let r = right as? TC {
      return r
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
  internal func getTypeClass<TC>(op: String,
                                 left:  PyObject,
                                 right: PyObject) throws -> TC {
    if let type: TC = self.getTypeClassOrNil(left: left, right: right) {
      return type
    }

    throw PyContextError
      .unsupportedBinaryOperandType(operation: op, left: left, right: right)
  }
}
