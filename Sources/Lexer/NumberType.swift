// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals

// MARK: - NumberType

public enum NumberType: CustomStringConvertible {
  case binary
  case octal
  case decimal
  case hexadecimal

  public var description: String {
    switch self {
    case .binary: return "binary"
    case .octal: return "octal"
    case .decimal: return "decimal"
    case .hexadecimal: return "hexadecimal"
    }
  }
}

// MARK: - NumberBase

internal protocol NumberBase {

  /// Type
  static var type: NumberType { get }

  /// Base
  static var radix: Int { get }

  /// Does given character represent valid digit?
  static func isDigit(_ c: UnicodeScalar) -> Bool
}

// MARK: - Binary

internal enum BinaryNumber: NumberBase {

  internal static var type = NumberType.binary

  internal static var radix = 2

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return c == "0" || c == "1"
  }
}

// MARK: - Octal

internal enum OctalNumber: NumberBase {

  internal static var type = NumberType.octal

  internal static var radix = 8

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return "0" <= c && c <= "7"
  }
}

// MARK: - Decimal

internal enum DecimalNumber: NumberBase {

  internal static var type = NumberType.decimal

  internal static var radix = 10

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return "0" <= c && c <= "9"
  }
}

// MARK: - Hex

internal enum HexNumber: NumberBase {

  internal static var type = NumberType.hexadecimal

  internal static var radix = 16

  internal static func isDigit(_ c: UnicodeScalar) -> Bool {
    return ("0" <= c && c <= "9")
        || ("a" <= c && c <= "f")
        || ("A" <= c && c <= "F")
  }
}
