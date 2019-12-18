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

  // MARK: - Init

  internal init(_ context: PyContext, value: Double) {
    self.value = value
    super.init(type: context.builtins.types.float)
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
    return .value(self.hasher.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value(String(describing: self.value))
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return .value(String(describing: self.value))
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    return !self.value.isZero
  }

  // sourcery: pymethod = __int__
  internal func asInt() -> PyResult<PyInt> {
    return .value(self.builtins.newInt(BigInt(self.value)))
  }

  // sourcery: pymethod = __float__
  internal func asFloat() -> PyResult<PyFloat> {
    return .value(self.builtins.newFloat(self.value))
  }

  // sourcery: pymethod = real
  internal func asReal() -> PyObject {
    return self
  }

  // sourcery: pymethod = imag
  internal func asImag() -> PyObject {
    return self.builtins.newFloat(0.0)
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
    return self.builtins.newFloat(-self.value)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal func abs() -> PyObject {
    return self.builtins.newFloat(Swift.abs(self.value))
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.builtins.newFloat(self.value + other))
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

    return .value(self.builtins.newFloat(self.value - other))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.builtins.newFloat(other - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return .value(self.builtins.newFloat(self.value * other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  internal func pow(exp: PyObject) -> PyResultOrNot<PyObject> {
    return self.pow(exp: exp, mod: nil)
  }

  // sourcery: pymethod = __pow__
  internal func pow(exp: PyObject, mod: PyObject?) -> PyResultOrNot<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .typeError("pow() 3rd argument not allowed unless all arguments are integers")
    }

    guard let exp = self.asDouble(exp) else {
      return .notImplemented
    }

    let result = Foundation.pow(self.value, exp)
    return .value(self.builtins.newFloat(result))
  }

  internal func rpow(base: PyObject) -> PyResultOrNot<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(base: PyObject, mod: PyObject?) -> PyResultOrNot<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .typeError("pow() 3rd argument not allowed unless all arguments are integers")
    }

    guard let base = self.asDouble(base) else {
      return .notImplemented
    }

    let result = Foundation.pow(base, self.value)
    return .value(self.builtins.newFloat(result))
  }

  private func isNilOrNone(_ value: PyObject?) -> Bool {
    return value == nil || value is PyNone
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  internal func truediv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.truediv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtruediv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.truediv(left: other, right: self.value)
  }

  private func truediv(left: Double, right: Double) -> PyResultOrNot<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float division by zero")
    }

    return .value(self.builtins.newFloat(left / right))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floordiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.floordiv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloordiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.floordiv(left: other, right: self.value)
  }

  private func floordiv(left: Double, right: Double) -> PyResultOrNot<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float floor division by zero")
    }

    let result = self.floordivRaw(left: left, right: right)
    return .value(self.builtins.newFloat(result))
  }

  private func floordivRaw(left: Double, right: Double) -> Double {
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
      return .zeroDivisionError("float modulo by zero")
    }

    let result = self.modRaw(left: left, right: right)
    return .value(self.builtins.newFloat(result))
  }

  private func modRaw(left: Double, right: Double) -> Double {
    return left.remainder(dividingBy: right)
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  internal func divmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.divmod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = self.asDouble(other) else {
      return .notImplemented
    }

    return self.divmod(left: other, right: self.value)
  }

  private func divmod(left: Double, right: Double) -> PyResultOrNot<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float divmod() by zero")
    }

    let div = self.floordivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)

    let tuple0 = self.builtins.newFloat(div)
    let tuple1 = self.builtins.newFloat(mod)
    return .value(self.builtins.newTuple(tuple0, tuple1))
  }

  // MARK: - Round

  // sourcery: pymethod = __round__
  /// Round a Python float v to the closest multiple of 10**-ndigits
  ///
  /// Return the Integral closest to x, rounding half toward even.
  /// When an argument is passed, work like built-in round(x, ndigits).
  internal func round(nDigits: PyObject?) -> PyResultOrNot<PyObject> {
    let nDigits = nDigits ?? self.builtins.none

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
      return .value(self.builtins.newFloat(self.value.rounded()))
    case .some:
      // TODO: Implement float rounding to arbitrary precision
      return .notImplemented
    case .none:
      return .typeError(
        "'\(nDigits.typeName)' object cannot be interpreted as an integer"
      )
    }
  }

  // MARK: - Trunc

  // sourcery: pymethod = __trunc__
  internal func trunc() -> PyResult<PyObject> {
    let raw = self.value

    var wholePart = 0.0
    Foundation.modf(raw, &wholePart)

    if let int = BigInt(exactly: wholePart) {
      return .value(self.builtins.newInt(int))
    }

    return .value(self.builtins.newFloat(wholePart))
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.float
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

    let alloca = isBuiltin ? PyFloat.init(type:value:) : PyFloatHeap.init(type:value:)

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
    if let float = object as? PyFloat {
      return .value(float.value)
    }

    if let owner = object as? __float__Owner {
      return owner.asFloat().map { $0.value }
    }

    switch object.builtins.callMethod(on: object, selector: "__float__") {
    case .value(let f):
      guard let float = f as? PyFloat else {
        let ot = object.typeName
        let ft = f.typeName
        return .typeError("\(ot).__float__ returned non-float (type \(ft))")
      }
      return .value(float.value)
    case .notImplemented, .missingMethod:
      let t = object.typeName
      return .typeError("float() argument must be a string, or a number, not '\(t)'")
    case .notCallable(let e), .error(let e):
      return .error(e)
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
