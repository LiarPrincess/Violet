// swiftlint:disable function_body_length
// swiftlint:disable function_parameter_count

// Most of the code was taken from mini-gmp: https://gmplib.org
// GMP function name is in the comment above method.
//
// The main reason why we use this version (instead of standard 2 complement)
// is that it avoids unnecessary allocation.
// For example: 2 complement when both numbers are negative would have to allocate
// 2 times (1 for each of the numbers) and then another one for result.
// GMP-mini does only 1 allocation, so that's what we prefer.

// MARK: - Helper extensions

// Implement missing pieces from 'C' integer api.

extension BigIntStorage.Word {

  fileprivate init(_ b: Bool) {
    self = b ? 1 : 0
  }

  /// This implements `-` before unsigned number.
  ///
  /// It works this way:
  /// - if it is `0` -> stay `0`
  /// - otherwise -> `MAX - x + 1`, so in our case `MAX - 1 + 1 = MAX`
  fileprivate var allOneIfTrueOtherwiseZero: BigIntStorage.Word {
    return self == 0 ? Self.zero : Self.max
  }
}

extension BigIntHeap {

  // MARK: - And

  internal mutating func and(other: Smi.Storage) {
    if self.isZero {
      return
    }

    if other.isZero {
      self.storage.setToZero()
      return
    }

    // Negative numbers are complicated, so we give up and allocate.
    if self.isNegative || other.isNegative {
      let heap = BigIntHeap(other)
      self.and(other: heap)
      return
    }

    defer { self.storage.checkInvariants() }

    // Just using '-' may overflow!
    let otherWord = Word(other.magnitude)

    assert(!self.storage.isZero, "Unexpected '0'")
    let selfWord = self.storage.withWordsBuffer { $0[0] }
    let result = selfWord & otherWord

    let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
    self.storage.setToAssumingCapacity(token, value: result)
  }

  /// void
  /// mpz_and (mpz_t r, const mpz_t u, const mpz_t v)
  internal mutating func and(other: BigIntHeap) {
    if self.isZero {
      return
    }

    if other.isZero {
      self.storage.setToZero()
      return
    }

    defer { self.storage.checkInvariants() }

    // Self |Other|Result          Self|Other|Result
    // short|long |count           long|short|count
    // -----+-----+------          ----+-----+------
    //   +  |  +  |Self              + |  +  |Other
    //   +  |  -  |Self              + |  -  |Self
    //   -  |  +  |Other             - |  +  |Other
    //   -  |  -  |Other             - |  -  |Self
    let isSelfShorter = self.storage.count <= other.storage.count
    let isSelfResultCount = isSelfShorter ? self.isPositiveOrZero : other.isNegative
    let resultCount = isSelfResultCount ? self.storage.count : other.storage.count
    let capacity = resultCount + (self.isNegative && other.isNegative ? 1 : 0)

    // We will set the new count to have a full access to the underlying buffer.
    // But we have to remember the previous count, because this is where we stop.
    let selfCount = self.storage.count
    let token = self.storage.guaranteeUniqueBufferReference(withCapacity: capacity)
    self.storage.setCount(token, value: capacity)

    self.storage.withMutableWordsBuffer(token) { selfPtr in
      other.storage.withWordsBuffer { otherPtr in
        Self.and(
          isLhsNegative: self.isNegative,
          lhs: selfPtr,
          isRhsNegative: other.isNegative,
          rhs: otherPtr,
          lhsCount: selfCount,
          resultCount: resultCount
        )
      }
    }

    self.storage.setIsNegative(token, value: self.isNegative && other.isNegative)
    self.storage.fixInvariants(token)
  }

