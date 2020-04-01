import Foundation
import Core

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://developer.apple.com/documentation/swift/double/floating-point_operators_for_double

// swiftlint:disable file_length
// swiftlint:disable type_name
// swiftlint:disable nesting

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
}

/// Private helper for comparison operations.
private protocol FloatCompare {
  /// Opposite compare. For example for '<' it will be '>'.
  associatedtype reflected: FloatCompare

  static func compare(left: BigInt, right: BigInt) -> Bool
  static func compare(left: Double, right: Double) -> Bool
}

private enum FloatSign: BigInt, Equatable {
  case plus =  1
  case minus =  -1
  case zero =  0
}

extension FloatCompare {

  fileprivate static func compare(left: Double, right: PyObject) -> CompareResult {
    // If both are floats then use standard Swift compare
    // (even if one of them is nan/inf/whatever).
    if let rightFloat = right as? PyFloat {
      let result = Self.compare(left: left, right: rightFloat.value)
      return .value(result)
    }

    // If i is an infinity, its magnitude exceeds any finite integer,
    // so it doesn't matter which int we compare i with. If i is a NaN, similarly.
    guard left.isFinite else {
      if right is PyInt {
        let result = Self.compare(left: left, right: 0.0)
        return .value(result)
      }

      return .notImplemented
    }

    if let rightInt = right as? PyInt {
      return Self.compare(left: left, right: rightInt.value)
    }

    return .notImplemented
  }

  private static func compare(left: Double, right: BigInt) -> CompareResult {
    // Easy case: different signs

    let leftSign = Self.getSign(left)
    let rightSign = Self.getSign(right)

    if leftSign != rightSign {
      let result = Self.compare(left: leftSign.rawValue, right: rightSign.rawValue)
      return .value(result)
    }

    // Scarry case: one is float, one is int, they have the same sign

    let nBits = right.minRequiredWidth
    if nBits <= 48 {
      // It's impossible that <= 48 bits overflowed.
      let d = Double(right)
      let result = Self.compare(left: left, right: d)
      return .value(result)
    }

    // Horror case: we are waaaay out of Double precision
    assert(rightSign != .zero) // else nBits = 0
    assert(leftSign != .zero) // we checked 'leftSign != rightSign'

    // We want to work with non-negative numbers.
    // Multiply both sides by -1; this also swaps the comparator.
    return leftSign == .minus ?
      Self.reflected.magic(left: -left, right: right, nBits: nBits) :
      Self.magic(left: left, right: right, nBits: nBits)
  }

  /// Use current position of the moon to return random value
  /// (actually if you read 'wiki', and 'cplusplus.com' it will make sense).
  private static func magic(left: Double,
                            right: BigInt,
                            nBits: Int) -> CompareResult {
    assert(left > 0)

    // Exponent is the # of bits in 'left' before the radix point;
    // we know that nBits (the # of bits in 'right') > 48 at this point
    // https://en.wikipedia.org/wiki/Radix_point
    let (_, exponent) = Foundation.frexp(left)

    if exponent < 0 || exponent < nBits {
      let result = Self.compare(left: 1.0, right: 2.0)
      return .value(result)
    }

    if exponent > nBits {
      let result = Self.compare(left: 2.0, right: 1.0)
      return .value(result)
    }

    // 'left' and 'right' have the same number of bits before the radix point.
    // Construct two ints that have the same comparison outcome.
    // BREAKPOINT: You can use 'assert 2.**54 == 2**54' to get here.
    assert(exponent == nBits)

    // 'vv' and 'ww' are the names used in CPython
    let (intPart, fracPart) = Foundation.modf(left)
    var leftVV = BigInt(intPart)
    var rightWW = Swift.abs(right)

    if fracPart != 0.0 {
      // Remove the last bit, and repace it with 1 for left
      rightWW = rightWW << 1
      leftVV = leftVV << 1
      leftVV = leftVV | 1
    }

    let result = Self.compare(left: leftVV, right: rightWW)
    return .value(result)
  }

  private static func getSign(_ value: Double) -> FloatSign {
    return value == 0.0 ? .zero :
           value >  0.0 ? .plus :
           .minus
  }

  private static func getSign(_ value: BigInt) -> FloatSign {
    return value == 0 ? .zero :
           value >  0 ? .plus :
           .minus
  }
}

extension PyFloat {

  // MARK: - Equatable

  private enum EqualCompare: FloatCompare {

