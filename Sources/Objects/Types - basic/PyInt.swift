import Foundation
import VioletCore

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

// swiftlint:disable file_length

internal let LONG_MAX = Int.max // 9223372036854775807
internal let LONG_MIN = Int.min // -9223372036854775808

// sourcery: pytype = int, default, baseType, longSubclass
/// All integers are implemented as “long” integer objects.
public class PyInt: PyObject {

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

  // This has to be `let` because we cache most used ints!
  public let value: BigInt

  override public var description: String {
    return "PyInt(\(self.value))"
  }

  // MARK: - Init

  internal convenience init(value: Int) {
    self.init(value: BigInt(value))
  }

  internal init(value: BigInt) {
    self.value = value
    super.init(type: Py.types.int)
  }

  /// Use only in PyBool or `__new__`!
  internal init(type: PyType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0 == $1 }
  }

  public func isEqual(_ other: PyInt) -> Bool {
    return self.value == other.value
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0 < $1 }
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0 <= $1 }
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0 > $1 }
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0 >= $1 }
  }

  private func compare(
    with other: PyObject,
    using compareFn: (BigInt, BigInt) -> Bool
  ) -> CompareResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    let result = compareFn(self.value, other.value)
    return .value(result)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    return .value(self.hashRaw())
  }

  internal func hashRaw() -> PyHash {
    return Py.hasher.hash(self.value)
  }

  // MARK: - String

  public func repr() -> PyResult<String> {
    return Self.repr(int: self)
  }

  // sourcery: pymethod = __repr__
  internal static func repr(int zelf: PyInt) -> PyResult<String> {
    // Why static? See comment at the top of 'PyBool'.
    return .value(String(describing: zelf.value))
  }

  public func str() -> PyResult<String> {
    return Self.str(int: self)
  }

  // sourcery: pymethod = __str__
  internal static func str(int zelf: PyInt) -> PyResult<String> {
    // Why static? See comment at the top of 'PyBool'.
    return .value(String(describing: zelf.value))
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  public func asBool() -> Bool {
    return self.value.isTrue
  }

  // sourcery: pymethod = __int__
  public func asInt() -> PyResult<PyInt> {
    return .value(self)
  }

  // sourcery: pymethod = __float__
  public func asFloat() -> PyResult<PyFloat> {
    return .value(Py.newFloat(Double(self.value)))
  }

  // sourcery: pymethod = __index__
  public func asIndex() -> BigInt {
    return self.value
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Imaginary

  // sourcery: pyproperty = real
  public func asReal() -> PyObject {
    // We cannot just return 'self'!
    // If we call 'True.real' then the result should be '1' not 'True'.
    return Py.newInt(self.value)
  }

  // sourcery: pyproperty = imag
  public func asImag() -> PyObject {
    return Py.newInt(0)
  }

  // sourcery: pymethod = conjugate
  /// int.conjugate
  /// Return self, the complex conjugate of any int.
  public func conjugate() -> PyObject {
    return self
  }

  // sourcery: pyproperty = numerator
  public func numerator() -> PyInt {
    return self
  }

  // sourcery: pyproperty = denominator
  public func denominator() -> PyInt {
    return Py.newInt(1)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Sign

  // sourcery: pymethod = __pos__
  public func positive() -> PyObject {
    return self
  }

  // sourcery: pymethod = __neg__
  public func negative() -> PyObject {
    return Py.newInt(-self.value)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  public func abs() -> PyObject {
    return Py.newInt(Swift.abs(self.value))
  }

  // MARK: - Trunc

  internal static let truncDoc = "Truncating an Integral returns itself."

  // sourcery: pymethod = __trunc__, , doc = truncDoc
  public func trunc() -> PyResult<PyInt> {
    return .value(self)
  }

  // MARK: - Floor

  internal static let floorDoc = "Flooring an Integral returns itself."

  // sourcery: pymethod = __floor__, , doc = floorDoc
  public func floor() -> PyObject {
    return self
  }

  // MARK: - Ceil

  internal static let ceilDoc = "Ceiling of an Integral returns itself."

  // sourcery: pymethod = __ceil__, , doc = ceilDoc
  public func ceil() -> PyObject {
    return self
  }

  // MARK: - Bit length

  internal static let bitLengthDoc = """
    bit_length($self, /)
    --

    Number of bits necessary to represent self in binary.

    >>> bin(37)
    \'0b100101\'
    >>> (37).bit_length()
    6
    """

  // sourcery: pymethod = bit_length, , doc = bitLengthDoc
  public func bitLength() -> PyObject {
    let result = self.value.minRequiredWidth
    return Py.newInt(result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(self.value + other.value))
  }

  // sourcery: pymethod = __radd__
  public func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  public func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(self.value - other.value))
  }

  // sourcery: pymethod = __rsub__
  public func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(other.value - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  public func mul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(self.value * other.value))
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
    guard let exp = exp as? PyInt else {
      return .value(Py.notImplemented)
    }

    switch self.parsePowMod(mod: mod) {
    case .none:
      let result = self.pow(base: self.value, exp: exp.value)
      return result.convertToObject()

    case .int(let modPyInt):
      if modPyInt.value == 0 {
        return .valueError("pow() 3rd argument cannot be 0")
      }

      switch self.pow(base: self.value, exp: exp.value) {
      case let .int(powInt):
        let result = powInt % modPyInt.value
        return .value(Py.newInt(result))
      case let .fraction(powDouble):
        let modDouble = Double(modPyInt.value)
        let result = powDouble.truncatingRemainder(dividingBy: modDouble)
        return .value(Py.newFloat(result))
      case let .error(e):
        return .error(e)
      }

    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  public func rpow(base: PyObject) -> PyResult<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  public func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard let base = base as? PyInt else {
      return .value(Py.notImplemented)
    }

    switch self.parsePowMod(mod: mod) {
    case .none:
      let result = self.pow(base: base.value, exp: self.value)
      return result.convertToObject()
    case .int:
      // Three-arg power doesn't use __rpow__.
      return .value(Py.notImplemented)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  private enum PowMod {
    case none
    case int(PyInt)
    case notImplemented
  }

  private func parsePowMod(mod: PyObject?) -> PowMod {
    guard let mod = mod else {
      return .none
    }

    if let int = mod as? PyInt {
      return .int(int)
    }

    if mod is PyNone {
      return .none
    }

    return .notImplemented
  }

  private enum PowResult {
    case int(BigInt)
    case fraction(Double)
    case error(PyBaseException)

    fileprivate func convertToObject() -> PyResult<PyObject> {
      switch self {
      case let .int(i):
        return .value(Py.newInt(i))
      case let .fraction(f):
        return .value(Py.newFloat(f))
      case let .error(e):
        return .error(e)
      }
    }
  }

  private func pow(base: BigInt, exp: BigInt) -> PowResult {
    if base == 0 && exp < 0 {
      let msg = "0.0 cannot be raised to a negative power"
      return .error(Py.newZeroDivisionError(msg: msg))
    }

    let result = self.powNonNegativeExp(base: base, exp: Swift.abs(exp))
    return exp > 0 ?
      .int(result) :
      .fraction(Double(1.0) / Double(result))
  }

  /// Specialized version of `pow` that assumes `exp >= 0`.
  ///
  /// This will always return some `BigInt`, never fraction or `ZeroDivisionError`.
  private func powNonNegativeExp(base: BigInt, exp: BigInt) -> BigInt {
    precondition(exp >= 0)

    // Order of the following checks matters!
    if exp == 0 {
      return 1
    }

    if exp == 1 {
      return base
    }

    // This has to be after 'exp == 0', because 'pow(0, 0) -> 1'
    if base == 0 {
      return 0
    }

    return self.exponentiationBySquaring(1, base, Swift.abs(exp))
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

  // sourcery: pymethod = __truediv__
  public func truediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rtruediv__
  public func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: other.value, right: self.value)
  }

  private func truediv(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right == 0 {
      return .zeroDivisionError("division by zero")
    }

    return .value(Py.newFloat(Double(left) / Double(right)))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  public func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rfloordiv__
  public func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: other.value, right: self.value)
  }

  private func floordiv(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right == 0 {
      return .zeroDivisionError("division by zero")
    }

    let result = self.floordivRaw(left: left, right: right)
    return .value(Py.newInt(result))
  }

  /// (Not so) fun fact: (-2).__floordiv__(3) == -1
  ///
  /// To be really honest: I have no idea how this works.
  /// But we have test for this, so it must be true.
  private func floordivRaw(left: BigInt, right: BigInt) -> BigInt {
    if self.sameSign(left: left, right: right) {
      return left / right
    }

    let leftAbs = Swift.abs(left)
    let rightAbs = Swift.abs(right)
    return -1 - (leftAbs - 1) / rightAbs
  }

  private func sameSign(left: BigInt, right: BigInt) -> Bool {
    let bothPositive = left >= 0 && right >= 0
    let bothNegative = left <= 0 && right <= 0
    return bothPositive || bothNegative
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  public func mod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rmod__
  public func rmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: other.value, right: self.value)
  }

  private func mod(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right == 0 {
      return .zeroDivisionError("modulo by zero")
    }

    let result = self.modRaw(left: left, right: right)
    return .value(Py.newInt(result))
  }

  /// -2 % 3 == 1
  private func modRaw(left: BigInt, right: BigInt) -> BigInt {
    if self.sameSign(left: left, right: right) {
      return left % right
    }

    // x = (x // y) * y + (x % y)
    // which gives us:
    // (x % y) = x - (x // y) * y

    let leftAbs = Swift.abs(left)
    let rightAbs = Swift.abs(right)
    let partial = rightAbs - 1 - (leftAbs - 1) % rightAbs

    let sign = BigInt(right < 0 ? -1 : 1)
    return sign * partial
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  public func divmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    let result = self.divmod(left: self.value, right: other.value)
    return result.map { $0.asObject() }
  }

  // sourcery: pymethod = __rdivmod__
  public func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    let result = self.divmod(left: other.value, right: self.value)
    return result.map { $0.asObject() }
  }

  private struct Divmod {
    fileprivate var quotient: BigInt
    fileprivate var remainder: BigInt

    fileprivate func asObject() -> PyTuple {
      let q = Py.newInt(self.quotient)
      let r = Py.newInt(self.remainder)
      return Py.newTuple(q, r)
    }
  }

  private func divmod(left: BigInt, right: BigInt) -> PyResult<Divmod> {
    if right == 0 {
      return .zeroDivisionError("divmod() by zero")
    }

    // Let's pray to inlining god for performance...
    let quotient = self.floordivRaw(left: left, right: right)
    let remainder = self.modRaw(left: left, right: right)
    return .value(Divmod(quotient: quotient, remainder: remainder))
  }

  // MARK: - LShift

  // sourcery: pymethod = __lshift__
  public func lshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.lshift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rlshift__
  public func rlshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.lshift(left: other.value, right: self.value)
  }

  private func lshift(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right < 0 {
      return .valueError("negative shift count")
    }

    return .value(Py.newInt(left << right))
  }

  // MARK: - RShift

  // sourcery: pymethod = __rshift__
  public func rshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.rshift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rrshift__
  public func rrshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return self.rshift(left: other.value, right: self.value)
  }

  private func rshift(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right < 0 {
      return .valueError("negative shift count")
    }

    return .value(Py.newInt(left >> right))
  }

  // MARK: - And

  public func and(_ other: PyObject) -> PyResult<PyObject> {
    return Self.and(int: self, other: other)
  }

  // sourcery: pymethod = __and__
  internal static func and(int zelf: PyInt,
                           other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of 'PyBool'.
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(zelf.value & other.value))
  }

  public func rand(_ other: PyObject) -> PyResult<PyObject> {
    return Self.rand(int: self, other: other)
  }

  // sourcery: pymethod = __rand__
  internal static func rand(int zelf: PyInt,
                            other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of 'PyBool'.
    return Self.and(int: zelf, other: other)
  }

  // MARK: - Or

  public func or(_ other: PyObject) -> PyResult<PyObject> {
    return Self.or(int: self, other: other)
  }

  // sourcery: pymethod = __or__
  internal static func or(int zelf: PyInt,
                          other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of 'PyBool'.
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(zelf.value | other.value))
  }

  public func ror(_ other: PyObject) -> PyResult<PyObject> {
    return Self.ror(int: self, other: other)
  }

  // sourcery: pymethod = __ror__
  internal static func ror(int zelf: PyInt,
                           other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of 'PyBool'.
    return Self.or(int: zelf, other: other)
  }

  // MARK: - Xor

  public func xor(_ other: PyObject) -> PyResult<PyObject> {
    return Self.xor(int: self, other: other)
  }

  // sourcery: pymethod = __xor__
  internal static func xor(int zelf: PyInt,
                           other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(Py.notImplemented)
    }

    return .value(Py.newInt(zelf.value ^ other.value))
  }

  public func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return Self.rxor(int: self, other: other)
  }

  // sourcery: pymethod = __rxor__
  internal static func rxor(int zelf: PyInt,
                            other: PyObject) -> PyResult<PyObject> {
    return Self.xor(int: zelf, other: other)
  }

  // MARK: - Invert

  // sourcery: pymethod = __invert__
  public func invert() -> PyObject {
    return Py.newInt(~self.value)
  }

  // MARK: - Round

  // sourcery: pymethod = __round__
  /// Round an integer `m` to the nearest `10**n (n positive)`.
  ///
  /// ```
  /// int.__round__(12345,  2) -> 12345
  /// int.__round__(12345, -2) -> 12300
  /// ```
  ///
  /// static PyObject *
  /// long_round(PyObject *self, PyObject *args)
  public func round(nDigits _nDigits: PyObject?) -> PyResult<PyObject> {
    let nDigits: BigInt
    switch self.parseRoundDigitCount(object: _nDigits) {
    case let .value(n): nDigits = n
    case let .error(e): return .error(e)
    }

    // if digits >= 0 then no rounding is necessary; return self unchanged
    if nDigits >= 0 {
      return .value(self)
    }

    // result = self - divmod_near(self, 10 ** -ndigits)[1]
    let pow10 = self.powNonNegativeExp(base: 10, exp: -nDigits)

    let divMod: Divmod
    switch self.divmodNear(left: self.value, right: pow10) {
    case let .value(d): divMod = d
    case let .error(e): return .error(e)
    }

    let result = self.value - divMod.remainder
    return .value(Py.newInt(result))
  }

  private func parseRoundDigitCount(object: PyObject?) -> PyResult<BigInt> {
    guard let object = object else {
      return .value(0)
    }

    if object.isNone {
      return .value(0)
    }

    return IndexHelper.bigInt(object)
  }

  /// Return a pair `(q, r)` such that `a = b * q + r`, and
  /// `abs(r) <= abs(b)/2`, with equality possible only if `q` is even.
  /// In other words, `q == a / b`, rounded to the nearest integer using
  /// round-half-to-even.
  ///
  /// PyObject *
  /// _PyLong_DivmodNear(PyObject *a, PyObject *b)
  private func divmodNear(left a: BigInt, right b: BigInt) -> PyResult<Divmod> {
    // Equivalent Python code:
    //
    // def divmod_near(a, b):
    //     q, r = divmod(a, b)
    //     # round up if either r / b > 0.5, or r / b == 0.5 and q is odd.
    //     # The expression r / b > 0.5 is equivalent to 2 * r > b if b is
    //     # positive, 2 * r < b if b negative.
    //
    //     greater_than_half = 2*r > b if b > 0 else 2*r < b
    //     exactly_half = 2*r == b
    //     if greater_than_half or exactly_half and q % 2 == 1:
    //         q += 1
    //         r -= b
    //     return q, r

    let quotientIsNegative = (a < 0) != (b < 0)

    var result: Divmod
    switch self.divmod(left: a, right: b) {
    case let .value(d):
      result = d
    case let .error(e):
      return .error(e)
    }

    var twiceRem = result.remainder << 2
    if quotientIsNegative {
      twiceRem = -twiceRem
    }

    // See Python code above
    let greaterThanHalf = b > 0 ? twiceRem > b : twiceRem < b
    let exactlyHalf = twiceRem == b
    let quotientIsOdd = (result.quotient & 1) == 1

    if greaterThanHalf || (exactlyHalf && quotientIsOdd) {
      if quotientIsNegative {
        result.quotient -= 1
        result.remainder += b
      } else {
        result.quotient += 1
        result.remainder -= b
      }
    }

    return .value(result)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["", "base"],
    format: "|OO:int"
  )

  // sourcery: pystaticmethod = __new__
  internal static func pyIntNew(type: PyType,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyInt> {
    switch self.newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let base = binding.optional(at: 1)
      return PyInt.pyIntNew(type: type, object: object, base: base)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyIntNew(type: PyType,
                               object: PyObject?,
                               base: PyObject?) -> PyResult<PyInt> {
    let isBuiltin = type === Py.types.int
    let alloca = isBuiltin ? self.newInt(type:value:) : PyIntHeap.init(type:value:)

    // If we do not have 1st argument -> 0
    guard let object = object else {
      if base != nil {
        return .typeError("int() missing string argument")
      }

      return .value(alloca(type, 0))
    }

    // If we do not have base -> try to cast 'object' as 'int'
    guard let base = base else {
      return PyInt.parseBigInt(objectWithoutBase: object).map { alloca(type, $0) }
    }

    // Check if base is 'int'
    let baseInt: Int
    switch IndexHelper.int(base) {
    case let .value(b): baseInt = b
    case let .error(e): return .error(e)
    }

    guard (baseInt == 0 || baseInt >= 2) && baseInt <= 36 else {
      return .valueError("int() base must be >= 2 and <= 36, or 0")
    }

    // Parse 'object' with a given 'base'
    switch PyInt.parseBigInt(string: object, base: baseInt) {
    case .value(let v): return .value(alloca(type, v))
    case .notString: break
    case .error(let e): return .error(e)
    }

    return .typeError("int() can't convert non-string with explicit base")
  }

  /// Allocate new PyInt (it will use 'builtins' cache if possible).
  private static func newInt(type: PyType, value: BigInt) -> PyInt {
    return Py.newInt(value)
  }

  /// PyObject *
  /// PyNumber_Long(PyObject *o)
  private static func parseBigInt(
    objectWithoutBase object: PyObject
  ) -> PyResult<BigInt> {
    // '__int__' and '__trunc__' have to be before 'PyInt' cast,
    // because they can be overriden

    switch PyInt.call__int__(object: object) {
    case .value(let int): return .value(int.value)
    case .missingMethod: break // try other
    case .error(let e): return .error(e)
    }

    switch PyInt.call__trunc__(object: object) {
    case .value(let int): return .value(int.value)
    case .missingMethod: break // try other
    case .error(let e): return .error(e)
    }

    if let int = object as? PyInt {
      return .value(int.value)
    }

    switch PyInt.parseBigInt(string: object, base: 10) {
    case .value(let v): return .value(v)
    case .notString: break
    case .error(let e): return .error(e)
    }

    let msg = "int() argument must be a string, a bytes-like object " +
              "or a number, not '\(object.typeName)'"
    return .typeError(msg)
  }

  private enum NumberConverterResult {
    case value(PyInt)
    case missingMethod
    case error(PyBaseException)
  }

  private static func call__int__(object: PyObject) -> NumberConverterResult {
    if let result = Fast.__int__(object) {
      switch result {
      case let .value(int): return .value(int)
      case let .error(e): return .error(e)
      }
    }

    switch Py.callMethod(object: object, selector: .__int__) {
    case .value(let o):
      guard let int = o as? PyInt else {
        let msg = "__int__ returned non-int (type \(o.typeName)"
        return .error(Py.newTypeError(msg: msg))
      }

      return .value(int)

    case .missingMethod:
      return .missingMethod
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func call__trunc__(object: PyObject) -> NumberConverterResult {
    if let result = Fast.__trunc__(object) {
      switch result {
      case let .value(int): return .value(int)
      case let .error(e): return .error(e)
      }
    }

    switch Py.callMethod(object: object, selector: .__trunc__) {
    case .value(let o):
      if let int = o as? PyInt {
        return .value(int)
      }

      let msg = "__trunc__ returned non-Integral (type \(o.typeName))"
      return .error(Py.newTypeError(msg: msg))

    case .missingMethod:
      return .missingMethod
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private enum IntFromString {
    case value(BigInt)
    case notString
    case error(PyBaseException)
  }

  private static func parseBigInt(string object: PyObject,
                                  base: Int) -> IntFromString {
    let string: String
    switch Py.extractString(object: object) {
    case .string(_, let s),
         .bytes(_, let s):
      string = s
    case .byteDecodingError(let bytes):
      let msg = "int() bytes at '\(bytes.ptr)' cannot be interpreted as str"
      return .error(Py.newValueError(msg: msg))
    case .notStringOrBytes:
      return .notString
    }

    guard let value = BigInt(parseUsingPythonRules: string, radix: base) else {
      let msg = "int() '\(string)' cannot be interpreted as int"
      return .error(Py.newValueError(msg: msg))
    }

    return .value(value)
  }
}
