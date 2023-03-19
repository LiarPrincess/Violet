// swiftlint:disable function_parameter_count
// swiftlint:disable function_body_length
// swiftlint:disable empty_count

// ASCII constants
private let _0: UInt8 = 48
private let _A: UInt8 = 65
private let _a: UInt8 = 97
private let _plus: UInt8 = 43
private let _minus: UInt8 = 45

extension BigInt {

  private typealias Word = BigIntStorage.Word
  private typealias UniqueBufferToken = BigIntStorage.UniqueBufferToken

  public init?(_ string: String, radix: Int = 10) {
    // swiftlint:disable:next yoda_condition
    guard 2 <= radix && radix <= 36 else {
      return nil
    }

    if string.isEmpty {
      return nil
    }

    let utf8 = string.utf8

    // Most of the time we will go 'fast' (in Swift dominant apps).
    // Fast (on 'UnsafeBufferPointer') is 2x faster than on 'UTF8View'.
    let fast = utf8.withContiguousStorageIfAvailable { ptr in
      return Self.parse(ptr, radix: radix)
    }

    // There is also 'string.withUTF8', but it may copy the whole input and that
    // could result in ENOMEM. We value stability over performance.
    // However, the generic version is ~5% slower than non-generic one.
    if let r = fast ?? Self.parse(utf8, radix: radix) {
      self = r
      return
    }

    return nil
  }

  // MARK: - Parse

  // Compiler will specialize, but you have to be very careful with modifications!
  // Check the performance after EVERY change and DO NOT ignore small regressions!
  private static func parse<C: BidirectionalCollection>(
    _ chars: C,
    radix: Int
  ) -> BigInt? where C.Element == UInt8 {
    assert(!chars.isEmpty, "BigInt.parse with empty?")

    var (isNegative, index) = Self.parseSign(chars)
    let endIndex = chars.endIndex

    if index == endIndex { // Only sign
      return nil
    }

    let hasZeroPrefix = Self.consumePrefix0(chars, index: &index)

    if index == endIndex { // Sign and zeros
      return hasZeroPrefix ? BigInt() : nil
    }

    let radix = Word(bitPattern: radix)
    let parser = Parser(radix: radix)

    let (charCountPerWord, power) = Word.maxRepresentablePower(of: radix)
    let remainingCount = chars.distance(from: index, to: endIndex)
    // 'capacity' is an overallocation, so we always have 1 more word.
    let capacity = (remainingCount / charCountPerWord) + 1

    var result = BigIntStorage(minimumCapacity: capacity)
    let token = result.guaranteeUniqueBufferReference()
    result.setIsNegative(token, value: isNegative)

    let isRadixPowerOf2 = radix & (radix - 1) == 0
    if isRadixPowerOf2 {
      return Self.radixIsPowerOfTwo(chars,
                                    index: index,
                                    result: &result,
                                    resultToken: token,
                                    radix: radix,
                                    parser: parser,
                                    capacityWith1MoreWord: capacity)
    }

    return Self.generic(chars,
                        index: index,
                        result: &result,
                        resultToken: token,
                        radix: radix,
                        parser: parser,
                        remainingCount: remainingCount,
                        charCountPerWord: charCountPerWord,
                        power: power)
  }

  private static func parseSign<C: Collection>(
    _ chars: C
  ) -> (isNegative: Bool, index: C.Index) where C.Element == UInt8 {
    var index = chars.startIndex
    let first = chars[index]

    if first == _plus {
      chars.formIndex(after: &index)
      return (isNegative: false, index: index)
    }

    if first == _minus {
      chars.formIndex(after: &index)
      return (isNegative: true, index: index)
    }

    return (isNegative: false, index: index)
  }

  private static func consumePrefix0<C: Collection>(
    _ chars: C,
    index: inout C.Index
  ) -> Bool where C.Element == UInt8 {
    let hasZeroPrefix = chars[index] == _0
    let endIndex = chars.endIndex

    while index != endIndex && chars[index] == _0 {
      chars.formIndex(after: &index)
    }

    return hasZeroPrefix
  }

  // MARK: - Radix is power of 2

