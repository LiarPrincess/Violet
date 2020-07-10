import XCTest
@testable import BigInt

class BigIntHeapEquatableTests: XCTestCase {

  // MARK: - Smi

  func test_smi_equal() {
    for smi in generateSmiValues(countButNotReally: 100) {
      let heap = BigIntHeap(smi)
      XCTAssertTrue(heap == smi, "\(smi)")
    }
  }

  func test_smi_notEqual() {
    let values = generateSmiValues(countButNotReally: 20)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      if lhs == rhs {
        continue
      }

      let lhsHeap = BigIntHeap(lhs)
      XCTAssertFalse(lhsHeap == rhs, "\(lhsHeap) == \(rhs)")

      let rhsHeap = BigIntHeap(rhs)
      XCTAssertFalse(rhsHeap == lhs, "\(rhsHeap) == \(lhs)")
    }
  }

  func test_smi_moreThan1Word_isNeverEqual() {
    for smi in generateSmiValues(countButNotReally: 10) {
      for p in generateHeapValues(countButNotReally: 10) {
        guard p.words.count > 1 else {
          continue
        }

        let heap = p.create()
        XCTAssertFalse(heap == smi, "\(heap) == \(smi)")
      }
    }
  }

  // MARK: - Heap

  func test_heap_equal() {
    for p in generateHeapValues(countButNotReally: 100) {
      let lhs = p.create()
      let rhs = p.create()
      XCTAssertEqual(lhs, rhs, "\(lhs)")
    }
  }

  func test_heap_withDifferentSign_isNeverEqual() {
    for p in generateHeapValues(countButNotReally: 100) {
      // '0' is always positive
      if p.isZero {
        continue
      }

      let lhs = BigIntHeap(isNegative: p.isNegative, words: p.words)
      let rhs = BigIntHeap(isNegative: !p.isNegative, words: p.words)
      XCTAssertNotEqual(lhs, rhs, "\(lhs)")
    }
  }

  func test_heap_withDifferentWords_isNeverEqual() {
    for p in generateHeapValues(countButNotReally: 20) {
      // '0' as no words
      if p.isZero {
        continue
      }

      let orginal = p.create()

      for i in 0..<orginal.storage.count {
        // Word can't be above '.max'
        if orginal.storage[i] != .max {
          var plus1 = orginal.storage
          plus1[i] += 1
          XCTAssertNotEqual(orginal, BigIntHeap(storage: plus1), "\(orginal)")
        }

        // Word can't be below '0'
        if orginal.storage[i] != 0 {
          var minus1 = orginal.storage
          minus1[i] -= 1
          XCTAssertNotEqual(orginal, BigIntHeap(storage: minus1), "\(orginal)")
        }
      }
    }
  }

  func test_heap_withDifferentWordCount_isNeverEqual() {
    for p in generateHeapValues(countButNotReally: 20) {
      let orginal = p.create()

      let moreWords = BigIntHeap(isNegative: p.isNegative, words: p.words + [42])
      XCTAssertNotEqual(orginal, moreWords, "\(orginal)")

      // We can't remove word if we don't have any!
      if !p.isZero {
        let lessWords = BigIntHeap(isNegative: false, words: Array(p.words.dropLast()))
        XCTAssertNotEqual(orginal, lessWords, "\(orginal)")
      }
    }
  }
}
