import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

class BigIntHeapInvertTests: XCTestCase {

  func test_invert_singleWord() {
    for int in generateIntValues(countButNotReally: 100) {
      let value = BigIntHeap(int)
      let result = value.invert()

      let expectedValue = ~int
      let expected = BigIntHeap(expectedValue)
      XCTAssertEqual(result, expected)

      XCTAssertEqual(int + expectedValue, -1)
    }
  }

  func test_invert_multipleWords() {
    let minus1 = BigIntHeap(-1)

    for p in generateHeapValues(countButNotReally: 100) {
      let value = p.create()
      var result = value.invert()

      // We always change sign, '0' becomes '-1'
      XCTAssertEqual(result.isNegative, !p.isNegative, "\(p)")

      // x + (~x) = -1
      let original = p.create()
      result.add(other: original)
      XCTAssertEqual(result, minus1, "\(p)")
    }
  }
}
