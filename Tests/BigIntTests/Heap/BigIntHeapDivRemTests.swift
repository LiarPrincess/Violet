import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

// We are using the same code for 'divRem' as for 'div'.
// Just check if it uses that implementation.
class BigIntHeapDivRemTests: XCTestCase {

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

      let lhsHeap = BigIntHeap(lhsSmi)
      let result = lhsHeap.divRem(other: rhs)

      let expectedDiv = lhsSmi / rhs
      XCTAssert(
        result.quotient == expectedDiv,
        "\(lhsSmi) / \(rhs) = \(result.quotient) vs \(expectedDiv)"
      )

      let expectedMod = lhsSmi % rhs
      XCTAssert(
        result.remainder == expectedMod,
        "\(lhsSmi) % \(rhs) = \(result.remainder) vs \(expectedMod)"
      )
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

      let lhsHeap = BigIntHeap(isNegative: false, words: lhsWord)
      let rhsHeap = BigIntHeap(isNegative: false, words: rhsWord)
      let result = lhsHeap.divRem(other: rhsHeap)

      let expectedDivWord = lhsWord / rhsWord
      let expectedDiv = BigIntHeap(isNegative: false, words: expectedDivWord)
      XCTAssertEqual(result.quotient, expectedDiv, "\(lhsWord) / \(rhsWord)")

      let expectedModWord = lhsWord % rhsWord
      let expectedMod = BigIntHeap(isNegative: false, words: expectedModWord)
      XCTAssertEqual(result.remainder, expectedMod, "\(lhsWord) % \(rhsWord)")
    }
  }
}
