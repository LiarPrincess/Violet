import XCTest
@testable import BigInt

// swiftlint:disable number_separator
// swiftlint:disable file_length
// swiftformat:disable numberFormatting

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

/// `2^n = value`
private typealias Pow2 = (value: Int, n: Int)

private let powersOf2: [Pow2] = [
  (value: 2, n: 1),
  (value: 4, n: 2),
  (value: 16, n: 4)
]

class BigIntHeapDivTests: XCTestCase {

  // MARK: - Smi - 0

  // For obvious reasons we will not have 'otherZero' test

  /// 0 / x = 0 rem 0
  func test_smi_selfZero() {
    for smi in generateSmiValues(countButNotReally: 100) {
      if smi.isZero {
        continue
      }

      var value = BigIntHeap()
      let rem = value.div(other: smi)

      XCTAssert(value.isZero)
      XCTAssert(rem.isZero)
    }
  }

  // MARK: - Smi - +1

  /// x / 1 = x rem 0
  func test_smi_otherPlusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      let rem = value.div(other: Smi.Storage(1))

      let noChanges = p.create()
      XCTAssertEqual(value, noChanges)
      XCTAssert(rem.isZero)
    }
  }

  /// 1 / x = 0 rem 1 (mostly)
  func test_smi_selfPlusOne() {
    for smi in generateSmiValues(countButNotReally: 100) {
      if smi.isZero {
        continue
      }

      var value = BigIntHeap(1)
      let rem = value.div(other: smi)

      switch smi {
      case 1: // 1 / 1 = 1 rem 0
        XCTAssertEqual(value, BigIntHeap(1))
        XCTAssert(rem.isZero)
      case -1: // 1 / (-1) = -1 rem 0
        XCTAssertEqual(value, BigIntHeap(-1))
        XCTAssert(rem.isZero)
      default:
        XCTAssert(value.isZero, "1 / \(smi)")
        XCTAssert(rem == 1, "1 / \(smi)") // Always positive!
      }
    }
  }

  // MARK: - Smi - -1

  /// x / (-1) = -x
  func test_smi_otherMinusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      let rem = value.div(other: Smi.Storage(-1))

      let expectedIsNegative = p.isPositive && !p.isZero
      let expected = BigIntHeap(isNegative: expectedIsNegative, words: p.words)
      XCTAssertEqual(value, expected)
      XCTAssert(rem.isZero)
    }
  }

  /// (-1) / x = 0 rem -1 (mostly)
  func test_smi_selfMinusOne() {
    for smi in generateSmiValues(countButNotReally: 100) {
      if smi.isZero {
        continue
      }

      var value = BigIntHeap(-1)
      let rem = value.div(other: smi)

      switch smi {
      case 1: // (-1) / 1 = -1 rem 0
        XCTAssertEqual(value, BigIntHeap(-1))
        XCTAssert(rem.isZero)
      case -1: // (-1) / (-1) = 1 rem 0
        XCTAssertEqual(value, BigIntHeap(1))
        XCTAssert(rem.isZero)
      default:
        XCTAssert(value.isZero)
        XCTAssertEqual(rem, -1)
      }
    }
  }

  // MARK: - Smi - pow 2

  /// Div by `n^2` should shift right by `n`
  func test_smi_otherIsPowerOf2() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      for power in powersOf2 {
        guard let p = self.cleanBitsSoItCanBeDividedWithoutOverflow(
          value: p,
          power: power
        ) else { continue }

        var value = p.create()
        let rem = value.div(other: Smi.Storage(power.value))

        let expectedWords = p.words.map { $0 >> power.n }
        var expected = BigIntHeap(isNegative: p.isNegative, words: expectedWords)
        expected.fixInvariants()

        XCTAssertEqual(value, expected, "\(p) / \(power.value)")
        // Rem is '0' because we cleaned those bits
        XCTAssert(rem.isZero, "\(p) / \(power.value)")
      }
    }
  }

  private func cleanBitsSoItCanBeDividedWithoutOverflow(
    value: HeapPrototype,
    power: Pow2
  ) -> HeapPrototype? {
    // 1111 << 1 = 1110
    let mask = Word.max << power.n
    let words = value.words.map { $0 & mask }

    // Zero may behave differently than other numbers
    let allWordsZero = words.allSatisfy { $0.isZero }
    if allWordsZero {
      return nil
    }

    return HeapPrototype(isNegative: value.isNegative, words: words)
  }

  // MARK: - Smi - Equal, less, greater

  /// x / x = 1 rem 0
  func test_smi_equalMagnitude() {
    let plusOne = BigIntHeap(1)
    let minusOne = BigIntHeap(-1)

    for smi in generateSmiValues(countButNotReally: 100) {
      if smi == 0 {
        continue
      }

      let plus = Smi.Storage(exactly: smi.magnitude)
      let minus = smi.isNegative ? smi : -smi

      // plus / plus = 1 rem 0
      if let plus = plus {
        var value = BigIntHeap(plus)
        let rem = value.div(other: plus)
        XCTAssertEqual(value, plusOne)
        XCTAssert(rem.isZero)
      }

      // plus / minus = -1 rem 0
      if let plus = plus {
        var value = BigIntHeap(plus)
        let rem = value.div(other: minus)
        XCTAssertEqual(value, minusOne)
        XCTAssert(rem.isZero)
      }

      // minus / plus = -1 rem 0
      if let plus = plus {
        var value = BigIntHeap(minus)
        let rem = value.div(other: plus)
        XCTAssertEqual(value, minusOne)
        XCTAssert(rem.isZero)
      }

      // minus / minus = 1 rem 0
      var value = BigIntHeap(minus)
      let rem = value.div(other: minus)
      XCTAssertEqual(value, plusOne)
      XCTAssert(rem.isZero)
    }
  }

  /// x / (x-n) = 1 rem n
  func test_smi_selfHas_greaterMagnitude() {
    let values = generateSmiValues(countButNotReally: 20)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      // We have separate test for equal magnitude
      if lhs.magnitude == rhs.magnitude {
        continue
      }

      let (valueSmi, otherSmi) = lhs.magnitude > rhs.magnitude ?
        (lhs, rhs) : (rhs, lhs)

      if otherSmi == 0 {
        continue
      }

      var value = BigIntHeap(valueSmi)
      let rem = value.div(other: otherSmi)

      // We have to convert to 'Int' because: min / -1' = (max + 1) = overflow
      let expectedDiv = Int(valueSmi) / Int(otherSmi)
      let expectedRem = Int(valueSmi) % Int(otherSmi)
      XCTAssertEqual(value, BigIntHeap(expectedDiv))
      XCTAssertEqual(Int(rem), expectedRem, "\(valueSmi) / \(otherSmi)")
    }
  }

  /// x / (x + n) = 0 rem x
  func test_smi_otherHas_greaterMagnitude() {
    let values = generateSmiValues(countButNotReally: 20)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      // We have separate test for equal magnitude
      if lhs.magnitude == rhs.magnitude {
        continue
      }

      let (valueSmi, otherSmi) = lhs.magnitude < rhs.magnitude ?
        (lhs, rhs) : (rhs, lhs)

      if otherSmi == 0 {
        continue
      }

      var value = BigIntHeap(valueSmi)
      let rem = value.div(other: otherSmi)

      XCTAssert(value.isZero)
      XCTAssertEqual(rem, valueSmi)
    }
  }

  // MARK: - Smi - Self has multiple words

  func test_smi_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhs: Smi.Storage = 370955168

    let expectedDivWords: [Word] = [10690820303666397895, 6630358837]
    let expectedRem: Smi.Storage = 237957591

    // plus, plus
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedDivWords))
    XCTAssertEqual(rem, expectedRem)

    // minus, plus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedDivWords))
    XCTAssertEqual(rem, -expectedRem)

    // plus, minus
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rem = lhs.div(other: -rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: expectedDivWords))
    XCTAssertEqual(rem, expectedRem)

    // minus, minus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rem = lhs.div(other: -rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: expectedDivWords))
    XCTAssertEqual(rem, -expectedRem)
  }

  // MARK: - Heap - 0

  // For obvious reasons we will not have 'otherZero' test

  /// 0 / x = 0 rem 0
  func test_heap_selfZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      var value = BigIntHeap()
      let other = p.create()
      let rem = value.div(other: other)

      XCTAssert(value.isZero)
      XCTAssert(rem.isZero)
    }
  }

  // MARK: - Heap - +1

  /// x / 1 = x rem 0
  func test_heap_otherPlusOne() {
    let plusOne = BigIntHeap(1)

    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      let rem = value.div(other: plusOne)

      let noChanges = p.create()
      XCTAssertEqual(value, noChanges)
      XCTAssert(rem.isZero)
    }
  }

  /// 1 / x = 0 rem 1 (mostly)
  func test_heap_selfPlusOne() {
    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      var value = BigIntHeap(1)
      let other = p.create()
      let rem = value.div(other: other)

      // 1 / 1 = 1 rem 0
      if p.isPositive && p.hasMagnitudeOfOne {
        XCTAssertEqual(value, BigIntHeap(1))
        XCTAssert(rem.isZero)
        continue
      }

      // 1 / (-1) = -1 rem 0
      if p.isNegative && p.hasMagnitudeOfOne {
        XCTAssertEqual(value, BigIntHeap(-1))
        XCTAssert(rem.isZero)
        continue
      }

      XCTAssert(value.isZero, "1 / \(p)")
      XCTAssert(rem == 1, "1 / \(p)") // Always positive!
    }
  }

  // MARK: - Heap - -1

  /// x / (-1) = -x
  func test_heap_otherMinusOne() {
    let minusOne = BigIntHeap(-1)

    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      let rem = value.div(other: minusOne)

      let expectedIsNegative = p.isPositive && !p.isZero
      let expected = BigIntHeap(isNegative: expectedIsNegative, words: p.words)
      XCTAssertEqual(value, expected)
      XCTAssert(rem.isZero)
    }
  }

  /// (-1) / x = 0 rem -1 (mostly)
  func test_heap_selfMinusOne() {
    let minusOne = BigIntHeap(-1)

    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      var value = BigIntHeap(-1)
      let other = p.create()
      let rem = value.div(other: other)

      // (-1) / 1 = -1 rem 0
      if p.isPositive && p.hasMagnitudeOfOne {
        XCTAssertEqual(value, BigIntHeap(-1))
        XCTAssert(rem.isZero)
        continue
      }

      // (-1) / (-1) = 1 rem 0
      if p.isNegative && p.hasMagnitudeOfOne {
        XCTAssertEqual(value, BigIntHeap(1))
        XCTAssert(rem.isZero)
        continue
      }

      XCTAssert(value.isZero)
      XCTAssertEqual(rem, minusOne)
    }
  }

  // MARK: - Heap - pow 2

  /// Div by `n^2` should shift right by `n`
  func test_heap_otherIsPowerOf2() {
    for p in generateHeapValues(countButNotReally: 20) {
      if p.isZero {
        continue
      }

      for power in powersOf2 {
        guard let p = self.cleanBitsSoItCanBeDividedWithoutOverflow(
          value: p,
          power: power
        ) else { continue }

        var value = p.create()
        let other = BigIntHeap(power.value)
        let rem = value.div(other: other)

        let expectedWords = p.words.map { $0 >> power.n }
        var expected = BigIntHeap(isNegative: p.isNegative, words: expectedWords)
        expected.fixInvariants()

        // Rem is '0' because we cleaned those bits
        XCTAssertEqual(value, expected, "\(p) / \(power.value)")
        XCTAssert(rem.isZero, "\(p) / \(power.value)")
      }
    }
  }

  // MARK: - Heap - Equal, less, greater

  /// x / x = 1 rem 0
  func test_heap_equalMagnitude() {
    let plusOne = BigIntHeap(1)
    let minusOne = BigIntHeap(-1)

    for p in generateHeapValues(countButNotReally: 100) {
      if p.isZero {
        continue
      }

      let plus = BigIntHeap(isNegative: false, words: p.words)
      let minus = BigIntHeap(isNegative: true, words: p.words)

      // plus / plus = 1 rem 0
      var value = plus
      var rem = value.div(other: plus)
      XCTAssertEqual(value, plusOne)
      XCTAssert(rem.isZero)

      // plus / minus = -1 rem 0
      value = plus
      rem = value.div(other: minus)
      XCTAssertEqual(value, minusOne)
      XCTAssert(rem.isZero)

      // minus / plus = -1 rem 0
      value = minus
      rem = value.div(other: plus)
      XCTAssertEqual(value, minusOne)
      XCTAssert(rem.isZero)

      // minus / minus = 1 rem 0
      value = minus
      rem = value.div(other: minus)
      XCTAssertEqual(value, plusOne)
      XCTAssert(rem.isZero)
    }
  }

  /// x / (x-n) = 1 rem n
  func test_heap_selfHas_greaterMagnitude() {
    let values = generateHeapValues(countButNotReally: 20)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      let valueP: HeapPrototype
      let otherP: HeapPrototype

      switch self.compareMagnitude(lhs: lhs, rhs: rhs) {
      case .equal:
        // We have separate test for equal magnitude
        continue
      case .less:
        valueP = rhs
        otherP = lhs
      case .greater:
        valueP = lhs
        otherP = rhs
      }

      if otherP.isZero {
        continue
      }

      // We don't know the exact values, just check that id did not crash
      // (and trues me overflow is strong with this one)
      var value = valueP.create()
      let other = otherP.create()
      _ = value.div(other: other)
    }
  }

  /// x / (x + n) = 0 rem x
  func test_heap_otherHas_greaterMagnitude() {
    let values = generateHeapValues(countButNotReally: 20)

    for (lhs, rhs) in allPossiblePairings(values: values) {
      let valueP: HeapPrototype
      let otherP: HeapPrototype

      switch self.compareMagnitude(lhs: lhs, rhs: rhs) {
      case .equal:
        // We have separate test for equal magnitude
        continue
      case .less:
        valueP = lhs
        otherP = rhs
      case .greater:
        valueP = rhs
        otherP = lhs
      }

      if otherP.isZero {
        continue
      }

      var value = valueP.create()
      let other = otherP.create()
      let rem = value.div(other: other)

      let expectedRem = valueP.create()
      XCTAssert(value.isZero)
      XCTAssertEqual(rem, expectedRem)
    }
  }

  private enum CompareMagnitude {
    case equal
    case less
    case greater
  }

  private func compareMagnitude(lhs: HeapPrototype,
                                rhs: HeapPrototype) -> CompareMagnitude {
    guard lhs.words.count == rhs.words.count else {
      return lhs.words.count > rhs.words.count ? .greater : .less
    }

    for (l, r) in zip(lhs.words, rhs.words).reversed() {
      if l > r {
        return .greater
      }

      if l < r {
        return .less
      }
    }

    return .equal
  }

  // MARK: - Heap - multiple words

  func test_heap_lhsLonger() {
    let lhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let rhsWords: [Word] = [1844674407370955168]
    let divWords: [Word] = [6148914691236517100, 1]
    let remWords: [Word] = [1229782938247304119]

    // plus, plus
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    var rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: false, words: remWords))

    // minus, plus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: true, words: remWords))

    // plus, minus
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: false, words: remWords))

    // minus, minus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: true, words: remWords))
  }

  func test_heap_rhsLonger() {
    let lhsWords: [Word] = [1844674407370955168]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]

    // plus, plus
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    var rem = lhs.div(other: rhs)
    XCTAssert(lhs.isZero)
    XCTAssertEqual(rem, BigIntHeap(isNegative: false, words: lhsWords))

    // minus, plus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssert(lhs.isZero)
    XCTAssertEqual(rem, BigIntHeap(isNegative: true, words: lhsWords))

    // plus, minus
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssert(lhs.isZero)
    XCTAssertEqual(rem, BigIntHeap(isNegative: false, words: lhsWords))

    // minus, minus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssert(lhs.isZero)
    XCTAssertEqual(rem, BigIntHeap(isNegative: true, words: lhsWords))
  }

  func test_heap_bothMultipleWords() {
    let lhsWords: [Word] = [1844674407370955168, 4304240283865562048]
    let rhsWords: [Word] = [3689348814741910327, 2459565876494606880]
    let divWords: [Word] = [1]
    let remWords: [Word] = [16602069666338596457, 1844674407370955167]

    // plus, plus
    var lhs = BigIntHeap(isNegative: false, words: lhsWords)
    var rhs = BigIntHeap(isNegative: false, words: rhsWords)
    var rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: false, words: remWords))

    // minus, plus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: false, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: true, words: remWords))

    // plus, minus
    lhs = BigIntHeap(isNegative: false, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: true, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: false, words: remWords))

    // minus, minus
    lhs = BigIntHeap(isNegative: true, words: lhsWords)
    rhs = BigIntHeap(isNegative: true, words: rhsWords)
    rem = lhs.div(other: rhs)
    XCTAssertEqual(lhs, BigIntHeap(isNegative: false, words: divWords))
    XCTAssertEqual(rem, BigIntHeap(isNegative: true, words: remWords))
  }
}
