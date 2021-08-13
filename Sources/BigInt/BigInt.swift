// swiftlint:disable file_length

/// `Int` but bigger. Much bigger…
public struct BigInt: SignedInteger,
                      Comparable, Hashable, Strideable,
                      CustomStringConvertible, CustomDebugStringConvertible {

  // MARK: - Properties

  internal enum Storage {
    case smi(Smi)
    case heap(BigIntHeap)
  }

  internal private(set) var value: Storage

  public var isOdd: Bool {
    return !self.isEven
  }

  public var isEven: Bool {
    switch self.value {
    case let .smi(smi):
      return smi.isEven
    case let .heap(heap):
      return heap.isEven
    }
  }

  public var isZero: Bool {
    switch self.value {
    case let .smi(smi):
      return smi.isZero
    case let .heap(heap):
      return heap.isZero
    }
  }

  public var isOne: Bool {
    switch self.value {
    case let .smi(smi):
      return smi.value == 1
    case let .heap(heap):
      return heap.isPositive && heap.hasMagnitudeOfOne
    }
  }

  public var isPositiveOrZero: Bool {
    return !self.isNegative
  }

  public var isNegative: Bool {
    switch self.value {
    case let .smi(smi):
      return smi.isNegative
    case let .heap(heap):
      return heap.isNegative
    }
  }

  /// The magnitude of this value.
  ///
  /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
  public var magnitude: BigInt {
    switch self.value {
    case let .smi(smi):
      return smi.magnitude
    case let .heap(heap):
      return heap.magnitude
    }
  }

  // MARK: - Init

  public init() {
    self.value = .smi(Smi(0))
  }

  public init<T: BinaryInteger>(_ value: T) {
    if let smi = Smi(value) {
      self.value = .smi(smi)
    } else {
      let heap = BigIntHeap(value)
      self.value = .heap(heap)
    }
  }

  public init(integerLiteral value: Int) {
    self.init(value)
  }

  public init?<T: BinaryInteger>(exactly source: T) {
    self.init(source)
  }

  public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
    self.init(source)
  }

  public init<T: BinaryInteger>(clamping source: T) {
    self.init(source)
  }

  public init<T: BinaryFloatingPoint>(_ source: T) {
    let heap = BigIntHeap(source)
    self.value = .heap(heap)
    self.downgradeToSmiIfPossible()
  }

  public init?<T: BinaryFloatingPoint>(exactly source: T) {
    guard let heap = BigIntHeap(exactly: source) else {
      return nil
    }

    self.value = .heap(heap)
    self.downgradeToSmiIfPossible()
  }

  internal init(smi value: Smi.Storage) {
    self.value = .smi(Smi(value))
  }

  /// This will downgrade to `Smi` if possible
  internal init(_ value: BigIntHeap) {
    self.value = .heap(value)
    self.downgradeToSmiIfPossible()
  }

  // MARK: - Downgrade

  private mutating func downgradeToSmiIfPossible() {
    switch self.value {
    case .smi:
      break
    case .heap(let heap):
      if let smi = heap.asSmiIfPossible() {
        self.value = .smi(smi)
      }
    }
  }

  // MARK: - Unary operators

  public static prefix func + (value: BigInt) -> BigInt {
    return value
  }

  public static prefix func - (value: BigInt) -> BigInt {
    switch value.value {
    case .smi(let smi):
      return smi.negated
    case .heap(var heap):
      // 'heap' is already a copy, so we can modify it without touching the 'value'
      heap.negate()
      return BigInt(heap)
    }
  }

  public static prefix func ~ (value: BigInt) -> BigInt {
    switch value.value {
    case .smi(let smi):
      return smi.inverted
    case .heap(var heap):
      // 'heap' is already a copy, so we can modify it without touching the 'value'
      heap.invert()
      return BigInt(heap)
    }
  }

  // MARK: - Add

  public static func + (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.add(other: rhs)

    case (.smi(let smi), .heap(var heap)),
         (.heap(var heap), .smi(let smi)):
      // 'heap' is already a copy, so we can modify it without touching the 'value'
      heap.add(other: smi.value)
      return BigInt(heap)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.add(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func += (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.add(other: rhs)
      lhs.value = result.value

    case (.smi(let lhsSmi), .heap(var rhs)):
      // Unfortunately in this case we have to copy 'rhs'
      rhs.add(other: lhsSmi.value)
      lhs.value = .heap(rhs)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.add(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.add(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Sub

  public static func - (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.sub(other: rhs)

    case (.smi(let lhs), .heap(var rhs)):
      // x - y = x + (-y) = (-y) + x
      rhs.negate()
      rhs.add(other: lhs.value)
      return BigInt(rhs)

    case (.heap(var lhs), .smi(let rhs)):
      lhs.sub(other: rhs.value)
      return BigInt(lhs)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.sub(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func -= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.sub(other: rhs)
      lhs.value = result.value

    case (.smi(let lhsSmi), .heap(var rhs)):
      // Unfortunately in this case we have to copy 'rhs'
      // x - y = x + (-y) = (-y) + x
      rhs.negate()
      rhs.add(other: lhsSmi.value)
      lhs.value = .heap(rhs)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.sub(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.sub(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Mul

  public static func * (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.mul(other: rhs)

    case (.smi(let smi), .heap(var heap)),
         (.heap(var heap), .smi(let smi)):
      heap.mul(other: smi.value)
      return BigInt(heap)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.mul(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func *= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.mul(other: rhs)
      lhs.value = result.value

    case (.smi(let lhsSmi), .heap(var rhs)):
      // Unfortunately in this case we have to copy 'rhs'
      rhs.mul(other: lhsSmi.value)
      lhs.value = .heap(rhs)
      lhs.downgradeToSmiIfPossible() // probably not

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.mul(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible() // probably not

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.mul(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible() // probably not
    }
  }

  // MARK: - Div

  public static func / (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.div(other: rhs)

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      _ = lhsHeap.div(other: rhs)
      return BigInt(lhsHeap)

    case (.heap(var heap), .smi(let smi)):
      _ = heap.div(other: smi.value)
      return BigInt(heap)

    case (.heap(var lhs), .heap(let rhs)):
      _ = lhs.div(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func /= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.div(other: rhs)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      _ = lhsHeap.div(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      _ = lhsHeap.div(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      _ = lhsHeap.div(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Mod

  public static func % (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.rem(other: rhs)

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.rem(other: rhs)
      return BigInt(lhsHeap)

    case (.heap(var lhs), .smi(let rhs)):
      lhs.rem(other: rhs.value)
      return BigInt(lhs)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.rem(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func %= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.rem(other: rhs)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.rem(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.rem(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.rem(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Div mod

  public typealias DivMod = (quotient: BigInt, remainder: BigInt)

  public func quotientAndRemainder(dividingBy other: BigInt) -> DivMod {
    func bothHeap(lhs: BigIntHeap, rhs: BigIntHeap) -> DivMod {
      let result = lhs.divRem(other: rhs)
      let quotient = BigInt(result.quotient)
      let remainder = BigInt(result.remainder)
      return (quotient: quotient, remainder: remainder)
    }

    switch (self.value, other.value) {
    case let (.smi(lhs), .smi(rhs)):
      // This is so cheap that we can do it in a trivial way
      let quotient = lhs.div(other: rhs)
      let remainder = lhs.rem(other: rhs)
      return (quotient: quotient, remainder: remainder)

    case let (.smi(lhs), .heap(rhs)):
      // We need to promote 'lhs' to heap
      let lhsHeap = BigIntHeap(lhs.value)
      return bothHeap(lhs: lhsHeap, rhs: rhs)

    case let (.heap(lhs), .smi(rhs)):
      let result = lhs.divRem(other: rhs.value)
      let quotient = BigInt(result.quotient)
      let remainder = BigInt(smi: result.remainder)
      return (quotient: quotient, remainder: remainder)

    case let (.heap(lhs), .heap(rhs)):
      return bothHeap(lhs: lhs, rhs: rhs)
    }
  }

  // MARK: - Power

  public func power(exponent: BigInt) -> BigInt {
    precondition(exponent >= 0, "Exponent must be positive")

    if exponent.isZero {
      return BigInt(1)
    }

    if exponent.isOne {
      return self
    }

    // This has to be after 'exp == 0', because 'pow(0, 0) -> 1'
    if self.isZero {
      return 0
    }

    var base = self
    var exponent = exponent
    var result = BigInt(1)

    // Eventually we will arrive to most significant '1'
    while !exponent.isOne {
      if exponent.isOdd {
        result *= base
      }

      base *= base
      exponent >>= 1 // Basically divided by 2, but faster
    }

    // Most significant '1' is odd:
    result *= base
    return result
  }

  // MARK: - And

  public static func & (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.and(other: rhs)

    case (.smi(let smi), .heap(var heap)),
         (.heap(var heap), .smi(let smi)):
      heap.and(other: smi.value)
      return BigInt(heap)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.and(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func &= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.and(other: rhs)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.and(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.and(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.and(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Or

  public static func | (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.or(other: rhs)

    case (.smi(let smi), .heap(var heap)),
         (.heap(var heap), .smi(let smi)):
      heap.or(other: smi.value)
      return BigInt(heap)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.or(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func |= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.or(other: rhs)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.or(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.or(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.or(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Xor

  public static func ^ (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.xor(other: rhs)

    case (.smi(let smi), .heap(var heap)),
         (.heap(var heap), .smi(let smi)):
      heap.xor(other: smi.value)
      return BigInt(heap)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.xor(other: rhs)
      return BigInt(lhs)
    }
  }

  public static func ^= (lhs: inout BigInt, rhs: BigInt) {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.xor(other: rhs)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.xor(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.xor(other: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.xor(other: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Shift left

  public static func << (lhs: BigInt, rhs: BigInt) -> BigInt {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs.shiftLeft(count: rhs.value)

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.shiftLeft(count: rhs)
      return BigInt(lhsHeap)

    case (.heap(var lhs), .smi(let rhs)):
      lhs.shiftLeft(count: rhs.value)
      return BigInt(lhs)

    case (.heap(var lhs), .heap(let rhs)):
      lhs.shiftLeft(count: rhs)
      return BigInt(lhs)
    }
  }

  public static func <<= <T: BinaryInteger>(lhs: inout BigInt, rhs: T) {
    let rhsBig = BigInt(rhs)

    switch (lhs.value, rhsBig.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.shiftLeft(count: rhs.value)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.shiftLeft(count: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.shiftLeft(count: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.shiftLeft(count: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - Shift right

  public static func >> (lhs: BigInt, rhs: BigInt) -> BigInt {
   switch (lhs.value, rhs.value) {
   case let (.smi(lhs), .smi(rhs)):
     return lhs.shiftRight(count: rhs.value)

   case let (.smi(lhsSmi), .heap(rhs)):
     var lhsHeap = BigIntHeap(lhsSmi.value)
     lhsHeap.shiftRight(count: rhs)
     return BigInt(lhsHeap)

   case (.heap(var lhs), .smi(let rhs)):
     lhs.shiftRight(count: rhs.value)
     return BigInt(lhs)

   case (.heap(var lhs), .heap(let rhs)):
     lhs.shiftRight(count: rhs)
     return BigInt(lhs)
   }
  }

  public static func >>= <T: BinaryInteger>(lhs: inout BigInt, rhs: T) {
    let rhsBig = BigInt(rhs)

    switch (lhs.value, rhsBig.value) {
    case let (.smi(lhsSmi), .smi(rhs)):
      let result = lhsSmi.shiftRight(count: rhs.value)
      lhs.value = result.value

    case let (.smi(lhsSmi), .heap(rhs)):
      var lhsHeap = BigIntHeap(lhsSmi.value)
      lhsHeap.shiftRight(count: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .smi(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.shiftRight(count: rhs.value)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()

    case (.heap(var lhsHeap), .heap(let rhs)):
      Self.releaseBufferToPreventCOW(&lhs)
      lhsHeap.shiftRight(count: rhs)
      lhs.value = .heap(lhsHeap)
      lhs.downgradeToSmiIfPossible()
    }
  }

  // MARK: - String

  public var description: String {
    switch self.value {
    case let .smi(smi):
      return smi.description
    case let .heap(heap):
      return heap.description
    }
  }

  public var debugDescription: String {
    let value = String(self, radix: 10, uppercase: false)

    let storage: String = {
      switch self.value {
      case let .smi(smi):
        return smi.debugDescription
      case let .heap(heap):
        return heap.debugDescription
      }
    }()

    return "\(value) (storage: \(storage))"
  }

  // 'toString' because we Java now
  internal func toString(radix: Int, uppercase: Bool) -> String {
    precondition(2 <= radix && radix <= 36, "radix must be in range 2...36")
    switch self.value {
    case let .smi(smi):
      return smi.toString(radix: radix, uppercase: uppercase)
    case let .heap(heap):
      return heap.toString(radix: radix, uppercase: uppercase)
    }
  }

  // MARK: - Equatable

  public static func == (lhs: BigInt, rhs: BigInt) -> Bool {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs == rhs

    case let (.smi(smi), .heap(heap)),
         let (.heap(heap), .smi(smi)):
      return heap == smi.value

    case let (.heap(lhs), .heap(rhs)):
      return lhs == rhs
    }
  }

  // MARK: - Comparable

  public static func < (lhs: BigInt, rhs: BigInt) -> Bool {
    switch (lhs.value, rhs.value) {
    case let (.smi(lhs), .smi(rhs)):
      return lhs < rhs

    case let (.smi(smi), .heap(heap)):
      // 'smi < heap' which is the same as 'heap > smi'
      // negation:
      // 'heap <= smi' which is the same as 'heap < smi or heap == smi'
      let heapIsLessOrEqual = heap < smi.value || heap == smi.value
      let heapIsGreater = !heapIsLessOrEqual
      return heapIsGreater

    case let (.heap(heap), .smi(smi)):
      return heap < smi.value

    case let (.heap(lhs), .heap(rhs)):
      return lhs < rhs
    }
  }

  // MARK: - Hashable

  public func hash(into hasher: inout Hasher) {
    switch self.value {
    case let .smi(smi):
      smi.hash(into: &hasher)
    case let .heap(heap):
      heap.hash(into: &hasher)
    }
  }

  // MARK: - Release buffer to prevent COW

  /// In `inout` operators we have `lhs: inout BigInt`, which we pattern match
  /// on `lhs.value` to extract `BigIntHeap`. This pattern matching increases
  /// `BigIntStorage.buffer` reference count to `2`.
  /// Then any operation done on this `BigIntStorage` would force COW,
  /// which kinda defeats the purpose of `inout`.
  ///
  /// To solve this we will temporary assign `lhs.value = smi.zero`.
  /// This will require some `ARC` traffic, but we probably need to fetch this
  /// object anyway (when we do not have `weak` refs, then `ref` count is stored
  /// as a 2nd word in object).
  ///
  /// Yes, it is a HACK.
  private static func releaseBufferToPreventCOW(_ int: inout BigInt) {
    let zero = Smi(Smi.Storage.zero)
    int.value = .smi(zero)
  }
}
