// TODO: unaryfunc nb_invert; unaryfunc nb_index; inquiry nb_bool;

// MARK: - Unary

public protocol SignedNumberTypeClass {
  /// Number without changes
  func positive(value: PyObject) throws -> PyObject
  /// Opposite of a given number
  func negative(value: PyObject) throws -> PyObject
}

public protocol AbsoluteNumberTypeClass {
  func abs(value: PyObject) throws -> PyObject
}

// MARK: - Convertible

public protocol PyBoolConvertibleTypeClass {
  func bool(value: PyObject) throws -> PyBool
}

public protocol PyIntConvertibleTypeClass {
  func int(value: PyObject) throws -> PyInt
}

public protocol PyFloatConvertibleTypeClass {
  func float(value: PyObject) throws -> PyFloat
}

// MARK: - Add, sub

public protocol AdditiveTypeClass {
  func add(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceAdditiveTypeClass {
  func addInPlace(left: PyObject, right: PyObject) throws
}

public protocol SubtractiveTypeClass {
  func sub(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceSubtractiveTypeClass {
  func subInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Mul

public protocol MultiplicativeTypeClass {
  func mul(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceMultiplicativeTypeClass {
  func mulInPlace(left: PyObject, right: PyObject) throws
}

public protocol MatrixMultiplicativeTypeClass {
  func matrixMul(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceMatrixMultiplicativeTypeClass {
  func matrixMulInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Div

public protocol DividableTypeClass {
  func div(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol FloorDividableTypeClass {
  func divFloor(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceDividableTypeClass {
  func divInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceFloorDividableTypeClass {
  func divFloorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol RemainderTypeClass {
  func remainder(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceRemainderTypeClass {
  func remainderInPlace(left: PyObject, right: PyObject) throws
}

public protocol DivModTypeClass {
  func divMod(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Shift

public protocol ShiftableTypeClass {
  func lshift(left: PyObject, right: PyObject) throws -> PyObject
  func rshift(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceShiftableTypeClass {
  func lshiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func rshiftInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Binary

public protocol BinaryTypeClass {
  func and(left: PyObject, right: PyObject) throws -> PyObject
  func or (left: PyObject, right: PyObject) throws -> PyObject
  func xor(left: PyObject, right: PyObject) throws -> PyObject
}

public protocol InPlaceBinaryTypeClass {
  func andInPlace(left: PyObject, right: PyObject) throws -> PyObject
  func orInPlace (left: PyObject, right: PyObject) throws -> PyObject
  func xorInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Power

public protocol PowerTypeClass {
  func power(left: PyObject, right: PyObject, x: PyObject) throws -> PyObject
}

public protocol InPlacePowerTypeClass {
  func powerInPlace(left: PyObject, right: PyObject, x: PyObject) throws -> PyObject
}
