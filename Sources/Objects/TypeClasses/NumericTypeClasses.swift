// MARK: - Unary

internal protocol SignedTypeClass: TypeClass {
  /// Returns o on success.
  /// This is the equivalent of the Python expression +o.
  var positive: PyObject { get }
  /// Returns the negation of o on success.
  /// This is the equivalent of the Python expression -o.
  var negative: PyObject { get }
}

internal protocol AbsTypeClass: TypeClass {
  /// Returns the absolute value of o.
  /// This is the equivalent of the Python expression abs(o).
  var abs: PyObject { get }
}

internal protocol InvertTypeClass: TypeClass {
  /// Returns the bitwise negation of o on success.
  /// This is the equivalent of the Python expression ~o.
  var invert: PyObject { get }
}

// MARK: - Add

internal typealias AddResult<T> = PyResultOrNot<T>

internal protocol AddTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2.
  /// This is the equivalent of the Python expression o1 + o2.
  func add(_ other: PyObject) -> AddResult<PyObject>
}

internal protocol RAddTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2.
  /// This is the equivalent of the Python expression o1 + o2.
  func radd(_ other: PyObject) -> AddResult<PyObject>
}

internal protocol AddInPlaceTypeClass: TypeClass {
  /// Returns the result of adding o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 += o2.
  func addInPlace(_ other: PyObject) -> AddResult<PyObject>
}

// MARK: - Sub

internal typealias SubResult<T> = PyResultOrNot<T>

internal protocol SubTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1.
  /// This is the equivalent of the Python expression o1 - o2.
  func sub(_ other: PyObject) -> SubResult<PyObject>
}

internal protocol RSubTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1.
  /// This is the equivalent of the Python expression o1 - o2.
  func rsub(_ other: PyObject) -> SubResult<PyObject>
}

internal protocol SubInPlaceTypeClass: TypeClass {
  /// Returns the result of subtracting o2 from o1..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 -= o2.
  func subInPlace(_ other: PyObject) -> SubResult<PyObject>
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

internal typealias MatrixMulResult<T> = PyResultOrNot<T>

internal protocol MatrixMulTypeClass: TypeClass {
  /// Returns the result of matrix multiplication on o1 and o2.
  /// This is the equivalent of the Python expression o1 @ o2.
  func matrixMul(_ other: PyObject) -> MatrixMulResult<PyObject>
}

internal protocol MatrixMulInPlaceTypeClass: TypeClass {
  /// Returns the result of matrix multiplication on o1 and o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 @= o2.
  func matrixMulInPlace(_ other: PyObject) -> MatrixMulResult<PyObject>
}

// MARK: - Power

internal typealias PowResult<T> = PyResultOrNot<T>

internal protocol PowTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// This is the equivalent of the Python expression pow(o1, o2, o3),
  /// where o3 is optional.
  func pow(_ other: PyObject) -> PowResult<PyObject>
}

internal protocol RPowTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// This is the equivalent of the Python expression pow(o1, o2, o3),
  /// where o3 is optional.
  func rpow(_ other: PyObject) -> PowResult<PyObject>
}

internal protocol PowInPlaceTypeClass: TypeClass {
  /// See the built-in function pow(). Returns NULL on failure.
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 **= o2 when o3 is Py_None,
  /// or an in-place variant of pow(o1, o2, o3) otherwise.
  /// If o3 is to be ignored, pass Py_None in its place
  /// (passing NULL for o3 would cause an illegal memory access).
  func powInPlace(_ other: PyObject) -> PowResult<PyObject>
}

// MARK: - True div

internal typealias TrueDivResult<T> = PyResultOrNot<T>

internal protocol TrueDivTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2.
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  func trueDiv(_ other: PyObject) -> TrueDivResult<PyObject>
}

internal protocol RTrueDivTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2.
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  func rtrueDiv(_ other: PyObject) -> TrueDivResult<PyObject>
}

internal protocol TrueDivInPlaceTypeClass: TypeClass {
  /// Return a reasonable approximation for the mathematical value of o1 divided by o2..
  /// The return value is “approximate” because binary floating point numbers
  /// are approximate; it is not possible to represent all real numbers in base two.
  /// This function can return a floating point value when passed two integers.
  /// The operation is done in-place when o1 supports it.
  func trueDivInPlace(_ other: PyObject) -> TrueDivResult<PyObject>
}

// MARK: - Floor div

internal typealias FloorDivResult<T> = PyResultOrNot<T>

internal protocol FloorDivTypeClass: TypeClass {
  /// Return the floor of o1 divided by o2.
  /// This is equivalent to the “classic” division of integers.
  func floorDiv(_ other: PyObject) -> FloorDivResult<PyObject>
}

