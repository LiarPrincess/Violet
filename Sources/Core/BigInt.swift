// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// Quote:
//   There is no limit for the length of integer literals apart
//   from what can be stored in available memory.
// We don't have that in Swift, so we will aproximate:

// TODOL Maybe use: https://github.com/apple/swift/blob/master/test/Prototypes/BigInt.swift

extension Double {
  public init(_ value: BigInt) {
    self = Double(value.value)
  }
}

extension Int {
  public init?(exactly value: BigInt) {
    guard let v = Int(exactly: value.value) else {
      return nil
    }

    self = v
  }
}

public struct BigInt:
  Equatable, Hashable, Comparable, Strideable,
  SignedNumeric,
  CustomStringConvertible {

  /// The maximum representable integer in this type
  /// (`-Int64.max` due to '-' being unary operator).
  public static let min = BigInt(-Int64.max)
  /// The minimum representable integer in this type (`Int64.max`).
  public static let max = BigInt(Int64.max)

  // MARK: - Properties

  fileprivate var value: Int64

  public var magnitude: UInt64 { return self.value.magnitude }

  public var description: String {
    return String(describing: self.value)
  }

  // MARK: - Init

  public init<T>(_ source: T) where T : BinaryInteger {
    self.value = Int64(source)
  }

  public init<T>(_ source: T) where T : BinaryFloatingPoint {
    self.value = Int64(source)
  }

  public init(integerLiteral value: Int64) {
    self.value = Int64(integerLiteral: value)
  }

  public init?<T>(exactly source: T) where T : BinaryInteger {
    guard let v = Int64(exactly: source) else { return nil }
    self.value = v
  }

  public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
    guard let v = Int64(exactly: source) else { return nil }
    self.value = v
  }

  /// This should be used only by the lexer!
  public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
    guard let value = Int64(text, radix: radix) else {
      return nil
    }
    self.value = value
  }

  // MARK: - Unary operators

  public prefix static func + (value: BigInt) -> BigInt {
    return value
  }

  public static prefix func - (value: BigInt) -> BigInt {
    return BigInt(-value.value)
  }

  public prefix static func ~ (value: BigInt) -> BigInt {
    return BigInt(~value.value)
  }

  // MARK: - Addition operators

  public static func + (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value + rhs.value)
  }

  public static func += (lhs: inout BigInt, rhs: BigInt) {
    lhs.value += rhs.value
  }

  // MARK: - Substraction operators

  public static func - (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value - rhs.value)
  }

  public static func -= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value -= rhs.value
  }

  // MARK: - Multiplication operators

  public static func * (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value * rhs.value)
  }

  public static func *= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value *= rhs.value
  }

  // MARK: - Division operators

  public static func / (lhs: BigInt, rhs:BigInt) -> BigInt {
    return BigInt(lhs.value / rhs.value)
  }

  public static func % (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value % rhs.value)
  }

  // MARK: - Compare operators

  public static func < (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value < rhs.value
  }

  public static func < <RHS>(lhs: BigInt, rhs: RHS) -> Bool where RHS: BinaryInteger {
    return lhs.value < rhs
  }

  public static func <= (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value <= rhs.value
  }

  public static func <= <RHS>(lhs: BigInt, rhs: RHS) -> Bool where RHS: BinaryInteger {
    return lhs.value <= rhs
  }

  public static func > (lhs: BigInt, rhs: BigInt) -> Bool {
    return rhs.value > lhs.value
  }

  public static func > <RHS>(lhs: BigInt, rhs: RHS) -> Bool where RHS: BinaryInteger {
    return lhs.value > rhs
  }

  public static func >= (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value >= rhs.value
  }

  public static func >= <RHS>(lhs: BigInt, rhs: RHS) -> Bool where RHS: BinaryInteger {
    return lhs.value >= rhs
  }

  // MARK: - Shift operators

  public static func << (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value << rhs.value)
  }

  public static func << <RHS>(lhs: BigInt, rhs: RHS) -> BigInt where RHS: BinaryInteger {
    return BigInt(lhs.value << rhs)
  }

  public static func <<= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value <<= rhs.value
  }

  public static func <<= <RHS>(lhs: inout BigInt, rhs: RHS) where RHS: BinaryInteger {
    lhs.value <<= rhs
  }

  public static func >> (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value >> rhs.value)
  }

  public static func >> <RHS>(lhs: BigInt, rhs: RHS) -> BigInt where RHS: BinaryInteger {
    return BigInt(lhs.value >> rhs)
  }

  public static func >>= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value >>= rhs.value
  }

  public static func >>= <RHS>(lhs: inout BigInt, rhs: RHS) where RHS: BinaryInteger {
    lhs.value >>= rhs
  }

  // MARK: - Binary operators

  public static func & (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value & rhs.value)
  }

  public static func | (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value | rhs.value)
  }

  public static func ^ (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value ^ rhs.value)
  }

  // MARK: - Strideable

  public func distance(to other: BigInt) -> BigInt {
    return other - self
  }

  public func advanced(by n: BigInt) -> BigInt {
    return self + n
  }
}
