import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

// We are using the same code for 'rem' as for 'div'.
// Just check if it uses that implementation.
class BigIntHeapModTests: XCTestCase {

  func test_smi() {
    let values = generateSmiValues(countButNotReally: 20)

    for (lhsSmi, rhs) in allPossiblePairings(values: values) {
      if rhs.isZero {
        continue
      }

      // non-representable - overflow
      if lhsSmi == .min && rhs == -1 {
        continue
      }

      var lhsHeap = BigIntHeap(lhsSmi)
      lhsHeap.rem(other: rhs)

      let expected = lhsSmi % rhs
      XCTAssert(lhsHeap == expected, "\(lhsSmi) % \(rhs) = \(lhsHeap) vs \(expected)")
    }
  }

  func test_heap() {
    let values = generateIntValues(countButNotReally: 20)

    for (lhsInt, rhsInt) in allPossiblePairings(values: values) {
      let lhsWord = Word(bitPattern: lhsInt)
      let rhsWord = Word(bitPattern: rhsInt)

      if rhsWord.isZero {
        continue
      }

      var lhsHeap = BigIntHeap(isNegative: false, words: lhsWord)
      let rhsHeap = BigIntHeap(isNegative: false, words: rhsWord)
      lhsHeap.rem(other: rhsHeap)

      let expectedWord = lhsWord % rhsWord
      let expected = BigIntHeap(isNegative: false, words: expectedWord)
      XCTAssertEqual(lhsHeap, expected, "\(lhsWord) % \(rhsWord)")
    }
  }
}
