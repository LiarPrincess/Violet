import VioletCore

// Sources:
// - mini-gmp: https://gmplib.org
//
// Mostly for right shift.
// The person that wrote it is a AMAZING…
//
// GMP function name is in the comment above method.

// swiftlint:disable function_body_length

extension BigIntHeap {

  internal typealias ReasonableCount = UInt64

  internal mutating func shiftLeft<T: BinaryInteger>(count: T) {
    let isNegative = count < T.zero

    if let count = ReasonableCount(exactly: count.magnitude) {
      if isNegative {
        self.shiftRight(count: count)
      } else {
        self.shiftLeft(count: count)
      }
    } else {
      if isNegative {
        self.unreasonableRight(count: count)
      } else {
        self.unreasonableLeft()
      }
    }
  }

  internal mutating func shiftRight <T: BinaryInteger>(count: T) {
    let isNegative = count < T.zero

    if let count = ReasonableCount(exactly: count.magnitude) {
      if isNegative {
        self.shiftLeft(count: count)
      } else {
        self.shiftRight(count: count)
      }
    } else {
      if isNegative {
        self.unreasonableLeft()
      } else {
        self.unreasonableRight(count: count)
      }
    }
  }

  // MARK: - Left

  internal mutating func shiftLeft(count: ReasonableCount) {
    if self.isZero || count == ReasonableCount.zero {
      return
    }

    defer { self.storage.checkInvariants() }

    let wordShift = Int(count / ReasonableCount(Word.bitWidth))
    let bitShift = Int(count % ReasonableCount(Word.bitWidth))

    let wordCountBeforeShift = self.storage.count
    let capacity = self.storage.count + wordShift + (bitShift == 0 ? 0 : 1)
    let token = self.storage.guaranteeUniqueBufferReference(withCapacity: capacity)
    self.storage.prependAssumingCapacity(token, element: 0, count: wordShift)

    // If we are shifting by multiply of 'Word' then we are done.
    // For example for 4 bit word if we shift by 4, 8, 12 or 16
    // we do not have to do anything else: [1011] << 4 = [1011][0000].
    if bitShift == 0 {
      return
    }

    // Ok, now we have to deal with bit (subword) shifting.
    // We will always start from the end to avoid overwriting lower words,
    // this is why we will use 'reversed'.
    //
    // Example for '1011 << 5' (assuming that our Word has 4 bits):
    // - Expected result:
    //   [1011] << 5 = [0001][0110][0000]
    //   But because we store 'low' words before 'high' words in our storage,
    //   this will be stored as [0000][0110][0001].
    // - Current situation:
    //   [1011] << 4 (because our Word has 4 bits) = [1011][0000]
    //   Which is stored as: [0000][1011]
    // - To be done:
    //   Shift by this 1 bit, because 4 (our Word size) + 1 = 5 (requested shift)
    //   [1011][0000] << 1 = [0001][0110][0000]

    // Append word that will be used for shifts from our most significant word.
    self.storage.appendAssumingCapacity(token, element: 0) // In example: [0000][1011][0000]

    let lowShift = bitShift // In example: 5 % 4 = 1
    let highShift = Word.bitWidth - lowShift // In example: 4 - 1 = 3

    self.storage.withMutableWordsBuffer(token) { words in
      for i in (0..<wordCountBeforeShift).reversed() {
        let indexAfterWordShift = i &+ wordShift

        let word = words[indexAfterWordShift] // In example: [1011]
        let lowPart = word &<< lowShift // In example: [1011] << 1 = [0110]
        let highPart = word &>> highShift // In example: [1011] >> 3 = [0001]

        let lowIndex = indexAfterWordShift // In example: 1 + 0 = 1, [0000][this][0000]
        let highIndex = lowIndex &+ 1 // In example: 1 + 1 = 2, [0000][1011][this]

        words[lowIndex] = lowPart
        words[highIndex] |= highPart
      }
    }

    self.storage.fixInvariants(token)
  }

  internal mutating func unreasonableLeft() {
    // Something is off.
    // We will execute order 66 and kill the jedi before they take control
    // over the whole galaxy (also known as ENOMEM).
    trap("Shifting by more than \(ReasonableCount.max) is not possible "
       + "(and it is probably not what you want anyway, "
       + "do you really have that much memory?).")
  }

  // MARK: - Right

