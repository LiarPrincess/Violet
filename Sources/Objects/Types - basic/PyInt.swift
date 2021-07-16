import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore longobject divrem

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

internal let LONG_MAX = Int.max // 9223372036854775807
internal let LONG_MIN = Int.min // -9223372036854775808

// sourcery: pytype = int, default, baseType, longSubclass
/// All integers are implemented as “long” integer objects.
public class PyInt: PyObject {

  // sourcery: pytypedoc
  internal static let intDoc = """
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

  // This has to be `let` because we cache most used ints!
  public let value: BigInt

  override public var description: String {
    return "PyInt(\(self.value))"
  }

  // MARK: - Init

  internal init(value: BigInt) {
    self.value = value
    super.init(type: Py.types.int)
  }

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
    guard let other = PyCast.asInt(other) else {
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
    switch Self.asDouble(int: self.value) {
    case let .value(d):
      return .value(Py.newFloat(d))
    case let .overflow(e):
      return .error(e)
    }
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
    // We cannot just return 'self' because of 'bool':
    // if we call 'True.real' then the result should be '1' not 'True'.
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

  // sourcery: pymethod = __trunc__, doc = truncDoc
  public func trunc() -> PyResult<PyInt> {
    return .value(self)
  }

  // MARK: - Floor

  internal static let floorDoc = "Flooring an Integral returns itself."

  // sourcery: pymethod = __floor__, doc = floorDoc
  public func floor() -> PyObject {
    return self
  }

  // MARK: - Ceil

  internal static let ceilDoc = "Ceiling of an Integral returns itself."

  // sourcery: pymethod = __ceil__, doc = ceilDoc
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

  // sourcery: pymethod = bit_length, doc = bitLengthDoc
  public func bitLength() -> Int {
    return self.value.minRequiredWidth
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = self.value + other.value
    return .value(Py.newInt(result))
  }

  // sourcery: pymethod = __radd__
  public func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  public func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = self.value - other.value
    return .value(Py.newInt(result))
  }

  // sourcery: pymethod = __rsub__
  public func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = other.value - self.value
    return .value(Py.newInt(result))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  public func mul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = self.value * other.value
    return .value(Py.newInt(result))
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
    guard let exp = PyCast.asInt(exp) else {
      return .value(Py.notImplemented)
    }

    switch self.parsePowMod(mod: mod) {
    case .none: // No modulo, just pow
      let result = self.pow(base: self.value, exp: exp.value)
      return result.asObject()

    case .int(let moduloPy): // pow and then modulo
      let modulo = moduloPy.value

      if modulo.isZero {
        return .valueError("pow() 3rd argument cannot be 0")
      }

      switch self.pow(base: self.value, exp: exp.value) {
      case let .int(powInt):
        let divMod = self.divmodWithUncheckedZero(left: powInt, right: modulo)
        return .value(Py.newInt(divMod.mod))

      case let .fraction(powDouble):
        switch Self.asDouble(int: modulo) {
        case let .value(d):
          let result = powDouble.truncatingRemainder(dividingBy: d)
          return .value(Py.newFloat(result))
        case let .overflow(e):
          return .error(e)
        }

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
    guard let base = PyCast.asInt(base) else {
      return .value(Py.notImplemented)
    }

    switch self.parsePowMod(mod: mod) {
    case .none:
      let result = self.pow(base: base.value, exp: self.value)
      return result.asObject()
    case .int:
      // 3-arg power doesn't use __rpow__.
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

    if PyCast.isNone(mod) {
      return .none
    }

    if let int = PyCast.asInt(mod) {
      return .int(int)
    }

    return .notImplemented
  }

  private enum PowResult {
    case int(BigInt)
    case fraction(Double)
    case error(PyBaseException)

    fileprivate func asObject() -> PyResult<PyObject> {
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
    if base.isZero && exp.isNegative {
      let msg = "0.0 cannot be raised to a negative power"
      return .error(Py.newZeroDivisionError(msg: msg))
    }

    let result = self.powNonNegativeExp(base: base, exp: Swift.abs(exp))
    if exp > 0 {
      return .int(result)
    }

    // exp is negative: return 1 / result
    switch Self.asDouble(int: result) {
    case .value(let d):
      return .fraction(Double(1.0) / d)
    case .overflow:
      return .fraction(1.0) // fraction! not int!
    }
  }

  /// Specialized version of `pow` that assumes `exp >= 0`.
  ///
  /// This will always return some `BigInt`, never fraction or `ZeroDivisionError`.
  private func powNonNegativeExp(base: BigInt, exp: BigInt) -> BigInt {
    precondition(exp.isPositiveOrZero)
    return base.power(exponent: exp)
  }

  // MARK: - True div

  // sourcery: pymethod = __truediv__
  public func truediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rtruediv__
  public func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.truediv(left: other.value, right: self.value)
  }

  /// static PyObject *
  /// long_true_divide(PyObject *v, PyObject *w)
  private func truediv(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    // This is not the 'correct' implementation!
    // We are waaay to trigger-happy on overflow.
    // But it is 'close enough' for most of the cases.

    let l: Double
    switch Self.asDouble(int: left) {
    case let .value(d): l = d
    case let .overflow(e): return .error(e)
    }

    let r: Double
    switch Self.asDouble(int: right) {
    case let .value(d): r = d
    case let .overflow(e): return .error(e)
    }

    if r.isZero {
      return .zeroDivisionError("division by zero")
    }

    let result = l / r
    return .value(Py.newFloat(result))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  public func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rfloordiv__
  public func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.floordiv(left: other.value, right: self.value)
  }

  private func floordiv(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("division by zero")
    }

    let divMod = self.divmod(left: left, right: right)
    return divMod.map { Py.newInt($0.div) }
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  public func mod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rmod__
  public func rmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.mod(left: other.value, right: self.value)
  }

  private func mod(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right.isZero {
      return .zeroDivisionError("modulo by zero")
    }

    let divMod = self.divmod(left: left, right: right)
    return divMod.map { Py.newInt($0.mod) }
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  public func divmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = self.divmod(left: self.value, right: other.value)
    return result.map { $0.asTuple() }
  }

  // sourcery: pymethod = __rdivmod__
  public func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = self.divmod(left: other.value, right: self.value)
    return result.map { $0.asTuple() }
  }

  private struct Divmod {
    fileprivate var div: BigInt
    fileprivate var mod: BigInt

    fileprivate func asTuple() -> PyTuple {
      let q = Py.newInt(self.div)
      let r = Py.newInt(self.mod)
      return Py.newTuple(q, r)
    }
  }

  private func divmod(left: BigInt, right: BigInt) -> PyResult<Divmod> {
    if right.isZero {
      return .zeroDivisionError("divmod() by zero")
    }

    let result = self.divmodWithUncheckedZero(left: left, right: right)
    return .value(result)
  }

  /// `Div` and `mod` in a single (and hopefully fast) package.
  /// It will not check if `right` is `0`! Caller is responsible fot this.
  /// Also, note that this is `divmod` not `divrem` (see below for details).
  ///
  /// The expression `a mod b` has the value `a - b * floor(a / b)`.
  /// This is also expressed as `a - b * trunc(a / b)`,
  /// if `trunc` truncates towards zero.
  ///
  /// Some examples:
  /// ```
  ///  a           b      a rem b         a mod b
  ///  13          10      3               3
  /// -13          10     -3               7
  ///  13         -10      3              -7
  /// -13         -10     -3              -3
  /// ```
  /// So, to get from `rem` to `mod`, we have to add `b` if `a` and `b`
  /// have different signs.
  ///
  /// This is different than what Swift does
  /// (even the method is named `quotientAndRemainder` not `quotientAndModulo`).
  private func divmodWithUncheckedZero(left: BigInt, right: BigInt) -> Divmod {
    assert(
      !right.isZero,
      "div by 0 should be handled before calling 'BigInt.divmodRaw'"
    )

    var (quotient, remainder) = left.quotientAndRemainder(dividingBy: right)

    // See comment above this method.
    let differentSign = left.isNegative != right.isNegative
    if differentSign {
      remainder += right
      quotient -= 1
    }

    return Divmod(div: quotient, mod: remainder)
  }

  // MARK: - LShift

  // sourcery: pymethod = __lshift__
  /// static PyObject *
  /// long_lshift(PyObject *v, PyObject *w)
  public func lshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.lshift(value: self.value, count: other.value)
  }

  // sourcery: pymethod = __rlshift__
  /// static PyObject *
  /// long_rshift(PyLongObject *a, PyLongObject *b)
  public func rlshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.lshift(value: other.value, count: self.value)
  }

  private func lshift(value: BigInt,
                      count countBig: BigInt) -> PyResult<PyObject> {
    if countBig.isNegative {
      return .valueError("negative shift count")
    }

    if value.isZero {
      let result = Py.newInt(0)
      return .value(result)
    }

    guard let count = Int(exactly: countBig) else {
      return .overflowError("too many digits in integer")
    }

    let result = value << count
    return .value(Py.newInt(result))
  }

  // MARK: - RShift

  // sourcery: pymethod = __rshift__
  public func rshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.rshift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rrshift__
  public func rrshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    return self.rshift(left: other.value, right: self.value)
  }

  private func rshift(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right.isNegative {
      return .valueError("negative shift count")
    }

    let result = left >> right
    return .value(Py.newInt(result))
  }

  // MARK: - And

  public func and(_ other: PyObject) -> PyResult<PyObject> {
    return Self.and(int: self, other: other)
  }

  // sourcery: pymethod = __and__
  internal static func and(int zelf: PyInt,
                           other: PyObject) -> PyResult<PyObject> {
    // Why static? See comment at the top of 'PyBool'.
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = zelf.value & other.value
    return .value(Py.newInt(result))
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
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = zelf.value | other.value
    return .value(Py.newInt(result))
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
    guard let other = PyCast.asInt(other) else {
      return .value(Py.notImplemented)
    }

    let result = zelf.value ^ other.value
    return .value(Py.newInt(result))
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
    let result = ~self.value
    return Py.newInt(result)
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
    if nDigits.isPositiveOrZero {
      return .value(self)
    }

    // result = self - divmod_near(self, 10 ** -ndigits)[1]
    let pow10 = self.powNonNegativeExp(base: 10, exp: -nDigits)

    let divMod: Divmod
    switch self.divmodNear(left: self.value, right: pow10) {
    case let .value(d): divMod = d
    case let .error(e): return .error(e)
    }

    let result = self.value - divMod.mod
    return .value(Py.newInt(result))
  }

  private func parseRoundDigitCount(object: PyObject?) -> PyResult<BigInt> {
    guard let object = object else {
      return .value(0)
    }

    switch IndexHelper.bigInt(object) {
    case let .value(int):
      return .value(int)
    case let .error(e),
         let .notIndex(e):
      return .error(e)
    }
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

    let quotientIsNegative = a.isNegative != b.isNegative

    var result: Divmod
    switch self.divmod(left: a, right: b) {
    case let .value(d):
      result = d
    case let .error(e):
      return .error(e)
    }

    var twiceRem = result.mod << 2
    if quotientIsNegative {
      twiceRem = -twiceRem
    }

    // See Python code above
    let greaterThanHalf = b > 0 ? twiceRem > b : twiceRem < b
    let exactlyHalf = twiceRem == b
    let quotientIsOdd = result.div.isOdd

    if greaterThanHalf || (exactlyHalf && quotientIsOdd) {
      if quotientIsNegative {
        result.div -= 1
        result.mod += b
      } else {
        result.div += 1
        result.mod -= b
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
      return Self.pyIntNew(type: type, object: object, base: base)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyIntNew(type: PyType,
                               object: PyObject?,
                               base: PyObject?) -> PyResult<PyInt> {
    // If we do not have 1st argument -> 0
    guard let object = object else {
      if base != nil {
        return .typeError("int() missing string argument")
      }

      return .value(Self.allocate(type: type, value: 0))
    }

    // If we do not have base -> try to cast 'object' as 'int'
    guard let base = base else {
      let parsed = Self.parseBigInt(objectWithoutBase: object)
      return parsed.map { Self.allocate(type: type, value: $0) }
    }

    // Check if base is 'int'
    let baseInt: Int
    switch IndexHelper.int(base, onOverflow: .default) {
    case let .value(b):
      baseInt = b
    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }

    guard (baseInt == 0 || baseInt >= 2) && baseInt <= 36 else {
      return .valueError("int() base must be >= 2 and <= 36, or 0")
    }

    // Parse 'object' with a given 'base'
    switch Self.parseBigInt(string: object, base: baseInt) {
    case .value(let v): return .value(Self.allocate(type: type, value: v))
    case .notString: break
    case .error(let e): return .error(e)
    }

    return .typeError("int() can't convert non-string with explicit base")
  }

  private static func allocate(type: PyType, value: BigInt) -> PyInt {
    // If this is a builtin then try to re-use interned values
    let isBuiltin = type === Py.types.int
    return isBuiltin ?
      Py.newInt(value):
      PyIntHeap(type: type, value: value)
  }

  /// PyObject *
  /// PyNumber_Long(PyObject *o)
  private static func parseBigInt(
    objectWithoutBase object: PyObject
  ) -> PyResult<BigInt> {
    // '__int__' and '__trunc__' have to be before 'PyCast.asInt',
    // because they can be overridden

    switch Self.call__int__(object: object) {
    case .value(let int): return .value(int.value)
    case .missingMethod: break // try other
    case .error(let e): return .error(e)
    }

    switch Self.call__trunc__(object: object) {
    case .value(let int): return .value(int.value)
    case .missingMethod: break // try other
    case .error(let e): return .error(e)
    }

    if let int = PyCast.asInt(object) {
      return .value(int.value)
    }

    switch Self.parseBigInt(string: object, base: 10) {
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
      guard let int = PyCast.asInt(o) else {
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
      if let int = PyCast.asInt(o) {
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
    switch Py.getString(object: object) {
    case .string(_, let s),
         .bytes(_, let s):
      string = s
    case .byteDecodingError(let bytes):
      let ptr = bytes.object.ptr
      let msg = "int() bytes at '\(ptr)' cannot be interpreted as str"
      return .error(Py.newValueError(msg: msg))
    case .notStringOrBytes:
      return .notString
    }

    do {
      let result = try BigInt(parseUsingPythonRules: string, base: base)
      return .value(result)
    } catch {
      let msg = "int() '\(string)' cannot be interpreted as int: \(error)"
      return .error(Py.newValueError(msg: msg))
    }
  }

  // MARK: - Helpers

  internal static func asDouble(int: PyInt) -> PyFloat.IntAsDouble {
    return Self.asDouble(int: int.value)
  }

  internal static func asDouble(int: BigInt) -> PyFloat.IntAsDouble {
    return PyFloat.asDouble(int: int)
  }
}
