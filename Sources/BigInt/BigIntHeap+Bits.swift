// swiftlint:disable function_body_length
// swiftlint:disable file_length

// Most of the code was taken from mini-gmp: https://gmplib.org
// GMP function name is in the comment above method.
//
// The main reason why we use this version (instead of standard 2 complement)
// is that it avoids unnecesary allocation.
// For example: 2 complement when both numbers are negative would have to allocate
// 2 times (1 for each of the numbers) and then another one for result.
// GMP-mini does only 1 allocation, so that's what we prefer.

// MARK: - Helper extensions

// Implement missing pieces from 'C' integer api.

extension Bool {

  fileprivate var asWord: BigIntStorage.Word {
    return self ? 1 : 0
  }
}

extension BigIntStorage.Word {

  fileprivate var isTrue: Bool {
    return self != 0
  }

  /// This implements `-` before unsigned number.
  ///
  /// It works this way:
  /// - if it is `0` -> stay `0`
  /// - otherwise -> `MAX - x + 1`, so in our case `MAX - 1 + 1 = MAX`
  fileprivate var allOneIfTrueOtherwiseZero: BigIntStorage.Word {
    return self.isTrue ? Self.max : Self.zero
  }
}

extension BigIntHeap {

  // MARK: - Words

  /// A collection containing the words of this value’s binary representation,
  /// in order from the least significant to most significant.
  internal var words: BigIntStorage {
    if self.isZero {
      var singleZeroElement = BigIntStorage(minimumCapacity: 1)
      singleZeroElement.append(0)
      return singleZeroElement
    }

    return self.asTwoComplement()
  }

  // MARK: - Trailing zero bit count

  /// The number of trailing zero bits in the binary representation of this integer.
  ///
  /// - Important:
  /// `0` is considered to have zero trailing zero bits.
  internal var trailingZeroBitCount: Int {
    for (index, word) in self.storage.enumerated() {
      if word != 0 { // swiftlint:disable:this for_where
        return index * Word.bitWidth + word.trailingZeroBitCount
      }
    }

    assert(self.isZero)
    return 0
  }

  // MARK: - Negate

  internal mutating func negate() {
    // Zero is always positive
    if self.isZero {
      assert(self.isPositive)
      return
    }

    self.storage.isNegative.toggle()
    self.checkInvariants()
  }

  // MARK: - Invert

  /// void
  /// mpz_com (mpz_t r, const mpz_t u)
  internal mutating func invert() {
    self.add(other: 1)
    self.negate()
    self.checkInvariants()
  }

  // MARK: - And

  internal mutating func and(other: Smi.Storage) {
    defer { self.checkInvariants() }

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

    // Just using '-' may overflow!
    let otherWord = Word(other.magnitude)

    assert(!self.storage.isEmpty, "Unexpected '0'")
    let selfWord = self.storage[0]

    self.storage.removeAll()
    self.storage.append(selfWord & otherWord)

    // 'other' is positive, so no matter what our sign is the result  will be '+'
    self.storage.isNegative = false
    self.fixInvariants()
  }

  /// void
  /// mpz_and (mpz_t r, const mpz_t u, const mpz_t v)
  ///
  /// Variable names mostly taken from GMP.
  internal mutating func and(other: BigIntHeap) {
    defer { self.checkInvariants() }

    if self.isZero {
      return
    }

    if other.isZero {
      self.storage.setToZero()
      return
    }

    // 'v' is smaller, 'u' is bigger
    let v = self.storage.count <= other.storage.count ? self.storage : other.storage
    let u = self.storage.count <= other.storage.count ? other.storage : self.storage
    assert(v.count <= u.count)

    var vIsNegative = v.isNegative.asWord
    var uIsNegative = u.isNegative.asWord
    var bothNegative = vIsNegative & uIsNegative

    let vMask = vIsNegative.allOneIfTrueOtherwiseZero
    let uMask = uIsNegative.allOneIfTrueOtherwiseZero
    let bothNegativeMask = bothNegative.allOneIfTrueOtherwiseZero

    // If the smaller input is positive, higher words don't matter.
    let resultCount = v.isPositive ? v.count : u.count
    var result = BigIntStorage(repeating: 0, count: resultCount + Int(bothNegative))

    for i in 0..<v.count {
      let ul = (u[i] ^ uMask) &+ uIsNegative
      uIsNegative = (ul < uIsNegative).asWord

      let vl = (v[i] ^ vMask) &+ vIsNegative
      vIsNegative = (vl < vIsNegative).asWord

      let rl = ((ul & vl) ^ bothNegativeMask) &+ bothNegative
      bothNegative = (rl < bothNegative).asWord

      result[i] = rl
    }

    assert(vIsNegative == 0)

    for i in v.count..<resultCount {
      let ul = (u[i] ^ uMask) &+ uIsNegative
      uIsNegative = (ul < uIsNegative).asWord

      let rl = ((ul & vMask) ^ bothNegativeMask) &+ bothNegative
      bothNegative = (rl < bothNegative).asWord

      result[i] = rl
    }

    if bothNegative.isTrue {
      result[resultCount] = bothNegative
    }

    result.isNegative = self.isNegative && other.isNegative
    result.fixInvariants()
    self.storage = result
  }

