extension PyContext {

  // MARK: - Add

  /// PyObject * PyNumber_Add(PyObject *v, PyObject *w)
  public func add(left: PyObject, right: PyObject) -> PyObject {
    return self.add(left: left, right: right, op: "+")
  }

  internal func add(left: PyObject, right: PyObject, op: String) -> PyObject {
    // TODO: this will not work for: Int + Double -> Double
//    let type: AddTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.sub(left: left, right: right)
//
//
//    if let type: AddTypeClass = self.getTypeClassOrNil(left: left, right: right) {
//      return type.add(left: left, right: right)
//    }
//
//    if let type: ConcatTypeClass = self.getTypeClassOrNil(left: left, right: right) {
//      return type.concat(left: left, right: right)
//    }
//
//    throw PyContextError
//      .unsupportedBinaryOperandType(operation: op, left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Sub

  /// BINARY_FUNC(PyNumber_Subtract, nb_subtract, "-")
  public func sub(left: PyObject, right: PyObject) -> PyObject {
    return self.sub(left: left, right: right, op: "-")
  }

  // sourcery: pymethod = __sub__
  internal func sub(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: SubTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.sub(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Mul

  /// PyObject * PyNumber_Multiply(PyObject *v, PyObject *w)
  public func mul(left: PyObject, right: PyObject) -> PyObject {
    return self.mul(left: left, right: right, op: "*")
  }

  // sourcery: pymethod = __mul__
  internal func mul(left: PyObject, right: PyObject, op: String) -> PyObject {
//    if let type: MulTypeClass = self.getTypeClassOrNil(left: left, right: right) {
//      return type.mul(left: left, right: right)
//    }
//
//    // [1] * 2 -> [1, 1] (or you know: [1] * True -> [1], because True is Int)
//    if let leftRepeat = left.type as? RepeatTypeClass {
//      let count = self.asRepeatCount(right)
//      return leftRepeat.repeat(value: left, count: count)
//    }
//
//    // 2 * [1] -> [1, 1]
//    if let rightRepeat = right.type as? RepeatTypeClass {
//      let count = self.asRepeatCount(left)
//      return rightRepeat.repeat(value: right, count: count)
//    }
//
//    throw PyContextError
//      .unsupportedBinaryOperandType(operation: op, left: left, right: right)
    return self.unimplemented()
  }

  internal func asRepeatCount(_ value: PyObject) -> PyInt {
    if let i = value as? PyInt {
      return i
    }

    fatalError()
  }

  // MARK: - Matrix mul

  /// PyObject * PyNumber_MatrixMultiply(PyObject *v, PyObject *w)
  public func matrixMul(left: PyObject, right: PyObject) -> PyObject {
    return self.matrixMul(left: left, right: right, op: "@")
  }

  internal func matrixMul(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: MatrixMulTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.matrixMul(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Pow

  /// PyObject * PyNumber_Power(PyObject *v, PyObject *w, PyObject *z)
  public func pow(value: PyObject, exponent: PyObject) -> PyObject {
    return self.pow(value: value, exponent: exponent, op: "** or pow()")
  }

  // sourcery: pymethod = __pow__
  internal func pow(value: PyObject, exponent: PyObject, op: String) -> PyObject {
//    let type: PowTypeClass = self.getTypeClass(op: op, left: value, right: exponent)
//    return type.pow(value: value, exponent: exponent)
    return self.unimplemented()
  }

  // MARK: - Div

  /// PyObject * PyNumber_TrueDivide(PyObject *v, PyObject *w)
  public func div(left: PyObject, right: PyObject) -> PyObject {
    return self.div(left: left, right: right, op: "/")
  }

  internal func div(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: DivTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.div(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Div floor

  /// PyObject * PyNumber_FloorDivide(PyObject *v, PyObject *w)
  public func divFloor(left: PyObject, right: PyObject) -> PyObject {
    return self.divFloor(left: left, right: right, op: "//")
  }

  internal func divFloor(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: DivFloorTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.divFloor(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Remainder

  /// PyObject * PyNumber_Remainder(PyObject *v, PyObject *w)
  public func remainder(left: PyObject, right: PyObject) -> PyObject {
    return self.remainder(left: left, right: right, op: "%")
  }

  internal func remainder(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: RemainderTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.remainder(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Div mod

  /// BINARY_FUNC(PyNumber_Divmod, nb_divmod, "divmod()")
  public func divMod(left: PyObject, right: PyObject) -> PyObject {
    return self.divMod(left: left, right: right, op: "divmod()")
  }

  // sourcery: pymethod = __divmod__
  internal func divMod(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: DivModTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.divMod(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Left shift

  /// BINARY_FUNC(PyNumber_Lshift, nb_lshift, "<<")
  public func lShift(left: PyObject, right: PyObject) -> PyObject {
    return self.lShift(left: left, right: right, op: "<<")
  }

  // sourcery: pymethod = __lshift__
  internal func lShift(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: ShiftTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.lShift(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Right shift

  /// BINARY_FUNC(PyNumber_Rshift, nb_rshift, ">>")
  public func rShift(left: PyObject, right: PyObject) -> PyObject {
    return self.rShift(left: left, right: right, op: ">>")
  }

  // sourcery: pymethod = __rshift__
  internal func rShift(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: ShiftTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.rShift(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Binary - and

  /// BINARY_FUNC(PyNumber_And, nb_and, "&")
  public func and(left: PyObject, right: PyObject) -> PyObject {
    return self.and(left: left, right: right, op: "&")
  }

  internal func and(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: BinaryTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.and(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Binary - or

  /// BINARY_FUNC(PyNumber_Or, nb_or, "|")
  public func or(left: PyObject, right: PyObject) -> PyObject {
    return self.or(left: left, right: right, op: "|")
  }

  internal func or(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: BinaryTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.or(left: left, right: right)
    return self.unimplemented()
  }

  // MARK: - Binary - xor

  /// BINARY_FUNC(PyNumber_Xor, nb_xor, "^")
  public func xor(left: PyObject, right: PyObject) -> PyObject {
    return self.xor(left: left, right: right, op: "^")
  }

  internal func xor(left: PyObject, right: PyObject, op: String) -> PyObject {
//    let type: BinaryTypeClass = self.getTypeClass(op: op, left: left, right: right)
//    return type.xor(left: left, right: right)
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
                                 right: PyObject) -> TC {
    if let type: TC = self.getTypeClassOrNil(left: left, right: right) {
      return type
    }

    fatalError()
  }
}
