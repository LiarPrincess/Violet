import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

class BigIntHeapBitTests: XCTestCase {

  // MARK: - Words

  func test_words_zero() {
    let value = BigIntHeap(0)
    let result = value.words

    XCTAssertEqual(result.count, 1)
    guard result.count == 1 else { return } // Prevent out of bound trap

    let word = result[0]
    XCTAssertEqual(word, 0)
  }

  func test_words_int() {
    for int in generateIntValues(countButNotReally: 100) {
      // We have separate test for '0'
      if int.isZero {
        continue
      }

      let value = BigIntHeap(int)
      let result = value.words

      let expected = int.words

      XCTAssertEqual(result.count, expected.count, "\(int)")
      for (r, e) in zip(result, expected) {
        XCTAssertEqual(r, e, "\(int)")
      }
    }
  }

  // MARK: - Trailing zero bit count

  func test_trailingZeroBitCount_zero() {
    // There is an edge case for '0':
    // - 'int' is finite, so they can return 'bitWidth'
    // - 'BigInt' is infinite, but we cant return that

    let zero = BigIntHeap()
    let result = zero.trailingZeroBitCount
    XCTAssertEqual(result, 0)
  }

  func test_trailingZeroBitCount_singleWord() {
    for int in generateIntValues(countButNotReally: 100) {
      // We have separate test for this
      if int.isZero {
        continue
      }

      let value = BigIntHeap(int)
      let result = value.trailingZeroBitCount

      let expected = int.trailingZeroBitCount
      XCTAssertEqual(result, expected, "\(int)")
    }
  }

  func test_trailingZeroBitCount_multipleWords() {
    for int0 in generateIntValues(countButNotReally: 10) {
      let word0 = Word(bitPattern: int0)

      for int1 in generateIntValues(countButNotReally: 10) {
        let word1 = Word(bitPattern: int1)

        // That would require 3rd word (which we don't have)
        if word0 == 0 && word1 == 0 {
          continue
        }

        let value = BigIntHeap(isNegative: int0.isNegative, words: word0, word1)
        let result = value.trailingZeroBitCount

        let expected = word0 != 0 ?
          word0.trailingZeroBitCount :
          Word.bitWidth + word1.trailingZeroBitCount

        XCTAssertEqual(result, expected, "\(word0) \(word1)")
      }
    }
  }
  }
}
