import VioletCore

// Sources:
// - mini-gmp: https://gmplib.org
//
// Mostly for right shift.
// The person that wrote it is a AMAZING…
//
// GMP function name is in the comment above method.

extension BigIntHeap {

  // MARK: - Left - smi

  internal mutating func shiftLeft(count: Smi.Storage) {
    defer { self.checkInvariants() }

    let word = Word(count.magnitude)

    if count.isPositive {
      self.shiftLeft(count: word)
    } else {
      self.shiftRight(count: word)
    }
  }

  // MARK: - Left - word

  internal mutating func shiftLeft(count: Word) {
    defer { self.checkInvariants() }

    if self.isZero || count.isZero {
      return
    }

    let wordShift = Int(count / Word(Word.bitWidth))
    let bitShift = Int(count % Word(Word.bitWidth))

    let wordCountBeforeShift = self.storage.count
    self.storage.prepend(0, count: wordShift)

    // If we are shifting by multiply of 'Word' than we are done.
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
    self.storage.append(0) // In example: [0000][1011][0000]

    let lowShift = bitShift // In example: 5 % 4 = 1
    let highShift = Word.bitWidth - lowShift // In example: 4 - 1 = 3

    for i in (0..<wordCountBeforeShift).reversed() {
      let indexAfterWordShift = i + wordShift

      let word = self.storage[indexAfterWordShift] // In example: [1011]
      let lowPart = word << lowShift // In example: [1011] << 1 = [0110]
      let highPart = word >> highShift // In example: [1011] >> 3 = [0001]

      let lowIndex = indexAfterWordShift // In example: 1 + 0 = 1, [0000][this][0000]
      let highIndex = lowIndex + 1 // In example: 1 + 1 = 2, [0000][1011][this]

      self.storage[lowIndex] = lowPart
      self.storage[highIndex] = self.storage[highIndex] | highPart
    }

    self.fixInvariants()
  }

  // MARK: - Left - heap

  internal mutating func shiftLeft(count: BigIntHeap) {
    defer { self.checkInvariants() }

    if count.isZero {
      return
    }

    if count.isPositive {
      guard let word = self.guaranteeSingleWord(shiftCount: count) else {
        // Something is off.
        // We will execute order 66 and kill the jedi before they take control
        // over the whole galaxy (also known as ENOMEM).
        trap(Self.unreasonableLeftShiftMsg)
      }

      self.shiftLeft(count: word)
    } else {
      guard let word = self.guaranteeSingleWord(shiftCount: count) else {
        self.storage.setToZero()
        return
      }

      self.shiftRight(count: word)
    }
  }

  // MARK: - Right - smi

  internal mutating func shiftRight(count: Smi.Storage) {
    defer { self.checkInvariants() }

    let word = Word(count.magnitude)

    if count.isPositive {
      self.shiftRight(count: word)
    } else {
      self.shiftLeft(count: word)
    }
  }

  // MARK: - Right - word

// swiftlint:disable function_body_length
// cSpell:ignore bitcnt

  /// static void
  /// mpz_div_q_2exp (mpz_t q, const mpz_t u, mp_bitcnt_t bitShift,
  ///     enum mpz_div_round_mode mode)
  internal mutating func shiftRight(count: Word) {
// swiftlint:enable function_body_length

    defer { self.checkInvariants() }

    if self.isZero || count.isZero {
      return
    }

    let wordShift = Int(count / Word(Word.bitWidth))
    let bitShift = Int(count % Word(Word.bitWidth))

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

    self.storage.dropFirst(wordCount: wordShift)

    // Nonsensical shifts (such as '1 >> 1000') return '0' (or '-1' for negative).
    if self.storage.isEmpty {
      self.storage.set(to: self.isNegative ? -1 : 0)
      return
    }

    // If we are shifting by multiply of 'Word' then we are done.
    // For example for 4 bit word if we shift by 4, 8, 12 or 16
    // we do not have to do anything else: [1011][0000] >> 4 = [1011].
    if bitShift == 0 {
      if needsFloorAdjustmentForNegativeNumbers {
        self.adjustAfterRightShift()
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

    // 'self.storage.count' is the number of words after 'dropFirst',
    // so this is basically 'for every remaining word'.
    for i in 0..<self.storage.count {
      let word = self.storage[i] // In example (for i = 1): [1011]

      let lowPart = word << lowShift // In example: [1011] << 1 = [0110]
      let highPart = word >> highShift // In example: [1011] >> 3 = [0001]

      let highIndex = i // In example: 1 + 1 = 2, [0000][1011][this]
      let lowIndex = highIndex - 1 // In example: 1 + 0 = 1, [0000][this][0000]

      self.storage[highIndex] = highPart

      // 1st moved word will try to write its 'lowPart' to index '-1'
      if lowIndex >= 0 {
        self.storage[lowIndex] = self.storage[lowIndex] | lowPart
      }
    }

    // We need to fix invariants before we call any other operation,
    // because it may assume that all of the invariants are 'ok'.
    let wasNegative = self.isNegative
    self.fixInvariants()

    if wasNegative && self.isZero {
      // '-1 >> 1000' = '-1'
      self.storage.set(to: -1)
    } else if needsFloorAdjustmentForNegativeNumbers {
      self.adjustAfterRightShift()
    }
  }

  private func hasAnyBitSet(wordShift: Int, bitShift: Int) -> Bool {
    for i in 0..<wordShift {
      let word = self.storage[i]
      if word != 0 {
        return true
      }
    }

    let word = self.storage[wordShift]
    let bitsMask = (Word(1) << bitShift) - 1
    let bits = word & bitsMask

    return bits > 0
  }

  private mutating func adjustAfterRightShift() {
    Self.addMagnitude(lhs: &self.storage, rhs: Word(1))
  }

  // MARK: - Right - heap

  internal mutating func shiftRight(count: BigIntHeap) {
    defer { self.checkInvariants() }

    if count.isZero {
      return
    }

    if count.isPositive {
      guard let word = self.guaranteeSingleWord(shiftCount: count) else {
        self.storage.setToZero()
        return
      }

      self.shiftRight(count: word)
    } else {
      guard let word = self.guaranteeSingleWord(shiftCount: count) else {
        // Something is off.
        // We will execute order 66 and kill the jedi before they take control
        // over the whole galaxy (also known as ENOMEM).
        trap(Self.unreasonableLeftShiftMsg)
      }

      self.shiftLeft(count: word)
    }
  }

  // MARK: - Sane left shift

  private static let unreasonableLeftShiftMsg =
    "Shifting by more than \(Word.max) is not possible "
  + "(and it is probably not what you want anyway, "
  + "do you really have that much memory?)."

  private func guaranteeSingleWord(shiftCount: BigIntHeap) -> Word? {
    guard shiftCount.storage.count == 1 else {
      return nil
    }

    return shiftCount.storage[0]
  }
}
