import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word

private let smiZero = Smi.Storage.zero
private let smiMax = Smi.Storage.max
private let smiMaxAsWord = Word(smiMax.magnitude)

class BigIntHeapShiftTests: XCTestCase {

  // MARK: - Left - smi

  func test_left_smi_byZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.shiftLeft(count: Smi.Storage(0))

      let expected = p.create()
      XCTAssertEqual(value, expected)
    }
  }

  func test_left_smi_byWholeWord() {
    for p in generateHeapValues(countButNotReally: 35) {
      // Shifting '0' obeys a bit different rules
      if p.isZero {
        continue
      }

      for wordShift in 1...3 {
        var value = BigIntHeap(isNegative: p.isNegative, words: p.words)

        let prefix = [Word](repeating: 0, count: wordShift)
        let expected = BigIntHeap(isNegative: p.isNegative, words: prefix + p.words)

        let bitShift = wordShift * Word.bitWidth
        value.shiftLeft(count: Smi.Storage(bitShift))
        XCTAssertEqual(value, expected)
      }
    }
  }

  func test_left_smi_byBits() {
    // We will be shifting by 3 bits, make sure that they are 0,
    // so that we stay inside 1 word.
    let hasPlaceToShiftMask = Word(0b111) << (Word.bitWidth - 3)

    for p in generateHeapValues(countButNotReally: 50, maxWordCount: 1) {
      // Shifting '0' obeys a bit different rules
      if p.isZero {
        continue
      }

      assert(p.words.count == 1)
      let word = p.words[0]

      let hasPlaceToShift = (word & hasPlaceToShiftMask) == 0
      guard hasPlaceToShift else {
        continue
      }

      for count in 1...3 {
        var value = p.create()

        let expectedBeforeShift = p.isNegative ? -Int(word) : Int(word)
        let expectedAfterShift = expectedBeforeShift << count
        let expected = BigIntHeap(expectedAfterShift)

        value.shiftLeft(count: Smi.Storage(count))
        XCTAssertEqual(value, expected, "\(value) == \(expected)")
      }
    }
  }

  /// `1011 << 5 = 1_0110_0000` (assuming that our Word has 4 bits)
  func test_left_smi_exampleFromCode() {
    let word = Word(bitPattern: 1 << (Word.bitWidth - 1) | 0b0011)
    var value = BigIntHeap(isNegative: false, words: word)

    let shiftCount = Smi.Storage(Word.bitWidth + 1)
    value.shiftLeft(count: shiftCount)

    let expected = BigIntHeap(isNegative: false, words: 0b0000, 0b0110, 0b0001)
    XCTAssertEqual(value, expected)
  }

  func test_left_smi_butActuallyRight() {
    let wordShift = 1
    let bitShift = wordShift * Word.bitWidth

    for p in generateHeapValues(countButNotReally: 50) {
      // We just want to test if we call 'shiftRight',
      // we do not care about edge cases.
      guard p.words.count > wordShift else {
        continue
      }

      // Set lowest word to '0' to avoid floor rounding case:
      // -5 / 2 = -3 not -2
      var words = p.words
      words[0] = 0

      var value = BigIntHeap(isNegative: p.isNegative, words: words)
      value.shiftLeft(count: -Smi.Storage(bitShift))

      let expectedWords = Array(words.dropFirst(wordShift))
      let expectedIsNegative = !expectedWords.isEmpty && p.isNegative
      let expected = BigIntHeap(isNegative: expectedIsNegative,
                                words: expectedWords)

      XCTAssertEqual(value, expected, "\(value) >> \(bitShift)")
    }
  }

  // MARK: - Left - heap

  func test_left_heap_byZero() {
    var value = BigIntHeap(isNegative: false, words: 0b01)
    let expected = BigIntHeap(isNegative: false, words: 0b01)

    value.shiftLeft(count: BigIntHeap(0))
    XCTAssertEqual(value, expected, "\(value) == \(expected)")
  }

  func test_left_heap_byBits() {
    var value = BigIntHeap(isNegative: false, words: 0b01)
    let expected = BigIntHeap(isNegative: false, words: 0b10)

    value.shiftLeft(count: BigIntHeap(1))
    XCTAssertEqual(value, expected, "\(value) == \(expected)")
  }

  func test_left_heap_butActuallyRight() {
    var value = BigIntHeap(isNegative: false, words: 0b11)
    let expected = BigIntHeap(isNegative: false, words: 0b01)

    value.shiftLeft(count: BigIntHeap(-1))
    XCTAssertEqual(value, expected, "\(value) == \(expected)")
  }

  // MARK: - Right - smi

  func test_right_smi_byZero() {
    for p in generateHeapValues(countButNotReally: 100) {
      var value = p.create()
      value.shiftRight(count: Smi.Storage(0))

      let expected = p.create()
      XCTAssertEqual(value, expected)
    }
  }

  func test_right_smi_byMoreThanBitWidth() {
    let zero = BigIntHeap()
    let minus1 = BigIntHeap(-1)

    for p in generateHeapValues(countButNotReally: 35) {
      var value = p.create()

      let moreThanBitWidth = value.bitWidth + 3 * Word.bitWidth
      value.shiftRight(count: Smi.Storage(moreThanBitWidth))

      if p.isPositive {
        XCTAssertEqual(value, zero, "\(p)")
      } else {
        XCTAssertEqual(value, minus1, "\(p)")
      }
    }
  }

  func test_right_smi_byWholeWord_positive() {
    let isNegative = false

    for p in generateHeapValues(countButNotReally: 50) {
      // No point in shifting '0'
      if p.isZero {
        continue
      }

      for wordShift in 1..<p.words.count {
        var value = BigIntHeap(isNegative: isNegative, words: p.words)

        let expectedWords = Array(p.words.dropFirst(wordShift))
        let expected = BigIntHeap(isNegative: isNegative, words: expectedWords)

        let bitShift = wordShift * Word.bitWidth
        value.shiftRight(count: Smi.Storage(bitShift))
        XCTAssertEqual(value, expected, "\(p), shift: \(wordShift)")
      }
    }
  }

  func test_right_smi_byWholeWord_negative_withoutAdjustment() {
    let isNegative = true

    for p in generateHeapValues(countButNotReally: 50) {
      // No point in shifting '0'
      if p.isZero {
        continue
      }

      for wordShift in 1..<p.words.count {
        // Set lowest words to '0' to avoid floor rounding case:
        // -5 / 2 = -3 not -2
        var words = p.words
        for i in 0..<wordShift {
          words[i] = 0
        }

        var value = BigIntHeap(isNegative: isNegative, words: words)

        let expectedWords = Array(p.words.dropFirst(wordShift))
        let expectedIsNegative = !expectedWords.isEmpty
        let expected = BigIntHeap(isNegative: expectedIsNegative, words: expectedWords)

        let bitShift = wordShift * Word.bitWidth
        value.shiftRight(count: Smi.Storage(bitShift))
        XCTAssertEqual(value, expected, "\(p), shift: \(wordShift)")
      }
    }
  }

  func test_right_smi_byWholeWord_negative_withAdjustment() {
    let isNegative = true

    for p in generateHeapValues(countButNotReally: 50) {
      // No point in shifting '0'
      if p.isZero {
        continue
      }

      for wordShift in 1..<p.words.count {
        // Setting the lowest word to non-zero value will force adjustment.
        // -5 / 2 = -3 not -2
        var words = p.words
        words[0] = max(words[0], 1)

        var value = BigIntHeap(isNegative: isNegative, words: words)

        // We need to drop words and then apply adjustment to increase magnitude
        var expectedWords = Array(p.words.dropFirst(wordShift))
        if !expectedWords.isEmpty {
          let (increasedMagnitude, overflow) = expectedWords[0].addingReportingOverflow(1)
          if overflow {
            continue
          }
          expectedWords[0] = increasedMagnitude
        }

        let expectedIsNegative = !expectedWords.isEmpty
        let expected = BigIntHeap(isNegative: expectedIsNegative, words: expectedWords)

        let bitShift = wordShift * Word.bitWidth
        value.shiftRight(count: Smi.Storage(bitShift))
        XCTAssertEqual(value, expected, "\(p), shift: \(wordShift)")
      }
    }
  }

  func test_right_smi_byBits() {
    for p in generateHeapValues(countButNotReally: 50, maxWordCount: 1) {
      // There is a different test for this
      if p.isZero {
        continue
      }

      assert(p.words.count == 1)
      let word = p.words[0]

      // Check if we can do this calculation on 'Int' (also exclude '.min')
      guard word <= Int.max else {
        continue
      }

      for bitShift in 1...3 {
        var value = p.create()
        value.shiftRight(count: Smi.Storage(bitShift))

        // Our plan:
        // 1. Convert 'p' to 'Int'
        // 2. Shift this 'Int'
        // 3. Compare with our result
        let valueAsInt = p.isNegative ? -Int(word) : Int(word)
        let expectedValue = valueAsInt >> bitShift
        let expected = BigIntHeap(expectedValue)

        XCTAssertEqual(value, expected, "for \(p) >> \(bitShift)")
      }
    }
  }

  /// `1011_0000_0000 >> 5 = 0101_1000` (assuming that our Word has 4 bits):
  func test_right_smi_exampleFromCode() {
    var value = BigIntHeap(isNegative: false, words: 0b0000, 0b0000, 0b1011)

    let shiftCount = Smi.Storage(Word.bitWidth + 1)
    value.shiftRight(count: shiftCount)

    XCTAssertFalse(value.isNegative)

    XCTAssertEqual(value.storage.count, 2)
    guard value.storage.count == 2 else { return } // Prevent 'out of range' trap

    let lowWord = value.storage[0]
    let expectedLowWord = Word(1) << (Word.bitWidth - 1)
    XCTAssertEqual(lowWord, expectedLowWord)

    let highWord = value.storage[1]
    XCTAssertEqual(highWord, 0b0101)
  }

  func test_right_smi_butActuallyLeft() {
    let bitShift = Word.bitWidth

    for p in generateHeapValues(countButNotReally: 50) {
      // We just want to test if we call 'shiftLeft',
      // we do not care about edge cases.

      if p.isZero {
        continue
      }

      var value = BigIntHeap(isNegative: p.isNegative, words: p.words)
      value.shiftRight(count: -Smi.Storage(bitShift))

      let expected = BigIntHeap(isNegative: p.isNegative,
                                words: [0] + p.words)

      XCTAssertEqual(value, expected, "\(value) >> \(bitShift)")
    }
  }

  // MARK: - Right - heap

  func test_right_heap_byZero() {
    var value = BigIntHeap(isNegative: false, words: 0b01)
    let expected = BigIntHeap(isNegative: false, words: 0b01)

    value.shiftRight(count: BigIntHeap(0))
    XCTAssertEqual(value, expected, "\(value) == \(expected)")
  }

  func test_right_heap_byBits() {
    var value = BigIntHeap(isNegative: false, words: 0b10)
    let expected = BigIntHeap(isNegative: false, words: 0b01)

    value.shiftRight(count: BigIntHeap(1))
    XCTAssertEqual(value, expected, "\(value) == \(expected)")
  }

  func test_right_heap_butActuallyRight() {
    var value = BigIntHeap(isNegative: false, words: 0b01)
    let expected = BigIntHeap(isNegative: false, words: 0b10)

    value.shiftRight(count: BigIntHeap(-1))
    XCTAssertEqual(value, expected, "\(value) == \(expected)")
  }
}
