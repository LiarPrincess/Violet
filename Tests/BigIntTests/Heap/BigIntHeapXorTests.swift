import XCTest
@testable import BigInt

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

private typealias Word = BigIntStorage.Word

class BigIntHeapXorTests: XCTestCase {

  // MARK: - Smi - zero

  func test_smi_selfZero() {
    for smi in generateSmiValues(countButNotReally: 100) {
      var lhs = BigIntHeap()
      lhs.xor(other: smi)

      // 'lhs' should be replaced by 'smi'
      XCTAssertEqual(lhs, BigIntHeap(smi))
    }
  }

  func test_smi_otherZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      var lhs = p.create()
      lhs.xor(other: Smi.Storage.zero)

      let noChanges = p.create()
      XCTAssertEqual(lhs, noChanges)
    }
  }

  // MARK: - Smi - other

  func test_smi_singleWord() {
    for lhsInt in generateIntValues(countButNotReally: 10) {
      for rhs in generateSmiValues(countButNotReally: 10) {
        var lhs = BigIntHeap(lhsInt)
        lhs.xor(other: rhs)

        let expectedInt = lhsInt ^ Int(rhs)
        let expected = BigIntHeap(expectedInt)

        XCTAssertEqual(lhs, expected, "\(lhsInt) ^ \(rhs)")
      }
    }
  }

  func test_smi_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhs: Smi.Storage = 370955168

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.xor(other: rhs)
    var expected = BigIntHeap(isNegative: false, words: [3689348814506778775, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.xor(other: rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348814506778775, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.xor(other: -rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348814506778793, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.xor(other: -rhs)
    expected = BigIntHeap(isNegative: false, words: [3689348814506778793, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  // MARK: - Heap - zero

  func test_heap_selfZero() {
    for rhsInt in generateIntValues(countButNotReally: 100) {
      let rhsWord = Word(rhsInt.magnitude)
      let rhs = BigIntHeap(isNegative: rhsInt.isNegative, words: rhsWord)

      var lhs = BigIntHeap()
      lhs.xor(other: rhs)

      // 'lhs' should be replaced by 'rhs'
      XCTAssertEqual(lhs, rhs)
    }
  }

  func test_heap_otherZero() {
    let zero = BigIntHeap()

    for p in generateHeapValues(countButNotReally: 100) {
      var lhs = p.create()
      lhs.xor(other: zero)

      let noChanges = p.create()
      XCTAssertEqual(lhs, noChanges)
    }
  }

  // MARK: - Heap - single word

  func test_heap_singleWord_trivial() {
    let lhsWord: Word = 0b1100
    let rhsWord: Word = 0b1010

    var lhs = BigIntHeap(isNegative: false, words: lhsWord)
    let rhs = BigIntHeap(isNegative: false, words: rhsWord)
    lhs.xor(other: rhs)

    let expected = lhsWord ^ rhsWord
    XCTAssertEqual(lhs, BigIntHeap(expected))
  }

  func test_heap_singleWord() {
    let values = generateIntValues(countButNotReally: 10)

    for (lhsInt, rhsInt) in allPossiblePairings(values: values) {
      let lhsWord = Word(lhsInt.magnitude)
      let rhsWord = Word(rhsInt.magnitude)

      var lhs = BigIntHeap(isNegative: lhsInt.isNegative, words: lhsWord)
      let rhs = BigIntHeap(isNegative: rhsInt.isNegative, words: rhsWord)
      lhs.xor(other: rhs)

      let expectedInt = lhsInt ^ rhsInt
      let expected = BigIntHeap(expectedInt)

      XCTAssertEqual(lhs, expected, "\(lhsInt) ^ \(rhsInt)")
    }
  }

  // MARK: - Heap - multiple words

  func test_heap_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhsWords: [Word] = [1844674407370955168]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.xor(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [3074457345618258583, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [3074457345618258583, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [3074457345618258601, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [3074457345618258601, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_rhsLonger() {
    let lhsWords: [Word] = [1844674407370955168]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.xor(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [3074457345618258583, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [3074457345618258601, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [3074457345618258583, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [3074457345618258601, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_bothMultipleWords() {
    let lhsWords: [Word] = [1844674407370955168, 4304240283865562048]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.xor(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [3074457345618258583, 1844674407370955232])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [3074457345618258601, 1844674407370955232])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [3074457345618258583, 1844674407370955232])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.xor(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [3074457345618258601, 1844674407370955232])
    XCTAssertEqual(lhs, expected)
  }
}
