import XCTest
@testable import BigInt

// swiftlint:disable line_length
// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

/// `2^n = value`
private typealias Pow2 = (value: Int, n: Int)

private let powersOf2: [Pow2] = [
  (value: 2, n: 1),
  (value: 4, n: 2),
  (value: 16, n: 4)
]

class BigIntHeapMulTests: XCTestCase {

  // MARK: - Smi - 0

  func test_smi_otherZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.mul(other: smiZero)
      XCTAssert(value.isZero)
    }
  }

  func test_smi_selfZero() {
    for smi in generateSmiValues(countButNotReally: 100) {
      var value = BigIntHeap()
      value.mul(other: smi)
      XCTAssert(value.isZero)
    }
  }

  // MARK: - Smi - +1

  func test_smi_otherPlusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.mul(other: Smi.Storage(1))

      let noChanges = p.create()
      XCTAssertEqual(value, noChanges)
    }
  }

  func test_smi_selfPlusOne() {
    for smi in generateSmiValues(countButNotReally: 100) {
      var value = BigIntHeap(1)
      value.mul(other: smi)

      let expected = BigIntHeap(smi)
      XCTAssertEqual(value, expected)
    }
  }

  // MARK: - Smi - -1

  func test_smi_otherMinusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.mul(other: Smi.Storage(-1))

      let expectedIsNegative = p.isPositive && !p.isZero
      let expected = BigIntHeap(isNegative: expectedIsNegative, words: p.words)
      XCTAssertEqual(value, expected)
    }
  }

  func test_smi_selfMinusOne() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // '-Smi.min' overflows
      if smi == .min {
        continue
      }

      var value = BigIntHeap(-1)
      value.mul(other: smi)

      let expected = BigIntHeap(-smi)
      XCTAssertEqual(value, expected)
    }
  }

  // MARK: - Smi - pow 2

  /// Mul by `n^2` should shift left by `n`
  func test_smi_otherIsPowerOf2() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      for power in powersOf2 {
        guard let p = self.cleanBitsSoItCanBeMultipliedWithoutOverflow(
          value: p,
          power: power
        ) else { continue }

        var value = p.create()
        value.mul(other: Smi.Storage(power.value))

        let expectedWords = p.words.map { $0 << power.n }
        let expected = BigIntHeap(isNegative: p.isNegative, words: expectedWords)
        XCTAssertEqual(value, expected, "\(p) * \(power.value)")
      }
    }
  }

  private func cleanBitsSoItCanBeMultipliedWithoutOverflow(
    value: HeapPrototype,
    power: Pow2
  ) -> HeapPrototype? {
    // 1111 >> 1 = 1110
    let mask = Word.max >> power.n
    let words = value.words.map { $0 & mask }

    // Zero may behave differently than other numbers
    let allWordsZero = words.allSatisfy { $0.isZero }
    if allWordsZero {
      return nil
    }

    return HeapPrototype(isNegative: value.isNegative, words: words)
  }

  // MARK: - Smi - Self has multiple words

  func test_smi_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhs: Smi.Storage = 370955168

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.mul(other: rhs)
    var expected = BigIntHeap(isNegative: false, words: [11068046445635360608, 1229782937530123449, 49460689])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.mul(other: rhs)
    expected = BigIntHeap(isNegative: true, words: [11068046445635360608, 1229782937530123449, 49460689])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.mul(other: -rhs)
    expected = BigIntHeap(isNegative: true, words: [11068046445635360608, 1229782937530123449, 49460689])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.mul(other: -rhs)
    expected = BigIntHeap(isNegative: false, words: [11068046445635360608, 1229782937530123449, 49460689])
    XCTAssertEqual(lhs, expected)
  }

  // MARK: - Smi - generated

  func test_smi_generated() {
    // If 'Smi' has 32 bit and 'Word' 64,
    // then 'smi * smi' will always have single word.
    let smiWidth = Smi.Storage.bitWidth
    assert(Word.bitWidth >= 2 * smiWidth)

    let values = generateSmiValues(countButNotReally: 15)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      var value = BigIntHeap(lhs)
      value.mul(other: rhs)

      let (high, low) = lhs.multipliedFullWidth(by: rhs)
      let expectedValue = Int(high) << smiWidth | Int(low)
      let expected = BigIntHeap(expectedValue)

      XCTAssertEqual(value, expected, "\(lhs) * \(rhs)")
    }
  }

  // MARK: - Heap - 0

  func test_heap_otherZero() {
    let zero = BigIntHeap()

    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.mul(other: zero)
      XCTAssert(value.isZero)
    }
  }

  func test_heap_selfZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = BigIntHeap()
      let other = p.create()
      value.mul(other: other)
      XCTAssert(value.isZero)
    }
  }

  // MARK: - Heap - +1

  func test_heap_otherPlusOne() {
    let one = BigIntHeap(1)

    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.mul(other: one)

      let noChanges = p.create()
      XCTAssertEqual(value, noChanges)
    }
  }

  func test_heap_selfPlusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = BigIntHeap(1)
      let other = p.create()
      value.mul(other: other)

      XCTAssertEqual(value, other)
    }
  }

  // MARK: - Heap - -1

  func test_heap_otherMinusOne() {
    let minus1 = BigIntHeap(-1)

    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.mul(other: minus1)

      let expectedIsNegative = p.isPositive && !p.isZero
      let expected = BigIntHeap(isNegative: expectedIsNegative, words: p.words)
      XCTAssertEqual(value, expected)
    }
  }

  func test_heap_selfMinusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = BigIntHeap(-1)
      let other = p.create()
      value.mul(other: other)

      let expectedIsNegative = p.isPositive && !p.isZero
      let expected = BigIntHeap(isNegative: expectedIsNegative, words: p.words)
      XCTAssertEqual(value, expected)
    }
  }

  // MARK: - Heap - pow 2

  /// Mul by `n^2` should shift left by `n`
  func test_heap_otherIsPowerOf2() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      for power in powersOf2 {
        guard let p = self.cleanBitsSoItCanBeMultipliedWithoutOverflow(
          value: p,
          power: power
        ) else { continue }

        var value = p.create()
        let other = BigIntHeap(power.value)
        value.mul(other: other)

        let expectedWords = p.words.map { $0 << power.n }
        let expected = BigIntHeap(isNegative: p.isNegative, words: expectedWords)
        XCTAssertEqual(value, expected, "\(p) * \(power.value)")
      }
    }
  }

  // MARK: - Heap - multiple words

  func test_heap_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhsWords: [Word] = [1844674407370955168]
    let expectedWords: [Word] = [
      18077809192235360608, 16110156491039675065, 245956587649460688
    ]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedWords))

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedWords))

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedWords))

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedWords))
  }

  func test_heap_rhsLonger() {
    let lhsWords: [Word] = [1844674407370955168]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let expectedWords: [Word] = [
      18077809192235360608, 16110156491039675065, 245956587649460688
    ]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedWords))

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedWords))

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedWords))

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedWords))
  }

  func test_heap_bothMultipleWords() {
    let lhsWords: [Word] = [1844674407370955168, 4304240283865562048]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let expectedWords: [Word] = [
      18077809192235360608, 6640827866535438585, 11600952384132895787, 573898704515408272
    ]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedWords))

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedWords))

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedWords))

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.mul(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedWords))
  }

  // MARK: - Heap - Carry overflow

  func test_heap_carryOverflow() {
    // Case 1
    // lowIndex 0
    //   high, low = 18446744073709551615 * 18446744073709551615 = 18446744073709551614 1
    //   carry, result[i] = current[i] + low + current carry = 0 1 0 = 0 1
    //   next carry = carry + high = 0 + 18446744073709551614 = 18446744073709551614
    //
    // lowIndex 1
    //   high, low = 18446744073709551615 * 18446744073709551615 = 18446744073709551614 1
    //   carry, result[i] = current[i] + low + current carry = 0 1 18446744073709551614 = 0 18446744073709551615
    //   next carry = carry + high = 0 + 18446744073709551614 = 18446744073709551614
    //   ^^^^^^^^^^ no overflow here!
    do {
      var lhs = BigIntHeap(isNegative: false, words: .max, .max, .max)
      let rhs = BigIntHeap(isNegative: false, words: .max, .max)
      lhs.mul(other: rhs)
    }

    // Case 2
    // lowIndex 0
    //   high, low = 18446744073709551615 * 18446744073709551614 = 18446744073709551613 2
    //   carry, result[i] = current[i] + low + current carry = 0 2 0 = 0 2
    //   next carry = carry + high = 0 + 18446744073709551613 = 18446744073709551613
    //
    // lowIndex 1
    //   high, low = 18446744073709551615 * 18446744073709551615 = 18446744073709551614 1
    //   carry, result[i] = current[i] + low + current carry = 0 1 18446744073709551613 = 0 18446744073709551614
    //   next carry = carry + high = 0 + 18446744073709551614 = 18446744073709551614
    //   ^^^^^^^^^^ no overflow here!
    do {
      var lhs = BigIntHeap(isNegative: false, words: .max, .max, .max)
      let rhs = BigIntHeap(isNegative: false, words: .max - 1, .max)
      lhs.mul(other: rhs)
    }

    // Case 3
    // lowIndex 0
    //   high, low = 18446744073709551615 * 18446744073709551615 = 18446744073709551614 1
    //   carry, result[i] = current[i] + low + current carry = 0 1 0 = 0 1
    //   next carry = carry + high = 0 + 18446744073709551614 = 18446744073709551614
    //
    // lowIndex 1
    //   high, low = 18446744073709551615 * 18446744073709551614 = 18446744073709551613 2
    //   carry, result[i] = current[i] + low + current carry = 0 2 18446744073709551614 = 1 0
    //   next carry = carry + high = 1 + 18446744073709551613 = 18446744073709551614
    //   ^^^^^^^^^^ no overflow here!
    do {
      var lhs = BigIntHeap(isNegative: false, words: .max, .max, .max)
      let rhs = BigIntHeap(isNegative: false, words: .max, .max - 1)
      lhs.mul(other: rhs)
    }
  }
}
