// swiftlint:disable empty_count

/// Small integer, named after similar type in `V8`.
internal struct Smi: Hashable, CustomStringConvertible, CustomDebugStringConvertible {

  internal typealias Storage = Int32

  // MARK: - Properties

  internal let value: Storage

  internal var isZero: Bool {
    return self.value.isZero
  }

  internal var isNegative: Bool {
    return self.value.isNegative
  }

  internal var isPositive: Bool {
    return self.value.isPositive
  }

  internal var isEven: Bool {
    return self.value & 0b1 == 0
  }

  internal var magnitude: BigInt {
    let result = self.value.magnitude
    return BigInt(result)
  }

  // MARK: - Init

  internal init(_ value: Storage) {
    self.value = value
  }

  internal init?<T: BinaryInteger>(_ value: T) {
    guard let storage = Storage(exactly: value) else {
      return nil
    }

    self.value = storage
  }

  // MARK: - Unary operations

  internal var negated: BigInt {
    // Binary numbers have bigger range on the negative side.
    if self.value == Storage.min {
      var selfHeap = self.asHeap()
      selfHeap.negate()
      return BigInt(selfHeap)
    }

    return BigInt(smi: -self.value)
  }

  internal var inverted: BigInt {
    return BigInt(smi: ~self.value)
  }

  // MARK: - Add

  internal func add(other: Smi) -> BigInt {
    let (result, overflow) = self.value.addingReportingOverflow(other.value)
    if !overflow {
      return BigInt(smi: result)
    }

    // Binary numbers have bigger range on the negative side.
    if self.value == Storage.min && other.value == Storage.min {
      var selfHeap = self.asHeap()
      selfHeap.shiftLeft(count: Storage(1)) // * 2
      return BigInt(selfHeap)
    }

    return self.handleAddSubOverflow(result: result)
  }

  private func handleAddSubOverflow(result: Storage) -> BigInt {
    // If we were positive:
    // - we only can overflow into positive values
    // - 'result' is negative, but it is value is exactly as we want,
    //    we just need it to treat as unsigned
    //
    // If we were negative:
    // - we only can overflow into negative values
    // - 'result' is positive, we have to 2 compliment it and treat as unsigned
    //
    // If we were zero:
    // - well… how did we overflow?

    let x = self.isNegative ? ((~result) &+ 1) : result
    let unsigned = Storage.Magnitude(bitPattern: x)

    var heap = BigIntHeap(unsigned)
    if self.isNegative {
      heap.negate()
    }

    return BigInt(heap)
  }

  // MARK: - Sub

  internal func sub(other: Smi) -> BigInt {
    let (result, overflow) = self.value.subtractingReportingOverflow(other.value)
    if !overflow {
      return BigInt(smi: result)
    }

    return self.handleAddSubOverflow(result: result)
  }

  // MARK: - Mul

  // `1` at front, `0` for the rest
  private static let mostSignificantBitMask: Storage.Magnitude = {
    let shift = Storage.Magnitude.bitWidth - 1
    return 1 << shift
  }()

  /// `1` for all
  private static let allOneMask: Storage = {
    let allZero = Storage(0)
    return ~allZero
  }()

  internal func mul(other: Smi) -> BigInt {
    let (high, low) = self.value.multipliedFullWidth(by: other.value)

    assert(Int.bitWidth > Storage.bitWidth)
    let result = Int(high) << Storage.bitWidth | Int(low)

    if let smi = Storage(exactly: result) {
      return BigInt(smi: smi)
    }

    let heap = BigIntHeap(result)
    return BigInt(heap)
  }

  // MARK: - Div

