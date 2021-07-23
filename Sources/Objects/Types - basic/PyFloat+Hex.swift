import Foundation
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore floatobject TOHEX ffffp inity

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://docs.python.org/3/library/stdtypes.html#float.fromhex <- THIS!

// MARK: - Hex

extension PyFloat {

  internal static let hexDoc = """
      hex($self, /)
      --

      Return a hexadecimal representation of a floating-point number.

      >>> (-0.1).hex()
      \'-0x1.999999999999ap-4\'
      >>> 3.14159.hex()
      \'0x1.921f9f01b866ep+1\'
      """

  /// `#define TOHEX_NBITS DBL_MANT_DIG + 3 - (DBL_MANT_DIG+2)%4`
  private var hexBitCount: Int {
    return DBL_MANT_DIG + 3 - (DBL_MANT_DIG + 2) % 4
  }

  // sourcery: pymethod = hex, doc = hexDoc
  public func hex() -> PyResult<String> {
    if self.value.isNaN || self.value.isInfinite {
      let repr = self.repr()
      return .value(repr)
    }

    if self.value.isZero {
      switch self.value.sign {
      case .plus: return .value("0x0.0p+0")
      case .minus: return .value("-0x0.0p+0")
      }
    }

    let sign = self.value < 0 ? "-" : ""
    var result = "\(sign)0x"

    let frexp = Frexp(value: Swift.abs(self.value))
    var exponent = frexp.exponent
    var mantissa = frexp.mantissa

    let shift = 1 - Swift.max(DBL_MIN_EXP - exponent, 0)
    mantissa = Foundation.scalbn(mantissa, shift) // scalbn(x, exp) = x * (2 ** exp)
    exponent -= shift

    // mantissa (hex!)
    func appendMantissaDigit() {
      let asInt = Int(mantissa)
      assert(0 <= asInt && asInt < 16)
      result.append(String(asInt, radix: 16, uppercase: false))
      mantissa -= Double(asInt)
    }

    appendMantissaDigit()
    result.append(".")

    for _ in 0..<((self.hexBitCount - 1) / 4) {
      mantissa *= 16.0
      appendMantissaDigit()
    }

    // exponent (decimal!)
    result.append("p")
    let exponentAbs = Swift.abs(exponent)
    result.append(exponent < 0 ? "-" : "+")
    result.append(String(exponentAbs, radix: 10, uppercase: false))

    return .value(result)
  }
}

// MARK: - From hex

extension PyFloat {

  internal static let fromHexDoc = """
      fromhex($type, string, /)
      --

      Create a floating-point number from a hexadecimal string.

      >>> float.fromhex(\'0x1.ffffp10\')
      2047.984375
      >>> float.fromhex(\'-0x1p-1074\')
      -5e-324
      """

  // sourcery: pyclassmethod = fromhex, doc = fromHexDoc
  public static func fromHex(type: PyType,
                             value: PyObject) -> PyResult<PyObject> {
    guard let stringObject = PyCast.asString(value) else {
      // This message looks weird, but argument name is 'string'
      let t = value.typeName
      return .typeError("fromhex(): string has to have str type, not \(t)")
    }

    let result = Self.fromHex(string: stringObject.value)

    switch result {
    case let .value(double):
      let pyFloat = Py.newFloat(double)

      // Fast path for 'float'
      if type === Py.types.float {
        return .value(pyFloat)
      }

      let callResult = Py.call(callable: type, arg: pyFloat)
      return callResult.asResult
    case let .error(e):
      return .error(e)
    }
  }

  /// Raw `fromHex` that works on Swift values, use this for debug.
  private static func fromHex(string _string: String) -> PyResult<Double> {
    var string = FromHexString(string: _string)
    if string.isEmpty {
      return .error(parserError())
    }

    switch parseInfinityOrNan(string: string) {
    case .value(let d): return .value(d)
    case .notInfinityOrNan: break // Try other
    case .error(let e): return .error(e)
    }

    // Format: [sign] ['0x'] integer ['.' fraction] ['p' exponent]

    let sign = parseSign(string: &string)
    _ = string.advanceIf("0x") // if not then nop

    // Integer and fraction are strings of hexadecimal (!) digits
    let integer = parseInteger(string: &string)
    let fraction = parseFraction(string: &string)

    // Skipping the 'insane' check from CPython, because we are lazy

    // Exponent is decimal
    let exponent: Int
    switch parseExponent(string: &string) {
    case .value(let e): exponent = e
    case .none: exponent = 0
    case .error(let e): return .error(e)
    }

    // At this point we should have exhausted the whole 'string'
    guard string.isEmpty else {
      return .error(parserError())
    }

    return combine(sign: sign,
                   integer: integer,
                   fraction: fraction,
                   exponent: exponent)
  }
}

