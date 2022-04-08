import Foundation
import BigInt
import VioletCore

// swiftlint:disable static_operator
// swiftlint:disable file_length
// cSpell:ignore longobject divrem

// In CPython:
// Objects -> longobject.c
// https://docs.python.org/3.7/c-api/long.html

internal let LONG_MAX = Int.max // 9223372036854775807
internal let LONG_MIN = Int.min // -9223372036854775808

// Ints are very common, so we will define those:
internal func == (lhs: PyInt, rhs: PyInt) -> Bool { lhs.value == rhs.value }
internal func == (lhs: PyInt, rhs: BigInt) -> Bool { lhs.value == rhs }
internal func == (lhs: BigInt, rhs: PyInt) -> Bool { lhs == rhs.value }
internal func != (lhs: PyInt, rhs: PyInt) -> Bool { lhs.value != rhs.value }
internal func != (lhs: PyInt, rhs: BigInt) -> Bool { lhs.value != rhs }
internal func != (lhs: BigInt, rhs: PyInt) -> Bool { lhs != rhs.value }
internal func < (lhs: PyInt, rhs: PyInt) -> Bool { lhs.value < rhs.value }
internal func < (lhs: PyInt, rhs: BigInt) -> Bool { lhs.value < rhs }
internal func < (lhs: BigInt, rhs: PyInt) -> Bool { lhs < rhs.value }
internal func <= (lhs: PyInt, rhs: PyInt) -> Bool { lhs.value <= rhs.value }
internal func <= (lhs: PyInt, rhs: BigInt) -> Bool { lhs.value <= rhs }
internal func <= (lhs: BigInt, rhs: PyInt) -> Bool { lhs <= rhs.value }
internal func > (lhs: PyInt, rhs: PyInt) -> Bool { lhs.value > rhs.value }
internal func > (lhs: PyInt, rhs: BigInt) -> Bool { lhs.value > rhs }
internal func > (lhs: BigInt, rhs: PyInt) -> Bool { lhs > rhs.value }
internal func >= (lhs: PyInt, rhs: PyInt) -> Bool { lhs.value >= rhs.value }
internal func >= (lhs: PyInt, rhs: BigInt) -> Bool { lhs.value >= rhs }
internal func >= (lhs: BigInt, rhs: PyInt) -> Bool { lhs >= rhs.value }

// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyInt: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
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

  // sourcery: storedProperty
  // Do not add 'set' to 'self.value' - we cache most used ints!
  public var value: BigInt { self.valuePtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, value: BigInt) {
    self.initializeBase(py, type: type)
    self.valuePtr.initialize(to: value)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyInt(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "value", value: zelf.value, includeInDescription: true)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, other: other, op: .__eq__) { $0 == $1 }
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, other: other, op: .__ne__) { $0 != $1 }
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, other: other, op: .__lt__) { $0 < $1 }
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, other: other, op: .__le__) { $0 <= $1 }
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, other: other, op: .__gt__) { $0 > $1 }
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compareOperation(py, zelf: zelf, other: other, op: .__ge__) { $0 >= $1 }
  }

  private static func compareOperation(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject,
                                       op: CompareResult.Operation,
                                       fn: (PyInt, PyInt) -> Bool) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, op)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    let result = fn(zelf, other)
    return .value(result)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    let result = zelf.hash(py)
    return .value(result)
  }

  internal func hash(_ py: Py) -> PyHash {
    return py.hasher.hash(self.value)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.toString(py, zelf: zelf, fnName: "__repr__")
  }

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.toString(py, zelf: zelf, fnName: "__str__")
  }

  private static let stringInternRange: ClosedRange<BigInt> = -10...256

  private static func toString(_ py: Py,
                               zelf _zelf: PyObject,
                               fnName: String) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let value = zelf.value
    let string = String(describing: value)

    let pyString = Self.stringInternRange.contains(value) ?
      py.intern(string: string) :
      py.newString(string)

    return PyResult(pyString)
  }

  // MARK: - As bool/int/float/index

  // sourcery: pymethod = __bool__
  internal static func __bool__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__bool__")
    }

    let result = zelf.value.isTrue
    return PyResult(py, result)
  }

  // sourcery: pymethod = __int__
  internal static func __int__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "__int__")
  }

  // sourcery: pymethod = __float__
  internal static func __float__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__float__")
    }

    switch Self.asDouble(py, int: zelf.value) {
    case let .value(d):
      return PyResult(py, d)
    case let .overflow(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __index__
  internal static func __index__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "__index__")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Imaginary

  // sourcery: pyproperty = real
  internal static func real(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "real")
  }

  // sourcery: pyproperty = imag
  internal static func imag(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.intOperation(py, zelf: zelf, fnName: "imag") { _ in 0 }
  }

  // sourcery: pymethod = conjugate
  /// int.conjugate
  /// Return self, the complex conjugate of any int.
  internal static func conjugate(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "conjugate")
  }

  // MARK: - Numerator, denominator

  // sourcery: pyproperty = numerator
  internal static func numerator(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "numerator")
  }

  // sourcery: pyproperty = denominator
  internal static func denominator(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.intOperation(py, zelf: zelf, fnName: "denominator") { _ in 1 }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Pos, neg, invert, abs

  // sourcery: pymethod = __pos__
  internal static func __pos__(_ py: Py, zelf: PyObject) -> PyResult {
    // 'int' is immutable, so if we are exactly 'int' (not an subclass),
    // then we can return ourself. (This saves an allocation).
    if let int = py.cast.asExactlyInt(zelf) {
      return .value(int.asObject)
    }

    return Self.unaryOperation(py, zelf: zelf, fnName: "__pos__") { $0 }
  }

  // sourcery: pymethod = __neg__
  internal static func __neg__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.unaryOperation(py, zelf: zelf, fnName: "__neg__") { -$0 }
  }

  // sourcery: pymethod = __invert__
  internal static func __invert__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.unaryOperation(py, zelf: zelf, fnName: "__invert__") { ~$0 }
  }

  // sourcery: pymethod = __abs__
  internal static func __abs__(_ py: Py, zelf: PyObject) -> PyResult {
    // 'int' is immutable, so if we are exactly 'int' (not a subclass) and '>=0',
    // then we can return ourself. (This saves an allocation).
    if let int = py.cast.asExactlyInt(zelf), int.value >= 0 {
      return .value(int.asObject)
    }

    return Self.unaryOperation(py, zelf: zelf, fnName: "__abs__") { Swift.abs($0) }
  }

  // MARK: - Trunc, floor, ceil

  internal static let truncDoc = "Truncating an Integral returns itself."

  // sourcery: pymethod = __trunc__, doc = truncDoc
  internal static func __trunc__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "__trunc__")
  }

  internal static let floorDoc = "Flooring an Integral returns itself."

  // sourcery: pymethod = __floor__, doc = floorDoc
  internal static func __floor__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "__floor__")
  }

  internal static let ceilDoc = "Ceiling of an Integral returns itself."

  // sourcery: pymethod = __ceil__, doc = ceilDoc
  internal static func __ceil__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "__ceil__")
  }

  // MARK: - Add, sub, mul

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__add__") { $0 + $1 }
  }

  // sourcery: pymethod = __radd__
  internal static func __radd__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__radd__") { $1 + $0 }
  }

  // sourcery: pymethod = __sub__
  internal static func __sub__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__sub__") { $0 - $1 }
  }

  // sourcery: pymethod = __rsub__
  internal static func __rsub__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    // Important: OTHER - ZELF (not zelf - other)
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__rsub__") { $1 - $0 }
  }

  // sourcery: pymethod = __mul__
  internal static func __mul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__mul__") { $0 * $1 }
  }

  // sourcery: pymethod = __rmul__
  internal static func __rmul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__rmul__") { $1 * $0 }
  }

  // MARK: - bit_length

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
  internal static func bit_length(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.intOperation(py, zelf: zelf, fnName: "bit_length") { $0.minRequiredWidth }
  }

  // MARK: - Pow

  // sourcery: pymethod = __pow__
  internal static func __pow__(_ py: Py,
                               zelf _zelf: PyObject,
                               exp: PyObject,
                               mod: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__pow__")
    }

    guard let exp = Self.downcast(py, exp) else {
      return .notImplemented(py)
    }

    if exp < 0 && !py.cast.isNilOrNone(mod) {
      let message = "pow() 2nd argument cannot be negative when 3rd argument specified"
      return .valueError(py, message: message)
    }

    switch zelf.parsePowMod(py, mod: mod) {
    case .none: // No modulo, just pow
      let result = zelf.pow(py, base: zelf.value, exp: exp.value)
      return result.toResult(py)

    case .int(let moduloPy): // pow and then modulo
      let modulo = moduloPy.value

      if modulo.isZero {
        return .valueError(py, message: "pow() 3rd argument cannot be 0")
      }

      switch zelf.pow(py, base: zelf.value, exp: exp.value) {
      case let .int(powInt):
        let divMod = Self.divmodWithUncheckedZero(left: powInt, right: modulo)
        return PyResult(py, divMod.mod)

      case let .fraction(powDouble):
        switch Self.asDouble(py, int: modulo) {
        case let .value(d):
          let result = powDouble.truncatingRemainder(dividingBy: d)
          return PyResult(py, result)
        case let .overflow(e):
          return .error(e)
        }

      case let .error(e):
        return .error(e)
      }

    case .notImplemented:
      return .notImplemented(py)
    }
  }

  // sourcery: pymethod = __rpow__
  internal static func __rpow__(_ py: Py,
                                zelf _zelf: PyObject,
                                base: PyObject,
                                mod: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__rpow__")
    }

    guard let base = Self.downcast(py, base) else {
      return .notImplemented(py)
    }

    switch zelf.parsePowMod(py, mod: mod) {
    case .none:
      let result = zelf.pow(py, base: base.value, exp: zelf.value)
      return result.toResult(py)
    case .int:
      // 3-arg power doesn't use __rpow__.
      return .notImplemented(py)
    case .notImplemented:
      return .notImplemented(py)
    }
  }

  private enum PowMod {
    case none
    case int(PyInt)
    case notImplemented
  }

  private func parsePowMod(_ py: Py, mod: PyObject?) -> PowMod {
    guard let mod = mod else {
      return .none
    }

    if py.cast.isNone(mod) {
      return .none
    }

    if let int = Self.downcast(py, mod) {
      return .int(int)
    }

    return .notImplemented
  }

  private enum PowResult {
    case int(BigInt)
    case fraction(Double)
    case error(PyBaseException)

    fileprivate func toResult(_ py: Py) -> PyResult {
      switch self {
      case let .int(i):
        return PyResult(py, i)
      case let .fraction(f):
        return PyResult(py, f)
      case let .error(e):
        return .error(e)
      }
    }
  }

  private func pow(_ py: Py, base: BigInt, exp: BigInt) -> PowResult {
    if base.isZero && exp.isNegative {
      let message = "0.0 cannot be raised to a negative power"
      let error = py.newZeroDivisionError(message: message)
      return .error(error.asBaseException)
    }

    let result = self.powNonNegativeExp(base: base, exp: Swift.abs(exp))
    if exp >= 0 {
      return .int(result)
    }

    // exp is negative: return 1 / result
    switch Self.asDouble(py, int: result) {
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
  internal static func __truediv__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.truedivOperation(py,
                                 zelf: zelf,
                                 other: other,
                                 fnName: "__truediv__",
                                 isZelfLeft: true)
  }

  // sourcery: pymethod = __rtruediv__
  internal static func __rtruediv__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.truedivOperation(py,
                                 zelf: zelf,
                                 other: other,
                                 fnName: "__rtruediv__",
                                 isZelfLeft: false)
  }

  /// static PyObject *
  /// long_true_divide(PyObject *v, PyObject *w)
  private static func truedivOperation(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject,
                                       fnName: String,
                                       isZelfLeft: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    // This is not the 'correct' implementation!
    // We are waaay too trigger-happy on overflow.
    // But it is 'close enough' for most of the cases.

    let zelfDouble: Double
    switch Self.asDouble(py, int: zelf) {
    case let .value(d): zelfDouble = d
    case let .overflow(e): return .error(e)
    }

    let otherDouble: Double
    switch Self.asDouble(py, int: other) {
    case let .value(d): otherDouble = d
    case let .overflow(e): return .error(e)
    }

    let left = isZelfLeft ? zelfDouble : otherDouble
    let right = isZelfLeft ? otherDouble : zelfDouble

    if right.isZero {
      return .zeroDivisionError(py, message: "division by zero")
    }

    let result = left / right
    return PyResult(py, result)
  }

  // MARK: - Floor div

  // sourcery: pymethod = __floordiv__
  internal static func __floordiv__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.floordivOperation(py,
                                  zelf: zelf,
                                  other: other,
                                  fnName: "__floordiv__",
                                  isZelfLeft: true)
  }

  // sourcery: pymethod = __rfloordiv__
  internal static func __rfloordiv__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.floordivOperation(py,
                                  zelf: zelf,
                                  other: other,
                                  fnName: "__rfloordiv__",
                                  isZelfLeft: false)
  }

  private static func floordivOperation(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject,
                                        fnName: String,
                                        isZelfLeft: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let left = isZelfLeft ? zelf.value : other.value
    let right = isZelfLeft ? other.value : zelf.value

    if right.isZero {
      return .zeroDivisionError(py, message: "division by zero")
    }

    let divMod = Self.divmodWithUncheckedZero(left: left, right: right)
    return PyResult(py, divMod.div)
  }

  // MARK: - Mod

  // sourcery: pymethod = __mod__
  internal static func __mod__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.modOperation(py,
                             zelf: zelf,
                             other: other,
                             fnName: "__mod__",
                             isZelfLeft: true)
  }

  // sourcery: pymethod = __rmod__
  internal static func __rmod__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.modOperation(py,
                             zelf: zelf,
                             other: other,
                             fnName: "__rmod__",
                             isZelfLeft: false)
  }

  private static func modOperation(_ py: Py,
                                   zelf _zelf: PyObject,
                                   other: PyObject,
                                   fnName: String,
                                   isZelfLeft: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let left = isZelfLeft ? zelf.value : other.value
    let right = isZelfLeft ? other.value : zelf.value

    if right.isZero {
      return .zeroDivisionError(py, message: "modulo by zero")
    }

    let divMod = Self.divmodWithUncheckedZero(left: left, right: right)
    return PyResult(py, divMod.mod)
  }

  // MARK: - Div mod

  // sourcery: pymethod = __divmod__
  internal static func __divmod__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.divModOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__divmod__",
                                isZelfLeft: true)
  }

  // sourcery: pymethod = __rdivmod__
  internal static func __rdivmod__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.divModOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rdivmod__",
                                isZelfLeft: false)
  }

  private static func divModOperation(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject,
                                      fnName: String,
                                      isZelfLeft: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let left = isZelfLeft ? zelf.value : other.value
    let right = isZelfLeft ? other.value : zelf.value

    if right.isZero {
      return .zeroDivisionError(py, message: "divmod() by zero")
    }

    let divModResult = Self.divMod(py, left: left, right: right)
    switch divModResult {
    case let .value(divMod):
      let d = py.newInt(divMod.div)
      let m = py.newInt(divMod.mod)
      return PyResult(py, tuple: d.asObject, m.asObject)
    case let .error(e):
      return .error(e)
    }
  }

  private struct DivMod {
    fileprivate var div: BigInt
    fileprivate var mod: BigInt
  }

  private static func divMod(_ py: Py, left: BigInt, right: BigInt) -> PyResultGen<DivMod> {
    if right.isZero {
      return .zeroDivisionError(py, message: "divmod() by zero")
    }

    let result = Self.divmodWithUncheckedZero(left: left, right: right)
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
  private static func divmodWithUncheckedZero(left: BigInt, right: BigInt) -> DivMod {
    assert(
      !right.isZero,
      "div by 0 should be handled before calling 'PyInt.divmodWithUncheckedZero'"
    )

    var (quotient, remainder) = left.quotientAndRemainder(dividingBy: right)

    // See comment above this method.
    let differentSign = left.isNegative != right.isNegative
    if differentSign {
      remainder += right
      quotient -= 1
    }

    return DivMod(div: quotient, mod: remainder)
  }

  // MARK: - LShift

  // sourcery: pymethod = __lshift__
  /// static PyObject *
  /// long_lshift(PyObject *v, PyObject *w)
  internal static func __lshift__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.lshiftOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__lshift__",
                                isZelfValue: true)
  }

  // sourcery: pymethod = __rlshift__
  /// static PyObject *
  /// long_rshift(PyLongObject *a, PyLongObject *b)
  internal static func __rlshift__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.lshiftOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rlshift__",
                                isZelfValue: false)
  }

  private static func lshiftOperation(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject,
                                      fnName: String,
                                      isZelfValue: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let value = isZelfValue ? zelf.value : other.value
    let countBig = isZelfValue ? other.value : zelf.value

    if countBig.isNegative {
      return .valueError(py, message: "negative shift count")
    }

    if value.isZero {
      return PyResult(py, 0)
    }

    guard let count = Int(exactly: countBig) else {
      return .overflowError(py, message: "too many digits in integer")
    }

    let result = value << count
    return PyResult(py, result)
  }

  // MARK: - RShift

  // sourcery: pymethod = __rshift__
  internal static func __rshift__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.rshiftOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rshift__",
                                isZelfValue: true)
  }

  // sourcery: pymethod = __rrshift__
  internal static func __rrshift__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.rshiftOperation(py,
                                zelf: zelf,
                                other: other,
                                fnName: "__rrshift__",
                                isZelfValue: false)
  }

  private static func rshiftOperation(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject,
                                      fnName: String,
                                      isZelfValue: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let value = isZelfValue ? zelf.value : other.value
    let count = isZelfValue ? other.value : zelf.value

    if count.isNegative {
      return .valueError(py, message: "negative shift count")
    }

    let result = value >> count
    return PyResult(py, result)
  }

  // MARK: - And, or, xor

  // sourcery: pymethod = __and__
  internal static func __and__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__and__") { $0 & $1 }
  }

  // sourcery: pymethod = __rand__
  internal static func __rand__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__rand__") { $1 & $0 }
  }

  // sourcery: pymethod = __or__
  internal static func __or__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__or__") { $0 | $1 }
  }

  // sourcery: pymethod = __ror__
  internal static func __ror__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__ror__") { $1 | $0 }
  }

  // sourcery: pymethod = __xor__
  internal static func __xor__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__xor__") { $0 ^ $1 }
  }

  // sourcery: pymethod = __rxor__
  internal static func __rxor__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.binaryOperation(py, zelf: zelf, other: other, fnName: "__rxor__") { $1 ^ $0 }
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
  internal static func __round__(_ py: Py,
                                 zelf _zelf: PyObject,
                                 nDigits _nDigits: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__round__")
    }

    let nDigits: BigInt
    switch Self.parseRoundDigitCount(py, object: _nDigits) {
    case let .value(n): nDigits = n
    case let .error(e): return .error(e)
    }

    // If digits >= 0 then no rounding is necessary; return self unchanged.
    // Unless we are subclass -> convert to int:
    // >>> round(True)
    // 1
    if nDigits.isPositiveOrZero {
      if py.cast.isExactlyInt(zelf.asObject) {
        return PyResult(zelf)
      }

      return PyResult(py, zelf.value)
    }

    // result = self - divmod_near(self, 10 ** -ndigits)[1]
    let pow10 = zelf.powNonNegativeExp(base: 10, exp: -nDigits)

    switch self.divmodNear(py, left: zelf.value, right: pow10) {
    case let .value(divMod):
      let result = zelf.value - divMod.mod
      return PyResult(py, result)
    case let .error(e):
      return .error(e)
    }
  }

  private static func parseRoundDigitCount(_ py: Py,
                                           object: PyObject?) -> PyResultGen<BigInt> {
    guard let object = object else {
      return .value(0)
    }

    switch IndexHelper.pyInt(py, object: object) {
    case let .value(pyInt):
      return .value(pyInt.value)
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
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
  private static func divmodNear(_ py: Py,
                                 left a: BigInt,
                                 right b: BigInt) -> PyResultGen<DivMod> {
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

    var result: DivMod
    switch Self.divMod(py, left: a, right: b) {
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
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    switch self.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let base = binding.optional(at: 1)
      return Self.__new__(py, type: type, object: object, base: base)
    case let .error(e):
      return .error(e)
    }
  }

  private static func __new__(_ py: Py,
                              type: PyType,
                              object: PyObject?,
                              base: PyObject?) -> PyResult {
    // If we do not have 1st argument -> 0
    guard let object = object else {
      if base != nil {
        return .typeError(py, message: "int() missing string argument")
      }

      return Self.allocate(py, type: type, value: 0)
    }

    // If we do not have base -> try to cast 'object' as 'int'
    guard let base = base else {
      let parsed = Self.new(py, fromObjectWithoutBase: object)
      switch parsed {
      case .pyInt(let pyInt): return Self.allocate(py, type: type, value: pyInt)
      case .bigInt(let value): return Self.allocate(py, type: type, value: value)
      case .error(let e): return .error(e)
      }
    }

    // Check if base is 'int'
    let baseInt: Int
    switch IndexHelper.int(py, object: base, onOverflow: .overflowError) {
    case let .value(b):
      baseInt = b
    case let .notIndex(lazyError):
      let error = lazyError.create(py)
      return .error(error)
    case let .overflow(_, lazyError):
      let error = lazyError.create(py)
      return .error(error)
    case let .error(e):
      return .error(e)
    }

    guard (baseInt == 0 || baseInt >= 2) && baseInt <= 36 else {
      return .valueError(py, message: "int() base must be >= 2 and <= 36, or 0")
    }

    // Parse 'object' with a given 'base'
    switch Self.new(py, fromString: object, base: baseInt) {
    case .value(let value):
      return Self.allocate(py, type: type, value: value)
    case .notString:
      return .typeError(py, message: "int() can't convert non-string with explicit base")
    case .error(let e):
      return .error(e)
    }
  }

  private static func isBuiltinIntType(_ py: Py, type: PyType) -> Bool {
    return type === py.types.int
  }

  private static func allocate(_ py: Py, type: PyType, value: PyInt) -> PyResult {
    // 'int' is immutable, so we can return the same thing (saves allocation).
    let isBuiltin = Self.isBuiltinIntType(py, type: type)
    let isNotSubclass = py.cast.isExactlyInt(value.asObject)

    if isBuiltin && isNotSubclass {
      return PyResult(value)
    }

    return Self.allocate(py, type: type, value: value.value)
  }

  private static func allocate(_ py: Py, type: PyType, value: BigInt) -> PyResult {
    // If this is a builtin then try to re-use interned values
    let isBuiltin = Self.isBuiltinIntType(py, type: type)
    let result = isBuiltin ?
      py.newInt(value) :
      py.memory.newInt(type: type, value: value)

    return PyResult(result)
  }

  private enum NewWithoutBaseResult {
    case pyInt(PyInt)
    case bigInt(BigInt)
    case error(PyBaseException)
  }

  /// PyObject *
  /// PyNumber_Long(PyObject *o)
  private static func new(
    _ py: Py,
    fromObjectWithoutBase object: PyObject
  ) -> NewWithoutBaseResult {
    // '__int__' and '__trunc__' have to be before 'py.cast.asInt',
    // because they can be overridden

    switch Self.call__int__(py, object: object) {
    case .value(let int): return .pyInt(int)
    case .missingMethod: break // try other
    case .error(let e): return .error(e)
    }

    switch Self.call__trunc__(py, object: object) {
    case .value(let int): return .pyInt(int)
    case .missingMethod: break // try other
    case .error(let e): return .error(e)
    }

    if let int = py.cast.asInt(object) {
      return .pyInt(int)
    }

    switch Self.new(py, fromString: object, base: 10) {
    case .value(let v): return .bigInt(v)
    case .notString: break
    case .error(let e): return .error(e)
    }

    let message = "int() argument must be a string, a bytes-like object " +
      "or a number, not '\(object.typeName)'"
    let error = py.newTypeError(message: message)
    return .error(error.asBaseException)
  }

  private enum NumberConverterResult {
    case value(PyInt)
    case missingMethod
    case error(PyBaseException)
  }

  private static func call__int__(_ py: Py, object: PyObject) -> NumberConverterResult {
    if let result = PyStaticCall.__int__(py, object: object) {
      switch result {
      case let .value(o): return Self.interpret__int__(py, object: o)
      case let .error(e): return .error(e)
      }
    }

    switch py.callMethod(object: object, selector: .__int__) {
    case .value(let o):
      return Self.interpret__int__(py, object: o)
    case .missingMethod:
      return .missingMethod
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func interpret__int__(_ py: Py, object: PyObject) -> NumberConverterResult {
    guard let int = py.cast.asInt(object) else {
      let message = "__int__ returned non-int (type \(object.typeName)"
      let error = py.newTypeError(message: message)
      return .error(error.asBaseException)
    }

    return .value(int)
  }

  private static func call__trunc__(_ py: Py, object: PyObject) -> NumberConverterResult {
    if let result = PyStaticCall.__trunc__(py, object: object) {
      switch result {
      case let .value(o): return Self.interpret__trunc__(py, object: o)
      case let .error(e): return .error(e)
      }
    }

    switch py.callMethod(object: object, selector: .__trunc__) {
    case .value(let o):
      return Self.interpret__trunc__(py, object: o)
    case .missingMethod:
      return .missingMethod
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func interpret__trunc__(_ py: Py, object: PyObject) -> NumberConverterResult {
    guard let int = py.cast.asInt(object) else {
      let message = "__trunc__ returned non-Integral (type \(object.typeName))"
      let error = py.newTypeError(message: message)
      return .error(error.asBaseException)
    }

    return .value(int)
  }

  private enum NewFromStringResult {
    case value(BigInt)
    case notString
    case error(PyBaseException)
  }

  private static func new(_ py: Py,
                          fromString object: PyObject,
                          base: Int) -> NewFromStringResult {
    let string: String
    switch py.getString(object: object, encoding: .default) {
    case .string(_, let s),
         .bytes(_, let s):
      string = s
    case .byteDecodingError(let bytes):
      let message = "int() bytes at '\(bytes.asObject.ptr)' cannot be interpreted as str"
      let error = py.newValueError(message: message)
      return .error(error.asBaseException)
    case .notStringOrBytes:
      return .notString
    }

    do {
      let result = try BigInt(parseUsingPythonRules: string, base: base)
      return .value(result)
    } catch {
      let message = "int() '\(string)' cannot be interpreted as int: \(error)"
      let error = py.newValueError(message: message)
      return .error(error.asBaseException)
    }
  }

  // MARK: - Operations

  /// Operation that returns ourself.
  private static func identityOperation(_ py: Py,
                                        zelf _zelf: PyObject,
                                        fnName: String) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    // Normally we could return ourself (as in: exactly the same object as 'zelf').
    // But if we are an subclass then we have to convert to 'int':
    // >>> True.imag
    // 0
    // >>> True.__index__()
    // 1
    if py.cast.isExactlyInt(zelf.asObject) {
      return PyResult(zelf)
    }

    return PyResult(py, zelf.value)
  }

  /// Operation that returns an `int`
  private static func intOperation(_ py: Py,
                                   zelf _zelf: PyObject,
                                   fnName: String,
                                   fn: (BigInt) -> Int) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let result = fn(zelf.value)
    return PyResult(py, result)
  }

  private static func unaryOperation(_ py: Py,
                                     zelf _zelf: PyObject,
                                     fnName: String,
                                     fn: (BigInt) -> BigInt) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let result = fn(zelf.value)
    return PyResult(py, result)
  }

  private static func binaryOperation(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject,
                                      fnName: String,
                                      fn: (BigInt, BigInt) -> BigInt) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let result = fn(zelf.value, other.value)
    return PyResult(py, result)
  }

  // MARK: - Helpers

  internal static func asDouble(_ py: Py, int: PyInt) -> PyFloat.IntAsDouble {
    return PyFloat.asDouble(py, int: int)
  }

  internal static func asDouble(_ py: Py, int: BigInt) -> PyFloat.IntAsDouble {
    return PyFloat.asDouble(py, int: int)
  }
}
