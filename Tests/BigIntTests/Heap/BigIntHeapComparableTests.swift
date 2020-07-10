import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

class BigIntHeapComparableTests: XCTestCase {

  // MARK: - Smi - different sign

  func test_smi_differentSign_negativeIsAlwaysLess() {
    for negativeRaw in generateSmiValues(countButNotReally: 10) {
      // '0' stays the same after negation
      if negativeRaw == 0 {
        continue
      }

      let negativeSmi = negativeRaw.isNegative ? negativeRaw : -negativeRaw
      let negativeHeap = BigIntHeap(negativeSmi)

      for positiveRaw in generateSmiValues(countButNotReally: 10) {
        // '-min' is not representable as 'Smi.Storage'
        if positiveRaw == .min {
          continue
        }

        let positive = positiveRaw.isPositive ?
          positiveRaw :
          Smi.Storage(positiveRaw.magnitude)

        XCTAssertTrue(negativeHeap < positive, "\(negativeHeap) < \(positive)")
      }
    }
  }

  // MARK: - Smi - same sign - 1 word

  func test_smi_sameSign_equalMagnitude_isNotLess() {
    for smi in generateSmiValues(countButNotReally: 100) {
      let heap = BigIntHeap(smi)
      XCTAssertFalse(heap < smi, "\(heap) < \(smi)")
    }
  }

  func test_smi_sameSign_smallerMagnitude_isLess() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // '0 - 1' changes sign
      // '.min - 1' overflows
      if smi == 0 || smi == .min {
        continue
      }

      let smallerHeap = BigIntHeap(smi - 1)
      XCTAssertTrue(smallerHeap < smi, "\(smallerHeap) < \(smi)")
    }
  }

  func test_smi_sameSign_greaterMagnitude_isNeverLess() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // '0 - 1' changes sign
      // '.max + 1' overflows
      if smi == 0 || smi == .max {
        continue
      }

      let biggerHeap = BigIntHeap(smi + 1)
      XCTAssertFalse(biggerHeap < smi, "\(biggerHeap) < \(smi)")
    }
  }

  // MARK: - Smi - same sign - more words

  func test_smi_sameSign_moreThan1Word() {
    for smi in generateSmiValues(countButNotReally: 10) {
      for p in generateHeapValues(countButNotReally: 10) {
        // We need more words
        guard p.words.count > 1 else {
          continue
        }

        // We need the same sign as 'smi'
        let heap = BigIntHeap(isNegative: smi.isNegative, words: p.words)

        // positive - more words -> bigger number
        // negative - more words -> smaller number
        if smi.isPositive {
          XCTAssertFalse(heap < smi, "\(heap) < \(smi)")
        } else {
          XCTAssertTrue(heap < smi, "\(heap) < \(smi)")
        }
      }
    }
  }

  // MARK: - Heap - different sign

  func test_heap_differentSign_negativeIsAlwaysLess() {
    for negativeRaw in generateHeapValues(countButNotReally: 10) {
      // '0' stays the same after negation
      if negativeRaw.isZero {
        continue
      }

      let negative = BigIntHeap(isNegative: true, words: negativeRaw.words)

      for positiveRaw in generateHeapValues(countButNotReally: 10) {
        let positive = BigIntHeap(isNegative: false, words: positiveRaw.words)
        XCTAssertTrue(negative < positive, "\(negative) < \(positive)")
      }
    }
  }

  // MARK: - Heap - same sign - equal word count

  func test_heap_sameSign_equalMagnitude_isNeverLess() {
    for p in generateHeapValues(countButNotReally: 100) {
      let lhs = p.create()
      let rhs = p.create()
      XCTAssertFalse(lhs < rhs, "\(lhs) < \(rhs)")
    }
  }

  func test_heap_sameSign_smallerMagnitude_isLess() {
    for p in generateHeapValues(countButNotReally: 100) {
      let value = p.create()
      var minus1 = value
      minus1.sub(other: Smi.Storage(1))

      XCTAssertTrue(minus1 < value, "\(minus1) < \(value)")
    }
  }

  func test_heap_sameSign_greaterMagnitude_isNeverLess() {
    for p in generateHeapValues(countButNotReally: 100) {
      let value = p.create()
      var plus1 = value
      plus1.add(other: Smi.Storage(1))

      XCTAssertFalse(plus1 < value, "\(plus1) < \(value)")
    }
  }

  // MARK: - Heap - same sign - different word count

  func test_heap_sameSign_moreWords() {
    for p in generateHeapValues(countButNotReally: 100) {
      let value = BigIntHeap(isNegative: p.isNegative, words: p.words)
      let moreWords = BigIntHeap(isNegative: p.isNegative, words: p.words + [42])

      // positive - more words -> bigger number
      // negative - more words -> smaller number
      if p.isPositive {
        XCTAssertTrue(value < moreWords, "\(value) < \(moreWords)")
        XCTAssertFalse(moreWords < value, "\(moreWords) < \(value)")
      } else {
        XCTAssertFalse(value < moreWords, "\(value) < \(moreWords)")
        XCTAssertTrue(moreWords < value, "\(moreWords) < \(value)")
      }
    }
  }
}
