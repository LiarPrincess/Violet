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
}
