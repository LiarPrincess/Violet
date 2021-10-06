// cSpell:ignore Riku

private let lowercaseDigits: [Character] = [
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
  "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
]

private let uppercaseDigits: [Character] = [
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
  "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]

extension BigIntHeap: CustomStringConvertible {

  internal var description: String {
    return self.toString(radix: 10, uppercase: false)
  }

  internal var debugDescription: String {
    return self.storage.description
  }

  internal func toString(radix: Int, uppercase: Bool) -> String {
    precondition(2 <= radix && radix <= 36, "Radix not in range 2...36.")

    if self.isZero {
      return "0"
    }

    if self.isPowerOf2(value: radix) {
      return self.radixIsPowerOfTwo(radix: radix, uppercase: uppercase)
    }

    if self.storage.count == 1 {
      let word = self.storage[0]
      let wordString = String(word, radix: radix, uppercase: uppercase)
      return self.signString + wordString
    }

    return self.generic(radix: radix, uppercase: uppercase)
  }

  private var signString: String {
    return self.isNegative ? "-" : ""
  }

  private func isPowerOf2(value: Int) -> Bool {
    return value & (value - 1) == 0
  }

  // MARK: - Radix is power of 2

  // swiftlint:disable:next function_body_length
  private func radixIsPowerOfTwo(radix: Int, uppercase: Bool) -> String {
    assert(!self.isZero)

    let characterSet = uppercase ? uppercaseDigits : lowercaseDigits

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

    // Char mask - mask representing 'bitsPerChar':
    // - radix = 16 = 0b1_0000 -> charMask = 16 - 1 = 15 = 0b1111
    // - radix =  8 = 0b0_1000 -> charMask =  8 - 1 =  7 = 0b0111 etc.
    let charMask = Word(radix) - 1

    // alreadyProcessedBits - number of bits that we already processed in current word.
    // For 1st word we will just skip all of the leading '0',
    // but the tricky part is that we still have to align it to 'bitsPerChar'.
    var alreadyProcessedBitCount: Int = {
      let leadingZeroCount = self.storage[self.storage.count - 1].leadingZeroBitCount
      let bitWidth = self.storage.count * Word.bitWidth - leadingZeroCount
      let totalCharCount = (bitWidth + bitsPerChar - 1) / bitsPerChar
      return self.storage.count * Word.bitWidth - totalCharCount * bitsPerChar
    }()

    var result = self.signString
    for i in stride(from: self.storage.count - 1, through: 0, by: -1) {
      let word = self.storage[i]

      // Extract as many 'chars' as we can from this word
      let usableBitCountInWord = Word.bitWidth - alreadyProcessedBitCount
      let charCountInWord = usableBitCountInWord / bitsPerChar

      for i in 0..<charCountInWord {
        let shift = usableBitCountInWord - bitsPerChar - i * bitsPerChar
        let charBits = (word >> shift) & charMask
        let digit = characterSet[Int(charBits)]
        result.append(digit)
      }

      // Append last 'char' (the one that is split between 2 words)
      let thisWordSplitBitCount = usableBitCountInWord % bitsPerChar
      if thisWordSplitBitCount != 0 {
        assert(i != 0, "Last should not need another word.")

        let otherWordSplitBitCount = bitsPerChar - thisWordSplitBitCount
        let thisWordPart = word << otherWordSplitBitCount
        let otherWordPart = self.storage[i - 1] >> (Word.bitWidth - otherWordSplitBitCount)

        let charBits = (thisWordPart | otherWordPart) & charMask
        let digit = characterSet[Int(charBits)]
        result.append(digit)

        alreadyProcessedBitCount = otherWordSplitBitCount
      } else {
        // We do not have split 'char', everything is simple and clean.
        //
        // Speaking of which: https://www.youtube.com/watch?v=Irl_Dc-Tc8U
        // And damn, Mickey and Riku in KH3 are such a good ship.
        alreadyProcessedBitCount = 0
      }
    }

    assert(alreadyProcessedBitCount == 0)
    return result
  }

  // MARK: - Generic

  private func generic(radix: Int, uppercase: Bool) -> String {
    var selfCopy = self
    if selfCopy.isNegative {
      selfCopy.negate()
    }

    /// Remainders from division by 'radix' (well, actually by 'power')
    var remainders = [Word]()
    let (scalarCountPerWord, power) = Word.maxRepresentablePower(of: radix)

    while !selfCopy.isZero {
      let remainder = selfCopy.div(other: power)
      assert(remainder.isPositive)
      remainders.append(remainder.magnitude)
    }

    assert(!remainders.isEmpty)

    var result = self.signString
    for (index, remainder) in remainders.reversed().enumerated() {
      let s = String(remainder, radix: radix, uppercase: uppercase)

      // Insert leading zeroes for mid-Words
      if index != 0 {
        let count = scalarCountPerWord - s.count
        assert(count >= 0) // swiftlint:disable:this empty_count
        result.append(String(repeating: "0", count: count))
      }

      result.append(s)
    }

    return result
  }
}
