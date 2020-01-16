import Foundation
import Core

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

// swiftlint:disable file_length

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
  internal let value: BigInt

  // MARK: - Init

  internal convenience init(_ context: PyContext, value: Int) {
    self.init(context, value: BigInt(value))
  }

  internal init(_ context: PyContext, value: BigInt) {
    self.value = value
    super.init(type: context.builtins.types.int)
  }

  /// Use only in PyBool or `__new__`!
  internal init(type: PyType, value: BigInt) {
    self.value = value
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PyInt) -> Bool {
    return self.value == other.value
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value < other.value)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value <= other.value)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value > other.value)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyInt else {
      return .notImplemented
    }

    return .value(self.value >= other.value)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .value(self.hashRaw())
  }

  internal func hashRaw() -> PyHash {
    return Py.hasher.hash(self.value)
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
    return AttributeHelper.getAttribute(from: self, name: name)
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

  // MARK: - Trunc

  internal static let truncDoc = "Truncating an Integral returns itself."

  // sourcery: pymethod = __trunc__, , doc = truncDoc
  internal func trunc() -> PyObject {
    return self
  }

  // MARK: - Floor

  internal static let floorDoc = "Flooring an Integral returns itself."

  // sourcery: pymethod = __floor__, , doc = floorDoc
  internal func floor() -> PyObject {
    return self
  }

  // MARK: - Ceil

  internal static let ceilDoc = "Ceiling of an Integral returns itself."

  // sourcery: pymethod = __ceil__, , doc = ceilDoc
  internal func ceil() -> PyObject {
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
  internal func bitLength() -> PyObject {
    let result = self.value.bitWidth
    return self.builtins.newInt(result)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(self.value + other.value))
  }

  // sourcery: pymethod = __radd__
  internal func radd(_ other: PyObject) -> PyResult<PyObject> {
    return self.add(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(self.value - other.value))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(other.value - self.value))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(self.value * other.value))
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
    guard let exp = exp as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    switch self.parsePowMod(mod: mod) {
    case .none:
      let result = self.pow(base: self.value, exp: exp.value)
      return .value(result.asObject(in: self.context))

    case .int(let modPyInt):
      if modPyInt.value == 0 {
        return .valueError("pow() 3rd argument cannot be 0")
      }

      switch self.pow(base: self.value, exp: exp.value) {
      case let .int(powInt):
        let result = powInt % modPyInt.value
        return .value(self.builtins.newInt(result))
      case let .fraction(powDouble):
        let modDouble = Double(modPyInt.value)
        let result = powDouble.truncatingRemainder(dividingBy: modDouble)
        return .value(self.builtins.newFloat(result))
      }

    case .notImplemented:
      return .value(self.builtins.notImplemented)
    }
  }

  internal func rpow(base: PyObject) -> PyResult<PyObject> {
    return self.rpow(base: base, mod: nil)
  }

  // sourcery: pymethod = __rpow__
  internal func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> {
    guard let base = base as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    switch self.parsePowMod(mod: mod) {
    case .none:
      let result = self.pow(base: base.value, exp: self.value)
      return .value(result.asObject(in: self.context))
    case .int:
      // Three-arg power doesn't use __rpow__.
      return .value(self.builtins.notImplemented)
    case .notImplemented:
      return .value(self.builtins.notImplemented)
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

    fileprivate func asObject(in context: PyContext) -> PyObject {
      switch self {
      case let .int(i): return context.builtins.newInt(i)
      case let .fraction(f): return context.builtins.newFloat(f)
      }
    }
  }

  private func pow(base: BigInt, exp: BigInt) -> PowResult {
    if exp == 0 {
      return .int(1)
    }

    if exp == 1 {
      return .int(base)
    }

    let result = self.exponentiationBySquaring(1, base, Swift.abs(exp))

    return exp > 0 ?
      .int(result) :
      .fraction(Double(1.0) / Double(result))
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
  internal func truediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.truediv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rtruediv__
  internal func rtruediv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.truediv(left: other.value, right: self.value)
  }

  private func truediv(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right == 0 {
      return .zeroDivisionError("division by zero")
    }

    return .value(self.builtins.newFloat(Double(left) / Double(right)))
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal func floordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.floordiv(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rfloordiv__
  internal func rfloordiv(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.floordiv(left: other.value, right: self.value)
  }

  private func floordiv(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right == 0 {
      return .zeroDivisionError("division by zero")
    }

    let result = self.floordivRaw(left: left, right: right)
    return .value(self.builtins.newInt(result))
  }

  private func floordivRaw(left: BigInt, right: BigInt) -> BigInt {
    return left / right
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  internal func mod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.mod(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rmod__
  internal func rmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.mod(left: other.value, right: self.value)
  }

  private func mod(left: BigInt, right: BigInt) -> PyResult<PyObject> {
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
  internal func divmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.divmod(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rdivmod__
  internal func rdivmod(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.divmod(left: other.value, right: self.value)
  }

  private func divmod(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right == 0 {
      return .zeroDivisionError("divmod() by zero")
    }

    let div = self.floordivRaw(left: left, right: right)
    let mod = self.modRaw(left: left, right: right)

    let tuple0 = self.builtins.newInt(div)
    let tuple1 = self.builtins.newInt(mod)
    return .value(self.builtins.newTuple(tuple0, tuple1))
  }

  // MARK: - LShift

  // sourcery: pymethod = __lshift__
  internal func lshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.lshift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rlshift__
  internal func rlshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.lshift(left: other.value, right: self.value)
  }

  private func lshift(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right < 0 {
      return .valueError("negative shift count")
    }

    return .value(self.builtins.newInt(left << right))
  }

  // MARK: - RShift

  // sourcery: pymethod = __rshift__
  internal func rshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.rshift(left: self.value, right: other.value)
  }

  // sourcery: pymethod = __rrshift__
  internal func rrshift(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return self.rshift(left: other.value, right: self.value)
  }

  private func rshift(left: BigInt, right: BigInt) -> PyResult<PyObject> {
    if right < 0 {
      return .valueError("negative shift count")
    }

    return .value(self.builtins.newInt(left >> right))
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(self.value & other.value))
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(self.value | other.value))
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResult<PyObject> {
    guard let other = other as? PyInt else {
      return .value(self.builtins.notImplemented)
    }

    return .value(self.builtins.newInt(self.value ^ other.value))
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResult<PyObject> {
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
  internal func round(nDigits: PyObject?) -> PyResult<PyObject> {
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
    return .value(self.builtins.notImplemented)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["", "base"],
    format: "|OO:int"
  )

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    switch newArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 2, "Invalid argument count returned from parser.")
      let arg0 = bind.count >= 1 ? bind[0] : nil
      let arg1 = bind.count >= 2 ? bind[1] : nil
      return PyInt.pyNew(type: type, x: arg0, base: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyNew(type: PyType,
                            x: PyObject?,
                            base: PyObject?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.int
    let alloca = isBuiltin ? newInt(type:value:) : PyIntHeap.init(type:value:)

    guard let x = x else {
      if base != nil {
        return .typeError("int() missing string argument")
      }

      return .value(alloca(type, 0))
    }

    guard let base = base else {
      return PyInt.parseBigIntWithoutBase(x).map { alloca(type, $0) }
    }

    let baseInt: Int
    switch IndexHelper.int(base) {
    case let .value(b): baseInt = b
    case let .error(e): return .error(e)
    }

    guard (baseInt == 0 || baseInt > 2) && baseInt <= 36 else {
      return .valueError("int() base must be >= 2 and <= 36, or 0")
    }

    switch PyInt.parseBigIntFromString(x, radix: baseInt) {
    case .value(let v): return .value(alloca(type, v))
    case .notString: break
    case .error(let e): return .error(e)
    }

    return .typeError("int() can't convert non-string with explicit base")
  }

  /// Allocate new PyInt (it will use 'builtins' cache if possible).
  private static func newInt(type: PyType, value: BigInt) -> PyInt {
    return type.builtins.newInt(value)
  }

  /// PyObject *
  /// PyNumber_Long(PyObject *o)
  private static func parseBigIntWithoutBase(_ object: PyObject) -> PyResult<BigInt> {
    if let int = object as? PyInt {
      return .value(int.value)
    }

    switch PyInt.callTrunc(object) {
    case .value(let o):
      guard let int = o as? PyInt else {
        return .typeError("__trunc__ returned non-Integral (type \(o.typeName))")
      }
      return .value(int.value)
    case .missingMethod:
      break // try other possibilities
    case .error(let e):
      return .error(e)
    }

    switch PyInt.parseBigIntFromString(object, radix: 10) {
    case .value(let v): return .value(v)
    case .notString: break
    case .error(let e): return .error(e)
    }

    return .typeError("int() argument must be a string, " +
                      "a bytes-like object or a number, " +
                      "not '\(object.typeName)'")
  }

  private enum IntFromString {
    case value(BigInt)
    case notString
    case error(PyErrorEnum)
  }

  private static func parseBigIntFromString(_ object: PyObject,
                                            radix: Int) -> IntFromString {
    if let str = object as? PyString {
      if let value = BigInt(str.value, radix: radix) {
        return .value(value)
      }

      let msg = "int() '\(str.value)' cannot be interpreted as int"
      return .error(.valueError(msg))
    }

    if let bytes = object as? PyBytesType {
      guard let string = bytes.data.string else {
        let msg = "int() bytes '\(bytes.ptrString)' cannot be interpreted as str"
        return .error(.valueError(msg))
      }

      if let value = BigInt(string, radix: radix) {
        return .value(value)
      }

      let msg = "int() '\(string)' cannot be interpreted as int"
      return .error(.valueError(msg))
    }

    return .notString
  }

  private enum CallTruncResult {
    case value(PyObject)
    case error(PyErrorEnum)
    case missingMethod
  }

  private static func callTrunc(_ object: PyObject) -> CallTruncResult {
    if let owner = object as? __trunc__Owner {
      return .value(owner.trunc())
    }

    switch object.builtins.callMethod(on: object, selector: "__trunc__") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .missingMethod
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
