// TODO: unaryfunc nb_index

// MARK: - Unary

internal protocol SignedTypeClass: TypeClass {
  /// Number without changes
  func positive(value: PyObject) throws -> PyObject
  /// Opposite of a given number
  func negative(value: PyObject) throws -> PyObject
}

internal protocol AbsTypeClass: TypeClass {
  func abs(value: PyObject) throws -> PyObject
}

internal protocol InvertTypeClass: TypeClass {
  func invert(value: PyObject) throws -> PyObject
}

// MARK: - Add, sub

internal protocol AddTypeClass: TypeClass {
  func add(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol AddInPlaceTypeClass: TypeClass {
  func addInPlace(left: PyObject, right: PyObject) throws
}

internal protocol SubTypeClass: TypeClass {
  func sub(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol SubInPlaceTypeClass: TypeClass {
  func subInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Mul

internal protocol MulTypeClass: TypeClass {
  func mul(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol MulInPlaceTypeClass: TypeClass {
  func mulInPlace(left: PyObject, right: PyObject) throws
}

internal protocol MatrixMulTypeClass: TypeClass {
  func matrixMul(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol MatrixMulInPlaceTypeClass: TypeClass {
  func matrixMulInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Div

internal protocol DivTypeClass: TypeClass {
  func div(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol DivFloorTypeClass: TypeClass {
  func divFloor(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol DivInPlaceTypeClass: TypeClass {
  func divInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol DivFloorInPlaceTypeClass: TypeClass {
  func divFloorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol RemainderTypeClass: TypeClass {
  func remainder(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol RemainderInPlaceTypeClass: TypeClass {
  func remainderInPlace(left: PyObject, right: PyObject) throws
}

internal protocol DivModTypeClass: TypeClass {
  func divMod(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Shift

internal protocol ShiftTypeClass: TypeClass {
  func lShift(left: PyObject, right: PyObject) throws -> PyObject
  func rShift(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol ShiftInPlaceTypeClass: TypeClass {
  func lShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func rShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Binary

internal protocol BinaryTypeClass: TypeClass {
  func and(left: PyObject, right: PyObject) throws -> PyObject
  func or (left: PyObject, right: PyObject) throws -> PyObject
  func xor(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol BinaryInPlaceTypeClass: TypeClass {
  func andInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func orInPlace (left: PyObject, right: PyObject) throws -> PyObject
  func xorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Power

internal protocol PowTypeClass: TypeClass {
  func pow(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol PowInPlaceTypeClass: TypeClass {
  func powInPlace(left: PyObject, right: PyObject) throws -> PyObject
}