  private static func and(
    isLhsNegative: Bool,
    lhs: UnsafeMutableBufferPointer<Word>,
    isRhsNegative: Bool,
    rhs: UnsafeBufferPointer<Word>,
    lhsCount: Int, // Count before resize
    resultCount: Int // Count after resize (but without bothNegative word)
  ) {
    var isShortNegative: Word
    let short: UnsafeBufferPointer<Word>
    var isLongNegative: Word
    let long: UnsafeBufferPointer<Word>
    let commonCount: Int
    let rhsCount = rhs.count

    if lhsCount <= rhsCount {
      short = UnsafeBufferPointer(lhs)
      isShortNegative = Word(isLhsNegative)
      long = rhs
      isLongNegative = Word(isRhsNegative)
      commonCount = lhsCount
    } else {
      short = rhs
      isShortNegative = Word(isRhsNegative)
      long = UnsafeBufferPointer(lhs)
      isLongNegative = Word(isLhsNegative)
      commonCount = rhsCount
    }

    var bothNegative = isShortNegative & isLongNegative

    let shortMask = isShortNegative.allOneIfTrueOtherwiseZero
    let longMask = isLongNegative.allOneIfTrueOtherwiseZero
    let bothNegativeMask = bothNegative.allOneIfTrueOtherwiseZero

    for i in 0..<commonCount {
      let longWord = (long[i] ^ longMask) &+ isLongNegative
      isLongNegative = Word(longWord < isLongNegative)

      let shortWord = (short[i] ^ shortMask) &+ isShortNegative
      isShortNegative = Word(shortWord < isShortNegative)

      let word = ((longWord & shortWord) ^ bothNegativeMask) &+ bothNegative
      bothNegative = Word(word < bothNegative)

      lhs[i] = word
    }

    assert(isShortNegative == 0)

    for i in commonCount..<resultCount {
      let longWord = (long[i] ^ longMask) &+ isLongNegative
      isLongNegative = Word(longWord < isLongNegative)

      let word: UInt = ((longWord & shortMask) ^ bothNegativeMask) &+ bothNegative
      bothNegative = Word(word < bothNegative)

      lhs[i] = word
    }

    if isLhsNegative && isRhsNegative {
      lhs[resultCount] = bothNegative // 0 or 1
    }
  }

  // MARK: - Or

  internal mutating func or(other: Smi.Storage) {
    if other.isZero {
      return
    }

    if self.isZero {
      let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
      self.storage.setToAssumingCapacity(token, value: Int(other))
      return
    }

    // Negative numbers are complicated, so we give up and allocate.
    if self.isNegative || other.isNegative {
      let heap = BigIntHeap(other)
      self.or(other: heap)
      return
    }

    defer { self.storage.checkInvariants() }

    // Just using '-' may overflow!
    let otherWord = Word(other.magnitude)
    let token = self.storage.guaranteeUniqueBufferReference()

    self.storage.withMutableWordsBuffer(token) { words in
      assert(!words.isEmpty, "Unexpected '0'")
      words[0] |= otherWord
    }

    // 'other' is positive, so no matter what our sign stays the same
    // self.storage.isNegative = no changes
    self.storage.fixInvariants(token)
  }

  /// void
  /// mpz_ior (mpz_t r, const mpz_t u, const mpz_t v)
  internal mutating func or(other: BigIntHeap) {
    if self.isZero {
      self.storage = other.storage
      return
    }

    if other.isZero {
      return
    }

    defer { self.storage.checkInvariants() }

    // Self |Other|Result          Self|Other|Result
    // short|long |count           long|short|count
    // -----+-----+------          ----+-----+------
    //   +  |  +  |Other             + |  +  |Self
    //   +  |  -  |Other             + |  -  |Other
    //   -  |  +  |Self              - |  +  |Self
    //   -  |  -  |Self              - |  -  |Other
    let isSelfShorter = self.storage.count <= other.storage.count
    let isSelfResultCount = isSelfShorter ? self.isNegative : other.isPositiveOrZero
    let resultCount = isSelfResultCount ? self.storage.count : other.storage.count
    let capacity = resultCount + (self.isNegative || other.isNegative ? 1 : 0)

    // We will set the new count to have a full access to the underlying buffer.
    // But we have to remember the previous count, because this is where we stop.
    let selfCount = self.storage.count
    let token = self.storage.guaranteeUniqueBufferReference(withCapacity: capacity)
    self.storage.setCount(token, value: capacity)

    self.storage.withMutableWordsBuffer(token) { selfPtr in
      other.storage.withWordsBuffer { otherPtr in
        Self.or(
          isLhsNegative: self.isNegative,
          lhs: selfPtr,
          isRhsNegative: other.isNegative,
          rhs: otherPtr,
          lhsCount: selfCount,
          resultCount: resultCount
        )
      }
    }

    self.storage.setIsNegative(token, value: self.isNegative || other.isNegative)
    self.storage.fixInvariants(token)
  }