  // MARK: - Or

  internal mutating func or(other: Smi.Storage) {
    defer { self.checkInvariants() }

    if self.isZero {
      self.storage.set(to: Int(other))
      return
    }

    if other.isZero {
      return
    }

    // Negative numbers are complicated, so we give up and allocate.
    if self.isNegative || other.isNegative {
      let heap = BigIntHeap(other)
      self.or(other: heap)
      return
    }

    // Just using '-' may overflow!
    let otherWord = Word(other.magnitude)

    assert(!self.storage.isEmpty, "Unexpected '0'")
    self.storage[0] |= otherWord

    // 'other' is positive, so no matter what our sign stays the same
    // self.storage.isNegative = no changes
    self.fixInvariants()
  }

  /// void
  /// mpz_ior (mpz_t r, const mpz_t u, const mpz_t v)
  ///
  /// Variable names mostly taken from GMP.
  internal mutating func or(other: BigIntHeap) {
    defer { self.checkInvariants() }

    if self.isZero {
      self.storage = other.storage
      return
    }

    if other.isZero {
      return
    }

    // 'v' is smaller, 'u' is bigger
    let v = self.storage.count <= other.storage.count ? self.storage : other.storage
    let u = self.storage.count <= other.storage.count ? other.storage : self.storage
    assert(v.count <= u.count)

    var vIsNegative = v.isNegative.asWord
    var uIsNegative = u.isNegative.asWord
    var anyNegative = vIsNegative | uIsNegative

    let vMask = vIsNegative.allOneIfTrueOtherwiseZero
    let uMask = uIsNegative.allOneIfTrueOtherwiseZero
    let anyNegativeMask = anyNegative.allOneIfTrueOtherwiseZero

    // If the smaller input is negative, by sign extension higher words don't matter.
    let resultCount = vMask.isTrue ? v.count : u.count
    var result = BigIntStorage(repeating: 0, count: resultCount + Int(anyNegative))

    for i in 0..<v.count {
      let ul = (u[i] ^ uMask) &+ uIsNegative
      uIsNegative = (ul < uIsNegative).asWord

      let vl = (v[i] ^ vMask) &+ vIsNegative
      vIsNegative = (vl < vIsNegative).asWord

      let rl = ((ul | vl) ^ anyNegativeMask) &+ anyNegative
      anyNegative = (rl < anyNegative).asWord

      result[i] = rl
    }

    assert(vIsNegative == 0)

    for i in v.count..<resultCount {
      let ul = (u[i] ^ uMask) &+ uIsNegative
      uIsNegative = (ul < uIsNegative).asWord

      let rl = ((ul | vMask) ^ anyNegativeMask) &+ anyNegative
      anyNegative = (rl < anyNegative).asWord

      result[i] = rl
    }

    if anyNegative.isTrue {
      result[resultCount] = anyNegative
    }

    result.isNegative = self.isNegative || other.isNegative
    result.fixInvariants()
    self.storage = result
  }

  // MARK: - Xor

