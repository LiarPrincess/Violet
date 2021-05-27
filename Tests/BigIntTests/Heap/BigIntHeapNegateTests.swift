import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

class BigIntHeapNegateTests: XCTestCase {

  func test_negate_zero() {
    var zero = BigIntHeap(0)
    zero.negate()

    let alsoZero = BigIntHeap(0)
    XCTAssertEqual(zero, alsoZero)
  }

  func test_negate_smi() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // 'Smi.min' negation overflows
      if smi == .min {
        continue
      }

      var value = BigIntHeap(smi)
      value.negate()

      let expected = -smi
      XCTAssertTrue(value == expected, "\(value) == \(expected)")
    }
  }

  func test_negate_heap() {
    for p in generateHeapValues(countButNotReally: 100) {
      // There is special test for '0'
      if p.isZero {
        continue
      }

      var value = p.create()

      // Single negation
      value.negate()
      XCTAssertEqual(value.isNegative, !p.isNegative)

      // Same magnitude?
      XCTAssertEqual(value.storage.count, p.words.count)
      for (negatedWord, originalWord) in zip(value.storage, p.words) {
        XCTAssertEqual(negatedWord, originalWord)
      }

      // Double negation - back to normal
      value.negate()
      XCTAssertEqual(value.isNegative, p.isNegative)

      // Same magnitude?
      XCTAssertEqual(value.storage.count, p.words.count)
      for (negatedWord, originalWord) in zip(value.storage, p.words) {
        XCTAssertEqual(negatedWord, originalWord)
      }
    }
  }
}
