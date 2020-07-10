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

  func test_words() {
    for int in generateIntValues(countButNotReally: 100) {
      let value = BigInt(int)

      let result = value.words
      let expected = int.words

      XCTAssertEqual(result.count, expected.count, "\(int)")

      for (r, e) in zip(result, expected) {
        XCTAssertEqual(r, e, "\(int)")
      }
    }
  }

  // MARK: - Bit width

  // Just need to check if we return the same thing as 'minRequiredWidth'
  func test_bitWidth_singleWord() {
    for int in generateIntValues(countButNotReally: 100) {
      let value = BigInt(int)
      XCTAssertEqual(value.bitWidth, value.minRequiredWidth)
    }
  }

  // Just need to check if we return the same thing as 'minRequiredWidth'
  func test_bitWidth_multipleWords() {
    for p in generateHeapValues(countButNotReally: 100) {
      let heap = p.create()
      let value = BigInt(heap)
      XCTAssertEqual(value.bitWidth, value.minRequiredWidth)
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

  func test_manitude_heap() {
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
