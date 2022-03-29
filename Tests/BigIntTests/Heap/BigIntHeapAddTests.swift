import XCTest
@testable import BigInt

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

class BigIntHeapAddTests: XCTestCase {

  // MARK: - Smi - zero

  func test_smi_otherZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      // We have separate test for 'self == 0'
      if p.isZero {
        continue
      }

      var value = p.create()
      value.add(other: smiZero)

      let staysTheSame = p.create()
      XCTAssertEqual(value, staysTheSame)
    }
  }

  func test_smi_selfZero() {
    for smi in generateSmiValues(countButNotReally: 100) {
      var value = BigIntHeap()
      value.add(other: smi)

      let expected = BigIntHeap(smi)
      XCTAssertEqual(value, expected)
    }
  }

  // MARK: - Smi - both positive

  /// (Word.max - smiMax) + smiMax = Word.max
  func test_smi_bothPositive_sameWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    value.add(other: smiMax)

    let expected = BigIntHeap(isNegative: false, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// Word.max + smiMax = well… a lot
  func test_smi_bothPositive_newWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.add(other: smiMax)

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - both negative

  /// -(Word.max - smiMaxAsWord) + (-smiMax) = -Word.max
  func test_smi_bothNegative_sameWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    value.add(other: -smiMax)

    let expected = BigIntHeap(isNegative: true, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// -Word.max + (-smiMax) = well… a lot
  func test_smi_bothNegative_newWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.add(other: -smiMax)

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - positive negative

  /// Word.max + (-smiMax) = Word.max - smiMax
  func test_smi_selfPositive_otherNegative_sameSign() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.add(other: -smiMax)

    let expected = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// smiMax + (-smiMax) = 0
  func test_smi_selfPositive_otherNegative_zero() {
    var value = BigIntHeap(isNegative: false, words: smiMaxAsWord)
    value.add(other: -smiMax)

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// 10 + (-smiMax) =  -(smiMax - 10)
  func test_smi_selfPositive_otherNegative_changingSign() {
    var value = BigIntHeap(isNegative: false, words: 10)
    value.add(other: -smiMax)

    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - negative positive

  /// -Word.max + smiMax = -(Word.max - smiMax)
  func test_smi_selfNegative_otherPositive_sameSign() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.add(other: smiMax)

    let expected = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// -smiMax + smiMax = 0
  func test_smi_selfNegative_otherPositive_zero() {
    var value = BigIntHeap(isNegative: true, words: smiMaxAsWord)
    value.add(other: smiMax)

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// -10 + smiMax =  smiMax - 10
  func test_smi_selfNegative_otherPositive_changingSign() {
    var value = BigIntHeap(isNegative: true, words: 10)
    value.add(other: smiMax)

    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Smi - Self has multiple words

  func test_smi_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhs: Smi.Storage = 370955168

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.add(other: rhs)
    var expected = BigIntHeap(isNegative: false, words: [3689348815112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.add(other: rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348814370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    lhs.add(other: -rhs)
    expected = BigIntHeap(isNegative: false, words: [3689348814370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    lhs.add(other: -rhs)
    expected = BigIntHeap(isNegative: true, words: [3689348815112865495, 2459565876494606880])
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

      // a + b
      if let lhs = lhsPlus, let rhs = rhsPlus {
        let (expected, overflow) = lhs.addingReportingOverflow(rhs)
        if !overflow {
          var lhsHeap = BigIntHeap(lhs)
          lhsHeap.add(other: rhs)
          XCTAssertTrue(lhsHeap == expected, "\(lhs) + \(rhs)")
        }
      }

      // a + (-b)
      if let lhs = lhsPlus {
        let (expected, overflow) = lhs.addingReportingOverflow(rhsMinus)
        if !overflow {
          var lhsHeap = BigIntHeap(lhs)
          lhsHeap.add(other: rhsMinus)
          XCTAssertTrue(lhsHeap == expected, "\(lhs) + \(rhsMinus)")
        }
      }

      // -a + b
      if let rhs = rhsPlus {
        let (expected, overflow) = lhsMinus.addingReportingOverflow(rhs)
        if !overflow {
          var lhsHeap = BigIntHeap(lhsMinus)
          lhsHeap.add(other: rhs)
          XCTAssertTrue(lhsHeap == expected, "\(lhsMinus) + \(rhs)")
        }
      }

      // -a + (-b)
      let (expected, overflow) = lhsMinus.addingReportingOverflow(rhsMinus)
      if !overflow {
        var lhsHeap = BigIntHeap(lhsMinus)
        lhsHeap.add(other: rhsMinus)
        XCTAssertTrue(lhsHeap == expected, "\(lhsMinus) + \(rhsMinus)")
      }
    }
  }

  // MARK: - Heap - zero

  func test_heap_otherZero() {
    let zero = BigIntHeap()

    for p in generateHeapValues(countButNotReally: 100) {
      // We have separate test for 'self == 0'
      if p.isZero {
        continue
      }

      var value = p.create()
      value.add(other: zero)

      let staysTheSame = p.create()
      XCTAssertEqual(value, staysTheSame)
    }
  }

  func test_heap_selfZero_otherPositive() {
    for p in generateHeapValues(countButNotReally: 100) {
      var lhs = BigIntHeap()
      let rhs = p.create()

      lhs.add(other: rhs)
      XCTAssertEqual(lhs, rhs)
    }
  }

  // MARK: - Heap - both positive

  /// (Word.max - smiMax) + smiMax = Word.max
  func test_heap_bothPositive_sameWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    value.add(other: BigIntHeap(smiMax))

    let expected = BigIntHeap(isNegative: false, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// Word.max + smiMax = well… a lot
  func test_heap_bothPositive_newWord() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.add(other: BigIntHeap(smiMax))

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - both negative

  /// -(Word.max - smiMaxAsWord) + (-smiMax) = -Word.max
  func test_heap_bothNegative_sameWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    value.add(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap(isNegative: true, words: Word.max)
    XCTAssertEqual(value, expected)
  }

  /// -Word.max + (-smiMax) = well… a lot
  func test_heap_bothNegative_newWord() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.add(other: BigIntHeap(-smiMax))

    // Why '-1'? 99 + 5 = 104, not 105!
    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 1, 1)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - positive negative

  /// Word.max + (-smiMax) = Word.max - smiMax
  func test_heap_selfPositive_otherNegative_sameSign() {
    var value = BigIntHeap(isNegative: false, words: Word.max)
    value.add(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap(isNegative: false, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// smiMax + (-smiMax) = 0
  func test_heap_selfPositive_otherNegative_zero() {
    var value = BigIntHeap(isNegative: false, words: smiMaxAsWord)
    value.add(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// 10 + (-smiMax) =  -(smiMax - 10)
  func test_heap_selfPositive_otherNegative_changingSign() {
    var value = BigIntHeap(isNegative: false, words: 10)
    value.add(other: BigIntHeap(-smiMax))

    let expected = BigIntHeap(isNegative: true, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - negative positive

  /// -Word.max + smiMax = -(Word.max - smiMax)
  func test_heap_selfNegative_otherPositive_sameSign() {
    var value = BigIntHeap(isNegative: true, words: Word.max)
    value.add(other: BigIntHeap(smiMax))

    let expected = BigIntHeap(isNegative: true, words: Word.max - smiMaxAsWord)
    XCTAssertEqual(value, expected)
  }

  /// -smiMax + smiMax = 0
  func test_heap_selfNegative_otherPositive_zero() {
    var value = BigIntHeap(isNegative: true, words: smiMaxAsWord)
    value.add(other: BigIntHeap(smiMax))

    let expected = BigIntHeap() // zero
    XCTAssertEqual(value, expected)
  }

  /// -10 + smiMax =  smiMax - 10
  func test_heap_selfNegative_otherPositive_changingSign() {
    var value = BigIntHeap(isNegative: true, words: 10)
    value.add(other: BigIntHeap(smiMax))

    let expected = BigIntHeap(isNegative: false, words: smiMaxAsWord - 10)
    XCTAssertEqual(value, expected)
  }

  // MARK: - Heap - multiple words

  func test_heap_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhsWords: [Word] = [1844674407370955168]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.add(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_rhsLonger() {
    let lhsWords: [Word] = [1844674407370955168]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.add(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [1844674407370955159, 2459565876494606880])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [5534023222112865495, 2459565876494606880])
    XCTAssertEqual(lhs, expected)
  }

  func test_heap_bothMultipleWords() {
    let lhsWords: [Word] = [1844674407370955168, 4304240283865562048]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // Both positive
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.add(other: rhs)

    var expected = BigIntHeap(isNegative: false, words: [5534023222112865495, 6763806160360168928])
    XCTAssertEqual(lhs, expected)

    // Self negative, other positive
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [16602069666338596457, 1844674407370955167])
    XCTAssertEqual(lhs, expected)

    // Self positive, other negative
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: false, words: [16602069666338596457, 1844674407370955167])
    XCTAssertEqual(lhs, expected)

    // Both negative
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    lhs.add(other: rhs)

    expected = BigIntHeap(isNegative: true, words: [5534023222112865495, 6763806160360168928])
    XCTAssertEqual(lhs, expected)
  }
}
