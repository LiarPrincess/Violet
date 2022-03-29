import XCTest
@testable import BigInt

private typealias Word = BigIntStorage.Word
private typealias WordsExpected = (words: [Word], expected: String)

private typealias BinaryTestCases = StringTestCases.Binary
private typealias QuinaryTestCases = StringTestCases.Quinary
private typealias OctalTestCases = StringTestCases.Octal
private typealias DecimalTestCases = StringTestCases.Decimal
private typealias HexTestCases = StringTestCases.Hex

class BigIntHeapStringTests: XCTestCase {

  // MARK: - Description

  func test_description_trivial() {
    XCTAssertEqual(String(describing: BigIntHeap(0)), "0")

    XCTAssertEqual(String(describing: BigIntHeap(1)), "1")
    XCTAssertEqual(String(describing: BigIntHeap(42)), "42")

    XCTAssertEqual(String(describing: BigIntHeap(-1)), "-1")
    XCTAssertEqual(String(describing: BigIntHeap(-42)), "-42")
  }

  func test_description_singleWord() {
    for (words, expected) in DecimalTestCases.singleWord {
      let positive = BigIntHeap(isNegative: false, words: words)
      let positiveDescription = String(describing: positive)
      XCTAssertEqual(positiveDescription, expected)

      let negative = BigIntHeap(isNegative: true, words: words)
      let negativeDescription = String(describing: negative)
      XCTAssertEqual(negativeDescription, "-" + expected)
    }
  }

  func test_description_singleWord_generated() {
    for int in generateIntValues(countButNotReally: 100) {
      let word = Word(bitPattern: int)
      let expected = String(describing: word)

      let positive = BigIntHeap(isNegative: false, words: word)
      let positiveDescription = String(describing: positive)
      XCTAssertEqual(positiveDescription, expected)

      if int != 0 {
        let negative = BigIntHeap(isNegative: true, words: word)
        let negativeDescription = String(describing: negative)
        XCTAssertEqual(negativeDescription, "-" + expected)
      }
    }
  }

  func test_description_twoWords() {
    for (words, expected) in DecimalTestCases.twoWords {
      let positive = BigIntHeap(isNegative: false, words: words)
      let positiveDescription = String(describing: positive)
      XCTAssertEqual(positiveDescription, expected)

      let negative = BigIntHeap(isNegative: true, words: words)
      let negativeDescription = String(describing: negative)
      XCTAssertEqual(negativeDescription, "-" + expected)
    }
  }

  func test_description_threeWords() {
    for (words, expected) in DecimalTestCases.threeWords {
      let positive = BigIntHeap(isNegative: false, words: words)
      let positiveDescription = String(describing: positive)
      XCTAssertEqual(positiveDescription, expected)

      let negative = BigIntHeap(isNegative: true, words: words)
      let negativeDescription = String(describing: negative)
      XCTAssertEqual(negativeDescription, "-" + expected)
    }
  }

  func test_description_fourWords() {
    for (words, expected) in DecimalTestCases.fourWords {
      let positive = BigIntHeap(isNegative: false, words: words)
      let positiveDescription = String(describing: positive)
      XCTAssertEqual(positiveDescription, expected)

      let negative = BigIntHeap(isNegative: true, words: words)
      let negativeDescription = String(describing: negative)
      XCTAssertEqual(negativeDescription, "-" + expected)
    }
  }

  // MARK: - Binary

  func test_binary_trivial() {
    self.binary(value: 0)

    self.binary(value: 1)
    self.binary(value: 42)

    self.binary(value: -1)
    self.binary(value: -42)
  }

