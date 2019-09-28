// MARK: - Unary

internal protocol SignedTypeClass: TypeClass {
  /// Returns o on success.
  /// This is the equivalent of the Python expression +o.
  func positive(value: PyObject) throws -> PyObject
  /// Returns the negation of o on success.
  /// This is the equivalent of the Python expression -o.
  func negative(value: PyObject) throws -> PyObject
}

internal protocol AbsTypeClass: TypeClass {
  /// Returns the absolute value of o.
  /// This is the equivalent of the Python expression abs(o).
  func abs(value: PyObject) throws -> PyObject
}

internal protocol InvertTypeClass: TypeClass {
  /// Returns the bitwise negation of o on success.
  /// This is the equivalent of the Python expression ~o.
  func invert(value: PyObject) throws -> PyObject
}

internal protocol IndexTypeClass: TypeClass {
  /// Returns the o converted to a Python int on success
  /// or TypeError exception raised on failure.
  func index(value: PyObject) throws -> PyInt
}

// MARK: - Add, sub

internal protocol AddTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2.
  /// This is the equivalent of the Python expression o1 + o2.
  func add(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol AddInPlaceTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 += o2.
  func addInPlace(left: PyObject, right: PyObject) throws
}

internal protocol SubTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1.
  /// This is the equivalent of the Python expression o1 - o2.
  func sub(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol SubInPlaceTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 -= o2.
  func subInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Mul

internal protocol MulTypeClass: TypeClass {
  /// Returns the result of multiplying o1 and o2.
  /// This is the equivalent of the Python expression o1 * o2.
  func mul(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol MulInPlaceTypeClass: TypeClass {
  /// Returns the result of multiplying o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 *= o2.
  func mulInPlace(left: PyObject, right: PyObject) throws
}

internal protocol MatrixMulTypeClass: TypeClass {
  /// Returns the result of matrix multiplication on o1 and o2.
  /// This is the equivalent of the Python expression o1 @ o2.
  func matrixMul(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol MatrixMulInPlaceTypeClass: TypeClass {
  /// Returns the result of matrix multiplication on o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 @= o2.
  func matrixMulInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Div

internal protocol DivTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2.
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  func div(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol DivInPlaceTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2..
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  /// The operation is done in-place when o1 supports it.
  func divInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol DivFloorTypeClass: TypeClass {
  /// Return the floor of o1 divided by o2.
  /// This is equivalent to the “classic” division of integers.
  func divFloor(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol DivFloorInPlaceTypeClass: TypeClass {
  /// Returns the mathematical floor of dividing o1 by o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 //= o2.
  func divFloorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol RemainderTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2.
  /// This is the equivalent of the Python expression o1 % o2.
  func remainder(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol RemainderInPlaceTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 %= o2.
  func remainderInPlace(left: PyObject, right: PyObject) throws
}

internal protocol DivModTypeClass: TypeClass {
  /// See the built-in function divmod(). Returns NULL on failure.
  /// This is the equivalent of the Python expression divmod(o1, o2).
  func divMod(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Shift

internal protocol ShiftTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 << o2.
  func lShift(left: PyObject, right: PyObject) throws -> PyObject
  /// Returns the result of right shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 >> o2.
  func rShift(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol ShiftInPlaceTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 <<= o2.
  func lShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
  /// Returns the result of right shifting o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 >>= o2.
  func rShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Binary

internal protocol BinaryTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// This is the equivalent of the Python expression o1 & o2.
  func and(left: PyObject, right: PyObject) throws -> PyObject
  /// Returns the “bitwise or” of o1 and o2 on success.
  /// This is the equivalent of the Python expression o1 | o2.
  func or(left: PyObject, right: PyObject) throws -> PyObject
  /// Returns the “bitwise exclusive or” of o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 ^ o2.
  func xor(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol BinaryInPlaceTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 &= o2.
  func andInPlace(left: PyObject, right: PyObject) throws -> PyObject
  /// Returns the “bitwise or” of o1 and o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 |= o2.
  func orInPlace(left: PyObject, right: PyObject) throws -> PyObject
  /// Returns the “bitwise exclusive or” of o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 ^= o2.
  func xorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Power

internal protocol PowTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// This is the equivalent of the Python expression pow(o1, o2, o3),
  /// where o3 is optional.
  func pow(value: PyObject, exponent: PyObject) throws -> PyObject
}

internal protocol PowInPlaceTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 **= o2 when o3 is Py_None,
  /// or an in-place variant of pow(o1, o2, o3) otherwise.
  /// If o3 is to be ignored, pass Py_None in its place
  /// (passing NULL for o3 would cause an illegal memory access).
  func powInPlace(value: PyObject, exponent: PyObject) throws -> PyObject
}
