// Sources:
// - V8 (google-javascript-thingie): 'src/objects/bigint.cc'
// - Knuth "The Art of Computer Programming vol 2" - 4.3.1 - Algorithm D
//
// Seriously look both of the sources!
// They are really good and very accessible.
// V8 implements exactly the "Algorithm D" without any noise/weirdness.
// Their implementation is AMAZING.

// swiftlint:disable file_length

extension BigIntHeap {

  // MARK: - Sign

  // - sign of the result follows standard math rules:
  //   if the operands had the same sign then positive, otherwise negative
  // - sign of the remainder is the same `self` sign
  //
  // Based on following Swift code:
  // ```
  // let x = 10
  // let y = 3
  //
  // print(" \(x) /  \(y) =",   x  /   y,  "rem",   x  %   y)  //  10 /  3 =  3 rem  1
  // print(" \(x) / -\(y) =",   x  / (-y), "rem",   x  % (-y)) //  10 / -3 = -3 rem  1
  // print("-\(x) /  \(y) =", (-x) /   y,  "rem", (-x) %   y)  // -10 /  3 = -3 rem -1
  // print("-\(x) / -\(y) =", (-x) / (-y), "rem", (-x) % (-y)) // -10 / -3 =  3 rem -1
  // ```

  /// If the signs are the same then result is positive:
  /// `2/1 = 2` and also `(-2)/(-1) = 2`
  private func divIsNegative(otherIsNegative: Bool) -> Bool {
    return self.isNegative != otherIsNegative
  }

  /// Remainder will have the same sign as we have now.
  ///
  /// (It will ignore the argument, but we want symmetry with `divIsNegative`)
  private func remIsNegative(otherIsNegative: Bool) -> Bool {
    return self.isNegative
  }

  // MARK: - Smi

  /// Returns remainder.
  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func div(other: Smi.Storage) -> Smi.Storage {
    defer { self.checkInvariants() }

    if other == -1 {
      self.negate() // x / (-1) = -x
      return .zero
    }

    let resultIsNegative = self.divIsNegative(otherIsNegative: other.isNegative)
    let remainderIsNegative = self.remIsNegative(otherIsNegative: other.isNegative)

    let otherMagnitude = Word(other.magnitude)
    let wordRemainder = self.div(other: otherMagnitude)

    let token = self.storage.guaranteeUniqueBufferReference()
    self.storage.setIsNegative(token, value: resultIsNegative)

    self.fixInvariants(token)

    // Remainder is always less than the number we divide by.
    // So even if we divide by min value (for example for 'Int8' it is -128),
    // the max possible remainder (127) is still representable in given type.
    let unsignedRemainder = Smi.Storage(wordRemainder.magnitude)
    return remainderIsNegative ? -unsignedRemainder : unsignedRemainder
  }

  // MARK: - Word

  internal struct DivWordRemainder {

    fileprivate static let zero = DivWordRemainder(isNegative: false, magnitude: 0)

    internal let isNegative: Bool
    internal let magnitude: Word

    internal var isPositive: Bool {
      return !self.isNegative
    }
  }

  /// Returns remainder.
  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func div(other: Word) -> DivWordRemainder {
    precondition(!other.isZero, "Division by zero")

    if other == 1 {
      return .zero // x / 1 = x
    }

    if self.isZero {
      return .zero // 0 / n = 0
    }

    defer { self.checkInvariants() }

    let resultIsNegative = self.divIsNegative(otherIsNegative: false)
    let remainderIsNegative = self.remIsNegative(otherIsNegative: other.isNegative)

    switch self.compareMagnitude(with: other) {
    case .equal: // 5 / 5 = 1 rem 0 and also 5 / (-5) = -1 rem 0
      let token = self.storage.guaranteeUniqueBufferReference()
      self.storage.setTo(token, value: resultIsNegative ? -1 : 1)
      return .zero

    case .less: // 3 / 5 = 0 rem 3
      // Basically return 'self' as remainder
      assert(self.storage.count == 1)
      let remainderMagnitude = self.storage.withWordsBuffer { $0[0] }
      self.storage.setToZero()
      return DivWordRemainder(isNegative: remainderIsNegative,
                              magnitude: remainderMagnitude)

    case .greater:
      let token = self.storage.guaranteeUniqueBufferReference()
      let remainderMagnitude = Self.divMagnitude(token, &self.storage, by: other)
      self.storage.setIsNegative(token, value: resultIsNegative)
      self.fixInvariants(token)

      return DivWordRemainder(isNegative: remainderIsNegative,
                              magnitude: remainderMagnitude)
    }
  }

