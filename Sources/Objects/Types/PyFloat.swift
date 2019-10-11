import Foundation
import Core

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://developer.apple.com/documentation/swift/double/floating-point_operators_for_double

// TODO: Float
// __class__
// __delattr__
// __dir__
// __format__
// __getattribute__
// __getformat__
// __getnewargs__
// __init__
// __init_subclass__
// __new__
// __reduce__
// __reduce_ex__
// __set_format__
// __setattr__
// __sizeof__
// __subclasshook__
// __trunc__
// fromhex
// hex
// is_integer

// swiftlint:disable file_length

// sourcery: pytype = float
/// This subtype of PyObject represents a Python floating point object.
internal final class PyFloat: PyObject,
  ReprTypeClass, StrTypeClass,
  ComparableTypeClass, HashableTypeClass,
  BoolConvertibleTypeClass, IntConvertibleTypeClass, FloatConvertibleTypeClass,
  RealConvertibleTypeClass, ImagConvertibleTypeClass, ConjugateTypeClass,
  SignedTypeClass, AbsTypeClass, RoundTypeClass,
  AddTypeClass, RAddTypeClass,
  SubTypeClass, RSubTypeClass,
  MulTypeClass, RMulTypeClass,
  PowTypeClass, RPowTypeClass,
  TrueDivTypeClass, RTrueDivTypeClass,
  FloorDivTypeClass, RFloorDivTypeClass,
  ModTypeClass, RModTypeClass,
  DivModTypeClass, RDivModTypeClass {

  internal static let doc: String = """
    float(x) -> floating point number

    Convert a string or number to a floating point number, if possible.
    """

  internal let value: Double

  // MARK: - Init

  internal init(_ context: PyContext, value: Double) {
    self.value = value
    super.init(type: context.types.float)
  }

  // MARK: - Equatable

  /// This is nightmare, whatever we do is wrong (see CPython comment above
  /// 'static PyObject* float_richcompare(PyObject *v, PyObject *w, int op)'
  /// for details).
  internal func isEqual(_ other: PyObject) -> EquatableResult {
    if let pyFloat = other as? PyFloat {
      return .value(self.value == pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value == float)
    }

    return .notImplemented
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    if let pyFloat = other as? PyFloat {
      return .value(self.value < pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value < float)
    }

    return .notImplemented
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    if let pyFloat = other as? PyFloat {
      return .value(self.value <= pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value <= float)
    }

    return .notImplemented
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    if let pyFloat = other as? PyFloat {
      return .value(self.value > pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value > float)
    }

    return .notImplemented
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    if let pyFloat = other as? PyFloat {
      return .value(self.value >= pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value >= float)
    }

    return .notImplemented
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
    return String(describing: self.value)
  }

  // MARK: - Convertible

  internal func asBool() -> PyResult<Bool> {
    return .value(!self.value.isZero)
  }

  internal func asInt() -> PyResult<PyInt> {
    return .value(self.int(BigInt(self.value)))
  }

  internal func asFloat() -> PyResult<PyFloat> {
    return .value(self.float(self.value))
  }

  internal func asReal() -> PyObject {
    return self
  }

  internal func asImag() -> PyObject {
    return self.float(0.0)
  }

  // MARK: - Imaginary

  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal func conjugate() -> PyObject {
    return self
  }

  // MARK: - Sign

  internal func positive() -> PyObject {
    return self
  }

  internal func negative() -> PyObject {
    return self.float(-self.value)
  }

  // MARK: - Abs

  internal func abs() -> PyObject {
    return self.float(Swift.abs(self.value))
  }

  // MARK: - Add

  internal func add(_ other: PyObject) -> AddResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(self.value + other))
  }

  internal func radd(_ other: PyObject) -> AddResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  internal func sub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(self.value - other))
  }

  internal func rsub(_ other: PyObject) -> SubResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(other - self.value))
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(self.value * other))
  }

  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  internal func pow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    let result = Foundation.pow(self.value, other)
    return .value(self.float(result))
  }

  internal func rpow(_ other: PyObject) -> PowResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    let result = Foundation.pow(other, self.value)
    return .value(self.float(result))
  }

  // MARK: - True div

  internal func trueDiv(_ other: PyObject) -> TrueDivResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.trueDiv(left: self.value, right: other)
  }

  internal func rtrueDiv(_ other: PyObject) -> TrueDivResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.trueDiv(left: other, right: self.value)
  }

  private func trueDiv(left: Double, right: Double) -> TrueDivResult<PyObject> {
    if right.isZero {
      return .error(.zeroDivisionError("float division by zero"))
    }

    return .value(self.float(left / right))
  }

  // MARK: - Floor div

  internal func floorDiv(_ other: PyObject) -> FloorDivResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.floorDiv(left: self.value, right: other)
  }

  internal func rfloorDiv(_ other: PyObject) -> FloorDivResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.floorDiv(left: other, right: self.value)
  }

  private func floorDiv(left: Double, right: Double) -> FloorDivResult<PyObject> {
    if right.isZero {
      return .error(.zeroDivisionError("float floor division by zero"))
    }

    let result = self.floorDivRaw(left: left, right: right)
    return .value(self.float(result))
  }

  private func floorDivRaw(left: Double, right: Double) -> Double {
    return Foundation.floor(left / right)
  }

  // MARK: - Mod

  internal func mod(_ other: PyObject) -> ModResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.mod(left: self.value, right: other)
  }

  internal func rmod(_ other: PyObject) -> ModResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.mod(left: other, right: self.value)
  }

  private func mod(left: Double, right: Double) -> ModResult<PyObject> {
    if right.isZero {
      return .error(.zeroDivisionError("float modulo by zero"))
    }

    let result = self.modRaw(left: left, right: right)
    return .value(self.float(result))
  }

  private func modRaw(left: Double, right: Double) -> Double {
    return left.remainder(dividingBy: right)
  }

  // MARK: - Div mod

  internal func divMod(_ other: PyObject) -> DivModResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.divMod(left: self.value, right: other)
  }

  internal func rdivMod(_ other: PyObject) -> DivModResult<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.divMod(left: other, right: self.value)
  }

  private func divMod(left: Double, right: Double) -> DivModResult<PyObject> {
    if right.isZero {
      return .error(.zeroDivisionError("float divmod() by zero"))
    }

    let div = self.floorDivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)
    return .value(self.tuple(self.float(div), self.float(mod)))
  }

  // MARK: - Round

  /// Round a Python float v to the closest multiple of 10**-ndigits
  ///
  /// Return the Integral closest to x, rounding half toward even.
  /// When an argument is passed, work like built-in round(x, ndigits).
  internal func round(nDigits: PyObject?) -> RoundResult<PyObject> {
    let nDigits = nDigits ?? self.context._none

    var digitCount: BigInt?

    if nDigits is PyNone {
      digitCount = 0
    }

    if let int = nDigits as? PyInt {
      digitCount = int.value
    }

    switch digitCount {
    case .some(0):
      // round to nearest integer
      return .value(self.float(self.value.rounded()))
    case .some:
      // TODO: Implement float rounding to arbitrary precision
      return .notImplemented
    case .none:
      return .error(
        .typeError("'\(nDigits.type.name)' object cannot be interpreted as an integer")
      )
    }
  }

  // MARK: - Helpers

  private func asDouble(_ object: PyObject) -> Double? {
    if let pyFloat = object as? PyFloat {
      return pyFloat.value
    }

    if let pyInt = object as? PyInt {
      return Double(pyInt.value)
    }

    return nil
  }
}
