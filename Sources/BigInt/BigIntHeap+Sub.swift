import VioletCore

extension BigIntHeap {

  // MARK: - Smi

  internal mutating func sub(other: Smi.Storage) {
    defer { self.checkInvariants() }

    if other.isZero {
      return
    }

    // Just using '-' may overflow!
    let word = Word(other.magnitude)

    if self.isZero {
      self.storage.append(word)
      self.storage.isNegative = !other.isNegative
      return
    }

    // We can simply add magnitudes when:
    // - self.isNegative && other.isPositive (for example: -5 - 6 = -11)
    // - self.isPositive && other.isNegative (for example:  5 - (-6) = 5 + 6 = 11)
    // which is the same as:
    if self.isNegative != other.isNegative {
      Self.addMagnitude(lhs: &self.storage, rhs: word)
      return
    }

    // Both have the same sign, for example '1 - 1' or '-2 - (-3)'.
    self.subSameSign(other: word)
  }

  // MARK: - Word

  internal mutating func sub(other: Word) {
    defer { self.checkInvariants() }

    // Different sign: 'self' negative, 'other' positive: -1 - 2
    if self.isNegative {
      Self.addMagnitude(lhs: &self.storage, rhs: other)
      return
    }

    // Same sign: both positive
    assert(self.isPositive)
    self.subSameSign(other: other)
  }

  /// Case when we have the same sign, for example '1 - 1' or '-2 - (-3)'.
  /// That means that we may need to cross 0.
  private mutating func subSameSign(other: Word) {
    if self.isZero {
      self.storage.isNegative = true
      self.storage.append(other)
      return
    }

    switch self.compareMagnitude(with: other) {
    case .equal: // 1 - 1
      self.storage.setToZero()

    case .less: // 1 - 2 = -(-1 + 2)  = -(2 - 1), we are changing sign
      let changedSign = !self.isNegative
      let result = other - self.storage[0]
      self.storage.set(to: result)
      self.storage.isNegative = changedSign

    case .greater: // 2 - 1, sign stays the same
      Self.subMagnitude(bigger: &self.storage, smaller: other)
      self.fixInvariants() // Fix possible '0' prefix
    }
  }

  internal static func subMagnitude(bigger: inout BigIntStorage,
                                    smaller: Word) {
    if smaller.isZero {
      return
    }

    var borrow = smaller
    for i in 0..<bigger.count {
      (borrow, bigger[i]) = bigger[i].subtractingFullWidth(borrow)

      if borrow == 0 {
        return
      }
    }

    trap("subMagnitude: bigger < smaller")
  }

  // MARK: - Heap

  internal mutating func sub(other: BigIntHeap) {
    defer { self.checkInvariants() }

    if other.isZero {
      return
    }

    // 0 - x = -x and 0 - (-x) = x
    if self.isZero {
      self.storage = other.storage
      self.storage.isNegative.toggle()
      return
    }

    // We can simply add magnitudes when:
    // - self.isNegative && other.isPositive (for example: -5 - 6 = -11)
    // - self.isPositive && other.isNegative (for example:  5 - (-6) = 5 + 6 = 11)
    // which is the same as:
    if self.isNegative != other.isNegative {
      Self.addMagnitudes(lhs: &self.storage, rhs: other.storage)
      return
    }

    // Both have the same sign, for example '1 - 1' or '-2 - (-3)'.
    // That means that we may need to cross 0.
    switch self.compareMagnitude(with: other) {
    case .equal: // 1 - 1
      self.storage.setToZero()

    case .less: // 1 - 2 = -(-1 + 2)  = -(2 - 1), we are changing sign
      let changedSign = !self.isNegative

      var otherCopy = other.storage
      Self.subMagnitudes(bigger: &otherCopy, smaller: self.storage)
      self.storage = otherCopy

      self.storage.isNegative = changedSign
      self.fixInvariants() // Fix possible '0' prefix

    case .greater: // 2 - 1
      Self.subMagnitudes(bigger: &self.storage, smaller: other.storage)
      self.fixInvariants() // Fix possible '0' prefix
    }
  }

  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  internal static func subMagnitudes(bigger: inout BigIntStorage,
                                     smaller: BigIntStorage) {
    if smaller.isZero {
      return
    }

    var borrow: Word = 0
    for i in 0..<smaller.count {
      (borrow, bigger[i]) = bigger[i].subtractingFullWidth(smaller[i], borrow)
    }

    for i in smaller.count..<bigger.count {
      if borrow == 0 {
        break
      }

      (borrow, bigger[i]) = bigger[i].subtractingFullWidth(borrow)
    }

    guard borrow == 0 else {
      trap("subMagnitude: bigger < smaller")
    }
  }
}