  /// Returns remainder.
  ///
  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  ///
  /// Precondition: `dividend > divisor`
  private static func divMagnitude(
    _ dividendToken: UniqueBufferToken,
    _ dividend: inout BigIntStorage,
    by divisor: Word
  ) -> Word {
    // Shifting right when 'other' is power of 2
    // would not work for negative numbers.
    return dividend.withMutableWordsBuffer(dividendToken) { dividend -> Word in
      var carry = Word.zero

      for i in (0..<dividend.count).reversed() {
        let arg = (high: carry, low: dividend[i])
        (dividend[i], carry) = divisor.dividingFullWidth(arg)
      }

      return carry
    }
  }

  // MARK: - Heap

  private static let zero = BigIntHeap()

  /// Returns remainder.
  internal mutating func div(other: BigIntHeap) -> BigIntHeap {
    // Special cases: other is '0', '1' or '-1'
    precondition(!other.isZero, "Division by zero")

    if other.hasMagnitudeOfOne {
      // x /   1  =  x rem 0
      // x / (-1) = -x rem 0
      if other.isNegative {
        self.negate()
      }

      return .zero
    }

    // Special case: '0' divided by anything is '0 rem 0'
    if self.isZero {
      return .zero
    }

    defer { self.checkInvariants() }

    let resultIsNegative = self.divIsNegative(otherIsNegative: other.isNegative)
    let remainderIsNegative = self.remIsNegative(otherIsNegative: other.isNegative)
    var token = self.storage.guaranteeUniqueBufferReference()

    switch self.compareMagnitude(with: other) {
    case .equal: // 5 / 5 = 1 rem 0 and also 5 / (-5) = -1 rem 0
      self.storage.setTo(token, value: resultIsNegative ? -1 : 1)
      return .zero

    case .less: // 3 / 5 = 0 rem 3
      // Basically return 'self' as remainder
      // We have to do a little dance to avoid COW.
      self.storage.setIsNegative(token, value: remainderIsNegative)
      let remainder = self
      self.storage.setToZero() // Will use predefined 'BigIntStorage.zero'
      return remainder

    case .greater:
      var remainder = Self.divMagnitude(token,  &self.storage, by: other.storage)
      token = self.storage.guaranteeUniqueBufferReference() // 'divMagnitude' may reallocate
      self.storage.setIsNegative(token, value: resultIsNegative)

      self.fixInvariants(token)

      let remainderToken = remainder.storage.guaranteeUniqueBufferReference()
      remainder.storage.setIsNegative(remainderToken, value: remainderIsNegative)
      remainder.fixInvariants(remainderToken)
      return remainder
    }
  }

  // MARK: - Oh no! We have to implement proper div logic!

  /// Returns remainder.
  ///
  /// See Knuth (seriously, do it).
  ///
  /// Will NOT look at the sign of any of those numbers!
  /// Only at the magnitude.
  private static func divMagnitude(
    _ lhsToken: UniqueBufferToken,
    _ lhs: inout BigIntStorage,
    by rhs: BigIntStorage
  ) -> BigIntHeap {
    // Check for single word divisor, to guarantee 'n >= 2'
    if rhs.count == 1 {
      let word = rhs.withWordsBuffer { $0[0] }
      let remainder = Self.divMagnitude(lhsToken, &lhs, by: word)
      return BigIntHeap(remainder.magnitude)
    }

    // D1.
    // Left-shift inputs so that the divisor's MSB is '1'.
    // Note that: 'a / b = (a * n) / (b * n)'
    let rhsLowWord = rhs.withWordsBuffer { $0[rhs.count - 1] }
    let shift = rhsLowWord.leadingZeroBitCount

    // Holds the (continuously updated) remaining part of the dividend,
    // which eventually becomes the remainder.
    var remainder = Self.specialLeftShift(lhs: lhs, shift: shift)
    let remainderToken = remainder.guaranteeUniqueBufferReference()
    // This is the correct value that should be used during calculation!
    let shiftedRhs = Self.specialLeftShift(rhs: rhs, shift: shift)
    defer { shiftedRhs.deallocate() }

    let lhsCount = lhs.count
    let rhsCount = rhs.count

    lhs.withMutableWordsBuffer(lhsToken) { lhs in
      // We no longer need 'lhs', since we will be using 'remainder',
      // for the actual division. We will use it to accumulate result instead.
      lhs.assign(repeating: 0)

      remainder.withMutableWordsBuffer(remainderToken) { remainder in
        Self.inner(
          lhsCount: lhsCount,
          rhsCount: rhsCount,
          lhsWhichBecomesRemainder: remainder,
          rhs: shiftedRhs,
          result: lhs
        )
      }
    }

    // 'lhs' holds the result
    lhs.fixInvariants(lhsToken)

    // D8.
    // Undo the 'specialLeftShift' from the start of this function
    Self.specialRightShift(remainderToken, value: &remainder, shift: shift)
    remainder.fixInvariants(remainderToken)
    return BigIntHeap(storageWithValidInvariants: remainder)
  }

