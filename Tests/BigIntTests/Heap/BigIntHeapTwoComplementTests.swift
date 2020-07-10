import XCTest
@testable import Core

private typealias Word = BigIntStorage.Word
private let mostSignificantBit1 = Word(1) << (Word.bitWidth - 1)

class BigIntHeapTwoComplementTests: XCTestCase {

  // MARK: - Init

  func test_initTwoComplement_zero() {
    var zero = BigIntStorage.zero
    let value = BigIntHeap(twoComplement: &zero)
    XCTAssertTrue(value == Smi.Storage.zero)
  }

  func test_initTwoComplement_positive_singleWord() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // We have separate test for '0'
      if smi.isZero {
        continue
      }

      let word = Word(smi.magnitude)

      // '1' as most significant bit means negative number (we need prefix word).
      // We will have separate test case for this.
      let hasMostSignificantBit1 = word & mostSignificantBit1 > 0
      if hasMostSignificantBit1 {
        continue
      }

      var param = BigIntStorage(isNegative: false, words: word)
      let value = BigIntHeap(twoComplement: &param)

      let expected = BigIntHeap(isNegative: false, words: word)
      XCTAssertEqual(value, expected)
    }
  }

  func test_initTwoComplement_positive_zeroPrefix() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // Set highest bit to '1' and add '0' prefix
      var word = Word(smi.magnitude)
      word |= mostSignificantBit1

      var param = BigIntStorage(isNegative: false, words: word, 0)
      let value = BigIntHeap(twoComplement: &param)

      let expected = BigIntHeap(isNegative: false, words: word)
      XCTAssertEqual(value, expected)
    }
  }

  func test_initTwoComplement_negative_singleWord() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // We have separate test for '0'
      if smi.isZero {
        continue
      }

      // Find a 2 complement of 'smi' in a 'Word' size
      let smiComplement = smi.isNegative ? Int(smi) : -Int(smi)
      let smiComplementBits = Word(bitPattern: smiComplement)

      let word = smiComplementBits

      // '0' as most significant bit means positive number (we need prefix word).
      // We will have separate test case for this.
      let hasMostSignificantBit0 = word & mostSignificantBit1 == 0
      if hasMostSignificantBit0 {
        continue
      }

      var param = BigIntStorage(isNegative: true, words: word)
      let value = BigIntHeap(twoComplement: &param)

      let expectedWord = Word(smi.magnitude)
      let expected = BigIntHeap(isNegative: true, words: expectedWord)
      XCTAssertEqual(value, expected)
    }
  }

  func test_initTwoComplement_negative_onePrefix() {
    for smi in generateSmiValues(countButNotReally: 100) {
      // Find a 2 complement of 'smi' in a 'Word' size
      let smiComplement = smi.isNegative ? Int(smi) : -Int(smi)
      let smiComplementBits = Word(bitPattern: smiComplement)

      // Set highest bit to '0'
      // Note that this changes the number we are testing!
      let zeroInFront = smiComplementBits & (~mostSignificantBit1)

      // We can't fit 2 complement of '0' in 'Word'
      let word = zeroInFront
      if word.isZero {
        continue
      }

      var param = BigIntStorage(isNegative: true, words: word, .max)
      let value = BigIntHeap(twoComplement: &param)

      let expectedWord = (~word) + 1
      let expected = BigIntHeap(isNegative: true, words: expectedWord)
      XCTAssertEqual(value, expected)
    }
  }

  // MARK: - As two complement

  func test_asTwoComplement_zero() {
    let value = BigIntHeap()
    let complement = value.asTwoComplement()
    XCTAssertTrue(complement.isEmpty)
  }

  func test_asTwoComplement_positive_singleWord() {
    for p in generateHeapValues(countButNotReally: 100, maxWordCount: 1) {
      // We have special test for '0'
      // We only want to test positive numbers
      if p.isZero || p.isNegative {
        continue
      }

      assert(p.words.count == 1)
      let word = p.words[0]

      // '1' as most significant bit means negative number
      // (we have separate test for this)
      let hasMostSignificantBit1 = word & mostSignificantBit1 > 0
      if hasMostSignificantBit1 {
        continue
      }

      assert(p.isPositive && p.words.count == 1)
      let value = p.create()
      let complement = value.asTwoComplement()

      let expected = BigIntHeap(isNegative: false, words: word)
      XCTAssertEqual(complement, expected.storage, "\(p)")
    }
  }

  func test_asTwoComplement_positive_needsZeroPrefix() {
    for wordCount in 1...3 {
      var words = [Word](repeating: 0, count: wordCount)
      words[wordCount - 1] = mostSignificantBit1

      let value = BigIntHeap(isNegative: false, words: words)
      let complement = value.asTwoComplement()

      let expectedWords = words + [0]
      let expected = BigIntStorage(isNegative: false, words: expectedWords)
      XCTAssertEqual(complement, expected, "\(complement) vs \(expected)")
    }
  }

  func test_asTwoComplement_negative_compareWithInt() {
    for p in generateHeapValues(countButNotReally: 100, maxWordCount: 1) {
      // We have special test for '0'
      // We only want to test negative numbers
      if p.isZero || p.isPositive {
        continue
      }

      assert(p.words.count == 1)
      let word = p.words[0]

      guard let int = Int(exactly: word) else {
        continue
      }

      let value = BigIntHeap(isNegative: true, words: word)
      let complement = value.asTwoComplement()

      let intComplement = -int
      let expectedWord = Word(bitPattern: intComplement)
      let expected = BigIntHeap(isNegative: true, words: expectedWord)

      XCTAssertEqual(complement, expected.storage, "\(p)")
    }
  }

  /// Example for 4-bit word:
  /// Initial: `1000 0000 0001`
  /// Negated: `0111 1111 1110`
  /// Added 1: `0111 1111 1111`
  /// At this point we need `1` prefix to get to: `1111 0111 1111 1111`
  func test_asTwoComplement_negative_needsOnePrefix() {
    for wordCount in 1...3 {
      var words = [Word](repeating: .zero, count: wordCount)
      words[0] |= 1
      words[wordCount - 1] |= mostSignificantBit1

      let value = BigIntHeap(isNegative: true, words: words)
      let complement = value.asTwoComplement()

      // 1111 1111 1111
      var expectedWords = [Word](repeating: .max, count: wordCount)
      // 0111 1111 1111
      expectedWords[wordCount - 1] = ~mostSignificantBit1
      // 1111 0111 1111 1111
      expectedWords.append(.max)

      let expected = BigIntHeap(isNegative: true, words: expectedWords)
      XCTAssertEqual(complement, expected.storage, "\(wordCount)")
    }
  }

  // MARK: - Complement and back

  func test_asTwoComplement_andBack() {
    for p in generateHeapValues(countButNotReally: 100) {
      let value = p.create()
      var complement = value.asTwoComplement()
      let reverse = BigIntHeap(twoComplement: &complement)
      XCTAssertEqual(value, reverse)
    }
  }
}
