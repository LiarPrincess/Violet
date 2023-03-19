import XCTest
@testable import BigInt

// swiftlint:disable type_name
// swiftlint:disable function_body_length
// swiftlint:disable file_length

private typealias Word = BigIntHeap.Word

// MARK: - Test case

/// `(x + a) + b = x + c`
private struct TestCase {

  fileprivate typealias Operation = (BigInt, BigInt) -> BigInt

  fileprivate let a: BigInt
  fileprivate let b: BigInt
  fileprivate let c: BigInt

  fileprivate init<A: BinaryInteger, B: BinaryInteger>(_ op: Operation, a: A, b: B) {
    self.a = BigInt(a)
    self.b = BigInt(b)
    self.c = op(self.a, self.b)
  }

  fileprivate init?(
    _ op: Operation,
    a: String,
    b: String,
    file: StaticString,
    line: UInt
  ) {
    guard let aBig = BigInt(a) else {
      XCTFail("Unable to parse: '\(a)'.", file: file, line: line)
      return nil
    }

    guard let bBig = BigInt(b) else {
      XCTFail("Unable to parse: '\(b)'.", file: file, line: line)
      return nil
    }

    self.a = aBig
    self.b = bBig
    self.c = op(aBig, bBig)
  }
}

// swiftlint:disable:next discouraged_optional_collection function_default_parameter_at_end
private func createTestCases(_ op: TestCase.Operation,
                             useBigNumbers: Bool = true,
                             file: StaticString,
                             line: UInt) -> [TestCase]? {
  var strings = [
    "0",
    "1", "-1",
    "2147483647", "-2147483647",
    "429496735", "-429496735",
    "214748371", "-214748371",
    "18446744073709551615", "-18446744073709551615"
  ]

  if useBigNumbers {
    strings.append(contentsOf: [
      "340282366920938463481821351505477763074",
      "-340282366920938463481821351505477763074",
      "6277101735386680764516354157049543343010657915253861384197",
      "-6277101735386680764516354157049543343010657915253861384197"
    ])
  }

  var result = [TestCase]()
  for (a, b) in allPossiblePairings(lhs: strings, rhs: strings) {
    if let testCase = TestCase(op, a: a, b: b, file: file, line: line) {
      result.append(testCase)
    } else {
      return nil
    }
  }

  return result
}

// MARK: - Test class

/// Operation that applied 2 times can also be expressed as a single application.
/// For example: `∀x, (x+a)+b = x+(a+b)`.
///
/// This is not exactly associativity, because we will also do this for shifts:
/// `(x >> a) >> b = x >> (a + b)`.
class ApplyA_ApplyB_Equals_ApplyAB: XCTestCase {

  private lazy var smiValues = generateSmiValues(countButNotReally: 20)
  private lazy var heapValues = generateHeapValues(countButNotReally: 20)

  // MARK: - Add

