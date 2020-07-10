import XCTest
@testable import BigInt

class SmiVsHeapProperties: XCTestCase {

  // MARK: - Words

  func test_words() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiResult = smi.words

      let heap = BigIntHeap(raw)
      let heapResult = heap.words

      XCTAssertEqual(smiResult.count, heapResult.count, "\(raw)")

      for (sWord, hWord) in zip(smiResult, heapResult) {
        XCTAssertEqual(sWord, hWord, "\(raw)")
      }
    }
  }

  // MARK: - Bit width

  func test_bitWidth() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiResult = smi.bitWidth

      let heap = BigIntHeap(raw)
      let heapResult = heap.bitWidth

      XCTAssertEqual(smiResult, heapResult, "\(raw)")
    }
  }

  // MARK: - Trailing zero bit count

  func test_trailingZeroBitCount() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiResult = smi.trailingZeroBitCount

      let heap = BigIntHeap(raw)
      let heapResult = heap.trailingZeroBitCount

      XCTAssertEqual(smiResult, heapResult, "\(raw)")
    }
  }

  // MARK: - Min required width

  func test_minRequiredWidth() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiResult = smi.minRequiredWidth

      let heap = BigIntHeap(raw)
      let heapResult = heap.minRequiredWidth

      XCTAssertEqual(smiResult, heapResult, "\(raw)")
    }
  }

  // MARK: - Magnitude

  func test_magnitude() {
    for raw in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(raw)
      let smiResult = smi.magnitude

      let heap = BigIntHeap(raw)
      let heapResult = heap.magnitude

      XCTAssertEqual(smiResult, heapResult, "\(raw)")
    }
  }
}
