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

class SmiShiftTests: XCTestCase {

  // MARK: - Left

  func test_left_byZero() {
    self.shiftLeftExpectingSmi(0, shift: 0)

    self.shiftLeftExpectingSmi(1, shift: 0)
    self.shiftLeftExpectingSmi(max, shift: 0)
    self.shiftLeftExpectingSmi(maxHalf, shift: 0)

    self.shiftLeftExpectingSmi(-1, shift: 0)
    self.shiftLeftExpectingSmi(min, shift: 0)
    self.shiftLeftExpectingSmi(minHalf, shift: 0)
  }

  func test_left_withoutOverflow() {
    func isSmi(value: Storage, shift: Int) -> Bool {
      let shifted = Int(value) << shift
      return Smi(shifted) != nil
    }

    let shiftValues = 0..<(Storage.bitWidth / 2)

    for shift in shiftValues {
      self.shiftLeftExpectingSmi(0, shift: shift)
    }

    for (_, value) in allPositivePowersOf2(type: Storage.self) {
      for shift in shiftValues {
        guard isSmi(value: value, shift: shift) else {
          continue
        }

        self.shiftLeftExpectingSmi(value, shift: shift)
      }
    }

    for (_, value) in allNegativePowersOf2(type: Storage.self) {
      for shift in shiftValues {
        guard isSmi(value: value, shift: shift) else {
          continue
        }

        self.shiftLeftExpectingSmi(value, shift: shift)
      }
    }
  }

  func test_left_negativeCount() {
    self.shiftLeftExpectingSmi(0, shift: -1)
    self.shiftLeftExpectingSmi(1, shift: -1)
    self.shiftLeftExpectingSmi(-1, shift: -1)
  }

  private func shiftLeftExpectingSmi<T: BinaryInteger>(_ _lhs: Storage,
                                                       shift: T,
                                                       file: StaticString = #file,
                                                       line: UInt = #line) {
    let lhs = Smi(_lhs)
    let expected = Int(_lhs) << shift
    let msg = "\(lhs) << \(shift)"

    let thingie = lhs.shiftLeft(count: shift)
    XCTAssert(thingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(thingie, BigInt(expected), msg, file: file, line: line)
  }

  // MARK: - Right

  func test_right_byZero() {
    self.shiftRight(0, shift: 0)

    self.shiftRight(1, shift: 0)
    self.shiftRight(max, shift: 0)
    self.shiftRight(maxHalf, shift: 0)

    self.shiftRight(-1, shift: 0)
    self.shiftRight(min, shift: 0)
    self.shiftRight(minHalf, shift: 0)
  }

  func test_right() {
    let shiftValues = 0..<(Storage.bitWidth / 2)

    for shift in shiftValues {
      self.shiftRight(0, shift: shift)
    }

    for (_, value) in allPositivePowersOf2(type: Storage.self) {
      for shift in shiftValues {
        self.shiftRight(value, shift: shift)
      }
    }

    for (_, value) in allNegativePowersOf2(type: Storage.self) {
      for shift in shiftValues {
        self.shiftRight(value, shift: shift)
      }
    }
  }

  func test_right_negativeCount() {
    self.shiftRight(0, shift: -1)
    self.shiftRight(1, shift: -1)
    self.shiftRight(-1, shift: -1)
  }

  private func shiftRight<T: BinaryInteger>(_ _lhs: Storage,
                                            shift: T,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
    let lhs = Smi(_lhs)
    let expected = Int(_lhs) >> shift
    let msg = "\(lhs) >> \(shift)"

    let thingie = lhs.shiftRight(count: shift)
    XCTAssert(thingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(thingie, BigInt(expected), msg, file: file, line: line)
  }
}
