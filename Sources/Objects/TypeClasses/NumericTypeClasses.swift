// TODO: unaryfunc nb_index

// MARK: - Unary

internal protocol SignedNumberTypeClass: TypeClass {
  /// Number without changes
  func positive(value: PyObject) throws -> PyObject
  /// Opposite of a given number
  func negative(value: PyObject) throws -> PyObject
}

internal protocol AbsoluteNumberTypeClass: TypeClass {
  func abs(value: PyObject) throws -> PyObject
}

internal protocol InvertibleNumberTypeClass: TypeClass {
  func invert(value: PyObject) throws -> PyObject
}

// MARK: - Add, sub

internal protocol AdditiveTypeClass: TypeClass {
  func add(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceAdditiveTypeClass: TypeClass {
  func addInPlace(left: PyObject, right: PyObject) throws
}

internal protocol SubtractiveTypeClass: TypeClass {
  func sub(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceSubtractiveTypeClass: TypeClass {
  func subInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Mul

internal protocol MultiplicativeTypeClass: TypeClass {
  func mul(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceMultiplicativeTypeClass: TypeClass {
  func mulInPlace(left: PyObject, right: PyObject) throws
}

internal protocol MatrixMultiplicativeTypeClass: TypeClass {
  func matrixMul(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceMatrixMultiplicativeTypeClass: TypeClass {
  func matrixMulInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Div

internal protocol DividableTypeClass: TypeClass {
  func div(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol FloorDividableTypeClass: TypeClass {
  func divFloor(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceDividableTypeClass: TypeClass {
  func divInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceFloorDividableTypeClass: TypeClass {
  func divFloorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol RemainderTypeClass: TypeClass {
  func remainder(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceRemainderTypeClass: TypeClass {
  func remainderInPlace(left: PyObject, right: PyObject) throws
}

internal protocol DivModTypeClass: TypeClass {
  func divMod(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Shift

internal protocol ShiftableTypeClass: TypeClass {
  func lShift(left: PyObject, right: PyObject) throws -> PyObject
  func rShift(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceShiftableTypeClass: TypeClass {
  func lShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func rShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Binary

internal protocol BinaryTypeClass: TypeClass {
  func and(left: PyObject, right: PyObject) throws -> PyObject
  func or (left: PyObject, right: PyObject) throws -> PyObject
  func xor(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlaceBinaryTypeClass: TypeClass {
  func andInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func orInPlace (left: PyObject, right: PyObject) throws -> PyObject
  func xorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Power

internal protocol PowerTypeClass: TypeClass {
  func pow(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol InPlacePowerTypeClass: TypeClass {
  func powInPlace(left: PyObject, right: PyObject) throws -> PyObject
}
