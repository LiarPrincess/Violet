// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// Quote:
//   There is no limit for the length of integer literals apart
//   from what can be stored in available memory.
// In Swift we dont't have such type, so for now we will just use 'Int64'.

// TODO: Maybe use: https://github.com/apple/swift/blob/master/test/Prototypes/BigInt.swift

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

  /// Type that will be used as a storage.
  fileprivate typealias Storage = Int64

  // MARK: - Static properties

  /// The maximum representable integer in this type.
  public static let min = BigInt(Storage.min)

  /// The minimum representable integer in this type.
  public static let max = BigInt(Storage.max)

  /// The number of bits used for the underlying binary representation of
  /// values of this type.
  ///
  /// For example: bit width of a `Int64` instance is 64.
  public static let bitWidth = Storage.bitWidth

  // MARK: - Properties

  fileprivate var value: Storage

  /// The magnitude of this value.
  ///
  /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
  public var magnitude: UInt64 {
    return self.value.magnitude
  }

  /// The number of leading zeros in this value's binary representation.
  ///
  /// For example, in an integer type with a `bitWidth` value of 8,
  /// the number *31* has three leading zeros.
  ///
  ///     let x: Int8 = 0b0001_1111
  ///     // x == 31
  ///     // x.leadingZeroBitCount == 3
  public var leadingZeroBitCount: Int {
    self.value.leadingZeroBitCount
  }

  /// Minimum number of bits needed to represent this value.
  /// `bitLength` in Python.
  public var minRequiredWidth: Int {
    return BigInt.bitWidth - self.value.leadingZeroBitCount
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

  // MARK: - Binary operators

  public static func + (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value + rhs.value)
  }

  public static func += (lhs: inout BigInt, rhs: BigInt) {
    lhs.value += rhs.value
  }

  public static func - (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value - rhs.value)
  }

  public static func -= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value -= rhs.value
  }

  public static func * (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value * rhs.value)
  }

  public static func *= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value *= rhs.value
  }

  public static func / (lhs: BigInt, rhs:BigInt) -> BigInt {
    return BigInt(lhs.value / rhs.value)
  }

  public static func % (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value % rhs.value)
  }

  // MARK: - Equatable

  // If we use default provided by Swift, then it will crash on
  // `if x == 0 { things... }`, where `x` is BigInt.
  // We have such cases in our unit tests. :/
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value
  }

  // MARK: - Compare operators

  public static func < (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value < rhs.value
  }

  public static func < <RHS: BinaryInteger>(lhs: BigInt, rhs: RHS) -> Bool {
    return lhs.value < rhs
  }

  public static func <= (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value <= rhs.value
  }

  public static func <= <RHS: BinaryInteger>(lhs: BigInt, rhs: RHS) -> Bool {
    return lhs.value <= rhs
  }

  public static func > (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value > rhs.value
  }

  public static func > <RHS: BinaryInteger>(lhs: BigInt, rhs: RHS) -> Bool {
    return lhs.value > rhs
  }

  public static func >= (lhs: BigInt, rhs: BigInt) -> Bool {
    return lhs.value >= rhs.value
  }

  public static func >= <RHS: BinaryInteger>(lhs: BigInt, rhs: RHS) -> Bool {
    return lhs.value >= rhs
  }

  // MARK: - Shift operators

  public static func << (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value << rhs.value)
  }

  public static func << <RHS: BinaryInteger>(lhs: BigInt, rhs: RHS) -> BigInt {
    return BigInt(lhs.value << rhs)
  }

  public static func <<= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value <<= rhs.value
  }

  public static func <<= <RHS: BinaryInteger>(lhs: inout BigInt, rhs: RHS) {
    lhs.value <<= rhs
  }

  public static func >> (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value >> rhs.value)
  }

  public static func >> <RHS: BinaryInteger>(lhs: BigInt, rhs: RHS) -> BigInt {
    return BigInt(lhs.value >> rhs)
  }

  public static func >>= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value >>= rhs.value
  }

  public static func >>= <RHS: BinaryInteger>(lhs: inout BigInt, rhs: RHS) {
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