  private static func radixIsPowerOfTwo<C: BidirectionalCollection>(
    _ chars: C,
    index: C.Index,
    result: inout BigIntStorage,
    resultToken token: UniqueBufferToken,
    radix: Word,
    parser: Parser,
    capacityWith1MoreWord capacity: Int
  ) -> BigInt? where C.Element == UInt8 {
    // Temporary, just so we have an access to the whole buffer.
    result.setCount(token, value: capacity)

    // This function returns the correct count.
    let count = result.withMutableWordsBuffer(token) { words -> Int in
      // Single character is responsible for this many bits.
      // - radix = 16 = 0b1_0000 -> bitsPerChar = 4
      // - radix =  8 = 0b0_1000 -> bitsPerChar = 3 etc.
      let bitsPerChar = radix.trailingZeroBitCount

      var wordIndex = 0
      var wordShift = 0
      words[wordIndex] = 0 // Clean uninitialized word

      var reverseIndex = chars.endIndex
      chars.formIndex(before: &reverseIndex)

      while reverseIndex >= index {
        let char = chars[reverseIndex]
        guard let digit = parser.parse(char) else {
          return -1
        }

        words[wordIndex] |= digit &<< wordShift
        wordShift &+= bitsPerChar

        if wordShift >= Word.bitWidth {
          wordIndex &+= 1
          wordShift = wordShift % Word.bitWidth
          // Move missing bits or (if 'wordShift == 0') clean uninitialized word.
          // 'capacity' is an overallocation, so we always have 1 more word.
          assert(wordIndex < capacity)
          words[wordIndex] = digit &>> (bitsPerChar &- wordShift)
        }

        chars.formIndex(before: &reverseIndex)
      }

      // Count = lastIndex + 1, because arrays use '0' based addressing.
      return wordIndex + 1
    }

    if count < 0 {
      return nil
    }

    result.setCount(token, value: count)
    result.fixInvariants(token)
    return BigInt(BigIntHeap(storageWithValidInvariants: result))
  }

  // MARK: - Generic

  private static func generic<C: Collection>(
    _ chars: C,
    index: C.Index,
    result: inout BigIntStorage,
    resultToken token: UniqueBufferToken,
    radix: Word,
    parser: Parser,
    remainingCount: Int,
    charCountPerWord: Int,
    power: Word
  ) -> BigInt? where C.Element == UInt8 {
    // Instead of using a single 'BigInt' and multiplying it by 'radix',
    // we will group scalars into words-sized chunks.
    // Then we will raise those chunks to appropriate power and add together.
    //
    // For example:
    // 1_2345_6789 = (1 * 10^8) + (2345 * 10^4) + (6789 * 10^0)
    //
    // So, we are doing most of our calculations in fast 'Word',
    // and then we switch to slow BigInt for a few final operations.
    var index = index
    let endIndex = chars.endIndex

    var currentWord = Word.zero
    let firstWordCount = remainingCount % charCountPerWord
    var remainingCharsInCurrentWord = firstWordCount == 0 ?
      charCountPerWord :
      firstWordCount

    while index != endIndex {
      let char = chars[index]
      guard let digit = parser.parse(char) else {
        return nil
      }

      // Strictly obeying 'charCountPerWord' allows us to skip overflow checks.
      currentWord = currentWord &* radix &+ digit
      remainingCharsInCurrentWord &-= 1

      if remainingCharsInCurrentWord == 0 {
        // Append word even if it is '0' - we can have '0' words in the middle!
        BigIntHeap.mulMagnitude(token, lhs: &result, rhs: power)
        BigIntHeap.addMagnitude(token, lhs: &result, rhs: currentWord)
        currentWord = 0
        remainingCharsInCurrentWord = charCountPerWord
      }

      chars.formIndex(after: &index)
    }

    result.fixInvariants(token)
    assert(index == endIndex)
    assert(remainingCharsInCurrentWord == charCountPerWord) // Next non-existing group
    return BigInt(BigIntHeap(storageWithValidInvariants: result))
  }

  // Taken from Swift sources (kind of...).
  private struct Parser {
    private let numericalUpperBound: UInt8
    private let uppercaseUpperBound: UInt8
    private let lowercaseUpperBound: UInt8

    fileprivate init(radix: Word) {
      if radix <= 10 {
        self.numericalUpperBound = _0 &+ UInt8(truncatingIfNeeded: radix)
        self.uppercaseUpperBound = _A
        self.lowercaseUpperBound = _a
      } else {
        self.numericalUpperBound = _0 &+ 10
        self.uppercaseUpperBound = _A &+ UInt8(truncatingIfNeeded: radix &- 10)
        self.lowercaseUpperBound = _a &+ UInt8(truncatingIfNeeded: radix &- 10)
      }
    }

    fileprivate func parse(_ char: UInt8) -> Word? {
      return
        _0 <= char && char < numericalUpperBound ? Word(truncatingIfNeeded: char &- _0) :
        _A <= char && char < uppercaseUpperBound ? Word(truncatingIfNeeded: char &- _A &+ 10) :
        _a <= char && char < lowercaseUpperBound ? Word(truncatingIfNeeded: char &- _a &+ 10) :
        nil
    }
  }
}
