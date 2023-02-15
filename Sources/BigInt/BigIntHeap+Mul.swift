extension BigIntHeap {

  // MARK: - Smi

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func mul(other: Smi.Storage) {
    if other == -1 {
      self.negate()
      return
    }

    let otherMagnitude = Word(other.magnitude)
    self.mul(other: otherMagnitude)

    if other.isNegative {
      self.negate()
    }
  }

  // MARK: - Word

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func mul(other: Word) {
    if other.isZero {
      self.storage.setToZero()
      return
    }

    if other == 1 {
      return
    }

    if self.isZero {
      return
    }

    defer { self.checkInvariants() }

    // Sign stays the same (we know that x > 0):
    //  1 * x =  x
    // -1 * x = -x
    let preserveIsNegative = self.isNegative
    let token = self.storage.guaranteeUniqueBufferReference()

    if self.hasMagnitudeOfOne {
      self.storage.setTo(token, value: other)
      self.storage.setIsNegative(token, value: preserveIsNegative)
      return
    }

    // And finally non-special case:
    let carry = self.storage.withMutableWordsBuffer(token) { lhs -> Word in
      var carry: Word = 0

      for i in 0..<lhs.count {
        let (high, low) = lhs[i].multipliedFullWidth(by: other)
        (carry, lhs[i]) = low.addingFullWidth(carry)
        carry = carry &+ high
      }

      return carry
    }

    if carry != 0 {
      self.storage.append(token, element: carry)
    }

    self.storage.setIsNegative(token, value: preserveIsNegative)
    self.fixInvariants()
  }

  // MARK: - Heap

  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func mul(other: BigIntHeap) {
    // Special cases for 'other': 0, 1, -1
    if other.isZero {
      self.storage.setToZero()
      return
    }

    if other.hasMagnitudeOfOne {
      if other.isNegative {
        self.negate()
      }

      return
    }

    if self.isZero {
      return
    }

    defer { self.checkInvariants() }

    if self.hasMagnitudeOfOne {
      // Copy other, change sign if self == -1
      let changeSign = self.isNegative
      self.storage = other.storage

      if changeSign {
        self.negate()
      }

      return
    }

    // And finally non-special case:
    var token = self.storage.guaranteeUniqueBufferReference()
    Self.mulMagnitude(token, lhs: &self.storage, rhs: other.storage)

    // If the signs are the same then we are positive.
    // '1 * 2 = 2' and also (-1) * (-2) = 2
    let isNegative = self.isNegative != other.isNegative
    token = self.storage.guaranteeUniqueBufferReference() // 'mulMagnitude' may reallocate
    self.storage.setIsNegative(token, value: isNegative)

    self.fixInvariants()
  }

  private typealias Buffer = UnsafeMutableBufferPointer<BigIntStorage.Word>

  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  ///
  /// We will be using school algorithm (`complexity: O(n^2)`):
  /// ```
  ///      2013
  ///    * 2019
  ///    ------
  ///     18117 <- inner loop for 'smallerWord = 9'
  ///     2013
  ///       0
  /// + 4026
  /// ---------
  ///   4064247 <- this is result
  /// ```.
  private static func mulMagnitude(
    _ lhsToken: UniqueBufferToken,
    lhs: inout BigIntStorage,
    rhs: BigIntStorage
  ) {
    //           1111 1111 | count:  8                     1111 1111 | count:  8
    //         *   11 1111 | count:  6                   * 1111 1111 | count:  8
    //  = 1 2345 6665 4321 | count: 13          = 123 4567 8765 4321 | count: 13
    //
    //           9999 9999 | count:  8                     9999 9999 | count:  8
    //         *   99 9999 | count:  6                   * 9999 9999 | count:  8
    // = 99 9998 9900 0001 | count: 14         = 9999 9998 0000 0001 | count: 16
    let count = lhs.count + rhs.count

    let buffer = Buffer.allocate(capacity: count)
    buffer.assign(repeating: 0)
    defer { buffer.deallocate() }

    lhs.withWordsBuffer { lhs in
      rhs.withWordsBuffer { rhs in
        Self.inner(lhs: lhs, rhs: rhs, into: buffer)
      }
    }

    // Remove front 0
    let highWord = buffer[count - 1]
    let countWithoutZero = count - (highWord == 0 ? 1 : 0)
    let resultBuffer = Buffer(start: buffer.baseAddress, count: countWithoutZero)
    lhs.replaceAll(lhsToken, withContentsOf: resultBuffer)
  }

  private static func inner(
    lhs: UnsafeBufferPointer<Word>,
    rhs: UnsafeBufferPointer<Word>,
    into buffer: Buffer
  ) {
    // We will use 'smaller' for inner loop in hope that it will generate
    // smaller pressure on cache/memory.
    let (smaller, bigger) = lhs.count <= rhs.count ? (lhs, rhs) : (rhs, lhs)

    for biggerIndex in 0..<bigger.count {
      var carry = Word.zero
      let biggerWord = bigger[biggerIndex]

      for smallerIndex in 0..<smaller.count {
        let smallerWord = smaller[smallerIndex]
        let resultIndex = biggerIndex + smallerIndex

        let (high, low) = biggerWord.multipliedFullWidth(by: smallerWord)
        (carry, buffer[resultIndex]) = buffer[resultIndex].addingFullWidth(low, carry)

        // Let's deal with 'high' in the next iteration.
        // No overflow possible (we have unit test for this).
        carry += high
      }

      // Last operation ('mul' or 'add') produced overflow.
      // We can just add it in the right place.
      buffer[biggerIndex + smaller.count] += carry
    }
  }
}
