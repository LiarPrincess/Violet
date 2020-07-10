internal struct BigIntHeap: Equatable, Hashable {

  internal typealias Word = BigIntStorage.Word

  // MARK: - Properties

  internal var storage: BigIntStorage

  internal var isZero: Bool {
    return self.storage.isZero
  }

  /// `0` is also positive.
  internal var isPositive: Bool {
    return self.storage.isPositive
  }

  internal var isNegative: Bool {
    return self.storage.isNegative
  }

  internal var isEven: Bool {
    guard let first = self.storage.first else {
      assert(self.isZero)
      return true // '0' is even
    }

    return first & 0b1 == 0
  }

  /// DO NOT USE in general code!
  /// It may allocate!
  ///
  /// This is not one of those 'easy/fast' methods.
  /// It is only here for `BigInt.magnitude`.
  internal var magnitude: BigInt {
    if self.isPositive {
      return BigInt(self)
    }

    var abs = self
    abs.negate()
    abs.checkInvariants()
    assert(abs.isPositive)
    return BigInt(abs)
  }

  internal var hasMagnitudeOfOne: Bool {
    return self.storage.count == 1 && self.storage[0] == 1
  }

  // MARK: - Init

  /// Init with storage set to `0`.
  internal init() {
    self.storage = .zero
  }

  internal init(minimumStorageCapacity: Int) {
    self.storage = BigIntStorage(minimumCapacity: minimumStorageCapacity)
  }

  internal init<T: BinaryInteger>(_ value: T) {
    // Assuming that biggest 'BinaryInteger' in Swift is representable by 'Word'.
    let isNegative = value.isNegative
    let magnitude = Word(value.magnitude)
    self.storage = BigIntStorage(isNegative: isNegative, magnitude: magnitude)
  }

  internal init(storage: BigIntStorage) {
    self.storage = storage
    self.fixInvariants()
  }

  // MARK: - Invariants

  internal mutating func fixInvariants() {
    self.storage.fixInvariants()
  }

  internal func checkInvariants() {
    self.storage.checkInvariants()
  }

  // MARK: - Type conversion

  internal func asSmiIfPossible() -> Smi? {
    if self.isZero {
      return Smi(Smi.Storage.zero)
    }

    // If we have more than 1 word then we are out of range
    guard self.storage.count == 1 else {
      return nil
    }

    let word = self.storage[0]
    if let storage = word.asSmiIfPossible(isNegative: self.isNegative) {
      return Smi(storage)
    }

    return nil
  }
}
