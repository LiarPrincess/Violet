import XCTest
@testable import BigInt

private typealias Word = BigIntHeap.Word

class BigIntPropertyTests: XCTestCase {

  // MARK: - Description

  func test_description() {
    for int in generateIntValues(countButNotReally: 100) {
      let value = BigInt(int)
      XCTAssertEqual(value.description, int.description, "\(int)")
    }
  }

  // MARK: - Words

  func test_words_zero() {
    let value = BigInt(0)
    XCTAssertWords(value, WordsTestCases.zeroWords)
  }

  func test_words_int() {
    for (value, expected) in WordsTestCases.int {
      let heap = BigIntHeap(value)
      let bigInt = BigInt(heap)
      XCTAssertWords(bigInt, expected)
    }
  }

  func test_words_multipleWords_positive() {
    for (words, expected) in WordsTestCases.heapPositive {
      let heap = BigIntHeap(isNegative: false, words: words)
      let bigInt = BigInt(heap)
      XCTAssertWords(bigInt, expected)
    }
  }

  func test_words_multipleWords_negative_powerOf2() {
    for (words, expected) in WordsTestCases.heapNegative_powerOf2 {
      let heap = BigIntHeap(isNegative: true, words: words)
      let bigInt = BigInt(heap)
      XCTAssertWords(bigInt, expected)
    }
  }

  func test_words_multipleWords_negative_notPowerOf2() {
    for (words, expected) in WordsTestCases.heapNegative_notPowerOf2 {
      let heap = BigIntHeap(isNegative: true, words: words)
      let bigInt = BigInt(heap)
      XCTAssertWords(bigInt, expected)
    }
  }

  // MARK: - Bit width

  func test_bitWidth_trivial() {
    let zero = BigInt(0)
    XCTAssertEqual(zero.bitWidth, 1) //  0 is just 0

    let plus1 = BigInt(1)
    XCTAssertEqual(plus1.bitWidth, 2) // 1 needs '0' prefix -> '01'

    let minus1 = BigInt(-1)
    XCTAssertEqual(minus1.bitWidth, 1) // -1 is just 1
  }