  /// Do `remainder / rhs` updating `result`
  private static func inner(
    lhsCount: Int,
    rhsCount: Int,
    lhsWhichBecomesRemainder lhs: UnsafeMutableBufferPointer<Word>,
    rhs: UnsafeBufferPointer<Word>,
    result: UnsafeMutableBufferPointer<Word>
  ) {
    // Assuming that we already checked for '0'
    assert(lhsCount >= rhsCount)
    assert(rhsCount >= 2) // We checked for 'divisor.storage.count == 1'
    assert(Word.bitWidth == 64) // Other not tested

    let n = rhsCount
    let m = lhsCount - rhsCount

    // In each iteration we will be dividing 'remainderHighWords' by 'divisorHighWords'
    // to estimate quotient word.
    let rhsHighWords = (rhs[n - 1], rhs[n - 2])

    // This will hold 'divisor * quotientGuess',
    // so that we do not have to allocate on every iteration.
    var mulBuffer = MulBuffer(capacity: n + 1)
    defer { mulBuffer.deallocate() }

    // D2. D7.
    // Iterate over the dividend's digit (like the 'grad school' algorithm).
    for i in stride(from: m, through: 0, by: -1) {
      // D3.
      // Estimate the current quotient digit by dividing the most significant
      // digits of dividend and divisor.
      // The result may be exact or it may be '1' too high.
      let remainderHighWords = (lhs[i + n], lhs[i + n - 1], lhs[i + n - 2])
      var guess = Self.approximateQuotient(dividing: remainderHighWords, by: rhsHighWords)

      // D4. D5. D6.
      // Multiply the divisor with the current quotient digit,
      // and subtract it from the dividend.
      // If there was 'borrow', then the quotient digit was '1' too high,
      // so we must correct it and undo one subtraction of the (shifted) divisor.
      mulBuffer.removeAll()
      Self.internalMultiply(lhs: rhs, rhs: guess, into: &mulBuffer)

      let borrow = Self.inPlaceSub(lhs: lhs, rhs: mulBuffer, startIndex: i)
      if borrow != 0 {
        let carry = Self.inPlaceAdd(lhs: lhs, rhs: rhs, startIndex: i)
        lhs[i + n] += carry
        guess -= 1
      }

      result[i] = guess
    }
  }

  private struct MulBuffer {

    private let ptr: UnsafeMutableBufferPointer<Word>
    fileprivate private(set) var count: Int

    fileprivate subscript(index: Int) -> Word {
      get { return self.ptr[index] }
      set { self.ptr[index] = newValue }
    }

    fileprivate init(capacity: Int) {
      self.ptr = UnsafeMutableBufferPointer<Word>.allocate(capacity: capacity)
      self.count = 0
    }

    fileprivate mutating func append(_ word: Word) {
      self[self.count] = word
      self.count += 1
    }

    fileprivate mutating func removeAll() {
      self.count = 0
    }

    fileprivate func deallocate() {
      self.ptr.deallocate()
    }
  }

  // MARK: - Approximate quotient

  /// See Knuth.
  private static func approximateQuotient(
    dividing u: (Word, Word, Word), // swiftlint:disable:this large_tuple
    by v: (Word, Word)
  ) -> Word {
    // 601 / 61 = ~10 = 9 = Word.max (example for decimal words)
    if u.0 == v.0 {
      return Word.max
    }

    // Divide 2 highest digits of 'u' by highest digit of 'v'
    var (q, remainder) = v.0.dividingFullWidth((u.0, u.1))

    // Decrement the quotient estimate as needed by looking at the next digit
    while Self.productGreaterThan(factor1: v.1, factor2: q, high: remainder, low: u.2) {
      q -= 1

      let (value, overflow) = remainder.addingReportingOverflow(v.0)
      remainder = value

      if overflow {
        break
      }
    }

    return q
  }

  /// Returns whether `(factor1 * factor2) > (high << kDigitBits) + low`.
  private static func productGreaterThan(factor1: Word,
                                         factor2: Word,
                                         high: Word,
                                         low: Word) -> Bool {
    let (resultHigh, resultLow) = factor1.multipliedFullWidth(by: factor2)
    return resultHigh > high || (resultHigh == high && resultLow > low)
  }

  // MARK: - Special shifts

