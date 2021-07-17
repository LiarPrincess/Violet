import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore floatobject

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://developer.apple.com/documentation/swift/double/floating-point_operators_for_double

internal let DBL_MANT_DIG = Double.significandBitCount + 1 // 53
internal let DBL_MIN_EXP = Double.leastNormalMagnitude.exponent + 1 // -1021
internal let DBL_MAX_EXP = Double.greatestFiniteMagnitude.exponent + 1 // 1024

// MARK: - Frexp

/// `value == mantissa * 2 ** exponent`
///
/// # Important
/// Do not use `Double.significand‚` or `Foundation.frexp`
/// (version that returns tuple)!
///
/// They return different results than `frexp` in CPython (which makes comparing
/// code very non-intuitive).
///
/// In Swift `value.significand` is always positive (afaik), for example:
/// ``` Swift
/// let value = -1.0
/// print(value.sign) -> minus
/// print(value.significand) -> 1.0 <- it is positive!
/// print(value.exponent) -> 0
/// ```
///
/// CPython uses version where significand is negative when value is negative
/// [cplusplus.com/frexp](https://www.cplusplus.com/reference/cmath/frexp).
///
/// # Naming
/// We could create our own `frexp` function, but then every reader would just
/// assume that we are using `Foundation` version.
/// If we start with uppercase then everyone will be like:
/// `wtf? uppercase? what is this? <surprised Pikachu face>`.
internal struct Frexp {

  internal let exponent: Int
  /// Negative if input number was negative!
  internal let mantissa: Double

  internal init(value: Double) {
    var e = Int32(0)
    self.mantissa = Foundation.frexp(value, &e) // non-tuple version
    self.exponent = Int(e)
  }
}

// MARK: - PyFloat

