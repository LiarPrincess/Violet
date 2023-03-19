import VioletCore

extension BigIntHeap {

  // MARK: - Smi

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func sub(other: Smi.Storage) {
    // Just using '-' may overflow!
    let otherMagnitude = Word(other.magnitude)

    if other.isPositive {
      self.sub(other: otherMagnitude) // x - y
    } else {
      self.add(other: otherMagnitude) // x - (-y) = x + y
    }
  }

  // MARK: - Word

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func sub(other: Word) {
    if other.isZero {
      return
    }

    // 0 - x = -x
    if self.isZero {
      let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
      self.storage.setToAssumingCapacity(token, value: other)
      self.negate()
      return
    }

    defer { self.storage.checkInvariants() }

    if self.isNegative {
      // Different sign: 'self' negative, 'other' positive: -1 - 2
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.addMagnitude(token, lhs: &self.storage, rhs: other)
      return
    }

    /// Same sign -> we may need to cross 0.
    /// For example '1 - 1' or '-2 - (-3)'.
    switch self.compareMagnitude(with: other) {
    case .equal: // 1 - 1
      self.storage.setToZero()

    case .less: // 1 - 2 = -(-1 + 2)  = -(2 - 1), we are changing sign
      let changedSign = !self.isNegative
      let word = self.storage.withWordsBuffer { $0[0] }
      let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
      self.storage.setToAssumingCapacity(token, value: other - word)
      self.storage.setIsNegative(token, value: changedSign)

    case .greater: // 2 - 1, sign stays the same
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.subMagnitude(token, bigger: &self.storage, smaller: other)
      self.storage.fixInvariants(token) // Fix possible '0' prefix
    }
  }

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal static func subMagnitude(
    _ biggerToken: UniqueBufferToken,
    bigger: inout BigIntStorage,
    smaller: Word
  ) {
    if smaller.isZero {
      return
    }

    let borrow = bigger.withMutableWordsBuffer(biggerToken) { bigger -> Word in
      var borrow = smaller

      for i in 0..<bigger.count {
        let (p, overflow) = bigger[i].subtractingReportingOverflow(borrow)
        borrow = 1
        bigger[i] = p

        if !overflow {
          return 0
        }
      }

      return borrow
    }

    if borrow != 0 {
      trap("subMagnitude: bigger < smaller")
    }
  }

  // MARK: - Heap

  internal mutating func sub(other: BigIntHeap) {
    if other.isZero {
      return
    }

    // 0 - x = -x
    // 0 - (-x) = x
    if self.isZero {
      self.storage = other.storage
      self.negate()
      return
    }

    defer { self.storage.checkInvariants() }

    // We can simply add magnitudes when:
    // - self.isNegative && other.isPositive: -5 - 6 = -11
    // - self.isPositive && other.isNegative:  5 - (-6) = 5 + 6 = 11
    if self.isNegative != other.isNegative {
      Self.addMagnitudes(lhs: &self.storage, rhs: other.storage)
      return
    }

    // We could do: -x - (-y) = -x + y = -(x - y) = -(x + (-y))
    // But this would be slower.

    // Same sign -> we may need to cross 0.
    // For example '1 - 1' or '-2 - (-3)'.
    switch self.compareMagnitude(with: other) {
    case .equal: // 1 - 1
      self.storage.setToZero()

    case .less: // 1 - 2 = -(-1 + 2)  = -(2 - 1), we are changing sign
      let changedSign = !self.isNegative
      var otherCopy = other.storage
      let otherToken = otherCopy.guaranteeUniqueBufferReference()

      Self.subMagnitudes(otherToken, bigger: &otherCopy, smaller: self.storage)
      otherCopy.setIsNegative(otherToken, value: changedSign)
      otherCopy.fixInvariants(otherToken) // Fix possible '0' prefix

      self.storage = otherCopy

    case .greater: // 2 - 1
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.subMagnitudes(token, bigger: &self.storage, smaller: other.storage)
      self.storage.fixInvariants(token) // Fix possible '0' prefix
    }
  }

  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  internal static func subMagnitudes(
    _ biggerToken: UniqueBufferToken,
    bigger: inout BigIntStorage,
    smaller: BigIntStorage
  ) {
    if smaller.isZero {
      return
    }

    let borrow = bigger.withMutableWordsBuffer(biggerToken) { bigger -> Word in
      return smaller.withWordsBuffer { smaller -> Word in
        var borrow: Word = 0

        for i in 0..<smaller.count {
          let (p1, ov1) = bigger[i].subtractingReportingOverflow(smaller[i])
          let (p2, ov2) = p1.subtractingReportingOverflow(borrow)
          borrow = (ov1 ? 1 : 0) &+ (ov2 ? 1 : 0)
          bigger[i] = p2
        }

        for i in smaller.count..<bigger.count {
          if borrow == 0 {
            return 0
          }

          let (p, ov) = bigger[i].subtractingReportingOverflow(borrow)
          borrow = ov ? 1 : 0
          bigger[i] = p
        }

        return borrow
      }
    }

    if borrow != 0 {
      trap("subMagnitude: bigger < smaller")
    }
  }
}
