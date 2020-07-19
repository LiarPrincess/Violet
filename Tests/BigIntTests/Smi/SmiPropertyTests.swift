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

  // MARK: - Words

  func test_words() {
    for storage in generateSmiValues(countButNotReally: 100) {
      let smi = Smi(storage)
      let result = Array(smi.words)
      let expected = Array(storage.words)
      XCTAssertEqual(result, expected, "\(storage)")
    }
  }

  // MARK: - Bit width

  func test_bitWidth_trivial() {
    let zero = Smi(Smi.Storage(0))
    XCTAssertEqual(zero.bitWidth, 1) //  0 is just 0

    let plus1 = Smi(Smi.Storage(1))
    XCTAssertEqual(plus1.bitWidth, 2) // 1 needs '0' prefix -> '01'

    let minus1 = Smi(Smi.Storage(-1))
    XCTAssertEqual(minus1.bitWidth, 1) // -1 is just 1
  }

  func test_bitWidth_positivePowersOf2() {
    for (int, power, expected) in BitWidthTestCases.positivePowersOf2 {
      guard let smi = Smi(int) else {
        continue
      }

      XCTAssertEqual(smi.bitWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_bitWidth_negativePowersOf2() {
    for (int, power, expected) in BitWidthTestCases.negativePowersOf2 {
      guard let smi = Smi(int) else {
        continue
      }

      XCTAssertEqual(smi.bitWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_bitWidth_smiTestCases() {
    for (value, expected) in BitWidthTestCases.smi {
      let smi = Smi(value)
      XCTAssertEqual(smi.bitWidth, expected, "\(value)")
    }
  }

  // MARK: - Min required width

  func test_minRequiredWidth_trivial() {
    let zero = Smi(all0)
    XCTAssertEqual(zero.minRequiredWidth, 0)

    let minus1 = Smi(all1)
    XCTAssertEqual(minus1.minRequiredWidth, 1) // -1 requires 1 bit
  }

  func test_minRequiredWidth_positivePowersOf2() {
    for (int, power, expected) in MinRequiredWidthTestCases.positivePowersOf2 {
      guard let smi = Smi(int) else {
        continue
      }

      XCTAssertEqual(smi.minRequiredWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_minRequiredWidth_negativePowersOf2() {
    for (int, power, expected) in MinRequiredWidthTestCases.negativePowersOf2 {
      guard let smi = Smi(int) else {
        continue
      }

      XCTAssertEqual(smi.minRequiredWidth, expected, "for \(int) (2^\(power))")
    }
  }

  func test_minRequiredWidth_smiTestCases() {
    for (value, expected) in MinRequiredWidthTestCases.smi {
      let smi = Smi(value)
      XCTAssertEqual(smi.minRequiredWidth, expected, "\(value)")
    }
  }
}
