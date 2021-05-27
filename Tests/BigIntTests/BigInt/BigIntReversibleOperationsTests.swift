import XCTest
@testable import BigInt

private typealias Word = BigIntHeap.Word

/// Reversible operation - operation for which exists 'reverse' operation
/// that undoes its effect.
/// For example for addition it is subtraction: `(n + x) - x = n`.
class BigIntReversibleOperationsTests: XCTestCase {

  private lazy var smiValues = generateSmiValues(countButNotReally: 20)
  private lazy var heapValues = generateHeapValues(countButNotReally: 20)

  private lazy var smiSmi = allPossiblePairings(values: self.smiValues)
  private lazy var smiHeap = allPossiblePairings(lhs: self.smiValues, rhs: self.heapValues)
  private lazy var heapSmi = allPossiblePairings(lhs: self.heapValues, rhs: self.smiValues)
  private lazy var heapHeap = allPossiblePairings(lhs: self.heapValues, rhs: self.heapValues)

  // MARK: - Add, sub

  func test_addSub_smiSmi() {
    for (lhsRaw, rhsRaw) in self.smiSmi {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.addSub(lhs: lhs, rhs: rhs)
    }
  }

  func test_addSub_smiHeap() {
    for (lhsRaw, rhsRaw) in self.smiHeap {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.addSub(lhs: lhs, rhs: rhs)
    }
  }

  func test_addSub_heapSmi() {
    for (lhsRaw, rhsRaw) in self.heapSmi {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.addSub(lhs: lhs, rhs: rhs)
    }
  }

  func test_addSub_heapHeap() {
    for (lhsRaw, rhsRaw) in self.heapHeap {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.addSub(lhs: lhs, rhs: rhs)
    }
  }

  private func addSub(lhs: BigInt,
                      rhs: BigInt,
                      file: StaticString = #file,
                      line: UInt = #line) {
    let expectedLhs = (lhs + rhs) - rhs
    XCTAssertEqual(lhs, expectedLhs, "\(lhs) +- \(rhs)", file: file, line: line)
  }

  // MARK: - Mul, div

  func test_mulDiv_smiSmi() {
    for (lhsRaw, rhsRaw) in self.smiSmi {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.mulDiv(lhs: lhs, rhs: rhs)
    }
  }

  func test_mulDiv_smiHeap() {
    for (lhsRaw, rhsRaw) in self.smiHeap {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.mulDiv(lhs: lhs, rhs: rhs)
    }
  }

  func test_mulDiv_heapSmi() {
    for (lhsRaw, rhsRaw) in self.heapSmi {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.mulDiv(lhs: lhs, rhs: rhs)
    }
  }

  func test_mulDiv_heapHeap() {
    for (lhsRaw, rhsRaw) in self.heapHeap {
      let lhs = self.create(lhsRaw)
      let rhs = self.create(rhsRaw)
      self.mulDiv(lhs: lhs, rhs: rhs)
    }
  }

  private func mulDiv(lhs: BigInt,
                      rhs: BigInt,
                      file: StaticString = #file,
                      line: UInt = #line) {
    if rhs.isZero {
      return
    }

    let expectedLhs = (lhs * rhs) / rhs
    XCTAssertEqual(lhs, expectedLhs, "\(lhs) */ \(rhs)", file: file, line: line)
  }

  // MARK: - Shift left, right

  func test_shiftLeftRight_smi() {
    for smi in self.smiValues {
      let value = self.create(smi)
      self.shiftLeftRight(value: value)
    }
  }

  func test_shiftLeftRight_heap() {
    for smi in self.heapValues {
      let value = self.create(smi)
      self.shiftLeftRight(value: value)
    }
  }

  private func shiftLeftRight(value: BigInt,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let lessThanWord = 5
    let word = Word.bitWidth
    let moreThanWord = Word.bitWidth + Word.bitWidth - 7

    for count in [lessThanWord, word, moreThanWord] {
      let result = (value << count) >> count
      XCTAssertEqual(result, value, "\(value) <<>> \(count)", file: file, line: line)
    }
  }

  // MARK: - To string, init

  func test_toStringInit_smi() {
    for smi in self.smiValues {
      let value = self.create(smi)
      self.toStringInit(value: value)
    }
  }

  func test_toStringInit_heap() {
    for smi in self.heapValues {
      let value = self.create(smi)
      self.toStringInit(value: value)
    }
  }

  private func toStringInit(value: BigInt,
                            file: StaticString = #file,
                            line: UInt = #line) {
    for radix in [2, 5, 10, 16] {
      do {
        let string = String(value, radix: radix)
        let int = try BigInt(string, radix: radix)
        XCTAssertEqual(int, value, "string: \(string)", file: file, line: line)
      } catch {
        XCTFail("radix: \(radix), error: \(error)", file: file, line: line)
      }
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
