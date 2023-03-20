// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
// swiftlint:disable empty_count
// cSpell:ignore Riku

// ASCII constants
private let _0: UInt8 = 48
private let _A: UInt8 = 65
private let _a: UInt8 = 97
private let _minus: UInt8 = 0x2D
private let maxRadix: BigIntStorage.Word = 36

private func ascii(_ n: BigIntStorage.Word, uppercase: Bool) -> UInt8 {
  // Performance sensitive area! Order of operations matters!
  // Compiler will emit code without overflow checks,
  // so we do not need to use unchecked '&' (like '&+' and '&-').
  assert(n < maxRadix) // Always less, never equal!
  let n = UInt8(truncatingIfNeeded: n)
  return n < 10 ?
    n + _0 :
    n - 10 + (uppercase ? _A : _a)
}

extension String {

  fileprivate typealias Initializer = (_ buffer: UnsafeMutableBufferPointer<UInt8>) -> Int

  /// Creates a new string with the specified capacity in UTF-8 code units, and
  /// then calls the given closure with a buffer covering the string's
  /// uninitialized memory.
  ///
  /// The closure should return the number of initialized code units.
  fileprivate static func create(
    unsafeUninitializedCapacity capacity: Int,
    initializingUTF8With initializer: Initializer
  ) -> String {
    // 'String(unsafeUninitializedCapacity:initializingUTF8With:)' is marked
    // with '@available(SwiftStdlib 5.3, *)'. The relation between Swift and
    // SwiftStdlib version is interesting (especially on Apple platforms).
    // Tested on Swift 5.5.2 and newer (which obviously mean >Swift 5.3).
    // As for the OS version check: I get it, but I'm not happy about it.

#if os(macOS)
    if #available(macOS 11.0, *) {
      return String(unsafeUninitializedCapacity: capacity, initializingUTF8With: initializer)
    } else {
      return Self.shim(capacity: capacity, initializer: initializer)
    }
#elseif os(iOS)
    if #available(iOS 14.0, *) {
      return String(unsafeUninitializedCapacity: capacity, initializingUTF8With: initializer)
    } else {
      return Self.shim(capacity: capacity, initializer: initializer)
    }
#elseif os(tvOS)
    if #available(tvOS 14.0, *) {
      return String(unsafeUninitializedCapacity: capacity, initializingUTF8With: initializer)
    } else {
      return Self.shim(capacity: capacity, initializer: initializer)
    }
#elseif os(watchOS)
    if #available(watchOS 7.0, *) {
      return String(unsafeUninitializedCapacity: capacity, initializingUTF8With: initializer)
    } else {
      return Self.shim(capacity: capacity, initializer: initializer)
    }
#else
    // Available in Swift 5.7.3 (older not tested).
    // Use 'Self.shim(capacity:initializer:)' if not.
    return String(unsafeUninitializedCapacity: capacity, initializingUTF8With: initializer)
#endif
  }

  private static func shim(capacity: Int, initializer: Initializer) -> String {
    let nullCapacity = capacity + 1
    let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: nullCapacity)
    defer { ptr.deallocate() }

    let bufferPtr = UnsafeMutableBufferPointer(start: ptr, count: capacity)
    let count = initializer(bufferPtr)
    assert(0 <= count && count <= capacity)

    let nullBufferPtr = UnsafeMutableBufferPointer(start: ptr, count: nullCapacity)
    nullBufferPtr[count] = 0

    return String(cString: ptr) // Borrows 'ptr' to create owned copy.
  }
}

extension BigIntHeap: CustomStringConvertible {

  internal var description: String {
    return self.toString(radix: 10, uppercase: false)
  }

  internal var debugDescription: String {
    return self.storage.description
  }

