import XCTest
@testable import Core

private typealias Word = BigIntStorage.Word

class BigIntHeapPropertyTests: XCTestCase {

  // MARK: - Is zero

  private let nonZeroValues: [Word] = [103, .max, 42, 43]

  func test_isZero() {
    let zero = BigIntHeap(0)
    XCTAssertTrue(zero.isZero)

    for (word0, word1) in allPossiblePairings(values: self.nonZeroValues) {
      let positive = BigIntHeap(isNegative: false, words: word0, word1)
      XCTAssertFalse(positive.isZero)

      let negative = BigIntHeap(isNegative: true, words: word0, word1)
      XCTAssertFalse(negative.isZero)
    }
  }

  // MARK: - Is positive

  func test_isPositive() {
    let zero = BigIntHeap(0)
    XCTAssertTrue(zero.isPositive)

    for (word0, word1) in allPossiblePairings(values: self.nonZeroValues) {
      let positive = BigIntHeap(isNegative: false, words: word0, word1)
      XCTAssertTrue(positive.isPositive)

      let negative = BigIntHeap(isNegative: true, words: word0, word1)
      XCTAssertFalse(negative.isPositive)
    }
  }

  // MARK: - Is negative

  func test_isNegative() {
    let zero = BigIntHeap(0)
    XCTAssertFalse(zero.isNegative)

    for (word0, word1) in allPossiblePairings(values: self.nonZeroValues) {
      let positive = BigIntHeap(isNegative: false, words: word0, word1)
      XCTAssertFalse(positive.isNegative)

      let negative = BigIntHeap(isNegative: true, words: word0, word1)
      XCTAssertTrue(negative.isNegative)
    }
  }

  // MARK: - Magnitude

  func test_magnitude_trivial() {
    let zero = BigIntHeap(0)
    XCTAssertEqual(zero.magnitude, BigInt(0))

    let one = BigIntHeap(1)
    XCTAssertEqual(one.magnitude, BigInt(1))

    let minusOne = BigIntHeap(-1)
    XCTAssertEqual(minusOne.magnitude, BigInt(1))
  }

  func test_magnitude_int() {
    for int in generateIntValues(countButNotReally: 100) {
      let heap = BigIntHeap(int)
      let magnitude = heap.magnitude

      let expected = int.magnitude
      XCTAssert(magnitude == expected, "\(int)")
    }
  }

  func test_manitude_heap() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      let negative = BigIntHeap(isNegative: true, words: p.words)
      let magnitude = negative.magnitude

      let expected = BigIntHeap(isNegative: false, words: p.words)
      XCTAssertEqual(magnitude, BigInt(expected))
    }
  }

  func test_manitude_negation() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      let positive = BigIntHeap(isNegative: false, words: p.words)
      let negative = BigIntHeap(isNegative: true, words: p.words)
      XCTAssertEqual(positive.magnitude, negative.magnitude)
    }
  }

  // MARK: - Has magnitude of 1

  func test_hasMagnitudeOfOne_true() {
    let positive = BigIntHeap(1)
    XCTAssertTrue(positive.hasMagnitudeOfOne)
    XCTAssertTrue(positive.isPositive)

    let negative = BigIntHeap(-1)
    XCTAssertTrue(negative.hasMagnitudeOfOne)
    XCTAssertTrue(negative.isNegative)
  }

  func test_hasMagnitudeOfOne_false() {
    let zero = BigIntHeap(0)
    XCTAssertFalse(zero.hasMagnitudeOfOne)

    for (word0, word1) in allPossiblePairings(values: self.nonZeroValues) {
      let positive = BigIntHeap(isNegative: false, words: word0, word1)
      XCTAssertFalse(positive.hasMagnitudeOfOne)

      let negative = BigIntHeap(isNegative: true, words: word0, word1)
      XCTAssertFalse(negative.hasMagnitudeOfOne)
    }
  }
}
