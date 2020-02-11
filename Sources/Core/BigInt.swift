// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// Quote:
//   There is no limit for the length of integer literals apart
//   from what can be stored in available memory.
// In Swift we dont't have such type, so for now we will just use 'Int64'.

// swiftlint:disable file_length

// TODO: Maybe use: https://github.com/apple/swift/blob/master/test/Prototypes/BigInt.swift

public struct BigInt:
  SignedInteger, BinaryInteger,
  Equatable, Hashable, Comparable, Strideable,
  CustomStringConvertible {

  /// Type that will be used as a storage.
  ///
  /// IMPLEMENTATION DETAIL! DO NOT USE!
  public typealias Storage = Int64

  // MARK: - Static properties

  /// A type that represents the words of a binary integer.
  public typealias Words = Storage.Words

  /// A type that can represent the absolute value of any possible value of this type.
  public typealias Magnitude = Storage.Magnitude

  /// The maximum representable integer in this type.
  public static let min = BigInt(Storage.min)

  /// The minimum representable integer in this type.
  public static let max = BigInt(Storage.max)

  // MARK: - Properties

  /// Holds our `BigInt` value.
  private var value: Storage

  /// A collection containing the words of this value’s binary representation,
  /// in order from the least significant to most significant.
  public var words: Words {
    return self.value.words
  }

  /// The magnitude of this value.
  ///
  /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
  public var magnitude: Magnitude {
    return self.value.magnitude
  }

  /// The number of bits used for the underlying binary representation of
  /// values of this type.
  ///
  /// For example: bit width of a `Int64` instance is 64.
  public var bitWidth: Int {
    return self.value.bitWidth
  }

  /// The number of trailing zeros in this value’s binary representation.
  public var trailingZeroBitCount: Int {
    return self.value.trailingZeroBitCount
  }

  /// The number of leading zeros in this value’s binary representation.
  public var leadingZeroBitCount: Int {
    return self.value.leadingZeroBitCount
  }

  /// Number of bits necessary to represent self in binary.
  /// `bitLength` in Python.
  ///
  ///```py
  /// >>> bin(37)
  /// '0b100101'
  /// >>> (37).bit_length()
  /// 6
  ///```
  public var minRequiredWidth: Int {
    if self == 0 {
      return 0
    }

    if self > 0 {
      return self.bitWidth - self.leadingZeroBitCount
    }

    // Reverse two complement -> the same '> 0'
    let reverse = (~self) + 1
    return reverse.bitWidth - reverse.leadingZeroBitCount
  }

  public var description: String {
    return String(describing: self.value)
  }

  // MARK: - Init

  public init() {
    self.value = Storage()
  }

  public init(integerLiteral value: Int) {
    self.value = Int64(value)
  }

  public init<T: BinaryInteger>(_ source: T) {
    self.value = Storage(source)
  }

  public init?<T: BinaryInteger>(exactly source: T) {
    guard let v = Storage(exactly: source) else { return nil }
    self.value = v
  }

  public init<T : BinaryInteger>(truncatingIfNeeded source: T) {
    self.value = Storage(truncatingIfNeeded: source)
  }

  public init<T : BinaryInteger>(clamping source: T) {
    self.value = Storage(clamping: source)
  }

  public init<T: BinaryFloatingPoint>(_ source: T) {
    self.value = Storage(source)
  }

  public init?<T: BinaryFloatingPoint>(exactly source: T) {
    guard let v = Storage(exactly: source) else { return nil }
    self.value = v
  }

  public init?<S: StringProtocol>(_ text: S, radix: Int = 10) {
    guard let value = Storage(text, radix: radix) else {
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

  public static func /= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value /= rhs.value
  }

  public static func % (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value % rhs.value)
  }

  public static func %= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value %= rhs.value
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

  // MARK: - Bit operators

  public static func & (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value & rhs.value)
  }

  public static func &= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value &= rhs.value
  }

  public static func | (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value | rhs.value)
  }

  public static func |= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value |= rhs.value
  }

  public static func ^ (lhs: BigInt, rhs: BigInt) -> BigInt {
    return BigInt(lhs.value ^ rhs.value)
  }

  public static func ^= (lhs: inout BigInt, rhs: BigInt) {
    lhs.value ^= rhs.value
  }

  // MARK: - Strideable

  public func distance(to other: BigInt) -> BigInt {
    return other - self
  }

  public func advanced(by n: BigInt) -> BigInt {
    return self + n
  }
}
