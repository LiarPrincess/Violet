import Foundation
import BigInt
import VioletCore

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://developer.apple.com/documentation/swift/double/floating-point_operators_for_double

// swiftlint:disable file_length
// swiftlint:disable type_name
// swiftlint:disable nesting

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
/// code very unintuitive).
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
/// This subtype of PyObject represents a Python floating point object.
public class PyFloat: PyObject {

  internal static let doc: String = """
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

  /// Use only in `__new__`!
  internal init(type: PyType, value: Double) {
    self.value = value
    super.init(type: type)
  }
}

// MARK: - Compare abstract

/// Private helper for comparison operations.
private protocol FloatCompare {
  /// Opposite compare. For example for '<' it will be '>'.
  associatedtype reflected: FloatCompare

  static func compare(left: BigInt, right: BigInt) -> Bool
  static func compare(left: Double, right: Double) -> Bool
}

private enum FloatSign: BigInt, Equatable {
  case plus = 1
  case minus = -1
  case zero = 0
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

    let frexp = Frexp(value: left)
    let exponent = frexp.exponent

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
           value > 0.0 ? .plus :
           .minus
  }

  private static func getSign(_ value: BigInt) -> FloatSign {
    return value == 0 ? .zero :
           value > 0 ? .plus :
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
  public func isEqual(_ other: PyObject) -> CompareResult {
    return EqualCompare.compare(left: self.value, right: other)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
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
  public func isLess(_ other: PyObject) -> CompareResult {
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
  public func isLessEqual(_ other: PyObject) -> CompareResult {
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
  public func isGreater(_ other: PyObject) -> CompareResult {
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
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return GreaterEqualCompare.compare(left: self.value, right: other)
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
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(self.value + other))
  }

  // sourcery: pymethod = __radd__
  public func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  public func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(self.value - other))
  }

  // sourcery: pymethod = __rsub__
  public func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(other - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  public func mul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newFloat(self.value * other))
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
    guard self.isNilOrNone(mod) else {
      let msg = "pow() 3rd argument not allowed unless all arguments are integers"
      return .typeError(msg)
    }

    guard let exp = PyFloat.asDouble(exp) else {
      return .value(Py.notImplemented)
    }

    let base = self.value

    if let e = self.checkPowInvariants(base: base, exp: exp) {
      return .error(e)
    }

    let result = Foundation.pow(base, exp)
    return .value(Py.newFloat(result))
  }

  public func rpow(base: PyObject) -> PyResult<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  public func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard self.isNilOrNone(mod) else {
      return .typeError("pow() 3rd argument not allowed unless all arguments are integers")
    }

    guard let base = PyFloat.asDouble(base) else {
      return .value(Py.notImplemented)
    }

    let exp = self.value

    if let e = self.checkPowInvariants(base: base, exp: exp) {
      return .error(e)
    }

    let result = Foundation.pow(base, exp)
    return .value(Py.newFloat(result))
  }

  private func checkPowInvariants(base: Double, exp: Double) -> PyBaseException? {
    if base.isZero && exp < 0 {
      let msg = "0.0 cannot be raised to a negative power"
      return Py.newZeroDivisionError(msg: msg)
    }

    return nil
  }

  private func isNilOrNone(_ value: PyObject?) -> Bool {
    return value == nil || value is PyNone
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  public func truediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rtruediv__
  public func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
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
  public func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: self.value, right: other)
  }

  // sourcery: pymethod = __rfloordiv__
  public func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
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
  public func mod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rmod__
  public func rmod(_ other: PyObject) -> PyResult<PyObject> {
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
  public func divmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyFloat.asDouble(other) else {
      return .value(Py.notImplemented)
    }

    return self.divmod(left: self.value, right: other)
  }

  // sourcery: pymethod = __rdivmod__
  public func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
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

  /// See comment in `round(nDigits: PyObject?)`.
  private var roundDigitCountMax: Int {
    return Int(Double(DBL_MANT_DIG - DBL_MIN_EXP) * 0.301_03)
  }

  /// See comment in `round(nDigits: PyObject?)`.
  private var roundDigitCountMin: Int {
    return -Int(Double(DBL_MAX_EXP + 1) * 0.301_03)
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

      // Dark magic incomming (well above our $0 paygrade):
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

    if object.isNone {
      return .none
    }

    switch IndexHelper.int(object) {
    case let .value(i):
      return .int(i)
    case let .error(e):
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

    let scalledToDigits: Double, pow10: Double
    if nDigit >= 0 {
       // CPython has special case for overflow, we are too lazy for that
      pow10 = Foundation.pow(10.0, Double(nDigit))
      scalledToDigits = self.value * pow10

      // Because 'mul' can overflow
      guard scalledToDigits.isFinite else {
        return .value(self)
      }
    } else {
      pow10 = Foundation.pow(10.0, -Double(nDigit))
      scalledToDigits = self.value / pow10
    }

    let rounded = self.roundToEven(value: scalledToDigits)
    let rescalled = nDigit >= 0 ? rounded / pow10 : rounded * pow10

    // if computation resulted in overflow, raise OverflowError
    guard rescalled.isFinite else {
      return .overflowError("overflow occurred during round")
    }

    return .value(Py.newFloat(rescalled))
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
    let string: String
    switch Py.extractString(object: object) {
    case .string(_, let s),
         .bytes(_, let s):
      string = s
    case .byteDecodingError(let bytes):
      let msg = "float() bytes at '\(bytes.ptr)' cannot be interpreted as str"
      return .error(Py.newValueError(msg: msg))
    case .notStringOrBytes:
      return .notString
    }

    guard let value = Double(parseUsingPythonRules: string) else {
      let msg = "float() '\(string)' cannot be interpreted as float"
      return .error(Py.newValueError(msg: msg))
    }

    return .value(value)
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

    let t = object.typeName
    let msg = "float() argument must be a string, or a number, not '\(t)'"
    return .typeError(msg)
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
