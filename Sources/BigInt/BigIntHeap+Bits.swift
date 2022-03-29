// swiftlint:disable function_body_length

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
}
