import Foundation
import VioletCore

// cSpell:ignore floatobject TOHEX ffffp inity

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://docs.python.org/3/library/stdtypes.html#float.fromhex <- THIS!

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

// MARK: - Hex

/// `#define TOHEX_NBITS DBL_MANT_DIG + 3 - (DBL_MANT_DIG+2)%4`
private let hexBitCount = DBL_MANT_DIG + 3 - (DBL_MANT_DIG + 2) % 4

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

  // sourcery: pymethod = hex, doc = hexDoc
  internal static func hex(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "hex")
    }

    let value = zelf.value

    if value.isNaN || value.isInfinite {
      return Self.__repr__(py, zelf: zelf.asObject)
    }

    if value.isZero {
      let string = value.sign == .plus ? "0x0.0p+0" : "-0x0.0p+0"
      let pyString = py.intern(string: string)
      return .value(pyString.asObject)
    }

    let sign = value < 0 ? "-" : ""
    var result = "\(sign)0x"

    let frexp = Frexp(value: Swift.abs(value))
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

    for _ in 0..<((hexBitCount - 1) / 4) {
      mantissa *= 16.0
      appendMantissaDigit()
    }

    // exponent (decimal!)
    result.append("p")
    let exponentAbs = Swift.abs(exponent)
    result.append(exponent < 0 ? "-" : "+")
    result.append(String(exponentAbs, radix: 10, uppercase: false))

    return PyResult(py, result)
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
  internal static func fromhex(_ py: Py, type: PyType, value: PyObject) -> PyResult {
    guard let stringObject = py.cast.asString(value) else {
      // This message looks weird, but argument name is 'string'
      let message = "fromhex(): string has to have str type, not \(value.typeName)"
      return .typeError(py, message: message)
    }

    let string = stringObject.value
    switch Self.fromHex(py, string: string) {
    case let .value(double):
      let pyFloat = py.newFloat(double)

      // Fast path for 'float'
      if Self.isBuiltinFloatType(py, type: type) {
        return .value(pyFloat.asObject)
      }

      let callResult = py.call(callable: type.asObject, arg: pyFloat.asObject)
      return callResult.asResult
    case let .error(e):
      return .error(e)
    }
  }

  /// Raw `fromHex` that works on Swift values, use this for debug.
  private static func fromHex(_ py: Py, string _string: String) -> PyResultGen<Double> {
    var string = FromHexString(string: _string)
    if string.isEmpty {
      let error = Self.parserError(py)
      return .error(error.asBaseException)
    }

    switch self.parseInfinityOrNan(py, string: string) {
    case .value(let d): return .value(d)
    case .notInfinityOrNan: break // Try other
    case .error(let e): return .error(e)
    }

    // Format: [sign] ['0x'] integer ['.' fraction] ['p' exponent]

    let sign = self.parseSign(string: &string)
    _ = string.advanceIf("0x") // if not then nop

    // Integer and fraction are strings of hexadecimal (!) digits
    let integer = self.parseInteger(string: &string)
    let fraction = self.parseFraction(string: &string)

    // Skipping the 'insane' check from CPython, because we are lazy

    // Exponent is decimal
    let exponent: Int
    switch self.parseExponent(py, string: &string) {
    case .value(let e): exponent = e
    case .none: exponent = 0
    case .error(let e): return .error(e)
    }

    // At this point we should have exhausted the whole 'string'
    guard string.isEmpty else {
      let error = Self.parserError(py)
      return .error(error.asBaseException)
    }

    return self.combine(py, sign: sign, integer: integer, fraction: fraction, exponent: exponent)
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

  private static func parseSign(string: inout FromHexString) -> FloatingPointSign {
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
  private static func parseInfinityOrNan(_ py: Py, string: FromHexString) -> InfinityOrNan {
    var copy = string
    let sign = self.parseSign(string: &copy)

    if copy.advanceIf("inf") {
      _ = copy.advanceIf("inity")

      guard copy.isEmpty else {
        let error = Self.parserError(py)
        return .error(error.asBaseException)
      }

      return .value(Double(sign: sign, magnitudeOf: Double.infinity))
    }

    if copy.advanceIf("nan") {
      guard copy.isEmpty else {
        let error = Self.parserError(py)
        return .error(error.asBaseException)
      }

      return .value(Double(sign: sign, magnitudeOf: Double.nan))
    }

    return .notInfinityOrNan
  }

  // MARK: - Integer

  private typealias HexDigit = Int
  private typealias HexDigits = [HexDigit]

  /// Integer and fraction are strings of hexadecimal (!) digits
  private static func parseInteger(string: inout FromHexString) -> HexDigits {
    return string.advance { $0.asHexDigit }
  }

  // MARK: - Fraction

  /// Integer and fraction are strings of hexadecimal (!) digits
  private static func parseFraction(string: inout FromHexString) -> HexDigits? {
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
  private static func parseExponent(_ py: Py, string: inout FromHexString) -> Exponent {
    guard string.advanceIf("p") else {
      return .none
    }

    let sign = self.parseSign(string: &string)
    let digitScalars = string.advance { isDecimal(scalar: $0) ? $0 : nil }

    if digitScalars.isEmpty {
      let error = Self.parserError(py)
      return .error(error.asBaseException)
    }

    let digits = String(digitScalars)
    guard let unsigned = Int(digits, radix: 10) else {
      let error = Self.parserError(py)
      return .error(error.asBaseException)
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
  private static func combine(_ py: Py,
                              sign: FloatingPointSign,
                              integer _integer: HexDigits,
                              fraction _fraction: HexDigits?,
                              exponent _exponent: Int) -> PyResultGen<Double> {
    // This will also check if coefficient is empty.
    guard let firstCoefficientDigit = _integer.first ?? _fraction?.first else {
      let error = Self.parserError(py)
      return .error(error.asBaseException)
    }

    let integer = self.ltrimZero(digits: _integer)
    let fraction = self.rtrimZero(digits: _fraction)

    let isCoeffZero = self.isCoefficientZero(integer: integer, fraction: fraction)
    if isCoeffZero || _exponent < LONG_MIN / 2 {
      return .value(0.0)
    }

    if _exponent > LONG_MAX / 2 {
      let error = Self.overflowError(py)
      return .error(error.asBaseException)
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
      let error = Self.overflowError(py)
      return .error(error.asBaseException)
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

  private static func isCoefficientZero(integer: HexDigits.SubSequence,
                                        fraction: HexDigits.SubSequence?) -> Bool {
    let isIntegerZero = integer.allSatisfy(self.isZero(hex:))
    let isFractionZero = fraction?.allSatisfy(self.isZero(hex:)) ?? true
    return isIntegerZero && isFractionZero
  }

  // MARK: - Helpers

  private static func isDecimal(scalar: UnicodeScalar) -> Bool {
    let digit = scalar.asDecimalDigit
    return digit != nil
  }

  private static func isHex(scalar: UnicodeScalar) -> Bool {
    let digit = scalar.asHexDigit
    return digit != nil
  }

  private static func isZero(hex: HexDigit) -> Bool {
    return hex == 0
  }

  private static func ltrimZero(digits: HexDigits) -> HexDigits.SubSequence {
    return digits.drop(while: self.isZero(hex:))
  }

  // Overload for optional
  private static func rtrimZero(digits: HexDigits?) -> HexDigits.SubSequence? {
    return digits.map(self.rtrimZero(digits:))
  }

  private static func rtrimZero(digits: HexDigits) -> HexDigits.SubSequence {
    return digits.dropLast(while: self.isZero(hex:))
  }

  // MARK: - Errors

  private static func parserError(_ py: Py) -> PyValueError {
    let message = "invalid hexadecimal floating-point string"
    return py.newValueError(message: message)
  }

  private static func overflowError(_ py: Py) -> PyOverflowError {
    let message = "hexadecimal value too large to represent as a float"
    return py.newOverflowError(message: message)
  }
}
