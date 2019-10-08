import Foundation
import Core

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

// TODO: Int
// @overload
// def __init__(self, x: Union[Text, bytes, SupportsInt] = ...) -> None: ...
// @overload
// def __init__(self, x: Union[Text, bytes, bytearray], base: int) -> None: ...
// def __getnewargs__(self) -> Tuple[int]: ...
// def bit_length(self) -> int: ...
// def to_bytes(self, length: int, byteorder: str, *, signed: bool = ...) -> bytes: ...
// @classmethod
// def from_bytes(cls, bytes: Sequence[int], byteorder: str, *, signed: bool = ...)

// swiftlint:disable file_length

/// All integers are implemented as “long” integer objects of arbitrary size.
internal class PyInt: PyObject,
  ReprTypeClass, StrTypeClass,
  EquatableTypeClass, ComparableTypeClass, HashableTypeClass,
  BoolConvertibleTypeClass, IntConvertibleTypeClass,
  FloatConvertibleTypeClass, ComplexConvertibleTypeClass,
  IndexConvertibleTypeClass,
  SignedTypeClass, AbsTypeClass, InvertTypeClass,
  AddTypeClass, RAddTypeClass,
  SubTypeClass, RSubTypeClass,
  MulTypeClass, RMulTypeClass,
  PowTypeClass, RPowTypeClass,
  TrueDivTypeClass, RTrueDivTypeClass,
  FloorDivTypeClass, RFloorDivTypeClass,
  ModTypeClass, RModTypeClass,
  DivModTypeClass, RDivModTypeClass,
  ShiftTypeClass, RShiftTypeClass,
  BinaryTypeClass, RBinaryTypeClass {

  internal var value: BigInt

  // MARK: - Init

  internal static func new(_ context: PyContext, _ value: Int) -> PyInt {
    return PyInt(type: context.types.int, value: BigInt(value))
  }

  internal static func new(_ context: PyContext, _ value: BigInt) -> PyInt {
    return PyInt(type: context.types.int, value: value)
  }

  internal init(type: PyIntType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PyInt) -> Bool {
    return self.value == other.value
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value < other.value)
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value <= other.value)
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value > other.value)
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value >= other.value)
  }

  // MARK: - Hashable

  internal var hash: HashableResult {
    return .value(self.context.hasher.hash(self.value))
  }

  // MARK: - String

  internal var repr: String {
    return String(describing: self.value)
  }

  internal var str: String {
    return self.repr
  }

  // MARK: - Convertible

  internal var asBool: PyResult<Bool> {
    return .value(self.value != 0)
  }

  internal var asInt: PyResult<PyInt> {
    return .value(self)
  }

  internal var asFloat: PyResult<PyFloat> {
    return .value(GeneralHelpers.pyFloat(Double(self.value)))
  }

  internal var asIndex: PyInt {
    return self
  }

  // MARK: - Imaginary

  internal var real: PyInt {
    return self
  }

  internal var imag: PyInt {
    return GeneralHelpers.pyInt(0)
  }

  internal var asComplex: PyResult<PyComplex> {
    let real = Double(self.value)
    return .value(GeneralHelpers.pyComplex(real: real, imag: 0.0))
  }

  /// int.conjugate
  /// Return self, the complex conjugate of any int.
  internal var conjugate: PyInt {
    return self
  }

  internal var numerator: PyInt {
    return self
  }

  internal var denominator: PyInt {
    return GeneralHelpers.pyInt(1)
  }

  // MARK: - Sign

  internal var positive: PyObject {
    return self
  }

  internal var negative: PyObject {
    return GeneralHelpers.pyInt(-self.value)
  }

  // MARK: - Abs

  internal var abs: PyObject {
    return GeneralHelpers.pyInt(Swift.abs(self.value))
  }

  // MARK: - Add

  internal func add(_ other: PyObject) -> AddResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(self.value + other.value))
  }

  internal func radd(_ other: PyObject) -> AddResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  internal func sub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(self.value - other.value))
  }

  internal func rsub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(other.value - self.value))
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(self.value * other.value))
  }

  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  internal func pow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    let result = self.pow(left: self.value, right: other.value)
    return .value(result.asObject())
  }

  internal func rpow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    let result = self.pow(left: other.value, right: self.value)
    return .value(result.asObject())
  }

  private enum InnerPowResult {
    case int(BigInt)
    case fraction(Double)

    fileprivate func asObject() -> PyObject {
      switch self {
      case let .int(i): return GeneralHelpers.pyInt(i)
      case let .fraction(f): return GeneralHelpers.pyFloat(f)
      }
    }
  }

  private func pow(left: BigInt, right: BigInt) -> InnerPowResult {
    if right == 0 {
      return .int(1)
    }

    if right == 1 {
      return .int(left)
    }

    let result = expBySq(1, left, Swift.abs(right))

    return right > 0 ?
      .int(result) :
      .fraction(Double(1.0) / Double(result))
  }

  // swiftlint:disable line_length

  /// Source:
  /// https://en.wikipedia.org/wiki/Exponentiation_by_squaring#Basic_method
  /// https://stackoverflow.com/questions/24196689/how-to-get-the-power-of-some-integer-in-swift-language
  private func expBySq(_ y: BigInt, _ x: BigInt, _ n: BigInt) -> BigInt {
    // swiftlint:enable line_length

    precondition(n >= 0)

    if n == 0 {
      return y
    }

    if n == 1 {
      return y * x
    }

    // swiftlint:disable:next legacy_multiple
    let isMultipleOf2 = n % 2 == 0
    return isMultipleOf2 ?
      expBySq(y, x * x, n / 2) :
      expBySq(y * x, x * x, (n - 1) / 2)
  }

  // MARK: - True div

  internal func trueDiv(_ other: PyObject) -> TrueDivResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.trueDiv(left: self.value, right: other.value)
  }

  internal func rtrueDiv(_ other: PyObject) -> TrueDivResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.trueDiv(left: other.value, right: self.value)
  }

  private func trueDiv(left: BigInt, right: BigInt) -> TrueDivResult<PyObject> {
    if right == 0 {
      return .error(.zeroDivisionError("division by zero"))
    }

    return .value(GeneralHelpers.pyFloat(Double(left) / Double(right)))
  }

  // MARK: - Floor div

  internal func floorDiv(_ other: PyObject) -> FloorDivResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.floorDiv(left: self.value, right: other.value)
  }

  internal func rfloorDiv(_ other: PyObject) -> FloorDivResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.floorDiv(left: other.value, right: self.value)
  }

  private func floorDiv(left: BigInt, right: BigInt) -> FloorDivResult<PyObject> {
    if right == 0 {
      return .error(.zeroDivisionError("division by zero"))
    }

    let result = self.floorDivRaw(left: left, right: right)
    return .value(GeneralHelpers.pyInt(result))
  }

  private func floorDivRaw(left: BigInt, right: BigInt) -> BigInt {
    return left / right
  }

  // MARK: - Mod

  internal func mod(_ other: PyObject) -> ModResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.mod(left: self.value, right: other.value)
  }

  internal func rmod(_ other: PyObject) -> ModResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.mod(left: other.value, right: self.value)
  }

  private func mod(left: BigInt, right: BigInt) -> ModResult<PyObject> {
    if right == 0 {
      return .error(.zeroDivisionError("modulo by zero"))
    }

    let result = self.modRaw(left: left, right: right)
    return .value(GeneralHelpers.pyInt(result))
  }

  private func modRaw(left: BigInt, right: BigInt) -> BigInt {
    return left % right
  }

  // MARK: - Div mod

  internal func divMod(_ other: PyObject) -> DivModResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.divMod(left: self.value, right: other.value)
  }

  internal func rdivMod(_ other: PyObject) -> DivModResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.divMod(left: other.value, right: self.value)
  }

  private func divMod(left: BigInt, right: BigInt) -> DivModResult<PyObject> {
    if right == 0 {
      return .error(.zeroDivisionError("divmod() by zero"))
    }

    let div = self.floorDivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)

    return .value(GeneralHelpers.pyTuple([
      GeneralHelpers.pyInt(div),
      GeneralHelpers.pyInt(mod)
    ]))
  }

  // MARK: - LShift

  internal func lShift(_ other: PyObject) -> ShiftResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.lShift(left: self.value, right: other.value)
  }

  internal func rlShift(_ other: PyObject) -> ShiftResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.lShift(left: other.value, right: self.value)
  }

  private func lShift(left: BigInt, right: BigInt) -> ShiftResult<PyObject> {
    if right < 0 {
      return .error(.valueError("negative shift count"))
    }

    return .value(GeneralHelpers.pyInt(left << right))
  }

  // MARK: - RShift

  internal func rShift(_ other: PyObject) -> ShiftResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.rShift(left: self.value, right: other.value)
  }

  internal func rrShift(_ other: PyObject) -> ShiftResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.rShift(left: other.value, right: self.value)
  }

  private func rShift(left: BigInt, right: BigInt) -> ShiftResult<PyObject> {
    if right < 0 {
      return .error(.valueError("negative shift count"))
    }

    return .value(GeneralHelpers.pyInt(left >> right))
  }

  // MARK: - And

  internal func and(_ other: PyObject) -> BinaryResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(self.value & other.value))
  }

  internal func rand(_ other: PyObject) -> BinaryResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  internal func or(_ other: PyObject) -> BinaryResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(self.value | other.value))
  }

  internal func ror(_ other: PyObject) -> BinaryResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  internal func xor(_ other: PyObject) -> BinaryResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(GeneralHelpers.pyInt(self.value ^ other.value))
  }

  internal func rxor(_ other: PyObject) -> BinaryResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Invert

  internal var invert: PyObject {
    return GeneralHelpers.pyInt(~self.value)
  }

  // MARK: - Round

  internal func round() -> PyResultOrNot<PyInt> {
    return .value(self)
  }

  /// Round an integer m to the nearest 10**n (n positive)
  ///
  /// ```
  /// int.__round__(12345,  2) -> 12345
  /// int.__round__(12345, -2) -> 12300
  /// ```
  internal func round(nDigits: PyObject) -> PyResultOrNot<PyInt> {
    guard let nDigits = GeneralHelpers.extractIndex(value: nDigits) else {
      fatalError()
    }

    // if ndigits >= 0 then no rounding is necessary; return self unchanged
    if nDigits >= 0 {
      return .value(self)
    }

    // TODO: Implement int rounding to arbitrary precision
    return .notImplemented
  }
}

internal class PyIntType: PyType {
//  override internal var name: String { return "int" }
//  override internal var doc: String? { return """
//int([x]) -> integer
//int(x, base=10) -> integer
//
//Convert a number or string to an integer, or return 0 if no arguments
//are given.  If x is a number, return x.__int__().  For floating point
//numbers, this truncates towards zero.
//
//If x is not a number or if base is given, then x must be a string,
//bytes, or bytearray instance representing an integer literal in the
//given base.  The literal can be preceded by '+' or '-' and be surrounded
//by whitespace.  The base defaults to 10.  Valid bases are 0 and 2-36.
//Base 0 means to interpret the base from the string as an integer literal.
//>>> int('0b100', base=0)
//4
//""" }
}
