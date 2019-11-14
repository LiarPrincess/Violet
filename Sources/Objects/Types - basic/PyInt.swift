import Foundation
import Core

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

// swiftlint:disable file_length

// sourcery: pytype = int
/// All integers are implemented as “long” integer objects of arbitrary size.
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
  internal let value: BigInt

  // MARK: - Init

  internal init(_ context: PyContext, value: BigInt) {
    self.value = value
    super.init(type: context.builtins.types.int)
  }

  /// Only for PyBool use!
  internal init(type: PyType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PyInt) -> Bool {
    return self.value == other.value
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value < other.value)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value <= other.value)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value > other.value)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value >= other.value)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .value(self.hashRaw())
  }

  internal func hashRaw() -> PyHash {
    return HashHelper.hash(self.value)
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
    return self.value != 0
  }

  // sourcery: pymethod = __int__
  internal func asInt() -> PyResult<PyInt> {
    return .value(self)
  }

  // sourcery: pymethod = __float__
  internal func asFloat() -> PyResult<PyFloat> {
    return .value(self.builtins.newFloat(Double(self.value)))
  }

  // sourcery: pymethod = __index__
  internal func asIndex() -> BigInt {
    return self.value
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Imaginary

  // sourcery: pymethod = real
  internal func asReal() -> PyObject {
    return self
  }

  // sourcery: pymethod = imag
  internal func asImag() -> PyObject {
    return self.builtins.newInt(0)
  }

  // sourcery: pymethod = conjugate
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
    return self.builtins.newInt(1)
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
    return self.builtins.newInt(-self.value)
  }

  // MARK: - Abs

  // sourcery: pymethod = __abs__
  internal func abs() -> PyObject {
    return self.builtins.newInt(Swift.abs(self.value))
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(self.value + other.value))
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(self.value - other.value))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(other.value - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(self.value * other.value))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mul(other)
  }

  // MARK: - Pow

  // sourcery: pymethod = __pow__
  internal func pow(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    let result = self.pow(left: self.value, right: other.value)
    return .value(self.asObject(result))
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    let result = self.pow(left: other.value, right: self.value)
    return .value(self.asObject(result))
  }

  private enum InnerPyResultOrNot {
    case int(BigInt)
    case fraction(Double)
  }

  private func pow(left: BigInt, right: BigInt) -> InnerPyResultOrNot {
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

  private func asObject(_ result: InnerPyResultOrNot) -> PyObject {
    switch result {
    case let .int(i): return self.builtins.newInt(i)
    case let .fraction(f): return self.builtins.newFloat(f)
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

  // sourcery: pymethod = __truediv__
  internal func trueDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.trueDiv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtrueDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.trueDiv(left: other.value, right: self.value)
  }

  private func trueDiv(left: BigInt, right: BigInt) -> PyResultOrNot<PyObject> {
    if right == 0 {
      return .zeroDivisionError("division by zero")
    }

    return .value(self.builtins.newFloat(Double(left) / Double(right)))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floorDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.floorDiv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloorDiv(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.floorDiv(left: other.value, right: self.value)
  }

  private func floorDiv(left: BigInt, right: BigInt) -> PyResultOrNot<PyObject> {
    if right == 0 {
      return .zeroDivisionError("division by zero")
    }

    let result = self.floorDivRaw(left: left, right: right)
    return .value(self.builtins.newInt(result))
  }

  private func floorDivRaw(left: BigInt, right: BigInt) -> BigInt {
    return left / right
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  internal func mod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.mod(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rmod__
  internal func rmod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.mod(left: other.value, right: self.value)
  }

  private func mod(left: BigInt, right: BigInt) -> PyResultOrNot<PyObject> {
    if right == 0 {
      return .zeroDivisionError("modulo by zero")
    }

    let result = self.modRaw(left: left, right: right)
    return .value(self.builtins.newInt(result))
  }

  private func modRaw(left: BigInt, right: BigInt) -> BigInt {
    return left % right
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  internal func divMod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.divMod(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivMod(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.divMod(left: other.value, right: self.value)
  }

  private func divMod(left: BigInt, right: BigInt) -> PyResultOrNot<PyObject> {
    if right == 0 {
      return .zeroDivisionError("divmod() by zero")
    }

    let div = self.floorDivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)

    let tuple0 = self.builtins.newInt(div)
    let tuple1 = self.builtins.newInt(mod)
    return .value(self.builtins.newTuple(tuple0, tuple1))
  }

  // MARK: - LShift

  // sourcery: pymethod = __lshift__
  internal func lShift(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.lShift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rlshift__
  internal func rlShift(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.lShift(left: other.value, right: self.value)
  }

  private func lShift(left: BigInt, right: BigInt) -> PyResultOrNot<PyObject> {
    if right < 0 {
      return .valueError("negative shift count")
    }

    return .value(self.builtins.newInt(left << right))
  }

  // MARK: - RShift

  // sourcery: pymethod = __rshift__
  internal func rShift(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.rShift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rrshift__
  internal func rrShift(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return self.rShift(left: other.value, right: self.value)
  }

  private func rShift(left: BigInt, right: BigInt) -> PyResultOrNot<PyObject> {
    if right < 0 {
      return .valueError("negative shift count")
    }

    return .value(self.builtins.newInt(left >> right))
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(self.value & other.value))
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(self.value | other.value))
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.builtins.newInt(self.value ^ other.value))
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.xor(other)
  }

  // MARK: - Invert

  // sourcery: pymethod = __invert__
  internal func invert() -> PyObject {
    return self.builtins.newInt(~self.value)
  }

  // MARK: - Round

  // sourcery: pymethod = __round__
  /// Round an integer m to the nearest 10**n (n positive)
  ///
  /// ```
  /// int.__round__(12345,  2) -> 12345
  /// int.__round__(12345, -2) -> 12300
  /// ```
  internal func round(nDigits: PyObject?) -> PyResultOrNot<PyObject> {
    let digitCount: BigInt? = {
      guard let n = nDigits else {
        return 0
      }

      if n is PyNone {
        return 0
      }

      if let int = n as? PyInt {
        return int.value
      }

      return nil
    }()

    // if digits >= 0 then no rounding is necessary; return self unchanged
    if let dc = digitCount, dc >= 0 {
      return .value(self)
    }

    // TODO: Implement int rounding to arbitrary precision
    return .notImplemented
  }
}
