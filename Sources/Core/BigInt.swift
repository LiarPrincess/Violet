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

  public init?(exactly: BigInt) {
    guard let d = Double(exactly: exactly.value) else {
      return nil
    }
    self = d
  }
}

extension BinaryInteger {
  public init?(exactly value: BigInt) {
    guard let v = Self(exactly: value.value) else {
      return nil
    }

    self = v
  }
}

extension String {
  public init(_ value: BigInt, radix: Int = 10, uppercase: Bool = false) {
    self.init(value.value, radix: radix, uppercase: uppercase)
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

  /// The magnitude of this value.
  ///
  /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
  public var magnitude: UInt64 { return self.value.magnitude }

  public var sign: Sign {
    if self.value > 0 { return .positive }
    if self.value < 0 { return .negative }
    return .zero
  }

  public enum Sign {
    case zero
    case positive
    case negative
  }

  /// The number of bits in the binary representation of this value.
  public var bitWidth: Int {
    return self.value.bitWidth
  }

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
    return lhs.value > rhs.value
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

  // MARK: - Equatable

  // If we use default provided by Swift, then it will crash on
  // `if x == 0 { things... }`, where `x` is BigInt.
  // We have such cases in our unit tests. :/
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value
  }
}
