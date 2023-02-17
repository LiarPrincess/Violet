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
        // V8 version is 2x slower.
        // Self.inner_v8(lhs: lhs, rhs: rhs, into: buffer)
      }
    }

    // Remove front 0
    let highWord = buffer[count - 1]
    let countWithoutZero = count - (highWord == 0 ? 1 : 0)
    let resultBuffer = Buffer(start: buffer.baseAddress, count: countWithoutZero)
    lhs.replaceAll(lhsToken, withContentsOf: resultBuffer)
  }

  // MARK: - Inner - direct

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

  // MARK: - Inner - V8

#if false

  // swiftlint:disable line_length
  // swiftlint:disable function_body_length

  // Line-by-line translation of V8 version.
  // https://github.com/v8/v8/blob/18723cd9934f6b59d8be1003225257a394c18f60/src/bigint/mul-schoolbook.cc#L28

  /// Z := X * Y.
  /// O(n²) "schoolbook" multiplication algorithm. Optimized to minimize
  /// bounds and overflow checks: rather than looping over X for every digit
  /// of Y (or vice versa), we loop over Z. The {BODY} macro above is what
  /// computes one of Z's digits as a sum of the products of relevant digits
  /// of X and Y. This yields a nearly 2x improvement compared to more obvious
  /// implementations.
  /// This method is *highly* performance sensitive even for the advanced
  /// algorithms, which use this as the base case of their recursive calls.
  private static func inner_v8(
    lhs: UnsafeBufferPointer<Word>,
    rhs: UnsafeBufferPointer<Word>,
    into z: Buffer
  ) {
    // x=bigger; y=smaller
    let (y, x) = lhs.count <= rhs.count ? (lhs, rhs) : (rhs, lhs)

    var next: Word = 0
    var next_carry: Word = 0
    var carry: Word = 0

    func body(_ zi: Word, index i: Int, xIndexMin: Int, xIndexMax: Int) {
      var zi = zi

      for j in xIndexMin...xIndexMax {
        // digit_t high;
        var high: Word = 0
        // digit_t low = digit_mul(X[j], Y[i - j], &high);
        let low = digit_mul(x[j], y[i - j], &high)
        // digit_t carrybit;
        var carrybit: Word = 0
        // zi = digit_add2(zi, low, &carrybit);
        zi = digit_add2(zi, low, &carrybit)
        // carry += carrybit;
        carry += carrybit
        // next = digit_add2(next, high, &carrybit);
        next = digit_add2(next, high, &carrybit)
        // next_carry += carrybit;
        next_carry += carrybit
      }

      z[i] = zi
    }

    // Unrolled first iteration: it's trivial.
    // Z[0] = digit_mul(X[0], Y[0], &next);
    z[0] = digit_mul(x[0], y[0], &next)

    // Unrolled second iteration: a little less setup.
    var i = 1
    if i < y.count {
      // digit_t zi = next;
      let zi = next
      // next = 0;
      next = 0
      // BODY(0, 1);
      body(zi, index: i, xIndexMin: 0, xIndexMax: 1)
      // i++;
      i += 1
    }

    // Main part: since X.len() >= Y.len() > i, no bounds checks are needed.
    // for (; i < Y.len(); i++)
    while i < y.count {
      // digit_t zi = digit_add2(next, carry, &carry);
      let zi = digit_add2(next, carry, &carry)
      // next = next_carry + carry;
      next = next_carry + carry
      // carry = 0;
      carry = 0
      // next_carry = 0;
      next_carry = 0
      // BODY(0, i);
      body(zi, index: i, xIndexMin: 0, xIndexMax: i)
      i += 1
    }

    // Last part: i exceeds Y now, we have to be careful about bounds.
    // int loop_end = X.len() + Y.len() - 2;
    let loop_end = x.count + y.count - 2
    // for (; i <= loop_end; i++) {
    while i <= loop_end {
      // int max_x_index = std::min(i, X.len() - 1);
      let max_x_index = Swift.min(i, x.count - 1)
      // int max_y_index = Y.len() - 1;
      let max_y_index = y.count - 1
      // int min_x_index = i - max_y_index;
      let min_x_index = i - max_y_index
      // digit_t zi = digit_add2(next, carry, &carry);
      let zi = digit_add2(next, carry, &carry)
      // next = next_carry + carry;
      next = next_carry + carry
      // carry = 0;
      carry = 0
      // next_carry = 0;
      next_carry = 0
      // BODY(min_x_index, max_x_index);
      body(zi, index: i, xIndexMin: min_x_index, xIndexMax: max_x_index)
      i += 1
    }

    // Write the last digit, and zero out any extra space in Z.
    // Z[i++] = digit_add2(next, carry, &carry);
    z[i] = digit_add2(next, carry, &carry)

    // DCHECK(carry == 0);
    assert(carry == 0)

    // Not needed in Violet:
    // i += 1
    // for (; i < Z.len(); i++)
    //   Z[i] = 0;
  }

  private static func digit_add2(_ a: Word, _ b: Word, _ high: inout Word) -> Word {
    let (low, overflow) = a.addingReportingOverflow(b)
    high = overflow ? 1 : 0
    return low
  }

  private static func digit_mul(_ a: Word, _ b: Word, _ high: inout Word) -> Word {
    let (h, l) = a.multipliedFullWidth(by: b)
    high = h
    return l
  }
#endif
}
