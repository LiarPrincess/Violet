import XCTest
@testable import BigInt

private typealias Storage = Smi.Storage

private let all0 = Storage(0)
private let all1 = Storage(~0)

private let max = Storage.max
private let maxHalf = max / 2
private let maxMinus1 = max - 1

private let min = Storage.min
private let minHalf = min / 2
private let minPlus1 = min + 1

class SmiPropertyTests: XCTestCase {

  // MARK: - Is zero

  func test_isZero() {
    self.zero(0, isZero: true)

    self.zero(-1, isZero: false)
    self.zero(1, isZero: false)

    self.zero(max, isZero: false)
    self.zero(maxHalf, isZero: false)
    self.zero(maxMinus1, isZero: false)

    self.zero(min, isZero: false)
    self.zero(minHalf, isZero: false)
    self.zero(minPlus1, isZero: false)
  }

  private func zero(_ value: Int32,
                    isZero: Bool,
                    file: StaticString = #file,
                    line: UInt = #line) {
    let smi = Smi(value)
    XCTAssertEqual(smi.isZero, isZero, file: file, line: line)
  }

  // MARK: - Is negative

  func test_isPositive_isNegative() {
    self.positiveNegative(0, isPositive: true)

    self.positiveNegative(1, isPositive: true)
    self.positiveNegative(max, isPositive: true)
    self.positiveNegative(maxHalf, isPositive: true)
    self.positiveNegative(maxMinus1, isPositive: true)

    self.positiveNegative(-1, isPositive: false)
    self.positiveNegative(min, isPositive: false)
    self.positiveNegative(minHalf, isPositive: false)
    self.positiveNegative(minPlus1, isPositive: false)
  }

  private func positiveNegative(_ value: Int32,
                                isPositive: Bool,
                                file: StaticString = #file,
                                line: UInt = #line) {
    let smi = Smi(value)
    let isNegative = !isPositive
    XCTAssertEqual(smi.isPositive, isPositive, "isPositive", file: file, line: line)
    XCTAssertEqual(smi.isNegative, isNegative, "isNegative", file: file, line: line)
  }

  // MARK: - Trailing zero bit count

  func test_trailingZeroBitCount() {
    self.trailingZeroBitCount(0, expected: 0) // <-- this!!!

    self.trailingZeroBitCount(1)
    self.trailingZeroBitCount(max)
    self.trailingZeroBitCount(maxHalf)
    self.trailingZeroBitCount(maxMinus1)

    self.trailingZeroBitCount(-1)
    self.trailingZeroBitCount(min)
    self.trailingZeroBitCount(minHalf)
    self.trailingZeroBitCount(minPlus1)

    for i in 0..<(Storage.bitWidth - 1) {
      let value = Storage(1 << i)
      self.trailingZeroBitCount(value, expected: i)
    }
  }

  private func trailingZeroBitCount(_ value: Int32,
                                    expected: Int? = nil,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
    let smi = Smi(value)
    let expected = expected ?? Storage(value).trailingZeroBitCount
    XCTAssertEqual(smi.trailingZeroBitCount, expected, file: file, line: line)
  }

  // MARK: - Magnitude

  func test_magnitude() {
    self.magnitude(0)

    self.magnitude(1)
    self.magnitude(max)
    self.magnitude(maxHalf)
    self.magnitude(maxMinus1)

    self.magnitude(-1)
    self.magnitude(min)
    self.magnitude(minHalf)
    self.magnitude(minPlus1)
  }

  private func magnitude(_ value: Int32,
                         file: StaticString = #file,
                         line: UInt = #line) {
    let smi = Smi(value)
    let expected = Int(value).magnitude
    XCTAssertEqual(smi.magnitude, BigInt(expected), file: file, line: line)
  }

  // MARK: - Min required width

  func test_minRequiredWidth_trivial() {
    self.minRequiredWidth(all0, expected: 0)
    self.minRequiredWidth(all1, expected: 1) // -1 requires 1 bit
  }

  func test_minRequiredWidth_allPositivePowersOf2() {
    for (power, value) in allPositivePowersOf2(type: Storage.self) {
      // >>> for i in range(1, 10):
      // ...     value = 1 << i
      // ...     print(i, value, value.bit_length())
      // ...
      // 1 2 2
      // 2 4 3
      // 3 8 4
      // 4 16 5
      let minRequiredWidth = power + 1
      self.minRequiredWidth(value, expected: minRequiredWidth)
    }
  }

  func test_minRequiredWidth_allNegativePowersOf2() {
    for (power, value) in allNegativePowersOf2(type: Storage.self) {
      // >>> for i in range(1, 10):
      // ...     value = 1 << i
      // ...     print(i, (-value).bit_length())
      //
      // 1 2
      // 2 3
      // 3 4
      // (etc)
      let minRequiredWidth = power + 1
      self.minRequiredWidth(value, expected: minRequiredWidth)
    }
  }

  func test_minRequiredWidth_predefined() {
    for (smi, expected) in MinRequiredWidthTestCases.smi {
      let int = BigInt(smi)
      let result = int.minRequiredWidth
      XCTAssertEqual(result, expected, "\(smi)")
    }
  }

  private func minRequiredWidth(_ value: Int32,
                                expected: Int,
                                file: StaticString = #file,
                                line: UInt = #line) {
    let smi = Smi(value)
    XCTAssertEqual(smi.minRequiredWidth, expected, file: file, line: line)
  }
}
