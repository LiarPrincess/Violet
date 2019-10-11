// MARK: - Unary

internal protocol SignedTypeClass: TypeClass {
  // sourcery: pymethod = __pos__
  func positive() -> PyObject
  // sourcery: pymethod = __neg__
  func negative() -> PyObject
}

internal protocol AbsTypeClass: TypeClass {
  // sourcery: pymethod = __abs__
  func abs() -> PyObject
}

internal protocol InvertTypeClass: TypeClass {
  // sourcery: pymethod = __invert__
  func invert() -> PyObject
}

// MARK: - Add

internal typealias AddResult<T> = PyResultOrNot<T>

internal protocol AddTypeClass: TypeClass {
  // sourcery: pymethod = __add__
  func add(_ other: PyObject) -> AddResult<PyObject>
}

internal protocol RAddTypeClass: TypeClass {
  // sourcery: pymethod = __radd__
  func radd(_ other: PyObject) -> AddResult<PyObject>
}

internal protocol AddInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __iadd__
  func addInPlace(_ other: PyObject) -> AddResult<PyObject>
}

// MARK: - Sub

internal typealias SubResult<T> = PyResultOrNot<T>

internal protocol SubTypeClass: TypeClass {
  // sourcery: pymethod = __sub__
  func sub(_ other: PyObject) -> SubResult<PyObject>
}

internal protocol RSubTypeClass: TypeClass {
  // sourcery: pymethod = __rsub__
  func rsub(_ other: PyObject) -> SubResult<PyObject>
}

internal protocol SubInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __isub__
  func subInPlace(_ other: PyObject) -> SubResult<PyObject>
}

// MARK: - Mul

internal typealias MulResult<T> = PyResultOrNot<T>

internal protocol MulTypeClass: TypeClass {
  // sourcery: pymethod = __mul__
  func mul(_ other: PyObject) -> MulResult<PyObject>
}

internal protocol RMulTypeClass: TypeClass {
  // sourcery: pymethod = __rmul__
  func rmul(_ other: PyObject) -> MulResult<PyObject>
}

internal protocol MulInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __imul__
  func mulInPlace(_ other: PyObject) -> MulResult<PyObject>
}

// MARK: - Matrix multiply

internal typealias MatrixMulResult<T> = PyResultOrNot<T>

internal protocol MatrixMulTypeClass: TypeClass {
  // sourcery: pymethod = __matmul__
  func matrixMul(_ other: PyObject) -> MatrixMulResult<PyObject>
}

internal protocol RMatrixMulTypeClass: TypeClass {
  // sourcery: pymethod = __rmatmul__
  func rmatrixMul(_ other: PyObject) -> MatrixMulResult<PyObject>
}

internal protocol MatrixMulInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __imatmul__
  func matrixMulInPlace(_ other: PyObject) -> MatrixMulResult<PyObject>
}

// MARK: - Power

internal typealias PowResult<T> = PyResultOrNot<T>

internal protocol PowTypeClass: TypeClass {
  // sourcery: pymethod = __pow__
  func pow(_ other: PyObject) -> PowResult<PyObject>
}

internal protocol RPowTypeClass: TypeClass {
  // sourcery: pymethod = __rpow__
  func rpow(_ other: PyObject) -> PowResult<PyObject>
}

internal protocol PowInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __ipow__
  func powInPlace(_ other: PyObject) -> PowResult<PyObject>
}

// MARK: - True div

internal typealias TrueDivResult<T> = PyResultOrNot<T>

internal protocol TrueDivTypeClass: TypeClass {
  // sourcery: pymethod = __truediv__
  func trueDiv(_ other: PyObject) -> TrueDivResult<PyObject>
}

internal protocol RTrueDivTypeClass: TypeClass {
  // sourcery: pymethod = __rtruediv__
  func rtrueDiv(_ other: PyObject) -> TrueDivResult<PyObject>
}

internal protocol TrueDivInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __itruediv__
  func trueDivInPlace(_ other: PyObject) -> TrueDivResult<PyObject>
}

// MARK: - Floor div

internal typealias FloorDivResult<T> = PyResultOrNot<T>

internal protocol FloorDivTypeClass: TypeClass {
  // sourcery: pymethod = __floordiv__
  func floorDiv(_ other: PyObject) -> FloorDivResult<PyObject>
}

internal protocol RFloorDivTypeClass: TypeClass {
  // sourcery: pymethod = __rfloordiv__
  func rfloorDiv(_ other: PyObject) -> FloorDivResult<PyObject>
}