    fileprivate typealias reflected = EqualCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left == right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left == right
    }
  }

  /// This is nightmare, whatever we do is wrong (see CPython comment above
  /// 'static PyObject* float_richcompare(PyObject *v, PyObject *w, int op)'
  /// for details).
  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return EqualCompare.compare(left: self.value, right: other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  private enum LessCompare: FloatCompare {

    fileprivate typealias reflected = GreaterCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left < right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left < right
    }
  }

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return LessCompare.compare(left: self.value, right: other)
  }

  private enum LessEqualCompare: FloatCompare {

    fileprivate typealias reflected = GreaterEqualCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left <= right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left <= right
    }
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return LessEqualCompare.compare(left: self.value, right: other)
  }

  private enum GreaterCompare: FloatCompare {

    fileprivate typealias reflected = LessCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left > right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left > right
    }
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return GreaterCompare.compare(left: self.value, right: other)
  }

  private enum GreaterEqualCompare: FloatCompare {

    fileprivate typealias reflected = LessEqualCompare

    fileprivate static func compare(left: BigInt, right: BigInt) -> Bool {
      return left >= right
    }

    fileprivate static func compare(left: Double, right: Double) -> Bool {
      return left >= right
    }
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return GreaterEqualCompare.compare(left: self.value, right: other)
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

  // sourcery: pyproperty = real
  internal func asReal() -> PyObject {
    return self
  }

  // sourcery: pyproperty = imag
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

  /// Round to 'nearest' integer
  /// Also: 0.5.__round__() == 0
  private var roundingRule: FloatingPointRoundingRule {
    return .toNearestOrEven
  }

  // sourcery: pymethod = __round__
  /// Round a Python float v to the closest multiple of 10**-ndigits
  ///
  /// Return the Integral closest to x, rounding half toward even.
  /// When an argument is passed, work like built-in round(x, ndigits).
  ///
  /// If `nDigits` is not given or is `None` -> Int.
  /// Otherwise -> Float.
  internal func round(nDigits: PyObject?) -> PyResult<PyObject> {
    guard let nDigits = nDigits else {
      return .value(self.roundToInt())
    }

    if nDigits is PyNone {
      return .value(self.roundToInt())
    }

    guard let nDigitsInt = nDigits as? PyInt else {
      let msg = "'\(nDigits.typeName)' object cannot be interpreted as an integer"
      return .typeError(msg)
    }

    switch nDigitsInt.value {
    case 0:
      let rounded = self.value.rounded(self.roundingRule)
      return .value(Py.newFloat(rounded))
    default:
      // TODO: Implement float rounding to arbitrary precision
      let msg = "Float rounding to arbitrary precision was not yet implemented."
      return .systemError(msg)
    }
  }

  internal func roundToInt() -> PyInt {
    let rounded = self.value.rounded(self.roundingRule)
    return Py.newInt(BigInt(rounded))
  }

  // MARK: - Trunc

  // sourcery: pymethod = __trunc__
  internal func trunc() -> PyObject {
    let (intPart, _) = Foundation.modf(self.value)

    if let int = BigInt(exactly: intPart) {
      return Py.newInt(int)
    }

    let int = BigInt(self.value)
    return Py.newInt(int)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.float
    if isBuiltin {
      if let e = ArgumentParser.noKwargsOrError(fnName: "float", kwargs: kwargs) {
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
    switch PyFloat.parseDouble(string: arg0) {
    case .value(let d): return .value(alloca(type, d))
    case .notString: break
    case .error(let e): return .error(e)
    }

    return PyFloat.extractDouble(arg0).map { alloca(type, $0) }
  }

  private enum DoubleFromString {
    case value(Double)
    case notString
    case error(PyBaseException)
  }

  private static func parseDouble(string object: PyObject) -> DoubleFromString {
    if let str = object as? PyString {
      guard let value = PyFloat.parseDouble(string: str.value) else {
        let msg = "float() '\(str.value)' cannot be interpreted as float"
        return .error(Py.newValueError(msg: msg))
      }
      return .value(value)
    }

    if let bytes = object as? PyBytesType {
      guard let string = bytes.data.string else {
        let msg = "float() bytes '\(bytes.ptrString)' cannot be interpreted as str"
        return .error(Py.newValueError(msg: msg))
      }

      if let value = PyFloat.parseDouble(string: string) {
        return .value(value)
      }

      let msg = "float() '\(string)' cannot be interpreted as float"
      return .error(Py.newValueError(msg: msg))
    }

    return .notString
  }

  private static func parseDouble(string: String) -> Double? {
    var input = string
    input.removeAll { $0.isWhitespace || $0 == "_" }
    return Double(input)
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

    return Py.callMethod(object: object, selector: .__float__)
  }

  // MARK: - Helpers

  private static func asDouble(_ object: PyObject) -> Double? {
    if let pyFloat = object as? PyFloat {
      return pyFloat.value
    }

    if let pyInt = object as? PyInt {
      // This will not work in a looooot of the cases.
      // But in most of the cases it will, so we will do it anyway.
      return Double(pyInt.value)
    }

    return nil
  }
}
