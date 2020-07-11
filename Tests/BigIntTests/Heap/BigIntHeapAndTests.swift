import XCTest
@testable import BigInt

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

private typealias Word = BigIntStorage.Word

class BigIntHeapAndTests: XCTestCase {

  // MARK: - Smi - zero

  func test_smi_selfZero() {
    let zero = BigIntHeap()

    for smi in generateSmiValues(countButNotReally: 100) {
      var lhs = BigIntHeap()
      lhs.and(other: smi)
      XCTAssertEqual(lhs, zero)
    }
  }

  func test_smi_otherZero() {
    let zero = BigIntHeap()

    for p in generateHeapValues(countButNotReally: 100) {
      var lhs = p.create()
      lhs.and(other: Smi.Storage.zero)
      XCTAssertEqual(lhs, zero)
    }
  }

  // MARK: - Smi - other

  func test_smi_singleWord() {
    for lhsInt in generateIntValues(countButNotReally: 10) {
      for rhs in generateSmiValues(countButNotReally: 10) {
        var lhs = BigIntHeap(lhsInt)
        lhs.and(other: rhs)

        let expectedInt = lhsInt & Int(rhs)
        let expected = BigIntHeap(expectedInt)

        XCTAssertEqual(lhs, expected, "\(lhsInt) & \(rhs)")
      }
    }
  }

  func test_smi_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhs: Smi.Storage = 370955168

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.and(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: 303043360))

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.and(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: 67911808))

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.and(other: -rhs)
    var expected = BigIntHeap(isNegative: false, words: [3689348814438866976, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.and(other: -rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348814809822144, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  // MARK: - Heap - zero

  func test_heap_selfZero() {
    let zero = BigIntHeap()

    for rhsInt in generateIntValues(countButNotReally: 100) {
      let rhsWord = Word(rhsInt.magnitude)
      let rhs = BigIntHeap(isNegative: rhsInt.isNegative, words: rhsWord)

      var lhs = BigIntHeap()
      lhs.and(other: rhs)
      XCTAssertEqual(lhs, zero)
    }
  }

  func test_heap_otherZero() {
    let zero = BigIntHeap()

    for p in generateHeapValues(countButNotReally: 100) {
      var lhs = p.create()
      lhs.and(other: zero)
      XCTAssertEqual(lhs, zero)
    }
  }

  // MARK: - Heap - single word

  func test_heap_singleWord_trivial() {
    let lhsWord: Word = 0b1100
    let rhsWord: Word = 0b1010

    var lhs = BigIntHeap(isNegative: false, words: lhsWord)
    let rhs = BigIntHeap(isNegative: false, words: rhsWord)
    lhs.and(other: rhs)

    let expected = lhsWord & rhsWord
    XCTAssertEqual(lhs, BigIntHeap(expected))
  }

  func test_heap_singleWord() {
    let values = generateIntValues(countButNotReally: 10)

    for (lhsInt, rhsInt) in allPossiblePairings(values: values) {
      let lhsWord = Word(lhsInt.magnitude)
      let rhsWord = Word(rhsInt.magnitude)

      var lhs = BigIntHeap(isNegative: lhsInt.isNegative, words: lhsWord)
      let rhs = BigIntHeap(isNegative: rhsInt.isNegative, words: rhsWord)
      lhs.and(other: rhs)

      let expectedInt = lhsInt & rhsInt
      let expected = BigIntHeap(expectedInt)

      XCTAssertEqual(lhs, expected, "\(lhsInt) & \(rhsInt)")
    }
  }

  // MARK: - Heap - multiple words

  func test_heap_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhsWords: [Word] = [1844674407370955168]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.and(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: 1229782938247303456)
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: false, words: 614891469123651712)
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [2459565876494606880, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [4304240283865562048, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_rhsLonger() {
    let lhsWords: [Word] = [1844674407370955168]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.and(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: 1229782938247303456)
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [2459565876494606880, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: false, words: 614891469123651712)
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [4304240283865562048, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_bothMultipleWords() {
    let lhsWords: [Word] = [1844674407370955168, 4304240283865562048]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.and(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [1229782938247303456, 2459565876494606848])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [2459565876494606880, 32])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [614891469123651712, 1844674407370955200])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.and(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [4304240283865562048, 4304240283865562080])
    XCTAssertEqual(lhs, expected)
  }
}
