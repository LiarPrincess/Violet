extension BigIntHeap {

  // MARK: - Smi

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func add(other: Smi.Storage) {
    // Just using '-' may overflow!
    let otherMagnitude = Word(other.magnitude)

    if other.isPositive {
      self.add(other: otherMagnitude)
    } else {
      self.sub(other: otherMagnitude)
    }
  }

  // MARK: - Word

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func add(other: Word) {
    if other.isZero {
      return
    }

    if self.isZero {
      let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
      self.storage.setToAssumingCapacity(token, value: other)
      return
    }

    defer { self.storage.checkInvariants() }

    if self.isPositiveOrZero {
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.addMagnitude(token, lhs: &self.storage, rhs: other)
    } else {
      // Self negative, other positive:  -x + y = -(x - y)
      self.negate() // -x -> x
      self.sub(other: other) // x - y
      self.negate() // -(x - y)
    }
  }

  internal static func addMagnitude(
    _ lhsToken: UniqueBufferToken,
    lhs: inout BigIntStorage,
    rhs: Word
  ) {
    // This check has to be here otherwise final 'lhs.append(carry)'
    // would append '0' which is illegal ('0' should have empty storage).
    if rhs == 0 {
      return
    }

    let carry = lhs.withMutableWordsBuffer(lhsToken) { lhs -> Word in
      var carry = rhs

      for i in 0..<lhs.count {
        let (p, overflow) = lhs[i].addingReportingOverflow(carry)
        carry = 1
        lhs[i] = p

        if !overflow {
          return 0
        }
      }

      return carry
    }

    if carry != 0 {
      lhs.appendWithPossibleGrow(lhsToken, element: carry)
    }
  }

  // MARK: - Heap

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func add(other: BigIntHeap) {
    if other.isZero {
      return
    }

    if self.isZero {
      self.storage = other.storage
      return
    }

    defer { self.storage.checkInvariants() }

    // If we have the same sign then we can simply add magnitude.
    if self.isNegative == other.isNegative {
      Self.addMagnitudes(lhs: &self.storage, rhs: other.storage)
      return
    }

    // We could do: -x + y = -(x - y)
    // But this would be slower.

    // Self positive, other negative: x + (-y) = x - y
    // We may need to cross 0.
    switch self.compareMagnitude(with: other) {
    case .equal: // 1 + (-1)
      self.storage.setToZero()

    case .less: // 1 + (-2) = 1 - 2 = -(-1 + 2) = -(2 - 1), we are changing sign
      let changedSign = !self.isNegative
      var otherCopy = other.storage
      let otherToken = otherCopy.guaranteeUniqueBufferReference()

      Self.subMagnitudes(otherToken, bigger: &otherCopy, smaller: self.storage)
      otherCopy.setIsNegative(otherToken, value: changedSign)
      otherCopy.fixInvariants(otherToken) // Fix possible '0' prefix

      self.storage = otherCopy

    case .greater: // 2 + (-1) = 2 - 1
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.subMagnitudes(token, bigger: &self.storage, smaller: other.storage)
      self.storage.fixInvariants(token) // Fix possible '0' prefix
    }
  }

  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  internal static func addMagnitudes(lhs: inout BigIntStorage, rhs: BigIntStorage) {
    if lhs.count >= rhs.count {
      Self.addMagnitudes_lhsLonger(lhs: &lhs, rhs: rhs)
    } else {
      Self.addMagnitudes_rhsLonger(lhs: &lhs, rhs: rhs)
    }
  }

  private static func addMagnitudes_lhsLonger(
    lhs: inout BigIntStorage,
    rhs: BigIntStorage
  ) {
    let token = lhs.guaranteeUniqueBufferReference()

    let carry = lhs.withMutableWordsBuffer(token) { lhs -> Word in
      return rhs.withWordsBuffer { rhs -> Word in
        var carry = Self.addMagnitudes_common(lhs: lhs, rhs: rhs, count: rhs.count)

        for i in rhs.count..<lhs.count {
          if carry == 0 {
            return 0
          }

          let (p, ov) = lhs[i].addingReportingOverflow(carry)
          carry = ov ? 1 : 0
          lhs[i] = p
        }

        return carry
      }
    }

    if carry != 0 {
      lhs.appendWithPossibleGrow(token, element: carry)
    }
  }

  private static func addMagnitudes_rhsLonger(
    lhs: inout BigIntStorage,
    rhs: BigIntStorage
  ) {
    let lhsCountBefore = lhs.count
    let token = lhs.guaranteeUniqueBufferReference(withCapacity: rhs.count)
    lhs.setCount(token, value: rhs.count)

    let carry = lhs.withMutableWordsBuffer(token) { lhs -> Word in
      return rhs.withWordsBuffer { rhs -> Word in
        var carry = Self.addMagnitudes_common(lhs: lhs, rhs: rhs, count: lhsCountBefore)

        for i in lhsCountBefore..<rhs.count {
          let (p, ov) = rhs[i].addingReportingOverflow(carry)
          carry = ov ? 1 : 0
          lhs[i] = p
        }

        return carry
      }
    }

    if carry != 0 {
      lhs.appendWithPossibleGrow(token, element: carry)
    }
  }

  /// Returns carry
  private static func addMagnitudes_common(
    lhs: UnsafeMutableBufferPointer<Word>,
    rhs: UnsafeBufferPointer<Word>,
    count: Int
  ) -> Word {
    var carry: Word = 0

    for i in 0..<count {
      let (p1, ov1) = lhs[i].addingReportingOverflow(rhs[i])
      let (p2, ov2) = p1.addingReportingOverflow(carry)

      // For some reason if we reorder the following lines on Intel
      // it will be 20% slower.
      carry = (ov1 ? 1 : 0) &+ (ov2 ? 1 : 0)
      lhs[i] = p2
    }

    return carry
  }
}