  func test_binary_singleWord() {
    for (words, expected) in BinaryTestCases.singleWord {
      self.binary(isNegative: false, words: words, expected: expected)
      self.binary(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_binary_twoWords() {
    for (words, expected) in BinaryTestCases.twoWords {
      self.binary(isNegative: false, words: words, expected: expected)
      self.binary(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  // MARK: - Quinary

  func test_quinary_trivial() {
    self.quinary(value: 0)

    self.quinary(value: 1)
    self.quinary(value: 42)

    self.quinary(value: -1)
    self.quinary(value: -42)
  }

  func test_quinary_singleWord() {
    for (words, expected) in QuinaryTestCases.singleWord {
      self.quinary(isNegative: false, words: words, expected: expected)
      self.quinary(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_quinary_twoWords() {
    for (words, expected) in QuinaryTestCases.twoWords {
      self.quinary(isNegative: false, words: words, expected: expected)
      self.quinary(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  // MARK: - Octal

  func test_octal_trivial() {
    self.octal(value: 0)

    self.octal(value: 1)
    self.octal(value: 42)

    self.octal(value: -1)
    self.octal(value: -42)
  }

  func test_octal_singleWord() {
    for (words, expected) in OctalTestCases.singleWord {
      self.octal(isNegative: false, words: words, expected: expected)
      self.octal(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_octal_twoWords() {
    for (words, expected) in OctalTestCases.twoWords {
      self.octal(isNegative: false, words: words, expected: expected)
      self.octal(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_octal_threeWords() {
    for (words, expected) in OctalTestCases.threeWords {
      self.octal(isNegative: false, words: words, expected: expected)
      self.octal(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  // MARK: - Decimal

  func test_decimal_trivial() {
    self.decimal(value: 0)

    self.decimal(value: 1)
    self.decimal(value: 42)

    self.decimal(value: -1)
    self.decimal(value: -42)
  }

  func test_decimal_singleWord() {
    for (words, expected) in DecimalTestCases.singleWord {
      self.decimal(isNegative: false, words: words, expected: expected)
      self.decimal(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_decimal_twoWords() {
    for (words, expected) in DecimalTestCases.twoWords {
      self.decimal(isNegative: false, words: words, expected: expected)
      self.decimal(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_decimal_threeWords() {
    for (words, expected) in DecimalTestCases.threeWords {
      self.decimal(isNegative: false, words: words, expected: expected)
      self.decimal(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  // MARK: - Hex

  func test_hex_trivial() {
    self.hex(value: 0)

    self.hex(value: 1)
    self.hex(value: 42)

    self.hex(value: -1)
    self.hex(value: -42)
  }

  func test_hex_singleWord() {
    for (words, expected) in HexTestCases.singleWord {
      self.hex(isNegative: false, words: words, expected: expected)
      self.hex(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_hex_twoWords() {
    for (words, expected) in HexTestCases.twoWords {
      self.hex(isNegative: false, words: words, expected: expected)
      self.hex(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  func test_hex_threeWords() {
    for (words, expected) in HexTestCases.threeWords {
      self.hex(isNegative: false, words: words, expected: expected)
      self.hex(isNegative: true, words: words, expected: "-" + expected)
    }
  }

  // MARK: - Value helper

  private func binary(value: Int,
                      file: StaticString = #file,
                      line: UInt = #line) {
    self.valueTest(value: value,
                   radix: 2,
                   uppercase: false,
                   file: file,
                   line: line)
  }

  private func quinary(value: Int,
                       file: StaticString = #file,
                       line: UInt = #line) {
    self.valueTest(value: value,
                   radix: 5,
                   uppercase: false,
                   file: file,
                   line: line)
  }

  private func octal(value: Int,
                     file: StaticString = #file,
                     line: UInt = #line) {
    self.valueTest(value: value,
                   radix: 8,
                   uppercase: false,
                   file: file,
                   line: line)
  }

  private func decimal(value: Int,
                       file: StaticString = #file,
                       line: UInt = #line) {
    self.valueTest(value: value,
                   radix: 10,
                   uppercase: false,
                   file: file,
                   line: line)
  }

  private func hex(value: Int,
                   file: StaticString = #file,
                   line: UInt = #line) {
    self.valueTest(value: value,
                   radix: 16,
                   uppercase: false,
                   file: file,
                   line: line)
  }

  private func valueTest(value: Int,
                         radix: Int,
                         uppercase: Bool,
                         file: StaticString,
                         line: UInt) {
    let msg = "\(value), radix: \(radix), uppercase: \(uppercase)"

    let heap = BigIntHeap(value)
    let result = heap.toString(radix: radix, uppercase: uppercase)
    let expected = String(value, radix: radix, uppercase: uppercase)
    XCTAssertEqual(result, expected, msg, file: file, line: line)
  }

  // MARK: - Word helper

  private func binary(isNegative: Bool,
                      words: [Word],
                      expected: String,
                      file: StaticString = #file,
                      line: UInt = #line) {
    self.wordTest(isNegative: isNegative,
                  words: words,
                  radix: 2,
                  uppercase: false,
                  expected: expected,
                  file: file,
                  line: line)
  }

  private func quinary(isNegative: Bool,
                       words: [Word],
                       expected: String,
                       file: StaticString = #file,
                       line: UInt = #line) {
    self.wordTest(isNegative: isNegative,
                  words: words,
                  radix: 5,
                  uppercase: false,
                  expected: expected,
                  file: file,
                  line: line)
  }

  private func octal(isNegative: Bool,
                     words: [Word],
                     expected: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
    self.wordTest(isNegative: isNegative,
                  words: words,
                  radix: 8,
                  uppercase: false,
                  expected: expected,
                  file: file,
                  line: line)
  }

  private func decimal(isNegative: Bool,
                       words: [Word],
                       expected: String,
                       file: StaticString = #file,
                       line: UInt = #line) {
    self.wordTest(isNegative: isNegative,
                  words: words,
                  radix: 10,
                  uppercase: false,
                  expected: expected,
                  file: file,
                  line: line)
  }

  private func hex(isNegative: Bool,
                   words: [Word],
                   expected: String,
                   file: StaticString = #file,
                   line: UInt = #line) {
    self.wordTest(isNegative: isNegative,
                  words: words,
                  radix: 16,
                  uppercase: false,
                  expected: expected,
                  file: file,
                  line: line)
  }

  // swiftlint:disable:next function_parameter_count
  private func wordTest(isNegative: Bool,
                        words: [Word],
                        radix: Int,
                        uppercase: Bool,
                        expected: String,
                        file: StaticString,
                        line: UInt) {
    let msg = "isNegative: \(isNegative), words: \(words), radix: \(radix), uppercase: \(uppercase)"

    let heap = BigIntHeap(isNegative: isNegative, words: words)
    let result = heap.toString(radix: radix, uppercase: uppercase)
    XCTAssertEqual(result, expected, msg, file: file, line: line)
  }
}
