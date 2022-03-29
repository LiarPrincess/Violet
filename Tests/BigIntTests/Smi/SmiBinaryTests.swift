import XCTest
@testable import BigInt

private typealias Storage = Smi.Storage

private let max = Storage.max
private let maxHalf = max / 2
private let maxMinus1 = max - 1

private let min = Storage.min
private let minHalf = min / 2
private let minPlus1 = min + 1

class SmiBinaryTests: XCTestCase {

  private let smallIntPairs = allPossiblePairings(
    values: [-2, -1, 0, 1, 2].map(Storage.init)
  )

  // MARK: - Add

  func test_add_withoutOverflow() {
    for (lhs, rhs) in self.smallIntPairs {
      self.addWithoutOverflow(lhs, rhs)
    }

    // 'expecting' argument is for readers, so we know what we testing
    self.addWithoutOverflow(max, 0, expecting: max)
    self.addWithoutOverflow(min, 0, expecting: min)
    self.addWithoutOverflow(max, min, expecting: -1)

    self.addWithoutOverflow(maxMinus1, 1, expecting: max)
    self.addWithoutOverflow(minPlus1, -1, expecting: min)
  }

  private func addWithoutOverflow(_ _lhs: Storage,
                                  _ _rhs: Storage,
                                  expecting: Storage? = nil,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = expecting.map(BigInt.init(smi:)) ?? BigInt(Int(_lhs) + Int(_rhs))
    let msg = "\(lhs) + \(rhs)"

    let lThingie = lhs.add(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.add(other: lhs)
    XCTAssert(rThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }

  func test_add_overflow_positive() {
    self.addWithOverflow(max, 1)
    self.addWithOverflow(max, max)
    self.addWithOverflow(max, maxMinus1)
    self.addWithOverflow(maxHalf, max)

    let testCount = Storage(128)
    let step = max / testCount

    for i in 1..<testCount {
      let other = i * step
      self.addWithOverflow(max, other)
    }
  }

  func test_add_overflow_negative() {
    self.addWithOverflow(min, -1)
    self.addWithOverflow(min, min)
    self.addWithOverflow(min, minPlus1)
    self.addWithOverflow(minHalf, min)

    let testCount = Storage(128)
    let step = max / testCount

    for i in 1..<testCount {
      let other = -i * step
      self.addWithOverflow(min, other)
    }
  }

  private func addWithOverflow(_ _lhs: Storage,
                               _ _rhs: Storage,
                               file: StaticString = #file,
                               line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) + Int(_rhs))
    let msg = "\(lhs) + \(rhs)"

    let lThingie = lhs.add(other: rhs)
    XCTAssert(lThingie.isHeap, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.add(other: lhs)
    XCTAssert(rThingie.isHeap, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }

  // MARK: - Sub

  func test_sub_withoutOverflow() {
    for (lhs, rhs) in self.smallIntPairs {
      self.subWithoutOverflow(lhs, rhs)
    }

    // 'expecting' argument is for readers, so we know what we testing
    self.subWithoutOverflow(max, 0, expecting: max)
    self.subWithoutOverflow(min, 0, expecting: min)
    self.subWithoutOverflow(0, max, expecting: minPlus1)
    self.subWithoutOverflow(0, minPlus1, expecting: max)

    self.subWithoutOverflow(max, max, expecting: 0)
    self.subWithoutOverflow(min, min, expecting: 0)

    self.subWithoutOverflow(max, 1, expecting: maxMinus1)
    self.subWithoutOverflow(min, -1, expecting: minPlus1)

    self.subWithoutOverflow(maxMinus1, -1, expecting: max)
    self.subWithoutOverflow(minPlus1, 1, expecting: min)
    self.subWithoutOverflow(1, min + 2, expecting: max)
    self.subWithoutOverflow(-1, max, expecting: min)
  }

  private func subWithoutOverflow(_ _lhs: Storage,
                                  _ _rhs: Storage,
                                  expecting: Storage? = nil,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = expecting.map(BigInt.init(smi:)) ?? BigInt(Int(_lhs) - Int(_rhs))
    let msg = "\(lhs) + \(rhs)"

    let thingie = lhs.sub(other: rhs)
    XCTAssert(thingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(thingie, expected, msg, file: file, line: line)
  }

  func test_sub_overflow_positive() {
    self.subWithOverflow(max, -1)
    self.subWithOverflow(max, min)
    self.subWithOverflow(max, minPlus1)
    self.subWithOverflow(maxHalf, min)

    let testCount = Storage(128)
    let step = max / testCount

    for i in 1..<testCount {
      let other = -i * step
      self.subWithOverflow(max, other)
    }
  }

  func test_sub_overflow_negative() {
    self.subWithOverflow(min, 1)
    self.subWithOverflow(min, max)
    self.subWithOverflow(min, maxMinus1)
    self.subWithOverflow(minHalf, max)

    let testCount = Storage(128)
    let step = max / testCount

    for i in 1..<testCount {
      let other = i * step
      self.subWithOverflow(min, other)
    }
  }

  private func subWithOverflow(_ _lhs: Storage,
                               _ _rhs: Storage,
                               file: StaticString = #file,
                               line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) - Int(_rhs))
    let msg = "\(lhs) + \(rhs)"

    let thingie = lhs.sub(other: rhs)
    XCTAssert(thingie.isHeap, msg, file: file, line: line)
    XCTAssertEqual(thingie, expected, msg, file: file, line: line)
  }

  // MARK: - Mul

  func test_mul_withoutOverflow() {
    for (lhs, rhs) in self.smallIntPairs {
      self.mulWithoutOverflow(lhs, rhs)
    }

    self.mulWithoutOverflow(max, 0)
    self.mulWithoutOverflow(maxHalf, 0)
    self.mulWithoutOverflow(min, 0)
    self.mulWithoutOverflow(minHalf, 0)

    self.mulWithoutOverflow(max, 1)
    self.mulWithoutOverflow(maxHalf, 1)
    self.mulWithoutOverflow(min, 1)
    self.mulWithoutOverflow(minHalf, 1)

    self.mulWithoutOverflow(max, -1)
    self.mulWithoutOverflow(maxHalf, -1)
    self.mulWithoutOverflow(minPlus1, -1)
    self.mulWithoutOverflow(minHalf, -1)

    for shift in 0..<16 { // NOT including 16!
      let value = Int32(1 << shift)
      self.mulWithoutOverflow(1, value)
      self.mulWithoutOverflow(2, value)
      self.mulWithoutOverflow(3, value)
    }
  }

  private func mulWithoutOverflow(_ _lhs: Storage,
                                  _ _rhs: Storage,
                                  expecting: Storage? = nil,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = expecting.map(BigInt.init(smi:)) ?? BigInt(Int(_lhs) * Int(_rhs))
    let msg = "\(lhs) * \(rhs)"

    let lThingie = lhs.mul(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.mul(other: lhs)
    XCTAssert(rThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }

  func test_mul_overflow_positive() {
    self.mulWithOverflow(max, max)
    self.mulWithOverflow(min, min)

    self.mulWithOverflow(max, maxMinus1)
    self.mulWithOverflow(max, maxHalf)
    self.mulWithOverflow(min, minPlus1)
    self.mulWithOverflow(min, minHalf)

    let testCount = Storage(128)
    let step = max / testCount

    for i in 1..<testCount {
      let other = -i * step
      self.mulWithOverflow(max, other)
    }
  }

  func test_mul_overflow_negative() {
    self.mulWithOverflow(max, min)
    self.mulWithOverflow(min, max)

    self.mulWithOverflow(max, minPlus1)
    self.mulWithOverflow(max, minHalf)
    self.mulWithOverflow(min, maxMinus1)
    self.mulWithOverflow(min, maxHalf)

    let testCount = Storage(128)
    let step = max / testCount

    for i in 1..<testCount {
      let other = i * step
      self.mulWithOverflow(min, other)
    }
  }

  private func mulWithOverflow(_ _lhs: Storage,
                               _ _rhs: Storage,
                               file: StaticString = #file,
                               line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) * Int(_rhs))
    let msg = "\(lhs) * \(rhs)"

    let lThingie = lhs.mul(other: rhs)
    XCTAssert(lThingie.isHeap, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)

    let rThingie = rhs.mul(other: lhs)
    XCTAssert(rThingie.isHeap, msg, file: file, line: line)
    XCTAssertEqual(rThingie, expected, msg, file: file, line: line)
  }

  // MARK: - Div

  func test_div_withoutOverflow() {
    for (lhs, rhs) in self.smallIntPairs {
      if rhs == 0 {
        continue
      }

      self.divWithoutOverflow(lhs, rhs)
    }

    self.divWithoutOverflow(max, 1)
    self.divWithoutOverflow(maxHalf, 1)
    self.divWithoutOverflow(min, 1)
    self.divWithoutOverflow(minHalf, 1)

    self.divWithoutOverflow(max, -1)
    self.divWithoutOverflow(maxHalf, -1)
    self.divWithoutOverflow(minPlus1, -1) // if we used 'min' -> overflow
    self.divWithoutOverflow(minHalf, -1)

    for shift in 0...16 {
      let value = Int32(1 << shift)
      self.divWithoutOverflow(value, 1)
      self.divWithoutOverflow(value, 2)
      self.divWithoutOverflow(value, 3)
    }
  }

  private func divWithoutOverflow(_ _lhs: Storage,
                                  _ _rhs: Storage,
                                  expecting: Storage? = nil,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = expecting.map(BigInt.init(smi:)) ?? BigInt(Int(_lhs) / Int(_rhs))
    let msg = "\(lhs) / \(rhs)"

    let lThingie = lhs.div(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)
  }

  func test_div_min_by_minus1() {
    // 'Storage.min / -1' -> value 1 greater than Storage.max
    self.divWithOverflow(min, -1)
  }

  private func divWithOverflow(_ _lhs: Storage,
                               _ _rhs: Storage,
                               file: StaticString = #file,
                               line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) / Int(_rhs))
    let msg = "\(lhs) / \(rhs)"

