import Foundation
import Core

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://developer.apple.com/documentation/swift/double/floating-point_operators_for_double

// swiftlint:disable file_length

// sourcery: pytype = float
/// This subtype of PyObject represents a Python floating point object.
internal final class PyFloat: PyObject {

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
  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    if let pyFloat = other as? PyFloat {
      return .value(self.value == pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value == float)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    if let pyFloat = other as? PyFloat {
      return .value(self.value < pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value < float)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    if let pyFloat = other as? PyFloat {
      return .value(self.value <= pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value <= float)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    if let pyFloat = other as? PyFloat {
      return .value(self.value > pyFloat.value)
    }

    if let pyInt = other as? PyInt {
      let float = Double(pyInt.value)
      return .value(self.value > float)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
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

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .value(HashHelper.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return String(describing: self.value)
  }

  // sourcery: pymethod = __str__
  internal func str() -> String {
    return String(describing: self.value)
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> PyResult<Bool> {
    return .value(!self.value.isZero)
  }

  // sourcery: pymethod = __int__
  internal func asInt() -> PyResult<PyInt> {
    return .value(self.int(BigInt(self.value)))
  }

  // sourcery: pymethod = __float__
  internal func asFloat() -> PyResult<PyFloat> {
    return .value(self.float(self.value))
  }

  // sourcery: pymethod = real
  internal func asReal() -> PyObject {
    return self
  }

  // sourcery: pymethod = imag
  internal func asImag() -> PyObject {
    return self.float(0.0)
  }

  // MARK: - Imaginary

  // sourcery: pymethod = conjugate
  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal func conjugate() -> PyObject {
    return self
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  internal func positive() -> PyObject {
    return self
  }

  // sourcery: pymethod = __neg__
  internal func negative() -> PyObject {
    return self.float(-self.value)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal func abs() -> PyObject {
    return self.float(Swift.abs(self.value))
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(self.value + other))
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(self.value - other))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(other - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.float(self.value * other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  // sourcery: pymethod = __pow__
  internal func pow(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    let result = Foundation.pow(self.value, other)
    return .value(self.float(result))
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    let result = Foundation.pow(other, self.value)
    return .value(self.float(result))
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  internal func trueDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.trueDiv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtrueDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.trueDiv(left: other, right: self.value)
  }

  private func trueDiv(left: Double, right: Double) -> PyResultOrNot<PyObject> {
    if right.isZero {
      return .error(.zeroDivisionError("float division by zero"))
    }

    return .value(self.float(left / right))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floorDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.floorDiv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloorDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.floorDiv(left: other, right: self.value)
  }

  private func floorDiv(left: Double, right: Double) -> PyResultOrNot<PyObject> {
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

  // sourcery: pymethod = __mod__
  internal func mod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.mod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rmod__
  internal func rmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.mod(left: other, right: self.value)
  }

  private func mod(left: Double, right: Double) -> PyResultOrNot<PyObject> {
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

  // sourcery: pymethod = __divmod__
  internal func divMod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.divMod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivMod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.divMod(left: other, right: self.value)
  }

  private func divMod(left: Double, right: Double) -> PyResultOrNot<PyObject> {
    if right.isZero {
      return .error(.zeroDivisionError("float divmod() by zero"))
    }

    let div = self.floorDivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)
    return .value(self.tuple(self.float(div), self.float(mod)))
  }

  // MARK: - Round

  // sourcery: pymethod = __round__
  /// Round a Python float v to the closest multiple of 10**-ndigits
  ///
  /// Return the Integral closest to x, rounding half toward even.
  /// When an argument is passed, work like built-in round(x, ndigits).
  internal func round(nDigits: PyObject?) -> PyResultOrNot<PyObject> {
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
        .typeError("'\(nDigits.typeName)' object cannot be interpreted as an integer")
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