  func test_add_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.addTest(value: int)
    }
  }

  func test_add_heap() {
    for smi in self.heapValues {
      let int = self.create(smi)
      self.addTest(value: int)
    }
  }

  private func addTest(value: BigInt,
                       file: StaticString = #file,
                       line: UInt = #line) {
    guard let testCases = createTestCases(+, file: file, line: line) else {
      return
    }

    for testCase in testCases {
      let a_b = value + testCase.a + testCase.b
      let ab = value + testCase.c

      XCTAssertEqual(
        a_b,
        ab,
        "\(value) + \(testCase.a) + \(testCase.b) vs \(value) + \(testCase.c)",
        file: file,
        line: line
      )

      var inoutA_B = value
      inoutA_B += testCase.a
      inoutA_B += testCase.b

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) += \(testCase.a) += \(testCase.b) vs \(value) + \(testCase.c)",
        file: file,
        line: line
      )

      var inoutAB = value
      inoutAB += testCase.c

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) += \(testCase.c) vs \(value) + \(testCase.c)",
        file: file,
        line: line
      )
    }
  }

  // MARK: - Sub

  func test_sub_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.subTest(value: int)
    }
  }

  func test_sub_heap() {
    for smi in self.heapValues {
      let int = self.create(smi)
      self.subTest(value: int)
    }
  }

  private func subTest(value: BigInt,
                       file: StaticString = #file,
                       line: UInt = #line) {
    // '+' because: (x-a)-b = x-(a+b)
    guard let testCases = createTestCases(+, file: file, line: line) else {
      return
    }

    for testCase in testCases {
      let a_b = value - testCase.a - testCase.b
      let ab = value - testCase.c

      XCTAssertEqual(
        a_b,
        ab,
        "\(value) - \(testCase.a) - \(testCase.b) vs \(value) - \(testCase.c)",
        file: file,
        line: line
      )

      var inoutA_B = value
      inoutA_B -= testCase.a
      inoutA_B -= testCase.b

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) -= \(testCase.a) -= \(testCase.b) vs \(value) - \(testCase.c)",
        file: file,
        line: line
      )

      var inoutAB = value
      inoutAB -= testCase.c

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) -= \(testCase.c) vs \(value) - \(testCase.c)",
        file: file,
        line: line
      )
    }
  }

  // MARK: - Mul

  func test_mul_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.mulTest(value: int)
    }
  }

  func test_mul_heap() {
    for p in self.heapValues {
      let int = self.create(p)
      self.mulTest(value: int)
    }
  }

  private func mulTest(value: BigInt,
                       file: StaticString = #file,
                       line: UInt = #line) {
    guard let testCases = createTestCases(*,
                                          useBigNumbers: false,
                                          file: file,
                                          line: line) else {
      return
    }

    for testCase in testCases {
      let a_b = value * testCase.a * testCase.b
      let ab = value * testCase.c

      XCTAssertEqual(
        a_b,
        ab,
        "\(value) * \(testCase.a) * \(testCase.b) vs \(value) * \(testCase.c)",
        file: file,
        line: line
      )

      var inoutA_B = value
      inoutA_B *= testCase.a
      inoutA_B *= testCase.b

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) *= \(testCase.a) *= \(testCase.b) vs \(value) * \(testCase.c)",
        file: file,
        line: line
      )

      var inoutAB = value
      inoutAB *= testCase.c

      XCTAssertEqual(
        inoutAB,
        ab,
        "\(value) *= \(testCase.c) vs \(value) * \(testCase.c)",
        file: file,
        line: line
      )
    }
  }

  // MARK: - Div

  func test_div_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.divTest(value: int)
    }
  }

  func test_div_heap() {
    for p in self.heapValues {
      let int = self.create(p)
      self.divTest(value: int)
    }
  }

  private let divTestCases = [
    TestCase(*, a: 3, b: 5),
    TestCase(*, a: 3, b: -5),
    TestCase(*, a: -3, b: 5),
    TestCase(*, a: -3, b: -5)
  ]

  private func divTest(value: BigInt,
                       file: StaticString = #file,
                       line: UInt = #line) {
    for testCase in self.divTestCases {
      let a_b = value / testCase.a / testCase.b
      let ab = value / testCase.c

      XCTAssertEqual(
        a_b,
        ab,
        "\(value) / \(testCase.a) / \(testCase.b) vs \(value) / \(testCase.c)",
        file: file,
        line: line
      )

      var inoutA_B = value
      inoutA_B /= testCase.a
      inoutA_B /= testCase.b

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) /= \(testCase.a) /= \(testCase.b) vs \(value) / \(testCase.c)",
        file: file,
        line: line
      )

      var inoutAB = value
      inoutAB /= testCase.c

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) /= \(testCase.c) vs \(value) / \(testCase.c)",
        file: file,
        line: line
      )
    }
  }

  // MARK: - Left shift

  func test_shiftLeft_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftLeftTest(value: int)
    }
  }

  func test_shiftLeft_heap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftLeftTest(value: int)
    }
  }

  // '+' because: (x << 3) << 5 = x << (3+5)
  private let shiftLeftTestCases: [TestCase] = [
    // Shift by 0 is important to test!
    TestCase(+, a: 1, b: 0),
    TestCase(+, a: 1, b: 1),
    TestCase(+, a: 3, b: 5),
    // More than Word
    TestCase(+, a: 7, b: Word.bitWidth - 5),
    TestCase(+, a: Word.bitWidth - 5, b: 7)
  ]

  private func shiftLeftTest(value: BigInt,
                             file: StaticString = #file,
                             line: UInt = #line) {
    for testCase in self.shiftLeftTestCases {
      let a_b = (value << testCase.a) << testCase.b
      let ab = value << testCase.c

      XCTAssertEqual(
        a_b,
        ab,
        "(\(value) << \(testCase.a)) << \(testCase.b) vs \(value) << \(testCase.c)",
        file: file,
        line: line
      )

      var inoutA_B = value
      inoutA_B <<= testCase.a
      inoutA_B <<= testCase.b

      XCTAssertEqual(
        inoutA_B,
        ab,
        "(\(value) <<= \(testCase.a)) <<= \(testCase.b) vs \(value) << \(testCase.c)",
        file: file,
        line: line
      )

      var inoutAB = value
      inoutAB <<= testCase.c

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) <<= \(testCase.c) vs \(value) << \(testCase.c)",
        file: file,
        line: line
      )
    }
  }

  // MARK: - Right shift

  func test_shiftRight_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftRightTest(value: int)
    }
  }

  func test_shiftRight_heap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftRightTest(value: int)
    }
  }

  // '+' because: (x >> 3) >> 5 = x >> (3+5)
  //
  // Right shift for more than 'Word.bitWidth' has a high probability
  // of shifting value into oblivion (0 or -1).
  private let shiftRightTestCases: [TestCase] = [
    // Shift by 0 is important to test!
    TestCase(+, a: 1, b: 0),
    TestCase(+, a: 1, b: 1),
    TestCase(+, a: 3, b: 5),
    // More than Word
    TestCase(+, a: 7, b: Word.bitWidth - 5),
    TestCase(+, a: Word.bitWidth - 5, b: 7)
  ]

  private func shiftRightTest(value: BigInt,
                              file: StaticString = #file,
                              line: UInt = #line) {
    for testCase in self.shiftRightTestCases {
      let a_b = (value >> testCase.a) >> testCase.b
      let ab = value >> testCase.c

      XCTAssertEqual(
        a_b,
        ab,
        "(\(value) >> \(testCase.a)) >> \(testCase.b) vs \(value) >> \(testCase.c)",
        file: file,
        line: line
      )

      var inoutA_B = value
      inoutA_B >>= testCase.a
      inoutA_B >>= testCase.b

      XCTAssertEqual(
        inoutA_B,
        ab,
        "(\(value) >>= \(testCase.a)) >>= \(testCase.b) vs \(value) >> \(testCase.c)",
        file: file,
        line: line
      )

      var inoutAB = value
      inoutAB >>= testCase.c

      XCTAssertEqual(
        inoutA_B,
        ab,
        "\(value) >>= \(testCase.c) vs \(value) >> \(testCase.c)",
        file: file,
        line: line
      )
    }
  }

  // MARK: - Helpers

  private func create(_ smi: Smi.Storage) -> BigInt {
    return BigInt(smi: smi)
  }

  private func create(_ p: HeapPrototype) -> BigInt {
    let heap = p.create()
    return BigInt(heap)
  }
}