  internal func toString(radix: Int, uppercase: Bool) -> String {
    precondition(2 <= radix && radix <= maxRadix, "Radix not in range 2...36.")

    if self.isZero {
      return "0"
    }

    // if self.storage.count == 1 {
    //   let sign = self.isNegative ? "-" : ""
    //   let word = self.storage.withWordsBuffer { $0[0] }
    //   let wordString = String(word, radix: radix, uppercase: uppercase)
    //   return sign + wordString
    // }

    let radix = Word(bitPattern: radix)
    let isRadixPowerOf2 = radix & (radix - 1) == 0

    guard isRadixPowerOf2 else {
      return self.generic(radix: radix, uppercase: uppercase)
    }

    return self.storage.withWordsBuffer { words in
      // We will treat all of our words as a single continuous buffer
      // and group them by 'bitsPerChar'.
      //
      // Bits per character - we will group this many bits to produce a character:
      // - radix = 16 = 0b1_0000 -> bitsPerChar = 4
      // - radix =  8 = 0b0_1000 -> bitsPerChar = 3 etc.
      let bitsPerChar = radix.trailingZeroBitCount

      if Word.bitWidth.isMultiple(of: bitsPerChar) {
        return Self.radixIsPowerOfTwo_charIsAlwaysInSingleWord(
          isNegative: self.isNegative,
          words: words,
          radix: radix,
          uppercase: uppercase
        )
      }

      return Self.radixIsPowerOfTwo_charCanUseMultipleWords(
        isNegative: self.isNegative,
        words: words,
        radix: radix,
        uppercase: uppercase
      )
    }
  }

  // MARK: - Radix is power of 2

  private static func radixIsPowerOfTwo_charIsAlwaysInSingleWord(
    isNegative: Bool,
    words: UnsafeBufferPointer<Word>,
    radix: Word,
    uppercase: Bool
  ) -> String {
    assert(!words.isEmpty)

    // How many bits go into 1 character.
    let bitsPerChar = radix.trailingZeroBitCount
    let qr = Word.bitWidth.quotientAndRemainder(dividingBy: bitsPerChar)
    assert(qr.remainder == 0)
    let charCountPerWord = qr.quotient

    let digitCount = Self.countDigitsPow2(words: words, bitsPerChar: bitsPerChar)
    let capacity = digitCount + (isNegative ? 1 : 0)

    return String.create(unsafeUninitializedCapacity: capacity) { ptr in
      var index = 0

      if isNegative {
        ptr[index] = _minus
        index = 1
      }

      // 0000 0001 1010 0101
      // ^^^^ skip (but only for 1st word)
      let last = words[words.count - 1]
      var skip = charCountPerWord - last.leadingZeroBitCount / bitsPerChar - 1
      let mask = radix - 1

      for word in words.reversed() {
        for groupIndex in stride(from: skip, through: 0, by: -1) {
          let shift = groupIndex &* bitsPerChar
          let group = (word &>> shift) & mask
          ptr[index] = ascii(group, uppercase: uppercase)
          index &+= 1
        }

        // From now on we print everything, even middle '0'
        skip = charCountPerWord - 1
      }

      assert(index <= capacity)
      return index
    }
  }

