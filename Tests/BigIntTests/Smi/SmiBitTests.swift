import XCTest
@testable import BigInt

private typealias Storage = Smi.Storage

private let all0 = Storage(0)
private let all1 = Storage(~0)

// `01010101…`
private let alternating01: Storage = {
  let shiftCount = Storage.bitWidth / 2

  var result = Storage.zero
  for i in 0..<shiftCount {
    let shift = 2 * i
    let value = Storage(01) << shift // '01', also known as '1'
    result |= value
  }

  return result
}()

// `10101010…`
private let alternating10 = ~alternating01

class SmiBtTests: XCTestCase {

  private let valuePairs = allPossiblePairings(
    values: [all0, all1, alternating01, alternating10]
  )

  // MARK: - And

  func test_and() {
    for (lhs, rhs) in self.valuePairs {
      self.and(lhs, rhs)
    }
  }

  private func and(_ _lhs: Storage,
                   _ _rhs: Storage,
                   file: StaticString = #file,
                   line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) & Int(_rhs))
    let msg = "\(lhs) & \(rhs)"

    let lThingie = lhs.and(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.and(other: lhs)
    XCTAssert(rThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }

  // MARK: - Or

  func test_or() {
    for (lhs, rhs) in self.valuePairs {
      self.or(lhs, rhs)
    }
  }

  private func or(_ _lhs: Storage,
                  _ _rhs: Storage,
                  file: StaticString = #file,
                  line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) | Int(_rhs))
    let msg = "\(lhs) | \(rhs)"

    let lThingie = lhs.or(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.or(other: lhs)
    XCTAssert(rThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }

  // MARK: - Xor

  func test_xor() {
    for (lhs, rhs) in self.valuePairs {
      self.xor(lhs, rhs)
    }
  }

  private func xor(_ _lhs: Storage,
                   _ _rhs: Storage,
                   file: StaticString = #file,
                   line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) ^ Int(_rhs))
    let msg = "\(lhs) ^ \(rhs)"

    let lThingie = lhs.xor(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.xor(other: lhs)
    XCTAssert(rThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }
}