  internal mutating func xor(other: Smi.Storage) {
    defer { self.checkInvariants() }

    if self.isZero {
      self.storage.set(to: Int(other))
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

    // Just using '-' may overflow!
    let otherWord = Word(other.magnitude)

    assert(!self.storage.isEmpty, "Unexpected '0'")
    self.storage[0] ^= otherWord

    // 'other' is positive, so no matter what our sign stays the same
    // self.storage.isNegative = no changes
    self.fixInvariants()
  }

  /// void
  /// mpz_xor (mpz_t r, const mpz_t u, const mpz_t v)
  ///
  /// Variable names mostly taken from GMP.
  internal mutating func xor(other: BigIntHeap) {
    defer { self.checkInvariants() }

    if self.isZero {
      self.storage = other.storage
      return
    }

    if other.isZero {
      return
    }

    // 'v' is smaller, 'u' is bigger
    let v = self.storage.count <= other.storage.count ? self.storage : other.storage
    let u = self.storage.count <= other.storage.count ? other.storage : self.storage
    assert(v.count <= u.count)

    var vIsNegative = v.isNegative.asWord
    var uIsNegative = u.isNegative.asWord
    var onlyOneNegative = vIsNegative ^ uIsNegative

    let vMask = vIsNegative.allOneIfTrueOtherwiseZero
    let uMask = uIsNegative.allOneIfTrueOtherwiseZero
    let onlyOneNegativeMask = onlyOneNegative.allOneIfTrueOtherwiseZero

    let resultCount = u.count
    var result = BigIntStorage(repeating: 0, count: resultCount + Int(onlyOneNegative))

    for i in 0..<v.count {
      let ul = (u[i] ^ uMask) &+ uIsNegative
      uIsNegative = (ul < uIsNegative).asWord

      let vl = (v[i] ^ vMask) &+ vIsNegative
      vIsNegative = (vl < vIsNegative).asWord

      let rl = (ul ^ vl ^ onlyOneNegativeMask) &+ onlyOneNegative
      onlyOneNegative = (rl < onlyOneNegative).asWord

      result[i] = rl
    }

    assert(vIsNegative == 0)

    for i in v.count..<resultCount {
      let ul = (u[i] ^ uMask) &+ uIsNegative
      uIsNegative = (ul < uIsNegative).asWord

      let rl = (ul ^ uMask) &+ onlyOneNegative
      onlyOneNegative = (rl < onlyOneNegative).asWord

      result[i] = rl
    }

    if onlyOneNegative.isTrue {
      result[resultCount] = onlyOneNegative
    }

    result.isNegative = self.isNegative != other.isNegative
    result.fixInvariants()
    self.storage = result
  }

  // MARK: - Two complement

  /// `inout` to avoid copy.
  internal init(twoComplement: inout BigIntStorage) {
    // Check for '0'
    guard let last = twoComplement.last else {
      self.init()
      return
    }

    let isPositive = last >> (Word.bitWidth - 1) == 0
    if isPositive {
      twoComplement.isNegative = false
    } else {
      // For negative numbers we have to revert 2 complement.
      twoComplement.isNegative = true
      twoComplement.transformEveryWord(fn: ~) // Invert every word
      Self.addMagnitude(lhs: &twoComplement, rhs: 1)
    }

    // 'fixInvariants' BEFORE 'init' to avoid COW!
    twoComplement.fixInvariants()
    self.init(storage: twoComplement)
  }

  /// We will return 'BigIntStorage' to save allocation in some cases.
  ///
  /// But remember that in this case it will be used as collection,
  /// that means that eny additional data (sign etc.) should be ignored.
  internal func asTwoComplement() -> BigIntStorage {
    if self.isZero {
      return self.storage
    }

    if self.isPositive {
      // '1' in front indicates negative number,
      // in such case we have to add artificial '0' in front
      // This does not happen very often.
      if let last = self.storage.last, last >> (Word.bitWidth - 1) == 1 {
        var copy = self.storage
        copy.append(0)
        return copy
      }

      return self.storage
    }

    assert(self.isNegative)

    // At this point our 'storage' holds positive number,
    // so we have force 2 complement.
    var copy = self.storage
    copy.transformEveryWord(fn: ~) // Invert every word
    Self.addMagnitude(lhs: &copy, rhs: 1)

    // '0' in front indicates positive number,
    // in such case we have to add artificial '1' in front
    // Again, this does not happen very often.
    if let last = copy.last, last >> (Word.bitWidth - 1) == 0 {
      copy.append(Word.max)
    }

    return copy
  }
}