  private static func radixIsPowerOfTwo_charCanUseMultipleWords(
    isNegative: Bool,
    words: UnsafeBufferPointer<Word>,
    radix: Word,
    uppercase: Bool
  ) -> String {
    assert(!words.isEmpty)

    // We will treat all of our words as a single continuous buffer
    // and group them by 'bitsPerChar' (starting from the back).
    //
    // Example for octal grouping (bitsPerChar = 3):
    // Grouped by word:        [000  001  01][1  010  101  0][10  101  010]
    // Grouped by bitsPerChar: [000][001][01  1][010][101][0  10][101][010]

    // Bits per character - we will group this many bits to produce character:
    // - radix = 16 = 0b1_0000 -> bitsPerChar = 4
    // - radix =  8 = 0b0_1000 -> bitsPerChar = 3 etc.
    let bitsPerChar = radix.trailingZeroBitCount
    let digitCount = Self.countDigitsPow2(words: words, bitsPerChar: bitsPerChar)
    let capacity = digitCount + (isNegative ? 1 : 0)

    return String.create(unsafeUninitializedCapacity: capacity) { ptr in
      var index = 0

      if isNegative {
        ptr[index] = _minus
        index = 1
      }

      // alreadyProcessedBits - number of bits that we already processed in current word.
      // For 1st word we will just skip all of the leading '0',
      // but the tricky part is that we still have to align it to 'bitsPerChar'.
      var alreadyProcessedBitCount = words.count * Word.bitWidth - digitCount * bitsPerChar
      // Mask - mask representing 'bitsPerChar':
      // - radix = 16 = 0b1_0000 -> charMask = 16 - 1 = 15 = 0b1111
      // - radix =  8 = 0b0_1000 -> charMask =  8 - 1 =  7 = 0b0111 etc.
      let mask = radix - 1

      for i in stride(from: words.count - 1, through: 0, by: -1) {
        let word = words[i]
        let wordRemainingBitCount = Word.bitWidth - alreadyProcessedBitCount
        let wordCharCount = wordRemainingBitCount / bitsPerChar

        for j in 0..<wordCharCount {
          let shift = wordRemainingBitCount &- bitsPerChar &- j &* bitsPerChar
          let group = (word &>> shift) & mask
          ptr[index] = ascii(group, uppercase: uppercase)
          index &+= 1
        }

        // Append last 'char' (the one that is split between 2 words)
        let wordSplitBitCount = wordRemainingBitCount % bitsPerChar
        if wordSplitBitCount != 0 {
          assert(i != 0, "Last should not need another word.")

          let shift = bitsPerChar - wordSplitBitCount
          let wordPart = word << shift
          let otherPart = words[i - 1] >> (Word.bitWidth - shift)

          let group = (wordPart | otherPart) & mask
          ptr[index] = ascii(group, uppercase: uppercase)
          index += 1

          alreadyProcessedBitCount = shift
        } else {
          // We do not have split 'char', everything is simple and clean.
          //
          // Speaking of which: https://www.youtube.com/watch?v=Irl_Dc-Tc8U
          // And damn, Mickey and Riku in KH3 are such a good ship.
          alreadyProcessedBitCount = 0
        }
      }

      assert(alreadyProcessedBitCount == 0)
      assert(index <= capacity)
      return index
    }
  }

  // MARK: - Generic

  private func generic(radix: Word, uppercase: Bool) -> String {
    assert(!words.isEmpty)

    var (divBuffer, digitCount) = self.storage.withWordsBuffer { words -> (DivBuffer, Int) in
      // Detail: order of those lines matter!
      // Creating 'DivBuffer' will 'memcpy'. 'countDigitsGeneric' will ask for the
      // last word. After 'DivBuffer' it should be in cache.
      // We are assuming how 'memcpy' works and this is a long shot,
      // but it is still a shot.
      let d = DivBuffer(words: words)
      let c = Self.countDigitsGeneric(words: words, radix: radix)
      return (d, c)
    }
    defer { divBuffer.deallocate() }

    let capacity = digitCount + (self.isNegative ? 1 : 0)
    let (charCountPerWord, power) = Word.maxRepresentablePower(of: radix)

    return String.create(unsafeUninitializedCapacity: capacity) { ptr in
      // We will write from the back
      var index = capacity - 1

      while !divBuffer.isZero {
        var remainder = Self.div(&divBuffer, by: power)
        let end = index - charCountPerWord

        while remainder != 0 {
          let qr = remainder.quotientAndRemainder(dividingBy: radix)
          remainder = qr.quotient
          ptr[index] = ascii(qr.remainder, uppercase: uppercase)
          index &-= 1
        }

        let isFirstWord = divBuffer.isZero

        while !isFirstWord && index != end {
          ptr[index] = _0
          index &-= 1
        }
      }

      if self.isNegative {
        ptr[index] = _minus
        index &-= 1
      }

      var count = capacity

      // Check for invalid capacity estimation
      if index != -1 {
        count = capacity - index - 1
        let dstPtr = ptr.baseAddress! // swiftlint:disable:this force_unwrapping
        let srcPtr = dstPtr.advanced(by: index + 1)
        dstPtr.assign(from: srcPtr, count: count)
        // For some reason we have to do this on macOS,
        // otherwise the tests will fail (Swift 5.5.2).
        dstPtr[count] = 0
      }

      return count
    }
  }

  // For some reason if we used `BigInt` to do divisions it would affect overall
  // `div` performance.
  // And I am not joking... all '/%' operations would get 20% slower. ???
  // Anyway, if you do any changes then also check for `/%` regressions.
  private struct DivBuffer {