  /// static void
  /// mpz_div_q_2exp (mpz_t q, const mpz_t u, mp_bitcnt_t bitShift,
  ///     enum mpz_div_round_mode mode)
  internal mutating func shiftRight(count: ReasonableCount) {
    if self.isZero || count == ReasonableCount.zero {
      return
    }

    defer { self.storage.checkInvariants() }

    let wordShift = Int(count / ReasonableCount(Word.bitWidth))
    let bitShift = Int(count % ReasonableCount(Word.bitWidth))

    // Swift uses what would be 'GMP_DIV_FLOOR' mode in 'GMP'.
    // Which means that if we are negative and any of the removed bits is '1'
    // then we have to round down.
    //
    // Look at this (div by 2 is the same as single shift right):
    // - Positive numbers:
    //   - 4 / 2 = 2
    //   - 5 / 2 = 2.5 which after floor rounding is 2
    // - Negative numbers:
    //   - -4 / 2 = -2
    //   - -5 / 2 = -2.5 which after floor rounding is -3 (not -2!)
    //
    // Tip: Disable the 'if adjust' part later in this function and check unit
    // tests for negative numbers. Every time we cut only '0' the test will pass,
    // in other cases test will fail.
    let needsFloorAdjustmentForNegativeNumbers = self.isNegative
      && self.hasAnyBitSet(wordShift: wordShift, bitShift: bitShift)

    let token = self.storage.guaranteeUniqueBufferReference()
    self.storage.dropFirst(token, wordCount: wordShift)

    // Nonsensical shifts (such as '1 >> 1000') return '0' (or '-1' for negative).
    if self.storage.isZero {
      assert(self.storage.capacity != 0) // We checked for 0
      self.storage.setToAssumingCapacity(token, value: self.isNegative ? -1 : 0)
      return
    }

    // If we are shifting by multiply of 'Word' then we are done.
    // For example for 4 bit word if we shift by 4, 8, 12 or 16
    // we do not have to do anything else: [1011][0000] >> 4 = [1011].
    if bitShift == 0 {
      if needsFloorAdjustmentForNegativeNumbers {
        self.adjustAfterRightShift(token)
      }

      return
    }

    // Ok, now we have to deal with bit (subword) shifting.
    //
    // Example for '1011_0000_0000 >> 5' (assuming that our Word has 4 bits):
    // - Expected result:
    //   [1011][0000][0000] >> 5 = [0101][1000]
    //   But because we store 'low' words before 'high' words in our storage,
    //   this will be stored as [1000][0101].
    // - Current situation:
    //   [1011][0000][0000] > 4 (because our Word has 4 bits) = [1011][0000]
    //   Which is stored as: [0000][1011]
    // - To be done:
    //   Shift by this 1 bit, because 4 (our Word size) + 1 = 5 (requested shift)
    //   [1011][0000] >> 1 = [0101][1000] (stored as: [1000][0101])

    let highShift = bitShift // In example: 5 % 4 = 1
    let lowShift = Word.bitWidth - highShift // In example: 4 - 1 = 3

    self.storage.withMutableWordsBuffer(token) { words in
      // 'words.count' is the number of words after 'dropFirst',
      // so this is basically 'for every remaining word'.
      for i in 0..<words.count {
        let word = words[i] // In example (for i = 1): [1011]

        let lowPart = word &<< lowShift // In example: [1011] << 1 = [0110]
        let highPart = word &>> highShift // In example: [1011] >> 3 = [0001]

        let highIndex = i // In example: 1 + 1 = 2, [0000][1011][this]
        let lowIndex = highIndex &- 1 // In example: 1 + 0 = 1, [0000][this][0000]

        words[highIndex] = highPart

        // 1st moved word will try to write its 'lowPart' to index '-1'
        if lowIndex >= 0 {
          words[lowIndex] |= lowPart
        }
      }
    }

    // We need to fix invariants before we call any other operation,
    // because it may assume that all of the invariants are 'ok'.
    let wasNegative = self.isNegative
    self.storage.fixInvariants(token)

    if wasNegative && self.isZero {
      // '-1 >> 1000' = '-1'
      assert(self.storage.capacity != 0) // We checked for 0
      self.storage.setToAssumingCapacity(token, value: -1)
    } else if needsFloorAdjustmentForNegativeNumbers {
      self.adjustAfterRightShift(token)
    }
  }

  private func hasAnyBitSet(wordShift: Int, bitShift: Int) -> Bool {
    return self.storage.withWordsBuffer { words -> Bool in
      for i in 0..<wordShift {
        let word = words[i]
        if word != 0 {
          return true
        }
      }

      let word = words[wordShift]
      let bitsMask = (Word(1) << bitShift) - 1
      let bits = word & bitsMask

      return bits > 0
    }
  }

  private mutating func adjustAfterRightShift(_ token: UniqueBufferToken) {
    Self.addMagnitude(token, lhs: &self.storage, rhs: Word(1))
  }

  internal mutating func unreasonableRight<T: BinaryInteger>(count: T) {
    // We assume that 'self.bitWidth' was below 'count'.
    // Do we need an assertion here? Will we ever work on a such big numbers?
    let new = self.isNegative ? -1 : 0
    let token = self.storage.guaranteeUniqueBufferReference(withCapacity: 1)
    self.storage.setToAssumingCapacity(token, value: new)
  }
}
