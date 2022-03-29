import XCTest
@testable import BigInt

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

class BigIntHeapSubTests: XCTestCase {

  // MARK: - Smi - zero

  func test_smi_otherZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      // We have separate test for 'self == 0'
      if p.isZero {
        continue
      }

      var value = p.create()
      value.sub(other: smiZero)

      let staysTheSame = p.create()
      XCTAssertEqual(value, staysTheSame)
    }
  }

  // 0 - x = -x
  func test_smi_selfZero() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // '-Smi.min' overflows
      if smi == .min {
        continue
      }

      var value = BigIntHeap()
      value.sub(other: smi)

      let expected = BigIntHeap(-smi)
      XCTAssertEqual(value, expected)
    }
  }

  // MARK: - Smi - both positive

  /// Word.max - smiMax = well… something
  func test_smi_bothPositive_sameSign() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.sub(other: smiMax)

    let expected = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// smiMax - smiMax = 0
  func test_smi_bothPositive_zero() {
    var value = BigIntHeap(isNegative: false, words: smiMaxAsWord)
    value.sub(other: smiMax)

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// 10 - smiMax =  -(smiMax - 10)
  func test_smi_bothPositive_changingSign() {
    var value = BigIntHeap(isNegative: false, words: 10)
    value.sub(other: smiMax)

    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - both negative

  /// -Word.max - (-smiMax) = well… something
  func test_smi_bothNegative_sameSign() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.sub(other: -smiMax)

    let expected = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// -smiMax - (-smiMax) = 0
  func test_smi_bothNegative_zero() {
    var value = BigIntHeap(isNegative: true, words: smiMaxAsWord)
    value.sub(other: -smiMax)

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// 10 - smiMax =  -(smiMax - 10)
  func test_smi_bothNegative_changingSign() {
    var value = BigIntHeap(isNegative: true, words: 10)
    value.sub(other: -smiMax)

    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - positive negative

  /// (Word.max - smiMax) - (-smiMax) = Word.max
  func test_smi_selfPositive_otherNegative_sameWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    value.sub(other: -smiMax)

    let expected = BigIntHeap(isNegative: false, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// Word.max - (-smiMax) = well… a lot
  func test_smi_selfPositive_otherNegative_newWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.sub(other: -smiMax)

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - negative positive

  /// -(Word.max - smiMax) - smiMax = -Word.max
  func test_smi_selfNegative_otherPositive_sameWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    value.sub(other: smiMax)

    let expected = BigIntHeap(isNegative: true, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// -Word.max - smiMax = well… a lot
  func test_smi_selfNegative_otherPositive_newWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.sub(other: smiMax)

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - Self has multiple words

  func test_smi_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhs: Smi.Storage = 370955168

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.sub(other: rhs)
    var expected = BigIntHeap(isNegative: false, words: [3689348814370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.sub(other: rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348815112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.sub(other: -rhs)
    expected = BigIntHeap(isNegative: false, words: [3689348815112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.sub(other: -rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348814370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  // MARK: - Smi - generated

  func test_smi_generated() {
    let values = generateSmiValues(countButNotReally: 20)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      let lhsPlus = lhs == .min ? nil : abs(lhs)
      let rhsPlus = rhs == .min ? nil : abs(rhs)
      let lhsMinus = lhs < 0 ? lhs : -lhs
      let rhsMinus = rhs < 0 ? rhs : -rhs

      // a - b
      if let lhs = lhsPlus, let rhs = rhsPlus {
        let (expected, overflow) = lhs.subtractingReportingOverflow(rhs)
        if !overflow {
          var lhsHeap = BigIntHeap(lhs)
          lhsHeap.sub(other: rhs)
          XCTAssertTrue(lhsHeap == expected, "\(lhs) - \(rhs)")
        }
      }

      // a - (-b)
      if let lhs = lhsPlus {
        let (expected, overflow) = lhs.subtractingReportingOverflow(rhsMinus)
        if !overflow {
          var lhsHeap = BigIntHeap(lhs)
          lhsHeap.sub(other: rhsMinus)
          XCTAssertTrue(lhsHeap == expected, "\(lhs) - \(rhsMinus)")
        }
      }

      // -a - b
      if let rhs = rhsPlus {
        let (expected, overflow) = lhsMinus.subtractingReportingOverflow(rhs)
        if !overflow {
          var lhsHeap = BigIntHeap(lhsMinus)
          lhsHeap.sub(other: rhs)
          XCTAssertTrue(lhsHeap == expected, "\(lhsMinus) - \(rhs)")
        }
      }

      // -a - (-b)
      let (expected, overflow) = lhsMinus.subtractingReportingOverflow(rhsMinus)
      if !overflow {
        var lhsHeap = BigIntHeap(lhsMinus)
        lhsHeap.sub(other: rhsMinus)
        XCTAssertTrue(lhsHeap == expected, "\(lhsMinus) - \(rhsMinus)")
      }
    }
  }

  // MARK: - Heap - zero

  // x - 0 = x
  func test_heap_otherZero() {
    let zero = BigIntHeap()

    for p in generateHeapValues(countButNotReally: 100) {
      // We have separate test for 'self == 0'
      if p.isZero {
        continue
      }

      var value = p.create()
      value.sub(other: zero)

      let staysTheSame = p.create()
      XCTAssertEqual(value, staysTheSame)
    }
  }

  // 0 - x = -x
  func test_heap_selfZero_otherPositive() {
    for p in generateHeapValues(countButNotReally: 100) {
      var lhs = BigIntHeap()
      let rhs = BigIntHeap(isNegative: p.isNegative, words: p.words)
      lhs.sub(other: rhs)

      let expected = BigIntHeap(isNegative: !p.isNegative, words: p.words)
      XCTAssertEqual(lhs, expected)
    }
  }

  // MARK: - Heap - both positive

  /// Word.max - smiMax = well… something
  func test_heap_bothPositive_sameSign() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.sub(other: BigIntHeap(smiMax))

    let expected = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// smiMax - smiMax = 0
  func test_heap_bothPositive_zero() {
    var value = BigIntHeap(isNegative: false, words: smiMaxAsWord)
    value.sub(other: BigIntHeap(smiMax))

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// 10 - smiMax =  -(smiMax - 10)
  func test_heap_bothPositive_changingSign() {
    var value = BigIntHeap(isNegative: false, words: 10)
    value.sub(other: BigIntHeap(smiMax))

    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - both negative

  /// -Word.max - (-smiMax) = well… something
  func test_heap_bothNegative_sameSign() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.sub(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// -smiMax - (-smiMax) = 0
  func test_heap_bothNegative_zero() {
    var value = BigIntHeap(isNegative: true, words: smiMaxAsWord)
    value.sub(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// 10 - smiMax =  -(smiMax - 10)
  func test_heap_bothNegative_changingSign() {
    var value = BigIntHeap(isNegative: true, words: 10)
    value.sub(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - positive negative

  /// (Word.max - smiMax) - (-smiMax) = Word.max
  func test_heap_selfPositive_otherNegative_sameWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    value.sub(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap(isNegative: false, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// Word.max - (-smiMax) = well… a lot
  func test_heap_selfPositive_otherNegative_newWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.sub(other: BigIntHeap(-smiMax))

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - negative positive

  /// -(Word.max - smiMax) - smiMax = -Word.max
  func test_heap_selfNegative_otherPositive_sameWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    value.sub(other: BigIntHeap(smiMax))

    let expected = BigIntHeap(isNegative: true, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// -Word.max - smiMax = well… a lot
  func test_heap_selfNegative_otherPositive_newWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.sub(other: BigIntHeap(smiMax))

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - multiple words

  func test_heap_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhsWords: [Word] = [1844674407370955168]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.sub(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_rhsLonger() {
    let lhsWords: [Word] = [1844674407370955168]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.sub(other: rhs)

    var expected = BigIntHeap(isNegative: true, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_bothMultipleWords() {
    let lhsWords: [Word] = [1844674407370955168, 4304240283865562048]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.sub(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [16602069666338596457, 1844674407370955167])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [5534023222112865495, 6763806160360168928])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [5534023222112865495, 6763806160360168928])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.sub(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [16602069666338596457, 1844674407370955167])
    XCTAssertEqual(lhs, expected)
  }
}