  private static func or(
    isLhsNegative: Bool,
    lhs: UnsafeMutableBufferPointer<Word>,
    isRhsNegative: Bool,
    rhs: UnsafeBufferPointer<Word>,
    lhsCount: Int, // Count before resize
    resultCount: Int // Count after resize (but without anyNegative word)
  ) {
    var isShortNegative: Word
    let short: UnsafeBufferPointer<Word>
    var isLongNegative: Word
    let long: UnsafeBufferPointer<Word>
    let commonCount: Int
    let rhsCount = rhs.count

    if lhsCount <= rhsCount {
      short = UnsafeBufferPointer(lhs)
      isShortNegative = Word(isLhsNegative)
      long = rhs
      isLongNegative = Word(isRhsNegative)
      commonCount = lhsCount
    } else {
      short = rhs
      isShortNegative = Word(isRhsNegative)
      long = UnsafeBufferPointer(lhs)
      isLongNegative = Word(isLhsNegative)
      commonCount = rhsCount
    }

    var anyNegative = isShortNegative | isLongNegative

    let shortMask = isShortNegative.allOneIfTrueOtherwiseZero
    let longMask = isLongNegative.allOneIfTrueOtherwiseZero
    let anyNegativeMask = anyNegative.allOneIfTrueOtherwiseZero

    for i in 0..<commonCount {
      let longWord = (long[i] ^ longMask) &+ isLongNegative
      isLongNegative = Word(longWord < isLongNegative)

      let shortWord = (short[i] ^ shortMask) &+ isShortNegative
      isShortNegative = Word(shortWord < isShortNegative)

      let word = ((longWord | shortWord) ^ anyNegativeMask) &+ anyNegative
      anyNegative = Word(word < anyNegative)

      lhs[i] = word
    }

    assert(isShortNegative == 0)

    for i in commonCount..<resultCount {
      let longWord = (long[i] ^ longMask) &+ isLongNegative
      isLongNegative = Word(longWord < isLongNegative)

      let word = ((longWord | shortMask) ^ anyNegativeMask) &+ anyNegative
      anyNegative = Word(word < anyNegative)

      lhs[i] = word
    }

    if isLhsNegative || isRhsNegative {
      lhs[resultCount] = anyNegative // 0 or 1
    }
  }

  // MARK: - Xor

  internal mutating func xor(other: Smi.Storage) {
    if self.isZero {
      let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
      self.storage.setToAssumingCapacity(token, value: Int(other))
      return
    }

    if other.isZero {
      return
    }

    // Negative numbers are complicated, so we give up and allocate.
    if self.isNegative || other.isNegative {
      let heap = BigIntHeap(other)
      self.xor(other: heap)
      return
    }

    defer { self.storage.checkInvariants() }

    // Just using '-' may overflow!
    let otherWord = Word(other.magnitude)
    let token = self.storage.guaranteeUniqueBufferReference()

    self.storage.withMutableWordsBuffer(token) { words in
      assert(!words.isEmpty, "Unexpected '0'")
      words[0] ^= otherWord
    }

    // 'other' is positive, so no matter what our sign stays the same
    // self.storage.isNegative = no changes
    self.storage.fixInvariants(token)
  }