    let lThingie = lhs.div(other: rhs)
    XCTAssert(lThingie.isHeap, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)
  }

  // MARK: - Mod

  func test_mod_withoutOverflow() {
    for (lhs, rhs) in self.smallIntPairs {
      if rhs == 0 {
        continue
      }

      self.modWithoutOverflow(lhs, rhs)
    }

    self.modWithoutOverflow(max, 1)
    self.modWithoutOverflow(maxHalf, 1)
    self.modWithoutOverflow(min, 1)
    self.modWithoutOverflow(minHalf, 1)

    self.modWithoutOverflow(max, -1)
    self.modWithoutOverflow(maxHalf, -1)
    self.modWithoutOverflow(minPlus1, -1) // if we used 'min' -> overflow
    self.modWithoutOverflow(minHalf, -1)

    for shift in 0...16 {
      let value = Int32(1 << shift)
      self.modWithoutOverflow(value, 1)
      self.modWithoutOverflow(value, 2)
      self.modWithoutOverflow(value, 3)
    }
  }

  private func modWithoutOverflow(_ _lhs: Storage,
                                  _ _rhs: Storage,
                                  expecting: Storage? = nil,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = expecting.map(BigInt.init(smi:)) ?? BigInt(Int(_lhs) % Int(_rhs))
    let msg = "\(lhs) % \(rhs)"

    let lThingie = lhs.rem(other: rhs)
    XCTAssert(lThingie.isSmi, msg, file: file, line: line)
    XCTAssertEqual(lThingie, expected, msg, file: file, line: line)
  }

  func test_mod_min_by_minus1() {
    // 'Storage.min / -1' -> value 1 greater than Storage.max
    // this also affects 'mod'.
    let _lhs = min
    let _rhs = Storage(-1)

    let lhs = Smi(_lhs)
    let rhs = Smi(_rhs)
    let expected = BigInt(Int(_lhs) % Int(_rhs))
    XCTAssertEqual(expected, BigInt(0))

    let lThingie = lhs.rem(other: rhs)
    XCTAssert(lThingie.isSmi) // 0 is smi
    XCTAssertEqual(lThingie, expected)
  }
}
