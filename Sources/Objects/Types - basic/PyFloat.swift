import Foundation
import Core

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://developer.apple.com/documentation/swift/double/floating-point_operators_for_double

// swiftlint:disable file_length

// sourcery: pytype = float, default, baseType
/// This subtype of PyObject represents a Python floating point object.
public class PyFloat: PyObject {

  internal static let doc: String = """
    float(x) -> floating point number

    Convert a string or number to a floating point number, if possible.
    """

  internal let value: Double

  override public var description: String {
    return "PyFloat(\(self.value))"
  }

  // MARK: - Init

  internal init(value: Double) {
    self.value = value
    super.init(type: Py.types.float)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, value: Double) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - Equatable

  /// This is nightmare, whatever we do is wrong (see CPython comment above
  /// 'static PyObject* float_richcompare(PyObject *v, PyObject *w, int op)'
  /// for details).
  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    if let o = PyFloat.asDouble(other) {
      return .value(self.value == o)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    if let o = PyFloat.asDouble(other) {
      return .value(self.value < o)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    if let o = PyFloat.asDouble(other) {
      return .value(self.value <= o)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    if let o = PyFloat.asDouble(other) {
      return .value(self.value > o)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    if let o = PyFloat.asDouble(other) {
      return .value(self.value >= o)
    }

    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .value(Py.hasher.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value(String(describing: self.value))
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return self.repr()
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    return !self.value.isZero
  }

  // sourcery: pymethod = __int__
  internal func asInt() -> PyResult<PyInt> {
    return .value(Py.newInt(BigInt(self.value)))
  }

  // sourcery: pymethod = __float__
  internal func asFloat() -> PyResult<PyFloat> {
    return .value(self)
  }

  // sourcery: pymethod = real
  internal func asReal() -> PyObject {
    return self
  }

  // sourcery: pymethod = imag
  internal func asImag() -> PyObject {
    return Py.newFloat(0.0)
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
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  internal func positive() -> PyObject {
    return self
  }

  // sourcery: pymethod = __neg__
  internal func negative() -> PyObject {
    return Py.newFloat(-self.value)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal func abs() -> PyObject {
    return Py.newFloat(Swift.abs(self.value))
  }

  // MARK: - Is integer

  internal static let isIntegerDoc = """
    is_integer($self, /)
    --

    Return True if the float is an integer.
    """

  // sourcery: pymethod = is_integer, , doc = isIntegerDoc
  internal func isInteger() -> PyBool {
    guard self.value.isFinite else {
      return Py.false
    }

    let result = floor(self.value) == self.value
    return Py.newBool(result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(self.value + other))
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(self.value - other))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(other - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(self.value * other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  internal func pow(exp: PyObject) -> PyResult<PyObject> {
    return self.pow(exp: exp, mod: nil)
  }

  // sourcery: pymethod = __pow__
  internal func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .typeError("pow() 3rd argument not allowed unless all arguments are integers")
    }

    guard let exp = PyFloat.asDouble(exp) else {
      return .value(Py.notImplemented)
    }

    let result = Foundation.pow(self.value, exp)
    return .value(Py.newFloat(result))
  }

  internal func rpow(base: PyObject) -> PyResult<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .typeError("pow() 3rd argument not allowed unless all arguments are integers")
    }

    guard let base = PyFloat.asDouble(base) else {
      return .value(Py.notImplemented)
    }

    let result = Foundation.pow(base, self.value)
    return .value(Py.newFloat(result))
  }

  private func isNilOrNone(_ value: PyObject?) -> Bool {
    return value == nil || value is PyNone
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  internal func truediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: other, right: self.value)
  }

  private func truediv(left: Double, right: Double) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float division by zero")
    }

    return .value(Py.newFloat(left / right))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: other, right: self.value)
  }