internal protocol RFloorDivTypeClass: TypeClass {
  /// Return the floor of o1 divided by o2.
  /// This is equivalent to the “classic” division of integers.
  func rfloorDiv(_ other: PyObject) -> FloorDivResult<PyObject>
}

internal protocol FloorDivInPlaceTypeClass: TypeClass {
  /// Returns the mathematical floor of dividing o1 by o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 //= o2.
  func floorDivInPlace(_ other: PyObject) -> FloorDivResult<PyObject>
}

// MARK: - Remainder

internal typealias ModResult<T> = PyResultOrNot<T>

internal protocol ModTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2.
  /// This is the equivalent of the Python expression o1 % o2.
  func mod(_ other: PyObject) -> ModResult<PyObject>
}

internal protocol RModTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2.
  /// This is the equivalent of the Python expression o1 % o2.
  func rmod(_ other: PyObject) -> ModResult<PyObject>
}

internal protocol ModInPlaceTypeClass: TypeClass {
  /// Returns the remainder of dividing o1 by o2..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 %= o2.
  func modInPlace(_ other: PyObject) -> ModResult<PyObject>
}

// MARK: - Div mod

internal typealias DivModResult<T> = PyResultOrNot<T>

internal protocol DivModTypeClass: TypeClass {
  /// See the built-in function divmod(). Returns NULL on failure.
  /// This is the equivalent of the Python expression divmod(o1, o2).
  func divMod(_ other: PyObject) -> DivModResult<PyObject>
}

internal protocol RDivModTypeClass: TypeClass {
  /// See the built-in function divmod(). Returns NULL on failure.
  /// This is the equivalent of the Python expression divmod(o1, o2).
  func rdivMod(_ other: PyObject) -> DivModResult<PyObject>
}

// MARK: - Shift

internal typealias ShiftResult<T> = PyResultOrNot<T>

internal protocol ShiftTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 << o2.
  func lShift(_ other: PyObject) -> ShiftResult<PyObject>
  /// Returns the result of right shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 >> o2.
  func rShift(_ other: PyObject) -> ShiftResult<PyObject>
}

internal protocol RShiftTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 << o2.
  func rlShift(_ other: PyObject) -> ShiftResult<PyObject>
  /// Returns the result of right shifting o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 >> o2.
  func rrShift(_ other: PyObject) -> ShiftResult<PyObject>
}

internal protocol ShiftInPlaceTypeClass: TypeClass {
  /// Returns the result of left shifting o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 <<= o2.
  func lShiftInPlace(_ other: PyObject) -> ShiftResult<PyObject>
  /// Returns the result of right shifting o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 >>= o2.
  func rShiftInPlace(_ other: PyObject) -> ShiftResult<PyObject>
}

// MARK: - Binary

internal typealias BinaryResult<T> = PyResultOrNot<T>

internal protocol BinaryTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// This is the equivalent of the Python expression o1 & o2.
  func and(_ other: PyObject) -> BinaryResult<PyObject>
  /// Returns the “bitwise or” of o1 and o2 on success.
  /// This is the equivalent of the Python expression o1 | o2.
  func or(_ other: PyObject) -> BinaryResult<PyObject>
  /// Returns the “bitwise exclusive or” of o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 ^ o2.
  func xor(_ other: PyObject) -> BinaryResult<PyObject>
}

internal protocol RBinaryTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// This is the equivalent of the Python expression o1 & o2.
  func rand(_ other: PyObject) -> BinaryResult<PyObject>
  /// Returns the “bitwise or” of o1 and o2 on success.
  /// This is the equivalent of the Python expression o1 | o2.
  func ror(_ other: PyObject) -> BinaryResult<PyObject>
  /// Returns the “bitwise exclusive or” of o1 by o2 on success.
  /// This is the equivalent of the Python expression o1 ^ o2.
  func rxor(_ other: PyObject) -> BinaryResult<PyObject>
}

internal protocol BinaryInPlaceTypeClass: TypeClass {
  /// Returns the “bitwise and” of o1 and o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 &= o2.
  func andInPlace(_ other: PyObject) -> BinaryResult<PyObject>
  /// Returns the “bitwise or” of o1 and o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 |= o2.
  func orInPlace(_ other: PyObject) -> BinaryResult<PyObject>
  /// Returns the “bitwise exclusive or” of o1 by o2 on success..
  /// The operation is done in-place when o1 supports it.
  /// This is the equivalent of the Python statement o1 ^= o2.
  func xorInPlace(_ other: PyObject) -> BinaryResult<PyObject>
}
