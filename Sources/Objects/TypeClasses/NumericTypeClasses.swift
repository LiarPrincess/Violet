// TODO: unaryfunc nb_invert; unaryfunc nb_index

// MARK: - Unary

public protocol SignedNumberTypeClass: TypeClass {
  /// Number without changes
  func positive(value: PyObject) throws -> PyObject
  /// Opposite of a given number
  func negative(value: PyObject) throws -> PyObject
}

public protocol AbsoluteNumberTypeClass: TypeClass {
  func abs(value: PyObject) throws -> PyObject
}

public protocol InvertNumberTypeClass: TypeClass {
  func invert(value: PyObject) throws -> PyObject
}

// MARK: - Convertible

public protocol PyBoolConvertibleTypeClass: TypeClass {
  func bool(value: PyObject) throws -> PyBool
}

public protocol PyIntConvertibleTypeClass: TypeClass {
  func int(value: PyObject) throws -> PyInt
}

public protocol PyFloatConvertibleTypeClass: TypeClass {
  func float(value: PyObject) throws -> PyFloat
}

// MARK: - Add, sub

public protocol AdditiveTypeClass: TypeClass {
  func add(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceAdditiveTypeClass: TypeClass {
  func addInPlace(left: PyObject, right: PyObject) throws
}

public protocol SubtractiveTypeClass: TypeClass {
  func sub(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceSubtractiveTypeClass: TypeClass {
  func subInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Mul

public protocol MultiplicativeTypeClass: TypeClass {
  func mul(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceMultiplicativeTypeClass: TypeClass {
  func mulInPlace(left: PyObject, right: PyObject) throws
}

public protocol MatrixMultiplicativeTypeClass: TypeClass {
  func matrixMul(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceMatrixMultiplicativeTypeClass: TypeClass {
  func matrixMulInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Div

public protocol DividableTypeClass: TypeClass {
  func div(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol FloorDividableTypeClass: TypeClass {
  func divFloor(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceDividableTypeClass: TypeClass {
  func divInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceFloorDividableTypeClass: TypeClass {
  func divFloorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol RemainderTypeClass: TypeClass {
  func remainder(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceRemainderTypeClass: TypeClass {
  func remainderInPlace(left: PyObject, right: PyObject) throws
}

public protocol DivModTypeClass: TypeClass {
  func divMod(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Shift

public protocol ShiftableTypeClass: TypeClass {
  func lShift(left: PyObject, right: PyObject) throws -> PyObject
  func rShift(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceShiftableTypeClass: TypeClass {
  func lShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func rShiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Binary

public protocol BinaryTypeClass: TypeClass {
  func and(left: PyObject, right: PyObject) throws -> PyObject
  func or (left: PyObject, right: PyObject) throws -> PyObject
  func xor(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceBinaryTypeClass: TypeClass {
  func andInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func orInPlace (left: PyObject, right: PyObject) throws -> PyObject
  func xorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Power

public protocol PowerTypeClass: TypeClass {
  func pow(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlacePowerTypeClass: TypeClass {
  func powInPlace(left: PyObject, right: PyObject) throws -> PyObject
}