    fileprivate let ptr: UnsafeMutableBufferPointer<Word>
    fileprivate var count: Int

    fileprivate var isZero: Bool {
      return self.count == 0
    }

    fileprivate init(words: UnsafeBufferPointer<Word>) {
      let count = words.count
      let ptr = UnsafeMutablePointer<Word>.allocate(capacity: count)

      // If there is no 'baseAddress' then the buffer is empty.
      if let wordsPtr = words.baseAddress {
        ptr.assign(from: wordsPtr, count: count)
      }

      self.ptr = UnsafeMutableBufferPointer(start: ptr, count: count)
      self.count = count
    }

    fileprivate func deallocate() {
      self.ptr.deallocate()
    }
  }

  /// Returns remainder.
  private static func div(_ dividend: inout DivBuffer, by divisor: Word) -> Word {
    var carry = Word.zero

    for i in (0..<dividend.count).reversed() {
      let arg = (high: carry, low: dividend.ptr[i])
      (dividend.ptr[i], carry) = divisor.dividingFullWidth(arg)
    }

    // Trim suffix zeros
    while dividend.count > 0 && dividend.ptr[dividend.count - 1] == 0 {
      dividend.count &-= 1
    }

    return carry
  }

  // MARK: - Count digits

  private static func countDigitsPow2(
    words: UnsafeBufferPointer<Word>,
    bitsPerChar: Int
  ) -> Int {
    let bitWidth = Self.magnitudeBitWidth(words: words)
    return Self.divCeil(bitWidth, by: bitsPerChar)
  }

  // Number of bits up to the highest '1' in binary representation.
  private static func magnitudeBitWidth(words: UnsafeBufferPointer<Word>) -> Int {
    let last = words[words.count - 1]
    return words.count * Word.bitWidth - last.leadingZeroBitCount
  }

  private static func divCeil<T: FixedWidthInteger>(
    _ dividend: T,
    by divisor: T
  ) -> T {
    return (dividend + divisor - 1) / divisor
  }

  // Lookup table for the maximum number of bits required per character of a
  // base-N string representation of a number. To increase accuracy, the array
  // value is the actual value multiplied by 32. To generate this table:
  // for (var i = 0; i <= 36; i++) { print(Math.ceil(Math.log2(i) * 32) + ","); }
  private static let kMaxBitsPerChar: [UInt8] = [
    0,   0,   32,  51,  64,  75,  83,  90,  96,  // 0..8
    102, 107, 111, 115, 119, 122, 126, 128,      // 9..16
    131, 134, 136, 139, 141, 143, 145, 147,      // 17..24
    149, 151, 153, 154, 156, 158, 159, 160,      // 25..32
    162, 163, 165, 166                           // 33..36
  ]

  private static let kBitsPerCharTableShift = 5
  private static let kBitsPerCharTableMultiplier: UInt64 = 1 << kBitsPerCharTableShift

  /// Upper bound.
  ///
  /// This function was taken from V8. It is a VERY accurate estimation.
  /// https://github.com/v8/v8/blob/6add89ebaa7890a25918dbd361c17562acf8b141/src/bigint/tostring.cc#L588
  private static func countDigitsGeneric(
    words: UnsafeBufferPointer<Word>,
    radix: Word
  ) -> Int {
    // Maximum number of bits we can represent with one character.
    let max_bits_per_char = Self.kMaxBitsPerChar[Int(radix)]
    // For estimating the result length, we have to be pessimistic and work with
    // the minimum number of bits one character can represent.
    let min_bits_per_char = UInt64(max_bits_per_char - 1)
    // Perform the following computation with uint64_t to avoid overflows.
    var chars_required = UInt64(Self.magnitudeBitWidth(words: words))
    // VIOLET: All values in 'kMaxBitsPerChar' are *32 and a/b = (a*n)/(b*n).
    chars_required *= Self.kBitsPerCharTableMultiplier
    chars_required = Self.divCeil(chars_required, by: min_bits_per_char)
    return Int(chars_required)
  }
}
