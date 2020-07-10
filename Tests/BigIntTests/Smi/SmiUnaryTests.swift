import XCTest
@testable import BigInt

private typealias Storage = Smi.Storage

class SmiUnaryTests: XCTestCase {

  // MARK: - Minus

  func test_minus() {
    // Do not add 'Storage.min', it is out of range of 'Smi'!
    // There is a special test for this.
    let values: [Storage] = [0, 42, .max, -42]

    for value in values {
      let smi = Smi(value)
      let expected = BigInt(smi: -value)
      XCTAssertEqual(smi.negated, expected, String(describing: value))
    }
  }

  func test_minus_min() {
    // We are going to hard-code some values, otherwise we would have to copy
    // production code to make this test work.
    let minSmi = -2_147_483_648
    XCTAssert(Storage.min == minSmi)

    guard let minSmiStorage = Storage(exactly: minSmi) else {
      XCTAssert(false, "Changed Smi.Storage?")
      return
    }

    let smi = Smi(minSmiStorage)
    let expected = BigInt(-minSmi)
    XCTAssertEqual(smi.negated, expected)
  }

  // MARK: - Invert

  func test_invert() {
    // Do not add 'Storage.min', it is out of range of 'Smi'!
    // There is a special test for this.
    let values: [Storage] = [0, 42, .max, -42, .min]

    for value in values {
      let smi = Smi(value)
      let expected = BigInt(smi: ~value)
      XCTAssertEqual(smi.inverted, expected, String(describing: value))
    }
  }
}