  private func floordiv(left: Double, right: Double) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float floor division by zero")
    }

    let result = self.floordivRaw(left: left, right: right)
    return .value(Py.newFloat(result))
  }

  private func floordivRaw(left: Double, right: Double) -> Double {
    return Foundation.floor(left / right)
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  internal func mod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rmod__
  internal func rmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: other, right: self.value)
  }

  private func mod(left: Double, right: Double) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float modulo by zero")
    }

    let result = self.modRaw(left: left, right: right)
    return .value(Py.newFloat(result))
  }

  private func modRaw(left: Double, right: Double) -> Double {
    return left.remainder(dividingBy: right)
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  internal func divmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.divmod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.divmod(left: other, right: self.value)
  }

  private func divmod(left: Double, right: Double) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float divmod() by zero")
    }

    let div = self.floordivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)

    let tuple0 = Py.newFloat(div)
    let tuple1 = Py.newFloat(mod)
    return .value(Py.newTuple(tuple0, tuple1))
  }

  // MARK: - Round

  // sourcery: pymethod = __round__
  /// Round a Python float v to the closest multiple of 10**-ndigits
  ///
  /// Return the Integral closest to x, rounding half toward even.
  /// When an argument is passed, work like built-in round(x, ndigits).
  internal func round(nDigits: PyObject?) -> PyResult<PyObject> {
    let nDigits = nDigits ?? Py.none

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
      return .value(Py.newFloat(self.value.rounded()))
    case .some:
      // TODO: Implement float rounding to arbitrary precision
      return .value(Py.notImplemented)
    case .none:
      let msg = "'\(nDigits.typeName)' object cannot be interpreted as an integer"
      return .typeError(msg)
    }
  }

  // MARK: - Trunc

  // sourcery: pymethod = __trunc__
  internal func trunc() -> PyObject {
    let raw = self.value

    var wholePart = 0.0
    Foundation.modf(raw, &wholePart)

    if let int = BigInt(exactly: wholePart) {
      return Py.newInt(int)
    }

    return Py.newFloat(wholePart)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.float
    if isBuiltin {
      if let e = ArgumentParser.noKwargsOrError(fnName: "float",
                                                kwargs: kwargs) {
        return .error(e)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "float",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    let alloca = isBuiltin ?
      PyFloat.init(type:value:) :
      PyFloatHeap.init(type:value:)

    if args.isEmpty {
      return .value(alloca(type, 0.0))
    }

    let arg0 = args[0]
    if let str = arg0 as? PyString {
      guard let value = Double(str.value) else {
        return .valueError("float() '\(str.value)' cannot be interpreted as float")
      }
      return .value(alloca(type, value))
    }

    return PyFloat.extractDouble(arg0).map { alloca(type, $0) }
  }

  /// PyObject *
  /// PyNumber_Float(PyObject *o)
  private static func extractDouble(_ object: PyObject) -> PyResult<Double> {
    // Call has to be before 'PyFloat.asDouble', because it can override
    switch PyFloat.callFloat(object) {
    case .value(let o):
      guard let f = o as? PyFloat else {
        let ot = o.typeName
        let msg = "\(object.typeName).__float__ returned non-float (type \(ot))"
        return .typeError(msg)
      }
      return .value(f.value)
    case .missingMethod:
      break // try other possibilities
    case .error(let e), .notCallable(let e):
      return .error(e)
    }

    if let d = PyFloat.asDouble(object) {
      return .value(d)
    }

    let msg = "float() argument must be a string, or a number, not '\(object.typeName)'"
    return .typeError(msg)
  }

  private static func callFloat(_ object: PyObject) -> CallMethodResult {
    if let owner = object as? __float__Owner {
      switch owner.asFloat() {
      case let .value(f): return .value(f)
      case let .error(e): return .error(e)
      }
    }

    return Py.callMethod(on: object, selector: "__float__")
  }

  // MARK: - Helpers

  private static func asDouble(_ object: PyObject) -> Double? {
    if let pyFloat = object as? PyFloat {
      return pyFloat.value
    }

    if let pyInt = object as? PyInt {
      return Double(pyInt.value)
    }

    return nil
  }
}