// sourcery: pytype = float, default, baseType
// sourcery: subclassInstancesHave__dict__
/// This subtype of PyObject represents a Python floating point object.
public class PyFloat: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    float(x) -> floating point number

    Convert a string or number to a floating point number, if possible.
    """

  public let value: Double

  override public var description: String {
    return "PyFloat(\(self.value))"
  }

  // MARK: - Init

  internal init(value: Double) {
    self.value = value
    super.init(type: Py.types.float)
  }

  internal init(type: PyType, value: Double) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    return FloatCompareHelper.isEqual(left: self.value, right: other)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return FloatCompareHelper.isLess(left: self.value, right: other)
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return FloatCompareHelper.isLessEqual(left: self.value, right: other)
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return FloatCompareHelper.isGreater(left: self.value, right: other)
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return FloatCompareHelper.isGreaterEqual(left: self.value, right: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    return .value(Py.hasher.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    return .value(String(describing: self.value))
  }

  // sourcery: pymethod = __str__
  public func str() -> PyResult<String> {
    return self.repr()
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  public func asBool() -> Bool {
    return !self.value.isZero
  }

  // sourcery: pymethod = __int__
  public func asInt() -> PyResult<PyInt> {
    return .value(Py.newInt(BigInt(self.value)))
  }

  // sourcery: pymethod = __float__
  public func asFloat() -> PyResult<PyFloat> {
    return .value(self)
  }

  // sourcery: pyproperty = real
  public func asReal() -> PyObject {
    return self
  }

  // sourcery: pyproperty = imag
  public func asImag() -> PyObject {
    return Py.newFloat(0.0)
  }

  // MARK: - Imaginary

  internal static let conjugateDoc = """
    conjugate($self, /)
    --

    Return self, the complex conjugate of any float.
    """

  // sourcery: pymethod = conjugate, doc = conjugateDoc
  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  public func conjugate() -> PyObject {
    return self
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  public func positive() -> PyObject {
    return self
  }

  // sourcery: pymethod = __neg__
  public func negative() -> PyObject {
    return Py.newFloat(-self.value)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  public func abs() -> PyObject {
    return Py.newFloat(Swift.abs(self.value))
  }

  // MARK: - Is integer

  internal static let isIntegerDoc = """
    is_integer($self, /)
    --

    Return True if the float is an integer.
    """

  // sourcery: pymethod = is_integer, , doc = isIntegerDoc
  public func isInteger() -> PyBool {
    guard self.value.isFinite else {
      return Py.false
    }

    let result = floor(self.value) == self.value
    return Py.newBool(result)
  }

  // MARK: - Integer ratio

  internal static let asIntegerRatioDoc = """
    as_integer_ratio($self, /)
    --

    Return integer ratio.

    Return a pair of integers, whose ratio is exactly equal to the original float
    and with a positive denominator.

    Raise OverflowError on infinities and a ValueError on NaNs.

    >>> (10.0).as_integer_ratio()
    (10, 1)
    >>> (0.0).as_integer_ratio()
    (0, 1)
    >>> (-.25).as_integer_ratio()
    (-1, 4)
    """

  // sourcery: pymethod = as_integer_ratio, doc = asIntegerRatioDoc
  public func asIntegerRatio() -> PyResult<PyObject> {
    if self.value.isInfinite {
      return .overflowError("cannot convert Infinity to integer ratio")
    }

    if self.value.isNaN {
      return .valueError("cannot convert NaN to integer ratio")
    }

    let frexp = Frexp(value: self.value)
    var exponent = frexp.exponent
    var mantissa = frexp.mantissa

    for _ in 0..<300 {
      if mantissa == Foundation.floor(mantissa) {
        break
      }

      mantissa *= 2
      exponent -= 1
    }

    var numerator: BigInt
    switch Py.newInt(double: mantissa) {
    case let .value(i): numerator = i.value
    case let .error(e): return .error(e)
    }

    var denominator = BigInt(1)

    if exponent > 0 {
      numerator = numerator << exponent
    } else {
      denominator = denominator << -exponent // notice '-'!
    }

    let pyNumerator = Py.newInt(numerator)
    let pyDenominator = Py.newInt(denominator)
    return .value(Py.newTuple(pyNumerator, pyDenominator))
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      let result = self.value + d
      return .value(Py.newFloat(result))

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __radd__
  public func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  public func sub(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      let result = self.value - d
      return .value(Py.newFloat(result))

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rsub__
  public func rsub(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      let result = d - self.value
      return .value(Py.newFloat(result))

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  public func mul(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      let result = self.value * d
      return .value(Py.newFloat(result))

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rmul__
  public func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  public func pow(exp: PyObject) -> PyResult<PyObject> {
    return self.pow(exp: exp, mod: nil)
  }

  // sourcery: pymethod = __pow__
  public func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    if let e = self.disallowPowMod(mod: mod) {
      return .error(e)
    }

    switch Self.asDouble(object: exp) {
    case let .value(exp):
      let base = self.value

      if let e = self.checkPowInvariants(base: base, exp: exp) {
        return .error(e)
      }

      let result = Foundation.pow(base, exp)
      return .value(Py.newFloat(result))

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  public func rpow(base: PyObject) -> PyResult<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  public func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    if let e = self.disallowPowMod(mod: mod) {
      return .error(e)
    }

    switch Self.asDouble(object: base) {
    case let .value(base):
      let exp = self.value

      if let e = self.checkPowInvariants(base: base, exp: exp) {
        return .error(e)
      }

      let result = Foundation.pow(base, exp)
      return .value(Py.newFloat(result))

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  private func disallowPowMod(mod: PyObject?) -> PyBaseException? {
    if PyCast.isNilOrNone(mod) {
      return nil
    }

    let msg = "pow() 3rd argument not allowed unless all arguments are integers"
    return Py.newTypeError(msg: msg)
  }

  private func checkPowInvariants(base: Double, exp: Double) -> PyBaseException? {
    if base.isZero && exp < 0 {
      let msg = "0.0 cannot be raised to a negative power"
      return Py.newZeroDivisionError(msg: msg)
    }

    return nil
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  public func truediv(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.truediv(left: self.value, right: d)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rtruediv__
  public func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.truediv(left: d, right: self.value)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  private func truediv(left: Double, right: Double) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("float division by zero")
    }

    return .value(Py.newFloat(left / right))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  public func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.floordiv(left: self.value, right: d)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rfloordiv__
  public func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.floordiv(left: d, right: self.value)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
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
  public func mod(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.mod(left: self.value, right: d)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rmod__
  public func rmod(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.mod(left: d, right: self.value)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
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
  public func divmod(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.divmod(left: self.value, right: d)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rdivmod__
  public func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
    switch Self.asDouble(object: other) {
    case let .value(d):
      return self.divmod(left: d, right: self.value)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .value(Py.notImplemented)
    }
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

  /// See comment in `round(nDigits: PyObject?)`.
  private var roundDigitCountMax: Int {
    // swiftformat:disable numberFormatting
    return Int(Double(DBL_MANT_DIG - DBL_MIN_EXP) * 0.301_03)
    // swiftformat:enable numberFormatting
  }

  /// See comment in `round(nDigits: PyObject?)`.
  private var roundDigitCountMin: Int {
    // swiftformat:disable numberFormatting
    return -Int(Double(DBL_MAX_EXP + 1) * 0.301_03)
    // swiftformat:enable numberFormatting
  }

  internal static let roundDoc = """
    __round__($self, ndigits=None, /)
    --

    Return the Integral closest to x, rounding half toward even.

    When an argument is passed, work like built-in round(x, ndigits).
    """

  // sourcery: pymethod = __round__, doc = roundDoc
  /// Round a Python float v to the closest multiple of 10**-ndigits
  ///
  /// Return the Integral closest to x, rounding half toward even.
  /// When an argument is passed, work like built-in round(x, ndigits).
  ///
  /// If `nDigits` is not given or is `None` returns the nearest integer.
  /// If `nDigits` is given returns the number rounded off to the `ndigits`.
  public func round(nDigits: PyObject?) -> PyResult<PyObject> {
    switch self.parseRoundDigitCount(object: nDigits) {
    case .none:
      let rounded = self.roundToEven(value: self.value)
      let result = Py.newInt(double: rounded)
      return result.map { $0 as PyObject }

    case .int(let nDigits):
      // nans and infinities round to themselves
      guard self.value.isFinite else {
        return .value(self)
      }

      // Dark magic incoming (well above our $0 pay grade):
      // Deal with extreme values for ndigits.
      // For ndigits > NDIGITS_MAX, x always rounds to itself.
      // For ndigits < NDIGITS_MIN, x always rounds to +-0.0.
      // Here 0.30103 is an upper bound for log10(2).

      if nDigits > self.roundDigitCountMax {
        return .value(self)
      }

      if nDigits < self.roundDigitCountMin {
        let zero = Double(signOf: self.value, magnitudeOf: 0.0)
        return .value(Py.newFloat(zero))
      }

      return self.round(nDigit: nDigits)

    case .error(let e):
      return .error(e)
    }
  }

  private enum RoundDigits {
    case none
    case int(Int)
    case error(PyBaseException)
  }

  private func parseRoundDigitCount(object: PyObject?) -> RoundDigits {
    guard let object = object else {
      return .none
    }

    if PyCast.isNone(object) {
      return .none
    }

    switch IndexHelper.int(object, onOverflow: .default) {
    case let .value(i):
      return .int(i)
    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }
  }

  /// Round to the closest allowed value;
  /// if two values are equally close, the even one is chosen.
  ///
  /// AFAIK it is te same as `value.round(.toNearestOrEven)`.
  private func roundToEven(value: Double) -> Double {
    let result = Foundation.round(value)

    if Foundation.fabs(value - result) == 0.5 {
      // halfway case: round to even
      return 2.0 * Foundation.round(value / 2.0)
    }

    return result
  }

  /// ``` Python
  /// (123.456).__round__(0) -> 123.0
  /// (123.456).__round__(1) -> 123.5
  /// (123.456).__round__(2) -> 123.46
  /// (123.456).__round__(-1) -> 120.0
  /// (123.456).__round__(-2) -> 100.0
  /// ```
  ///
  /// static PyObject *
  /// double_round(double x, int ndigits)
  ///
  /// We are implementing version with 'PY_NO_SHORT_FLOAT_REPR'
  /// even though we actually have 'SHORT_FLOAT_REPR'.
  private func round(nDigit: Int) -> PyResult<PyObject> {
    assert(self.roundDigitCountMin <= nDigit && nDigit <= self.roundDigitCountMax)

    let scaledToDigits: Double, pow10: Double
    if nDigit >= 0 {
       // CPython has special case for overflow, we are too lazy for that
      pow10 = Foundation.pow(10.0, Double(nDigit))
      scaledToDigits = self.value * pow10

      // Because 'mul' can overflow
      guard scaledToDigits.isFinite else {
        return .value(self)
      }
    } else {
      pow10 = Foundation.pow(10.0, -Double(nDigit))
      scaledToDigits = self.value / pow10
    }

    let rounded = self.roundToEven(value: scaledToDigits)
    let rescaled = nDigit >= 0 ? rounded / pow10 : rounded * pow10

    // if computation resulted in overflow, raise OverflowError
    guard rescaled.isFinite else {
      return .overflowError("overflow occurred during round")
    }

    return .value(Py.newFloat(rescaled))
  }

  // MARK: - Trunc

  internal static let truncDoc = """
    __trunc__($self, /)
    --

    Return the Integral closest to x between 0 and x.
    """

  // sourcery: pymethod = __trunc__, doc = truncDoc
  public func trunc() -> PyResult<PyInt> {
    var intPart: Double = 0
    _ = Foundation.modf(self.value, &intPart)
    return Py.newInt(double: intPart)
  }

  // MARK: - Python new

  internal static let newDoc = """
    float(x=0, /)
    --

    Convert a string or number to a floating point number, if possible.
    """

  // sourcery: pystaticmethod = __new__, doc = newDoc
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyFloat> {
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

    if args.isEmpty {
      return .value(Self.allocate(type: type, value: 0.0))
    }

    let arg0 = args[0]
    switch Self.pyNew(fromString: arg0) {
    case .value(let d): return .value(Self.allocate(type: type, value: d))
    case .notString: break
    case .error(let e): return .error(e)
    }

    switch Self.pyNew(fromNumber: arg0) {
    case .value(let d): return .value(Self.allocate(type: type, value: d))
    case .notNumber: break
    case .error(let e): return .error(e)
    }

    let msg = "float() argument must be a string, or a number, not '\(arg0.typeName)'"
    return .typeError(msg)
  }

  private static func allocate(type: PyType, value: Double) -> PyFloat {
    // If this is a builtin then try to re-use interned values
    // (do we even have interned floats?)
    let isBuiltin = type === Py.types.float
    return isBuiltin ?
      Py.newFloat(value):
      PyFloatHeap(type: type, value: value)
  }

  private enum DoubleFromString {
    case value(Double)
    case notString
    case error(PyBaseException)
  }

  private static func pyNew(fromString object: PyObject) -> DoubleFromString {
    switch Py.getString(object: object) {
    case .string(_, let s),
         .bytes(_, let s):
      guard let value = Double(parseUsingPythonRules: s) else {
        let msg = "float() '\(s)' cannot be interpreted as float"
        return .error(Py.newValueError(msg: msg))
      }

      return .value(value)

    case .byteDecodingError(let bytes):
      let ptr = bytes.object.ptr
      let msg = "float() bytes at '\(ptr)' cannot be interpreted as str"
      return .error(Py.newValueError(msg: msg))

    case .notStringOrBytes:
      return .notString
    }
  }

  private enum DoubleFromNumber {
    case value(Double)
    case error(PyBaseException)
    case notNumber
  }

  /// PyObject *
  /// PyNumber_Float(PyObject *o)
  private static func pyNew(fromNumber object: PyObject) -> DoubleFromNumber {
    // Call has to be before 'Self.asDouble', because it can override
    switch Self.callFloat(object) {
    case .value(let o):
      guard let f = PyCast.asFloat(o) else {
        let ot = o.typeName
        let msg = "\(object.typeName).__float__ returned non-float (type \(ot))"
        return .error(Py.newTypeError(msg: msg))
      }
      return .value(f.value)
    case .missingMethod:
      break // try other possibilities
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    switch Self.asDouble(object: object) {
    case let .value(d):
      return .value(d)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notNumber
    }
  }

  private static func callFloat(_ object: PyObject) -> PyInstance.CallMethodResult {
    if let result = Fast.__float__(object) {
      switch result {
      case let .value(f): return .value(f)
      case let .error(e): return .error(e)
      }
    }

    return Py.callMethod(object: object, selector: .__float__)
  }

  // MARK: - As double

  internal enum AsDouble {
    case value(Double)
    case intOverflow(PyInt, PyBaseException)
    case notDouble
  }

  /// Try to extract `double` from `float` or `int`.
  ///
  /// CPython: `define CONVERT_TO_DOUBLE(obj, dbl)`
  internal static func asDouble(object: PyObject) -> AsDouble {
    if let pyFloat = PyCast.asFloat(object) {
      return .value(pyFloat.value)
    }

    if let int = PyCast.asInt(object) {
      switch Self.asDouble(int: int) {
      case let .value(d):
        return .value(d)
      case let .overflow(e):
        return .intOverflow(int, e)
      }
    }

    return .notDouble
  }

  internal enum IntAsDouble {
    case value(Double)
    case overflow(PyBaseException)
  }

  internal static func asDouble(int: PyInt) -> IntAsDouble {
    return Self.asDouble(int: int.value)
  }

  internal static func asDouble(int: BigInt) -> IntAsDouble {
    // This is not the best way…
    // But in general conversion 'Int -> Double' is a very complicated thing.
    // But it falls onto 'close enough' category.

    let result = Double(int)
    assert(!result.isNaN && !result.isSubnormal)

    guard result.isFinite else {
      let e = Py.newOverflowError(msg: "int too large to convert to float")
      return .overflow(e)
    }

    return .value(result)
  }
}
