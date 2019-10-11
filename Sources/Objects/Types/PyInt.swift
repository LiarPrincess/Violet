import Foundation
import Core

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

// TODO: Int
// __class__
// __delattr__
// __dir__
// __ceil__
// __floor__
// __format__
// __getattribute__
// __getnewargs__
// __init__
// __init_subclass__
// __new__
// __reduce__
// __reduce_ex__
// __setattr__
// __sizeof__
// __subclasshook__
// __trunc__
// bit_length
// from_bytes
// to_bytes

// swiftlint:disable file_length

// sourcery: pytype = int
/// All integers are implemented as “long” integer objects of arbitrary size.
internal class PyInt: PyObject,
  ReprTypeClass, StrTypeClass,
  ComparableTypeClass, HashableTypeClass,
  BoolConvertibleTypeClass, IntConvertibleTypeClass, FloatConvertibleTypeClass,
  RealConvertibleTypeClass, ImagConvertibleTypeClass, ConjugateTypeClass,
  IndexConvertibleTypeClass,
  SignedTypeClass, AbsTypeClass, InvertTypeClass, RoundTypeClass,
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

  internal class var doc: String { return """
    int([x]) -> integer
    int(x, base=10) -> integer

    Convert a number or string to an integer, or return 0 if no arguments
    are given.  If x is a number, return x.__int__().  For floating point
    numbers, this truncates towards zero.

    If x is not a number or if base is given, then x must be a string,
    bytes, or bytearray instance representing an integer literal in the
    given base.  The literal can be preceded by '+' or '-' and be surrounded
    by whitespace.  The base defaults to 10.  Valid bases are 0 and 2-36.
    Base 0 means to interpret the base from the string as an integer literal.
    >>> int('0b100', base=0)
    4
    """
  }

  internal var value: BigInt

  // MARK: - Init

  // TODO: Cache <-10, 255> values

  internal init(_ context: PyContext, value: BigInt) {
    self.value = value
    super.init(type: context.types.int)
  }

  /// Only for PyBool use!
  internal init(type: PyType, value: BigInt) {
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

  internal func hash() -> HashableResult {
    return .value(self.context.hasher.hash(self.value))
  }

  // MARK: - String

  internal func repr() -> String {
    return String(describing: self.value)
  }

  internal func str() -> String {
    return self.repr()
  }

  // MARK: - Convertible

  internal func asBool() -> PyResult<Bool> {
    return .value(self.value != 0)
  }

  internal func asInt() -> PyResult<PyInt> {
    return .value(self)
  }

  internal func asFloat() -> PyResult<PyFloat> {
    return .value(self.float(Double(self.value)))
  }

  internal func asIndex() -> BigInt {
    return self.value
  }

  // MARK: - Imaginary

  internal func asReal() -> PyObject {
    return self
  }

  internal func asImag() -> PyObject {
    return self.int(0)
  }

  /// int.conjugate
  /// Return self, the complex conjugate of any int.
  internal func conjugate() -> PyObject {
    return self
  }

  // sourcery: pymethod = numerator
  internal func numerator() -> PyInt {
    return self
  }

  // sourcery: pymethod = denominator
  internal func denominator() -> PyInt {
    return self.int(1)
  }

  // MARK: - Sign

  internal func positive() -> PyObject {
    return self
  }

  internal func negative() -> PyObject {
    return self.int(-self.value)
  }

  // MARK: - Abs

  internal func abs() -> PyObject {
    return self.int(Swift.abs(self.value))
  }

  // MARK: - Add

  internal func add(_ other: PyObject) -> AddResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(self.value + other.value))
  }

  internal func radd(_ other: PyObject) -> AddResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  internal func sub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(self.value - other.value))
  }

  internal func rsub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(other.value - self.value))
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(self.value * other.value))
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
    return .value(self.asObject(result))
  }

  internal func rpow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    let result = self.pow(left: other.value, right: self.value)
    return .value(self.asObject(result))
  }

  private enum InnerPowResult {
    case int(BigInt)
    case fraction(Double)
  }

  private func pow(left: BigInt, right: BigInt) -> InnerPowResult {
    if right == 0 {
      return .int(1)
    }

    if right == 1 {
      return .int(left)
    }

    let result = self.exponentiationBySquaring(1, left, Swift.abs(right))

    return right > 0 ?
      .int(result) :
      .fraction(Double(1.0) / Double(result))
  }

  private func asObject(_ result: InnerPowResult) -> PyObject {
    switch result {
    case let .int(i): return self.int(i)
    case let .fraction(f): return self.float(f)
    }
  }

  /// Source:
  /// https://stackoverflow.com/questions/24196689
  /// https://en.wikipedia.org/wiki/Exponentiation_by_squaring#Basic_method
  private func exponentiationBySquaring(_ y: BigInt,
                                        _ x: BigInt,
                                        _ n: BigInt) -> BigInt {
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
      self.exponentiationBySquaring(y, x * x, n / 2) :
      self.exponentiationBySquaring(y * x, x * x, (n - 1) / 2)
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

    return .value(self.float(Double(left) / Double(right)))
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
    return .value(self.int(result))
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
    return .value(self.int(result))
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
    return .value(self.tuple(self.int(div), self.int(mod)))
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

    return .value(self.int(left << right))
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

    return .value(self.int(left >> right))
  }

  // MARK: - And

  internal func and(_ other: PyObject) -> BinaryResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(self.value & other.value))
  }

  internal func rand(_ other: PyObject) -> BinaryResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  internal func or(_ other: PyObject) -> BinaryResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(self.value | other.value))
  }

  internal func ror(_ other: PyObject) -> BinaryResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  internal func xor(_ other: PyObject) -> BinaryResult<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.int(self.value ^ other.value))
  }

  internal func rxor(_ other: PyObject) -> BinaryResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Invert

  internal func invert() -> PyObject {
    return self.int(~self.value)
  }

  // MARK: - Round

  /// Round an integer m to the nearest 10**n (n positive)
  ///
  /// ```
  /// int.__round__(12345,  2) -> 12345
  /// int.__round__(12345, -2) -> 12300
  /// ```
  internal func round(nDigits: PyObject?) -> RoundResult<PyObject> {
    let nDigits = nDigits ?? self.context._none

    var digitCount: BigInt?

    if nDigits is PyNone {
      digitCount = 0
    }

    if let int = nDigits as? PyInt {
      digitCount = int.value
    }

    // if digits >= 0 then no rounding is necessary; return self unchanged
    if let dc = digitCount, dc >= 0 {
      return .value(self)
    }

    // TODO: Implement int rounding to arbitrary precision
    return .notImplemented
  }
}
