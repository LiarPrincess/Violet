// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals

private let ascii0: UInt32 = 48
private let asciia: UInt32 = 97
private let asciiA: UInt32 = 65

// MARK: - NumberType

internal protocol NumberType {

  /// Base
  static var radix: UInt32 { get }

  /// Does given unicode scalar represent valid digit?
  static func isDigit(_ c: UnicodeScalar) -> Bool

  /// Get digit value
  static func parseDigit(_ c: UnicodeScalar) -> UInt32
}

// MARK: - Binary

internal enum BinaryNumber: NumberType {

  internal static var radix: UInt32 = 2

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return c == "0" || c == "1"
  }

  internal static func parseDigit(_ c: UnicodeScalar) -> UInt32 {
    assert(isDigit(c))
    return c.value - ascii0
  }
}

// MARK: - Octal

internal enum OctalNumber: NumberType {

  internal static var radix: UInt32 = 8

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return "0" <= c && c <= "7"
  }

  internal static func parseDigit(_ c: UnicodeScalar) -> UInt32 {
    assert(isDigit(c))
    return c.value - ascii0
  }
}

// MARK: - Decimal

internal enum DecimalNumber: NumberType {

  internal static var radix: UInt32 = 10

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return "0" <= c && c <= "9"
  }

  internal static func parseDigit(_ c: UnicodeScalar) -> UInt32 {
    assert(isDigit(c))
    return c.value - ascii0
  }
}

// MARK: - Hex

internal enum HexNumber: NumberType {

  internal static var radix: UInt32 = 16

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return ("0" <= c && c <= "9")
        || ("a" <= c && c <= "f")
        || ("A" <= c && c <= "F")
  }

  internal static func parseDigit(_ c: UnicodeScalar) -> UInt32 {
    assert(isDigit(c))
    switch c {
    case "0"..."9": return c.value - ascii0
    case "a"..."f": return c.value - asciia + 10
    case "A"..."F": return c.value - asciiA + 10
    default: return 0 // not possible, we checked it with self.isHex
    }
  }
}