// MARK: - FromHexString

private typealias Scalars = String.UnicodeScalarView.SubSequence

private struct FromHexString: CustomStringConvertible {

  private var window: Scalars

  fileprivate var description: String {
    return String(self.window)
  }

  fileprivate var isEmpty: Bool {
    return self.window.isEmpty
  }

  fileprivate init(string: String) {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
    let scalars = trimmed.unicodeScalars
    self.window = scalars[scalars.startIndex...]
  }

  fileprivate var peek: UnicodeScalar? {
    return self.window.first
  }

  fileprivate mutating func advanceIf(_ string: String) -> Bool {
    let scalars = string.unicodeScalars

    guard self.window.count >= scalars.count else {
      return false
    }

    for (w, s) in zip(self.window, scalars) {
      guard self.isEqual(lhs: w, rhs: s) else {
        return false
      }
    }

    self.advance(count: scalars.count)
    return true
  }

  /// Advance while the given function returns any value.
  fileprivate mutating func advance<R>(
    while map: (UnicodeScalar) -> R?
  ) -> [R] {
    if self.isEmpty {
      return []
    }

    var result = [R]()
    var firstInvalidScalarIndex = self.window.startIndex

    while firstInvalidScalarIndex != self.window.endIndex {
      let scalar = self.window[firstInvalidScalarIndex]

      guard let value = map(scalar) else {
        break
      }

      result.append(value)
      self.window.formIndex(after: &firstInvalidScalarIndex)
    }

    self.window = self.window[firstInvalidScalarIndex...]
    return result
  }

  private mutating func advance(count: Int) {
    // swiftlint:disable:next empty_count
    assert(count >= 0)

    guard let index = self.index(offset: count) else {
      trap("'FromHexString.advance' called to advance after end")
    }

    self.window = self.window[index...]
  }

  private func index(offset: Int) -> Scalars.Index? {
    assert(offset >= 0)
    return self.window.index(self.window.startIndex,
                             offsetBy: offset,
                             limitedBy: self.window.endIndex)
  }

  private func isEqual(lhs: UnicodeScalar, rhs: UnicodeScalar) -> Bool {
    // Used for 'inf' and 'nan', so lowercase if enough
    let lhsLower = lhs.properties.lowercaseMapping
    let rhsLower = rhs.properties.lowercaseMapping
    return lhsLower == rhsLower
  }
}

// MARK: - Sign

extension Double {

  fileprivate init(sign: FloatingPointSign, magnitudeOf magnitude: Double) {
    switch sign {
    case .plus:
      self = Double(signOf: 1.0, magnitudeOf: magnitude)
    case .minus:
      self = Double(signOf: -1.0, magnitudeOf: magnitude)
    }
  }
}

private func parseSign(string: inout FromHexString) -> FloatingPointSign {
  if string.advanceIf("-") {
    return .minus
  }

  if string.advanceIf("+") {
    return .plus
  }

  return .plus
}

// MARK: - Infinity or nan

private enum InfinityOrNan {
  case value(Double)
  case notInfinityOrNan
  case error(PyBaseException)
}

/// double
/// _Py_parse_inf_or_nan(const char *p, char **endptr)
private func parseInfinityOrNan(string: FromHexString) -> InfinityOrNan {
  var copy = string
  let sign = parseSign(string: &copy)

  if copy.advanceIf("inf") {
    _ = copy.advanceIf("inity")

    guard copy.isEmpty else {
      return .error(parserError())
    }

    return .value(Double(sign: sign, magnitudeOf: Double.infinity))
  }

  if copy.advanceIf("nan") {
    guard copy.isEmpty else {
      return .error(parserError())
    }

    return .value(Double(sign: sign, magnitudeOf: Double.nan))
  }

  return .notInfinityOrNan
}

// MARK: - Integer

private typealias HexDigit = Int
private typealias HexDigits = [HexDigit]

/// Integer and fraction are strings of hexadecimal (!) digits
private func parseInteger(string: inout FromHexString) -> HexDigits {
  return string.advance { $0.asHexDigit }
}

// MARK: - Fraction

/// Integer and fraction are strings of hexadecimal (!) digits
private func parseFraction(string: inout FromHexString) -> HexDigits? {
  guard string.advanceIf(".") else {
    return nil
  }

  return string.advance { $0.asHexDigit }
}

// MARK: - Exponent

private enum Exponent {
  case none
  case value(Int)
  case error(PyBaseException)
}