  internal func div(other: Smi) -> BigInt {
    let (result, overflow) = self.value.dividedReportingOverflow(by: other.value)
    if !overflow {
      return BigInt(smi: result)
    }

    // AFAIK we can overflow in 2 cases:
    // - 'other' is 0
    // - 'Storage.min / -1' -> value 1 greater than Storage.max

    precondition(other.value != 0, "Division by zero") // Well, hello there…

    assert(self.value == Storage.min)
    assert(other.value == Storage(-1))
    let maxPlus1 = Storage.max.magnitude + 1
    let heap = BigIntHeap(maxPlus1)
    return BigInt(heap)
  }

  // MARK: - Mod

  internal func rem(other: Smi) -> BigInt {
    let (result, overflow) =
      self.value.remainderReportingOverflow(dividingBy: other.value)

    if !overflow {
      return BigInt(smi: result)
    }

    // This has the same assumptions for overflow as 'div'.
    // Please check 'div' for details.

    precondition(other.value != 0, "Division by zero") // Well, hello there…

    assert(self.value == Storage.min)
    assert(other.value == Storage(-1))
    return BigInt(smi: 0)
  }

  // MARK: - And

  internal func and(other: Smi) -> BigInt {
    return BigInt(smi: self.value & other.value)
  }

  // MARK: - Or

  internal func or(other: Smi) -> BigInt {
    return BigInt(smi: self.value | other.value)
  }

  // MARK: - Xor

  internal func xor(other: Smi) -> BigInt {
    return BigInt(smi: self.value ^ other.value)
  }

  // MARK: - Shift left

  internal func shiftLeft<T: BinaryInteger>(count: T) -> BigInt {
    if count == 0 {
      return BigInt(smi: self.value)
    }

    if count < 0 {
      // Magnitude, because '-' could overflow
      return self.shiftRight(count: count.magnitude)
    }

    let maxShiftInsideSmi: Int
    if self.isPositive {
      // Basically check if any of the shifted bits is '1'.
      // But remember that after shift the MSB must be '0'!
      let leadingZeroBitCount = self.value.leadingZeroBitCount
      let excludeMostSignificantBit = 1
      maxShiftInsideSmi = leadingZeroBitCount - excludeMostSignificantBit
    } else {
      // Basically check if any of the shifted bits is '0'.
      // We also have to exclude the situation in which after the shift
      // we would end up with '0' at MSB. We could actually to check for this
      // or we could just be conservative and exclude this additional bit.
      let inverted = ~self.value
      let leadingZeroBitCount = inverted.leadingZeroBitCount
      let excludeMostSignificantBit = 1
      maxShiftInsideSmi = leadingZeroBitCount - excludeMostSignificantBit
    }

    if count <= maxShiftInsideSmi {
      let result = self.value << count
      return BigInt(smi: result)
    }

    // There is no other way than to upgrade 'self' to heap
    var selfHeap = self.asHeap()
    selfHeap.shiftLeft(count: Storage(count))
    return BigInt(selfHeap)
  }

  // MARK: - Shift right

  internal func shiftRight<T: BinaryInteger>(count: T) -> BigInt {
    if count == 0 {
      return BigInt(smi: self.value)
    }

    if count < 0 {
      // Magnitude, because '-' could overflow
      return self.shiftLeft(count: count.magnitude)
    }

    let result = self.value >> count
    return BigInt(smi: result)
  }

  // MARK: - String

  internal var description: String {
    return self.value.description
  }

  internal var debugDescription: String {
    return "Smi(\(self.value))"
  }

  internal func toString(radix: Int, uppercase: Bool) -> String {
    return String(self.value, radix: radix, uppercase: uppercase)
  }

  // MARK: - Equatable

  internal static func == (lhs: Smi, rhs: Smi) -> Bool {
    return lhs.value == rhs.value
  }

  // MARK: - Comparable

  internal static func < (lhs: Smi, rhs: Smi) -> Bool {
    return lhs.value < rhs.value
  }

  // MARK: - Hashable

  internal func hash(into hasher: inout Hasher) {
    hasher.combine(self.value)
  }

  // MARK: - As heap

  private func asHeap() -> BigIntHeap {
    return BigIntHeap(self.value)
  }
}