  func test_bitWidth_positivePowersOf2() {
    for (int, power, expected) in BitWidthTestCases.positivePowersOf2 {
      let bigInt = BigInt(int)
      XCTAssertEqual(bigInt.bitWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_bitWidth_negativePowersOf2() {
    for (int, power, expected) in BitWidthTestCases.negativePowersOf2 {
      let bigInt = BigInt(int)
      XCTAssertEqual(bigInt.bitWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_bitWidth_smiTestCases() {
    for (value, expected) in BitWidthTestCases.smi {
      let bigInt = BigInt(value)
      XCTAssertEqual(bigInt.bitWidth, expected, "\(value)")
    }
  }

  func test_bitWidth_multipleWords_positivePowersOf2() {
    let correction = BitWidthTestCases.positivePowersOf2Correction

    for zeroWordCount in [1, 2] {
      let zeroWords = [Word](repeating: 0, count: zeroWordCount)
      let zeroWordsBitWidth = zeroWordCount * Word.bitWidth

      for (power, value) in allPositivePowersOf2(type: Word.self) {
        let words = zeroWords + [value]
        let heap = BigIntHeap(isNegative: false, words: words)
        let bigInt = BigInt(heap)

        let expected = power + correction + zeroWordsBitWidth
        XCTAssertEqual(bigInt.bitWidth, expected, "\(heap)")
      }
    }
  }

  func test_bitWidth_multipleWords_negativePowersOf2() {
    let correction = BitWidthTestCases.negativePowersOf2Correction

    for zeroWordCount in [1, 2] {
      let zeroWords = [Word](repeating: 0, count: zeroWordCount)
      let zeroWordsBitWidth = zeroWordCount * Word.bitWidth

      for (power, value) in allPositivePowersOf2(type: Word.self) {
        let words = zeroWords + [value]
        let heap = BigIntHeap(isNegative: true, words: words)
        let bigInt = BigInt(heap)

        let expected = power + correction + zeroWordsBitWidth
        XCTAssertEqual(bigInt.bitWidth, expected, "\(heap)")
      }
    }
  }

  // MARK: - Min required width

  func test_minRequiredWidth_smi() {
    for (smi, expected) in MinRequiredWidthTestCases.smi {
      let int = BigInt(smi)
      let result = int.minRequiredWidth
      XCTAssertEqual(result, expected, "\(smi)")
    }
  }

  func test_minRequiredWidth_heap() {
    for (string, expected) in MinRequiredWidthTestCases.heap {
      do {
        let int = try BigInt(string)
        let result = int.minRequiredWidth
        XCTAssertEqual(result, expected, string)
      } catch {
        XCTFail("\(string), error: \(error)")
      }
    }
  }

  func test_minRequiredWidth_positivePowersOf2() {
    for (int, power, expected) in MinRequiredWidthTestCases.positivePowersOf2 {
      let heap = BigInt(int)
      XCTAssertEqual(heap.minRequiredWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_minRequiredWidth_negativePowersOf2() {
    for (int, power, expected) in MinRequiredWidthTestCases.negativePowersOf2 {
      let heap = BigInt(int)
      XCTAssertEqual(heap.minRequiredWidth, expected, "for \(int) (2^\(power))")
    }
  }

  // MARK: - Trailing zero bit count

  func test_trailingZeroBitCount_zero() {
    let zero = BigInt(0)
    XCTAssertEqual(zero.trailingZeroBitCount, 0)
  }

  func test_trailingZeroBitCount_int() {
    for raw in generateIntValues(countButNotReally: 100) {
      if raw.isZero {
        continue
      }

      let int = BigInt(raw)
      let result = int.trailingZeroBitCount

      let expected = raw.trailingZeroBitCount
      XCTAssertEqual(result, expected)
    }
  }

  func test_trailingZeroBitCount_heap_nonZeroFirstWord() {
    for p in generateHeapValues(countButNotReally: 100, maxWordCount: 3) {
      if p.isZero {
        continue
      }

      // We have separate test for numbers that have '0' last word
      if p.words[0] == 0 {
        continue
      }

      let heap = p.create()
      let int = BigInt(heap)
      let result = int.trailingZeroBitCount

      let expected = p.words[0].trailingZeroBitCount
      XCTAssertEqual(result, expected)
    }
  }

  func test_trailingZeroBitCount_heap_zeroFirstWord() {
    for p in generateHeapValues(countButNotReally: 100, maxWordCount: 3) {
      if p.isZero {
        continue
      }

      guard p.words.count > 1 else {
        continue
      }

      var words = p.words
      words[0] = 0

      let heap = BigIntHeap(isNegative: p.isNegative, words: words)
      let int = BigInt(heap)
      let result = int.trailingZeroBitCount

      let expected = Word.bitWidth + p.words[1].trailingZeroBitCount
      XCTAssertEqual(result, expected)
    }
  }

  // MARK: - Even, odd

  func test_smi() {
    for smi in generateSmiValues(countButNotReally: 100) {
      let int = BigInt(smi)

      let expectedEven = smi.isMultiple(of: 2)
      XCTAssertEqual(int.isEven, expectedEven, "\(smi)")
      XCTAssertEqual(int.isOdd, !expectedEven, "\(smi)")
    }
  }

  func test_heap() {
    for p in generateHeapValues(countButNotReally: 100) {
      let heap = p.create()
      let int = BigInt(heap)

      // swiftlint:disable:next legacy_multiple
      let expectedEven = int % 2 == 0
      XCTAssertEqual(int.isEven, expectedEven, "\(heap)")
      XCTAssertEqual(int.isOdd, !expectedEven, "\(heap)")
    }
  }

  // MARK: - Magnitude

  func test_magnitude_int() {
    for raw in generateIntValues(countButNotReally: 100) {
      let int = BigInt(raw)
      let magnitude = int.magnitude

      let expected = raw.magnitude
      XCTAssert(magnitude == expected, "\(raw)")
    }
  }

  func test_magnitude_heap() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      let positiveHeap = BigIntHeap(isNegative: false, words: p.words)
      let positive = BigInt(positiveHeap)

      let negativeHeap = BigIntHeap(isNegative: true, words: p.words)
      let negative = BigInt(negativeHeap)

      XCTAssertEqual(positive.magnitude, negative.magnitude)
    }
  }
}
