// MARK: - Unary

internal protocol SignedTypeClass: TypeClass {
  /// Returns o on success.
  /// This is the equivalent of the Python expression +o.
  func positive() -> PyObject
  /// Returns the negation of o on success.
  /// This is the equivalent of the Python expression -o.
  func negative() -> PyObject
}

internal protocol AbsTypeClass: TypeClass {
  /// Returns the absolute value of o.
  /// This is the equivalent of the Python expression abs(o).
  func abs() -> PyObject
}

internal protocol InvertTypeClass: TypeClass {
  /// Returns the bitwise negation of o on success.
  /// This is the equivalent of the Python expression ~o.
  func invert() -> PyObject
}

internal protocol IndexTypeClass: TypeClass {
  /// Returns the o converted to a Python int on success
  /// or TypeError exception raised on failure.
  func index(value: PyObject) -> PyInt
}

// MARK: - Add

internal typealias AddResult<T> = PyResultOrNot<T>

internal protocol AddTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2.
  /// This is the equivalent of the Python expression o1 + o2.
  func add(_ other: PyObject) -> AddResult<PyObject>
}

internal protocol AddInPlaceTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 += o2.
  func addInPlace(_ other: PyObject) -> AddResult<PyObject>
}

// MARK: - Sub

internal protocol SubTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1.
  /// This is the equivalent of the Python expression o1 - o2.
  func sub(_ other: PyObject) -> PyObject
}

internal protocol SubInPlaceTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 -= o2.
  func subInPlace(_ other: PyObject)
}

// MARK: - Mul

internal typealias MulResult<T> = PyResultOrNot<T>

internal protocol MulTypeClass: TypeClass {
  /// Returns the result of multiplying o1 and o2.
  /// This is the equivalent of the Python expression o1 * o2.
  func mul(_ other: PyObject) -> MulResult<PyObject>
}

internal protocol RMulTypeClass: TypeClass {
  /// Returns the result of multiplying o1 and o2.
  /// This is the equivalent of the Python expression o1 * o2.
  func rmul(_ other: PyObject) -> MulResult<PyObject>
}

internal protocol MulInPlaceTypeClass: TypeClass {
  /// Returns the result of multiplying o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 *= o2.
  func mulInPlace(_ other: PyObject) -> MulResult<PyObject>
}

// MARK: - Matrix multiply

internal protocol MatrixMulTypeClass: TypeClass {
  /// Returns the result of matrix multiplication on o1 and o2.
  /// This is the equivalent of the Python expression o1 @ o2.
  func matrixMul(_ other: PyObject) -> PyObject
}

internal protocol MatrixMulInPlaceTypeClass: TypeClass {
  /// Returns the result of matrix multiplication on o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 @= o2.
  func matrixMulInPlace(_ other: PyObject)
}

// MARK: - Div

internal protocol DivTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2.
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  func div(_ other: PyObject) -> PyObject
}

internal protocol DivInPlaceTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2..
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  /// The operation is done in-place when o1 supports it.
  func divInPlace(_ other: PyObject)
}

internal protocol DivFloorTypeClass: TypeClass {
  /// Return the floor of o1 divided by o2.
  /// This is equivalent to the “classic” division of integers.
  func divFloor(_ other: PyObject) -> PyObject
}

internal protocol DivFloorInPlaceTypeClass: TypeClass {
  /// Returns the mathematical floor of dividing o1 by o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 //= o2.
  func divFloorInPlace(_ other: PyObject)
}

internal protocol RemainderTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2.
  /// This is the equivalent of the Python expression o1 % o2.
  func remainder(_ other: PyObject) -> PyObject
}

internal protocol RemainderInPlaceTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 %= o2.
  func remainderInPlace(_ other: PyObject)
}

internal protocol DivModTypeClass: TypeClass {
  /// See the built-in function divmod(). Returns NULL on failure.
  /// This is the equivalent of the Python expression divmod(o1, o2).
  func divMod(_ other: PyObject) -> PyObject
}

// MARK: - Shift

internal protocol ShiftTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 << o2.
  func lShift(_ other: PyObject) -> PyObject
  /// Returns the result of right shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 >> o2.
  func rShift(_ other: PyObject) -> PyObject
}

internal protocol ShiftInPlaceTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 <<= o2.
  func lShiftInPlace(_ other: PyObject)
  /// Returns the result of right shifting o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 >>= o2.
  func rShiftInPlace(_ other: PyObject)
}

// MARK: - Binary

internal protocol BinaryTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// This is the equivalent of the Python expression o1 & o2.
  func and(_ other: PyObject) -> PyObject
  /// Returns the “bitwise or” of o1 and o2 on success.
  /// This is the equivalent of the Python expression o1 | o2.
  func or(_ other: PyObject) -> PyObject
  /// Returns the “bitwise exclusive or” of o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 ^ o2.
  func xor(_ other: PyObject) -> PyObject
}

internal protocol BinaryInPlaceTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 &= o2.
  func andInPlace(_ other: PyObject)
  /// Returns the “bitwise or” of o1 and o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 |= o2.
  func orInPlace(_ other: PyObject)
  /// Returns the “bitwise exclusive or” of o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 ^= o2.
  func xorInPlace(_ other: PyObject)
}

// MARK: - Power

internal protocol PowTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// This is the equivalent of the Python expression pow(o1, o2, o3),
  /// where o3 is optional.
  func pow(_ exponent: PyObject) -> PyObject
}

internal protocol PowInPlaceTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 **= o2 when o3 is Py_None,
  /// or an in-place variant of pow(o1, o2, o3) otherwise.
  /// If o3 is to be ignored, pass Py_None in its place
  /// (passing NULL for o3 would cause an illegal memory access).
  func powInPlace(_ exponent: PyObject)
}
