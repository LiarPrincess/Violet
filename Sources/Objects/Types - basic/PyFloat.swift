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

// sourcery: pytype = float, isDefault, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyFloat: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    float(x) -> floating point number

    Convert a string or number to a floating point number, if possible.
    """

  // sourcery: storedProperty
  internal var value: Double { self.valuePtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, value: Double) {
    self.initializeBase(py, type: type)
    self.valuePtr.initialize(to: value)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyFloat(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "value", value: zelf.value, includeInDescription: true)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return FloatCompareHelper.isEqual(py, left: zelf.value, right: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = FloatCompareHelper.isEqual(py, left: zelf.value, right: other)
    return isEqual.not
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__lt__)
    }

    return FloatCompareHelper.isLess(py, left: zelf.value, right: other)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__le__)
    }

    return FloatCompareHelper.isLessEqual(py, left: zelf.value, right: other)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__gt__)
    }

    return FloatCompareHelper.isGreater(py, left: zelf.value, right: other)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ge__)
    }

    return FloatCompareHelper.isGreaterEqual(py, left: zelf.value, right: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    let result = py.hasher.hash(zelf.value)
    return .value(result)
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

  private static func toString(_ py: Py,
                               zelf _zelf: PyObject,
                               fnName: String) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let value = zelf.value
    let result = Self.toString(py, value: value)
    return PyResult(result)
  }

  private static func toString(_ py: Py, value: Double) -> PyString {
    // 'str' is immutable, so we can intern most common values.
    if value.isNaN {
      return py.intern(string: "nan")
    }

    switch value.sign {
    case .plus:
      if value.isInfinite { return py.intern(string: "inf") }
      if value.isZero { return py.intern(string: "0.0") }
      if value == 1.0 { return py.intern(string: "1.0") }
    case .minus:
      if value.isInfinite { return py.intern(string: "-inf") }
      if value.isZero { return py.intern(string: "-0.0") }
      if value == -1.0 { return py.intern(string: "-1.0") }
    }

    let result = String(describing: value)
    return py.newString(result)
  }

  // MARK: - As bool/int/float/index

  // sourcery: pymethod = __bool__
  internal static func __bool__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__bool__")
    }

    let result = !zelf.value.isZero
    return PyResult(py, result)
  }

  // sourcery: pymethod = __int__
  internal static func __int__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__int__")
    }

    let result = BigInt(zelf.value)
    return PyResult(py, result)
  }

  // sourcery: pymethod = __float__
  internal static func __float__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "__float__")
  }

  // MARK: - Imaginary

  // sourcery: pyproperty = real
  internal static func real(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.identityOperation(py, zelf: zelf, fnName: "real")
  }

  // sourcery: pyproperty = imag
  internal static func imag(_ py: Py, zelf: PyObject) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "imag")
    }

    return PyResult(py, 0.0)
  }

  internal static let conjugateDoc = """
    conjugate($self, /)
    --

    Return self, the complex conjugate of any float.
    """

  // sourcery: pymethod = conjugate, doc = conjugateDoc
  /// float.conjugate
  /// Return self, the complex conjugate of any float.
  internal static func conjugate(_ py: Py, zelf: PyObject) -> PyResult {
    return self.identityOperation(py, zelf: zelf, fnName: "conjugate")
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

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Pos, neg, abs

  // sourcery: pymethod = __pos__
  internal static func __pos__(_ py: Py, zelf: PyObject) -> PyResult {
    // 'float' is immutable, so if we are exactly 'float' (not an subclass),
    // then we can return ourself. (This saves an allocation).
    if let float = py.cast.asExactlyFloat(zelf) {
      return .value(float.asObject)
    }

    return Self.unaryOperation(py, zelf: zelf, fnName: "__pos__") { $0 }
  }

  // sourcery: pymethod = __neg__
  internal static func __neg__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.unaryOperation(py, zelf: zelf, fnName: "__neg__") { -$0 }
  }

  // sourcery: pymethod = __abs__
  internal static func __abs__(_ py: Py, zelf: PyObject) -> PyResult {
    // 'float' is immutable, so if we are exactly 'float' (not a subclass) and '>=0',
    // then we can return ourself. (This saves an allocation).
    if let float = py.cast.asExactlyFloat(zelf), float.value >= 0 {
      return .value(float.asObject)
    }

    return Self.unaryOperation(py, zelf: zelf, fnName: "__abs__") { Swift.abs($0) }
  }

  // MARK: - Is integer

  internal static let isIntegerDoc = """
    is_integer($self, /)
    --

    Return True if the float is an integer.
    """

  // sourcery: pymethod = is_integer, doc = isIntegerDoc
  internal static func is_integer(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "is_integer")
    }

    let value = zelf.value
    guard value.isFinite else {
      return PyResult(py, false)
    }

    let result = floor(value) == value
    return PyResult(py, result)
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
  internal static func as_integer_ratio(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "as_integer_ratio")
    }

    let value = zelf.value

    if value.isInfinite {
      return .overflowError(py, message: "cannot convert Infinity to integer ratio")
    }

    if value.isNaN {
      return .valueError(py, message: "cannot convert NaN to integer ratio")
    }

    let frexp = Frexp(value: value)
    var exponent = frexp.exponent
    var mantissa = frexp.mantissa

    for _ in 0..<300 {
      if mantissa == Foundation.floor(mantissa) {
        break
      }

      mantissa *= 2
      exponent -= 1
    }

    var pyMantissa: PyInt
    switch py.newInt(double: mantissa) {
    case let .value(i): pyMantissa = i
    case let .error(e): return .error(e)
    }

    let numerator: PyInt
    let denominator: PyInt
    if exponent > 0 {
      numerator = py.newInt(pyMantissa.value << exponent)
      denominator = py.newInt(1)
    } else {
      numerator = pyMantissa
      denominator = py.newInt(BigInt(1) << -exponent) // notice '-'!
    }

    return PyResult(py, tuple: numerator.asObject, denominator.asObject)
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

  // MARK: - Pow

  // sourcery: pymethod = __pow__
  internal static func __pow__(_ py: Py,
                               zelf: PyObject,
                               exp: PyObject,
                               mod: PyObject?) -> PyResult {
    return Self.powOperation(py,
                             zelf: zelf,
                             other: exp,
                             mod: mod,
                             fnName: "__pow__",
                             isZelfBase: true)
  }

  // sourcery: pymethod = __rpow__
  internal static func __rpow__(_ py: Py,
                                zelf: PyObject,
                                base: PyObject,
                                mod: PyObject?) -> PyResult {
    return Self.powOperation(py,
                             zelf: zelf,
                             other: base,
                             mod: mod,
                             fnName: "__rpow__",
                             isZelfBase: false)
  }

  // swiftlint:disable function_parameter_count
  private static func powOperation(_ py: Py,
                                   zelf _zelf: PyObject,
                                   other: PyObject,
                                   mod: PyObject?,
                                   fnName: String,
                                   isZelfBase: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    guard py.cast.isNilOrNone(mod) else {
      let message = "pow() 3rd argument not allowed unless all arguments are integers"
      return .typeError(py, message: message)
    }

    switch Self.asDouble(py, object: other) {
    case let .value(other):
      let base = isZelfBase ? zelf.value : other
      let exp = isZelfBase ? other : zelf.value

      if base.isZero && exp < 0 {
        let message = "0.0 cannot be raised to a negative power"
        return .zeroDivisionError(py, message: message)
      }

      let result = Foundation.pow(base, exp)
      return PyResult(py, result)

    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notImplemented(py)
    }
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

  private static func truedivOperation(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject,
                                       fnName: String,
                                       isZelfLeft: Bool) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    switch Self.asDouble(py, object: other) {
    case let .value(other):
      let left = isZelfLeft ? zelf.value : other
      let right = isZelfLeft ? other : zelf.value

      if right.isZero {
        return .zeroDivisionError(py, message: "float division by zero")
      }

      let result = left / right
      return PyResult(py, result)

    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notImplemented(py)
    }
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

    switch Self.asDouble(py, object: other) {
    case let .value(other):
      let left = isZelfLeft ? zelf.value : other
      let right = isZelfLeft ? other : zelf.value

      if right.isZero {
        return .zeroDivisionError(py, message: "float floor division by zero")
      }

      let divMod = Self.divmodWithUncheckedZero(left: left, right: right)
      return PyResult(py, divMod.div)

    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notImplemented(py)
    }
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

    switch Self.asDouble(py, object: other) {
    case let .value(other):
      let left = isZelfLeft ? zelf.value : other
      let right = isZelfLeft ? other : zelf.value

      if right.isZero {
        return .zeroDivisionError(py, message: "float modulo by zero")
      }

      let divMod = Self.divmodWithUncheckedZero(left: left, right: right)
      return PyResult(py, divMod.mod)

    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notImplemented(py)
    }
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

    switch Self.asDouble(py, object: other) {
    case let .value(other):
      let left = isZelfLeft ? zelf.value : other
      let right = isZelfLeft ? other : zelf.value

      if right.isZero {
        return .zeroDivisionError(py, message: "float divmod()")
      }

      let divMod = Self.divmodWithUncheckedZero(left: left, right: right)

      let element0 = py.newFloat(divMod.div)
      let element1 = py.newFloat(divMod.mod)
      return PyResult(py, tuple: element0.asObject, element1.asObject)

    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notImplemented(py)
    }
  }

  private struct DivMod {
    fileprivate var div: Double
    fileprivate var mod: Double
  }

  // This is the exact copy of (damn this is complicated):
  // static PyObject *
  // float_divmod(PyObject *v, PyObject *w)
  private static func divmodWithUncheckedZero(left: Double, right: Double) -> DivMod {
    var mod = Foundation.fmod(left, right)
    var div = (left - mod) / right

    if !mod.isZero {
      // Ensure the 'div' has the same sign as the 'right'
      let isRightNegative = right < 0
      let isModNegative = mod < 0

      if isRightNegative != isModNegative {
        mod += right
        div -= 1.0
      }
    } else {
      // Ensure the 'mod' has the same sign as the 'right'
      mod = Double(signOf: right, magnitudeOf: 0.0)
    }

    // Snap quotient to nearest integral value
    var floordiv: Double
    if !div.isZero {
      floordiv = Foundation.floor(div)
      if div - floordiv > 0.5 {
        floordiv += 1.0
      }
    } else {
      // 'div' is zero - get the same sign as the true quotient
      floordiv = Double(signOf: left / right, magnitudeOf: 0.0)
    }

    return DivMod(div: floordiv, mod: mod)
  }

  // MARK: - Round

  /// See comment in `round(_:zelf:nDigits: PyObject?)`.
  private static let roundDigitCountMax = Int(Double(DBL_MANT_DIG - DBL_MIN_EXP) * 0.30_103)

  /// See comment in `round(_:zelf:nDigits: PyObject?)`.
  private static let roundDigitCountMin = -Int(Double(DBL_MAX_EXP + 1) * 0.30_103)

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
  internal static func __round__(_ py: Py,
                                 zelf _zelf: PyObject,
                                 nDigits: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__round__")
    }

    switch Self.parseRoundDigitCount(py, object: nDigits) {
    case .none:
      let rounded = Self.roundToEven(value: zelf.value)
      let result = py.newInt(double: rounded)
      return result.map { $0.asObject }

    case .int(let nDigits):
      // nans and infinities round to themselves
      guard zelf.value.isFinite else {
        return PyResult(zelf)
      }

      // Dark magic incoming (well above our $0 pay grade):
      // Deal with extreme values for ndigits.
      // For ndigits > NDIGITS_MAX, x always rounds to itself.
      // For ndigits < NDIGITS_MIN, x always rounds to +-0.0.
      // Here 0.30103 is an upper bound for log10(2).

      if nDigits > Self.roundDigitCountMax {
        return PyResult(zelf)
      }

      if nDigits < Self.roundDigitCountMin {
        let zero = Double(signOf: zelf.value, magnitudeOf: 0.0)
        return PyResult(py, zero)
      }

      let result = Self.round(py, zelf: zelf, nDigit: nDigits)
      return PyResult(result)

    case .error(let e):
      return .error(e)
    }
  }

  private enum RoundDigits {
    case none
    case int(Int)
    case error(PyBaseException)
  }

  private static func parseRoundDigitCount(_ py: Py, object: PyObject?) -> RoundDigits {
    guard let object = object else {
      return .none
    }

    if py.cast.isNone(object) {
      return .none
    }

    switch IndexHelper.int(py, object: object, onOverflow: .overflowError) {
    case let .value(i):
      return .int(i)
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
      return .error(e)
    }
  }

  /// Round to the closest allowed value;
  /// if two values are equally close, the even one is chosen.
  ///
  /// AFAIK it is te same as `value.round(.toNearestOrEven)`.
  private static func roundToEven(value: Double) -> Double {
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
  private static func round(_ py: Py, zelf: PyFloat, nDigit: Int) -> PyResultGen<PyFloat> {
    assert(self.roundDigitCountMin <= nDigit && nDigit <= self.roundDigitCountMax)

    let scaledToDigits: Double, pow10: Double
    if nDigit >= 0 {
      // CPython has special case for overflow, we are too lazy for that
      pow10 = Foundation.pow(10.0, Double(nDigit))
      scaledToDigits = zelf.value * pow10

      // Because 'mul' can overflow
      guard scaledToDigits.isFinite else {
        return .value(zelf)
      }
    } else {
      pow10 = Foundation.pow(10.0, -Double(nDigit))
      scaledToDigits = zelf.value / pow10
    }

    let rounded = Self.roundToEven(value: scaledToDigits)
    let rescaled = nDigit >= 0 ? rounded / pow10 : rounded * pow10

    // if computation resulted in overflow, raise OverflowError
    guard rescaled.isFinite else {
      return .overflowError(py, message: "overflow occurred during round")
    }

    let result = py.newFloat(rescaled)
    return .value(result)
  }

  // MARK: - Trunc

  internal static let truncDoc = """
    __trunc__($self, /)
    --

    Return the Integral closest to x between 0 and x.
    """

  // sourcery: pymethod = __trunc__, doc = truncDoc
  internal static func __trunc__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__trunc__")
    }

    var intPart: Double = 0
    _ = Foundation.modf(zelf.value, &intPart)

    let result = py.newInt(double: intPart)
    return PyResult(result)
  }

  // MARK: - Python new

  internal static let newDoc = """
    float(x=0, /)
    --

    Convert a string or number to a floating point number, if possible.
    """

  // sourcery: pystaticmethod = __new__, doc = newDoc
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    if Self.isBuiltinFloatType(py, type: type) {
      if let e = ArgumentParser.noKwargsOrError(py,
                                                fnName: Self.pythonTypeName,
                                                kwargs: kwargs) {
        return .error(e.asBaseException)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    if args.isEmpty {
      return Self.allocate(py, type: type, value: 0.0)
    }

    let arg0 = args[0]

    switch Self.new(py, fromString: arg0) {
    case .value(let d): return Self.allocate(py, type: type, value: d)
    case .notString: break
    case .error(let e): return .error(e.asBaseException)
    }

    switch Self.new(py, fromNumber: arg0) {
    case .pyFloat(let pyFloat): return Self.allocate(py, type: type, value: pyFloat)
    case .double(let double): return Self.allocate(py, type: type, value: double)
    case .notNumber: break
    case .error(let e): return .error(e)
    }

    let message = "float() argument must be a string, or a number, not '\(arg0.typeName)'"
    return .typeError(py, message: message)
  }

  internal static func isBuiltinFloatType(_ py: Py, type: PyType) -> Bool {
    return type === py.types.float
  }

  private static func allocate(_ py: Py, type: PyType, value: PyFloat) -> PyResult {
    // 'float' is immutable, so we can return the same thing (saves allocation).
    let isBuiltin = Self.isBuiltinFloatType(py, type: type)
    let isNotSubclass = py.cast.isExactlyFloat(value.asObject)

    if isBuiltin && isNotSubclass {
      return PyResult(value)
    }

    return Self.allocate(py, type: type, value: value.value)
  }

  private static func allocate(_ py: Py, type: PyType, value: Double) -> PyResult {
    // If this is a builtin then try to re-use interned values
    // (do we even have interned floats?)
    let isBuiltin = Self.isBuiltinFloatType(py, type: type)
    let result = isBuiltin ?
      py.newFloat(value) :
      py.memory.newFloat(type: type, value: value)

    return PyResult(result)
  }

  private enum DoubleFromString {
    case value(Double)
    case notString
    case error(PyValueError)
  }

  private static func new(_ py: Py, fromString object: PyObject) -> DoubleFromString {
    switch py.getString(object: object, encoding: .default) {
    case .string(_, let s),
         .bytes(_, let s):
      guard let value = Double(parseUsingPythonRules: s) else {
        let message = "float() '\(s)' cannot be interpreted as float"
        let error = py.newValueError(message: message)
        return .error(error)
      }

      return .value(value)

    case .byteDecodingError(let bytes):
      let ptr = bytes.asObject.ptr
      let message = "float() bytes at '\(ptr)' cannot be interpreted as str"
      let error = py.newValueError(message: message)
      return .error(error)

    case .notStringOrBytes:
      return .notString
    }
  }

  private enum NewFromNumber {
    case pyFloat(PyFloat)
    case double(Double)
    case error(PyBaseException)
    case notNumber
  }

  /// PyObject *
  /// PyNumber_Float(PyObject *o)
  private static func new(_ py: Py, fromNumber object: PyObject) -> NewFromNumber {
    // Call has to be before 'Self.asDouble', because it can override
    switch Self.callFloat(py, object: object) {
    case .value(let o):
      guard let float = py.cast.asFloat(o) else {
        let message = "\(object.typeName).__float__ returned non-float (type \(o.typeName))"
        let error = py.newTypeError(message: message)
        return .error(error.asBaseException)
      }

      return .pyFloat(float)

    case .missingMethod:
      break // try other possibilities
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    if let float = py.cast.asFloat(object) {
      return .pyFloat(float)
    }

    switch Self.asDouble(py, object: object) {
    case let .value(d):
      return .double(d)
    case let .intOverflow(_, e):
      return .error(e)
    case .notDouble:
      return .notNumber
    }
  }

  private static func callFloat(_ py: Py, object: PyObject) -> Py.CallMethodResult {
    if let result = PyStaticCall.__float__(py, object: object) {
      switch result {
      case let .value(f):
        return .value(f.asObject)
      case let .error(e):
        return .error(e)
      }
    }

    return py.callMethod(object: object, selector: .__float__)
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
    // But if we are an subclass then we have to convert to 'float':
    // >>> class f(float): pass
    // ...
    // >>> x = f(1.6)
    // >>> type(x.__float__())
    // <class 'float'>
    if py.cast.isExactlyFloat(zelf.asObject) {
      return PyResult(zelf)
    }

    return PyResult(py, zelf.value)
  }

  private static func unaryOperation(_ py: Py,
                                     zelf _zelf: PyObject,
                                     fnName: String,
                                     fn: (Double) -> Double) -> PyResult {
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
                                      fn: (Double, Double) -> Double) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    switch Self.asDouble(py, object: other) {
    case let .value(d):
      let result = fn(zelf.value, d)
      return PyResult(py, result)

    case let .intOverflow(_, e):
      return .error(e)

    case .notDouble:
      return .notImplemented(py)
    }
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
  internal static func asDouble(_ py: Py, object: PyObject) -> AsDouble {
    if let pyFloat = Self.downcast(py, object) {
      return .value(pyFloat.value)
    }

    if let int = py.cast.asInt(object) {
      switch Self.asDouble(py, int: int) {
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

  internal static func asDouble(_ py: Py, int: PyInt) -> IntAsDouble {
    return Self.asDouble(py, int: int.value)
  }

  internal static func asDouble(_ py: Py, int: BigInt) -> IntAsDouble {
    // This is not the best way…
    // But in general conversion 'Int -> Double' is a very complicated thing.
    // But it falls onto 'close enough' category.

    let result = Double(int)
    assert(!result.isNaN && !result.isSubnormal)

    guard result.isFinite else {
      let message = "int too large to convert to float"
      let error = py.newOverflowError(message: message)
      return .overflow(error.asBaseException)
    }

    return .value(result)
  }
}