/// Exponent is a decimal (!) integer with an optional leading sign.
private func parseExponent(string: inout FromHexString) -> Exponent {
  guard string.advanceIf("p") else {
    return .none
  }

  let sign = parseSign(string: &string)
  let digitScalars = string.advance { isDecimal(scalar: $0) ? $0 : nil }

  if digitScalars.isEmpty {
    return .error(parserError())
  }

  let digits = String(digitScalars)
  guard let unsigned = Int(digits, radix: 10) else {
    return .error(parserError())
  }

  switch sign {
  case .plus:
    return .value(unsigned)
  case .minus:
    return .value(-unsigned)
  }
}

// MARK: - Combine

/// [sign] ['0x'] integer ['.' fraction] ['p' exponent]
///
/// Example for '`0x3.a7p10`':
/// - sign: plus
/// - integer: `[3]`
/// - fraction: `[a, 7] -> [10, 7]`
/// - exponent: `10`
///
/// That gives us:
/// ```
/// (3 + 10./16 + 7./(16**2)) * 2.0 ** 10 =
/// (3 + 0,625 + 0,02734375)  * 1024 =
/// 3,65234375 * 1024 =
/// 3740.0
/// ```
private func combine(sign: FloatingPointSign,
                     integer _integer: HexDigits,
                     fraction _fraction: HexDigits?,
                     exponent _exponent: Int) -> PyResult<Double> {
  // This will also check if coefficient is empty.
  guard let firstCoefficientDigit = _integer.first ?? _fraction?.first else {
    return .error(parserError())
  }

  let integer = ltrimZero(digits: _integer)
  let fraction = rtrimZero(digits: _fraction)

  let isCoeffZero = isCoefficientZero(integer: integer, fraction: fraction)
  if isCoeffZero || _exponent < LONG_MIN / 2 {
    return .value(0.0)
  }

  if _exponent > LONG_MAX / 2 {
    return .error(overflowError())
  }

  let nFractionDigits = fraction?.count ?? 0
  let nDigits = nFractionDigits + integer.count

  // Adjust exponent for fractional part.
  let exponent = _exponent - 4 * nFractionDigits

  // top_exp = 1 more than exponent of most sig. bit of coefficient
  let topExponent: Int = {
    var result = exponent + 4 * (nDigits - 1)

    var digit = firstCoefficientDigit
    while digit != 0 {
      result += 1
      digit /= 2
    }

    return result
  }()

  if topExponent < DBL_MIN_EXP - DBL_MANT_DIG {
    return .value(0.0)
  }

  if topExponent > DBL_MAX_EXP {
    return .error(overflowError())
  }

  // At this point CPython checks if 'exp >= lsb' to decide if we need rounding.
  // We will just assume that we don't need rounding (because we are lazy).

  var significand = 0.0
  for digit in integer {
    significand = 16.0 * significand + Double(digit)
  }
  for digit in fraction ?? [] {
    significand = 16.0 * significand + Double(digit)
  }

  let result = Double(sign: sign, exponent: exponent, significand: significand)
  return .value(result)
}

private func isCoefficientZero(integer: HexDigits.SubSequence,
                               fraction: HexDigits.SubSequence?) -> Bool {
  let isIntegerZero = integer.allSatisfy(isZero(hex:))
  let isFractionZero = fraction?.allSatisfy(isZero(hex:)) ?? true
  return isIntegerZero && isFractionZero
}

// MARK: - Helpers

private func isDecimal(scalar: UnicodeScalar) -> Bool {
  let digit = scalar.asDecimalDigit
  return digit != nil
}

private func isHex(scalar: UnicodeScalar) -> Bool {
  let digit = scalar.asHexDigit
  return digit != nil
}

private func isZero(hex: HexDigit) -> Bool {
  return hex == 0
}

private func ltrimZero(digits: HexDigits) -> HexDigits.SubSequence {
  return digits.drop(while: isZero(hex:))
}

// Overload for optional
private func rtrimZero(digits: HexDigits?) -> HexDigits.SubSequence? {
  return digits.map(rtrimZero(digits:))
}

private func rtrimZero(digits: HexDigits) -> HexDigits.SubSequence {
  return digits.dropLast(while: isZero(hex:))
}

// MARK: - Errors

private func parserError() -> PyBaseException {
  let msg = "invalid hexadecimal floating-point string"
  return Py.newValueError(msg: msg)
}

private func overflowError() -> PyBaseException {
  let msg = "hexadecimal value too large to represent as a float"
  return Py.newOverflowError(msg: msg)
}