  private static func specialLeftShift(
    lhs value: BigIntStorage,
    shift: Int
  ) -> BigIntStorage {
    let count = value.count + 1
    var result = BigIntStorage(repeating: .zero, count: count)
    let token = result.guaranteeUniqueBufferReference()

    result.withMutableWordsBuffer(token) { result in
      value.withWordsBuffer { value in
        result[result.count - 1] = value[value.count - 1] >> (Word.bitWidth - shift)

        for i in stride(from: value.count - 1, to: 0, by: -1) {
          let high = value[i] << shift
          let low = value[i - 1] >> (Word.bitWidth - shift)
          result[i] = high | low
        }

        result[0] = value[0] << shift
      }
    }

    return result
  }

  private static func specialLeftShift(
    rhs value: BigIntStorage,
    shift: Int
  ) -> UnsafeBufferPointer<Word> {
    let count = value.count
    let result = UnsafeMutableBufferPointer<Word>.allocate(capacity: count)
    result.assign(repeating: 0)

    value.withWordsBuffer { value in
      for i in stride(from: value.count - 1, to: 0, by: -1) {
        let high = value[i] << shift
        let low = value[i - 1] >> (Word.bitWidth - shift)
        result[i] = high | low
      }

      result[0] = value[0] << shift
    }

    return UnsafeBufferPointer(result)
  }

  private static func specialRightShift(
    _ token: UniqueBufferToken,
    value: inout BigIntStorage,
    shift: Int
  ) {
    if shift == 0 {
      return
    }

    value.withMutableWordsBuffer(token) { value in
      for i in 0..<(value.count - 1) {
        let low = value[i] >> shift
        let high = value[i + 1] << (Word.bitWidth - shift)
        value[i] = high | low
      }

      value[value.count - 1] = value[value.count - 1] >> shift
    }
  }

  // MARK: - Add, sub, mul

  /// Adds `rhs` onto `lhs`, starting with `rhs` 0th digit at `lhs` `startIndex` digit.
  ///
  /// Returns the `carry` (0 or 1).
  private static func inPlaceAdd(
    lhs: UnsafeMutableBufferPointer<Word>,
    rhs: UnsafeBufferPointer<Word>,
    startIndex: Int
  ) -> Word {
    var carry: Word = 0

    for i in 0..<rhs.count {
      let (word1, overflow1) = lhs[startIndex + i].addingReportingOverflow(rhs[i])
      let (word2, overflow2) = word1.addingReportingOverflow(carry)
      lhs[startIndex + i] = word2
      carry = (overflow1 ? 1 : 0) + (overflow2 ? 1 : 0)
    }

    return carry
  }

  /// Subtracts `rhs` from `lhs`, starting with `rhs` 0th digit
  /// and `lhs` `startIndex` digit.
  ///
  /// Returns the `borrow` (0 or 1).
  private static func inPlaceSub(
    lhs: UnsafeMutableBufferPointer<Word>,
    rhs: MulBuffer,
    startIndex: Int
  ) -> Word {
    var borrow: Word = 0

    for i in 0..<rhs.count {
      let (word1, borrow1) = lhs[startIndex + i].subtractingReportingOverflow(rhs[i])
      let (word2, borrow2) = word1.subtractingReportingOverflow(borrow)
      lhs[startIndex + i] = word2
      borrow = (borrow1 ? 1 : 0) + (borrow2 ? 1 : 0)
    }

    return borrow
  }

  /// Multiplies `lhs` with `rhs` and adds `summand` to the result.
  /// `result` and `lhs` may be the same BigInt for in-place modification.
  private static func internalMultiply(
    lhs: UnsafeBufferPointer<Word>,
    rhs: Word,
    into result: inout MulBuffer
  ) {
    var carry: Word = 0

    for i in 0..<lhs.count {
      let (high, low) = lhs[i].multipliedFullWidth(by: rhs)
      let (word, overflow) = low.addingReportingOverflow(carry)
      result.append(word)
      carry = high &+ (overflow ? 1 : 0)
    }

    // Add the leftover carry
    if carry != 0 {
      result.append(carry)
    }
  }

  // MARK: - Rem

  internal mutating func rem(other: Smi.Storage) {
    defer { self.checkInvariants() }

    var copy = self
    let result = copy.div(other: other)
    self = BigIntHeap(result)
  }

  internal mutating func rem(other: BigIntHeap) {
    defer { self.checkInvariants() }

    var copy = self
    let result = copy.div(other: other)
    self = result
  }

  // MARK: - Div rem

  internal typealias DivRem<Remainder> = (quotient: BigIntHeap, remainder: Remainder)

  internal func divRem(other: Smi.Storage) -> DivRem<Smi.Storage> {
    var copy = self
    let rem = copy.div(other: other)
    return (copy, rem)
  }

  internal func divRem(other: BigIntHeap) -> DivRem<BigIntHeap> {
    var copy = self
    let rem = copy.div(other: other)
    return (copy, rem)
  }
}
