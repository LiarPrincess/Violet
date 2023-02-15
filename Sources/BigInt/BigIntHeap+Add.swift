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
      let token = self.storage.guaranteeUniqueBufferReference()
      self.storage.setTo(token, value: other)
      return
    }

    defer { self.checkInvariants() }

    if self.isPositive {
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
        (carry, lhs[i]) = lhs[i].addingFullWidth(carry)

        if carry == 0 {
          return 0
        }
      }

      return carry
    }

    if carry != 0 {
      lhs.append(lhsToken, element: carry)
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

    defer { self.checkInvariants() }

    // If we have the same sign then we can simply add magnitude.
    if self.isNegative == other.isNegative {
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.addMagnitudes(token, lhs: &self.storage, rhs: other.storage)
      return
    }

    // Self negative, other positive:  -x + y = -(x - y)
    if self.isNegative && other.isPositive {
      self.negate() // -x -> x
      self.sub(other: other) // x - y
      self.negate() // -(x - y)
      self.fixInvariants()
      return
    }

    // Self positive, other negative: x + (-y) = x - y
    // We may need to cross 0.
    assert(self.isPositive && other.isNegative)

    switch self.compareMagnitude(with: other) {
    case .equal: // 1 + (-1)
      self.storage.setToZero()

    case .less: // 1 + (-2) = 1 - 2 = -(-1 + 2) = -(2 - 1), we are changing sign
      let changedSign = !self.isNegative
      var otherCopy = other.storage
      let otherToken = otherCopy.guaranteeUniqueBufferReference()

      Self.subMagnitudes(otherToken, bigger: &otherCopy, smaller: self.storage)
      otherCopy.setIsNegative(otherToken, value: changedSign)
      otherCopy.fixInvariants() // Fix possible '0' prefix

      self.storage = otherCopy

    case .greater: // 2 + (-1) = 2 - 1
      let token = self.storage.guaranteeUniqueBufferReference()
      Self.subMagnitudes(token, bigger: &self.storage, smaller: other.storage)
      self.fixInvariants() // Fix possible '0' prefix
    }
  }

  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  internal static func addMagnitudes(
    _ lhsToken: UniqueBufferToken,
    lhs: inout BigIntStorage,
    rhs: BigIntStorage
  ) {
    let commonCount = Swift.min(lhs.count, rhs.count)
    let maxCount = Swift.max(lhs.count, rhs.count)
    lhs.reserveCapacity(lhsToken, capacity: maxCount)

    // Add the words up to the common count, carrying any overflows
    var carry = lhs.withMutableWordsBuffer(lhsToken) { lhs -> Word in
      return rhs.withWordsBuffer { rhs -> Word in
        var carry: Word = 0

        for i in 0..<commonCount {
          (carry, lhs[i]) = lhs[i].addingFullWidth(rhs[i], carry)
        }

        return carry
      }
    }

    // If there are leftover words in 'lhs', just need to handle any carries
    if lhs.count > rhs.count {
      carry = lhs.withMutableWordsBuffer(lhsToken) { lhs -> Word in
        for i in commonCount..<maxCount {
          if carry == 0 {
            return 0
          }

          (carry, lhs[i]) = lhs[i].addingFullWidth(carry)
        }

        return carry
      }
    }
    // If there are leftover words in 'rhs', need to copy to 'lhs' with carries
    else {
      rhs.withWordsBuffer { rhs in
        for i in commonCount..<maxCount {
          // Append remaining words if nothing to carry
          if carry == 0 {
            lhs.append(contentsOf: rhs.suffix(from: i))
            break
          }

          let word: Word
          (carry, word) = rhs[i].addingFullWidth(carry)
          lhs.append(lhsToken, element: word)
        }
      }
    }

    if carry != 0 {
      lhs.append(lhsToken, element: carry)
    }
  }
}