internal protocol FloorDivInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __ifloordiv__
  func floorDivInPlace(_ other: PyObject) -> FloorDivResult<PyObject>
}

// MARK: - Remainder

internal typealias ModResult<T> = PyResultOrNot<T>

internal protocol ModTypeClass: TypeClass {
  // sourcery: pymethod = __mod__
  func mod(_ other: PyObject) -> ModResult<PyObject>
}

internal protocol RModTypeClass: TypeClass {
  // sourcery: pymethod = __rmod__
  func rmod(_ other: PyObject) -> ModResult<PyObject>
}

internal protocol ModInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __imod__
  func modInPlace(_ other: PyObject) -> ModResult<PyObject>
}

// MARK: - Div mod

internal typealias DivModResult<T> = PyResultOrNot<T>

internal protocol DivModTypeClass: TypeClass {
  // sourcery: pymethod = __divmod__
  func divMod(_ other: PyObject) -> DivModResult<PyObject>
}

internal protocol RDivModTypeClass: TypeClass {
  // sourcery: pymethod = __rdivmod__
  func rdivMod(_ other: PyObject) -> DivModResult<PyObject>
}

// MARK: - Shift

internal typealias ShiftResult<T> = PyResultOrNot<T>

internal protocol ShiftTypeClass: TypeClass {
  // sourcery: pymethod = __lShift__
  func lShift(_ other: PyObject) -> ShiftResult<PyObject>
  // sourcery: pymethod = __rShift__
  func rShift(_ other: PyObject) -> ShiftResult<PyObject>
}

internal protocol RShiftTypeClass: TypeClass {
  // sourcery: pymethod = __rlshift__
  func rlShift(_ other: PyObject) -> ShiftResult<PyObject>
  // sourcery: pymethod = __rrshift__
  func rrShift(_ other: PyObject) -> ShiftResult<PyObject>
}

internal protocol ShiftInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __ilshift__
  func lShiftInPlace(_ other: PyObject) -> ShiftResult<PyObject>
  // sourcery: pymethod = __irshift__
  func rShiftInPlace(_ other: PyObject) -> ShiftResult<PyObject>
}

// MARK: - Binary

internal typealias BinaryResult<T> = PyResultOrNot<T>

internal protocol BinaryTypeClass: TypeClass {
  // sourcery: pymethod = __and__
  func and(_ other: PyObject) -> BinaryResult<PyObject>
  // sourcery: pymethod = __or__
  func or(_ other: PyObject) -> BinaryResult<PyObject>
  // sourcery: pymethod = __xor__
  func xor(_ other: PyObject) -> BinaryResult<PyObject>
}

internal protocol RBinaryTypeClass: TypeClass {
  // sourcery: pymethod = __rand__
  func rand(_ other: PyObject) -> BinaryResult<PyObject>
  // sourcery: pymethod = __ror__
  func ror(_ other: PyObject) -> BinaryResult<PyObject>
  // sourcery: pymethod = __rxor__
  func rxor(_ other: PyObject) -> BinaryResult<PyObject>
}

internal protocol BinaryInPlaceTypeClass: TypeClass {
  // sourcery: pymethod = __iand__
  func andInPlace(_ other: PyObject) -> BinaryResult<PyObject>
  // sourcery: pymethod = __ior__
  func orInPlace(_ other: PyObject) -> BinaryResult<PyObject>
  // sourcery: pymethod = __ixor__
  func xorInPlace(_ other: PyObject) -> BinaryResult<PyObject>
}

// MARK: - Other

internal typealias RoundResult<T> = PyResultOrNot<T>
internal typealias TruncResult<T> = PyResultOrNot<T>
internal typealias FloorResult<T> = PyResultOrNot<T>
internal typealias CeilResult<T> = PyResultOrNot<T>

internal protocol RoundTypeClass: TypeClass {
  // sourcery: pymethod = __round__
  func round(nDigits: PyObject?) -> RoundResult<PyObject>
}

internal protocol TruncTypeClass: TypeClass {
  // sourcery: pymethod = __trunc__
  func trunc() -> TruncResult<PyObject>
}

internal protocol FloorTypeClass: TypeClass {
  // sourcery: pymethod = __floor__
  func floor() -> FloorResult<PyObject>
}

internal protocol CeilTypeClass: TypeClass {
  // sourcery: pymethod = __ceil__
  func ceil() -> CeilResult<PyObject>
}

internal protocol ConjugateTypeClass: TypeClass {
  // sourcery: pymethod = conjugate
  func conjugate() -> PyObject
}