  /// void
  /// mpz_xor (mpz_t r, const mpz_t u, const mpz_t v)
  internal mutating func xor(other: BigIntHeap) {
    if self.isZero {
      self.storage = other.storage
      return
    }

    if other.isZero {
      return
    }

    defer { self.storage.checkInvariants() }

    // Self |Other|Result          Self|Other|Result
    // short|long |count           long|short|count
    // -----+-----+------          ----+-----+------
    //   +  |  +  |Other             + |  +  |Self
    //   +  |  -  |Other             + |  -  |Self
    //   -  |  +  |Other             - |  +  |Self
    //   -  |  -  |Other             - |  -  |Self
    let isSelfLonger = self.storage.count >= other.storage.count
    let resultCount = isSelfLonger ? self.storage.count : other.storage.count
    let capacity = resultCount + (self.isNegative != other.isNegative ? 1 : 0)

    // We will set the new count to have a full access to the underlying buffer.
    // But we have to remember the previous count, because this is where we stop.
    let selfCount = self.storage.count
    let token = self.storage.guaranteeUniqueBufferReference(withCapacity: capacity)
    self.storage.setCount(token, value: capacity)

    self.storage.withMutableWordsBuffer(token) { selfPtr in
      other.storage.withWordsBuffer { otherPtr in
        Self.xor(
          isLhsNegative: self.isNegative,
          lhs: selfPtr,
          isRhsNegative: other.isNegative,
          rhs: otherPtr,
          lhsCount: selfCount,
          resultCount: resultCount
        )
      }
    }

    self.storage.setIsNegative(token, value: self.isNegative != other.isNegative)
    self.storage.fixInvariants(token)
  }

  private static func xor(
    isLhsNegative: Bool,
    lhs: UnsafeMutableBufferPointer<Word>,
    isRhsNegative: Bool,
    rhs: UnsafeBufferPointer<Word>,
    lhsCount: Int, // Count before resize
    resultCount: Int // Count after resize (but without onlyOneNegative word)
  ) {
    var isShortNegative: Word
    let short: UnsafeBufferPointer<Word>
    var isLongNegative: Word
    let long: UnsafeBufferPointer<Word>
    let commonCount: Int
    let rhsCount = rhs.count

    if lhsCount <= rhsCount {
      short = UnsafeBufferPointer(lhs)
      isShortNegative = Word(isLhsNegative)
      long = rhs
      isLongNegative = Word(isRhsNegative)
      commonCount = lhsCount
    } else {
      short = rhs
      isShortNegative = Word(isRhsNegative)
      long = UnsafeBufferPointer(lhs)
      isLongNegative = Word(isLhsNegative)
      commonCount = rhsCount
    }

    var onlyOneNegative = isShortNegative ^ isLongNegative

    let shortMask = isShortNegative.allOneIfTrueOtherwiseZero
    let longMask = isLongNegative.allOneIfTrueOtherwiseZero
    let onlyOneNegativeMask = onlyOneNegative.allOneIfTrueOtherwiseZero

    for i in 0..<commonCount {
      let longWord = (long[i] ^ longMask) &+ isLongNegative
      isLongNegative = Word(longWord < isLongNegative)

      let shortWord = (short[i] ^ shortMask) &+ isShortNegative
      isShortNegative = Word(shortWord < isShortNegative)

      let word = (longWord ^ shortWord ^ onlyOneNegativeMask) &+ onlyOneNegative
      onlyOneNegative = Word(word < onlyOneNegative)

      lhs[i] = word
    }

    assert(isShortNegative == 0)

    for i in commonCount..<resultCount {
      let longWord = (long[i] ^ longMask) &+ isLongNegative
      isLongNegative = Word(longWord < isLongNegative)

      let word = (longWord ^ longMask) &+ onlyOneNegative
      onlyOneNegative = Word(word < onlyOneNegative)

      lhs[i] = word
    }

    if isLhsNegative != isRhsNegative {
      lhs[resultCount] = onlyOneNegative // 0 or 1
    }
  }
}
