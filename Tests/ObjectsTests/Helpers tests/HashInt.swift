import XCTest
import BigInt
import VioletCore
@testable import VioletObjects

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

class HashInt: XCTestCase {

  // MARK: - Zero

  func test_zero_isZero() {
    XCTAssertEqual(self.hash(+0), 0)
    XCTAssertEqual(self.hash(-0), 0)
  }

  // MARK: - Positive

  func test_positive_small_stayTheSame() {
    for value in 1...255 {
      let big = BigInt(value)
      XCTAssertEqual(self.hash(big), value)
    }
  }

  func test_positive_aroundInt32max_stayTheSame() {
    let values: [Int] = [
      Int(Int32.max) - 1,
      Int(Int32.max) + 0,
      Int(Int32.max) + 1
    ]

    for value in values {
      let big = BigInt(value)
      XCTAssertEqual(self.hash(big), value)
    }
  }

  func test_positive_aroundModulus_wrapsIfNeeded() {
    // Try this in 64-bit Python:
    // >>> x = 1 << 61
    // >>> hash(x - 2)
    // 2305843009213693950
    // >>> hash(x - 1)
    // 0
    // >>> hash(x + 0)
    // 1
    // >>> hash(x + 1)
    // 2

    let modulus = BigInt(1 << 61)
    XCTAssertEqual(self.hash(modulus - 2), 2305843009213693950)
    XCTAssertEqual(self.hash(modulus - 1), 0)
    XCTAssertEqual(self.hash(modulus + 0), 1)
    XCTAssertEqual(self.hash(modulus + 1), 2)
  }

  // MARK: - Negative

  func test_negative_1_isMinus1() {
    // CPython would return '-2'.
    let zero = BigInt(-1)
    XCTAssertEqual(self.hash(zero), -1)
  }

  func test_negative_small_stayTheSame() {
    for value in 2...255 {
      let negValue = -value
      let big = BigInt(negValue)
      XCTAssertEqual(self.hash(big), negValue)
    }
  }

  func test_negative_aroundInt32min_stayTheSame() {
    let values: [Int] = [
      Int(Int32.min) - 1,
      Int(Int32.min) + 0,
      Int(Int32.min) + 1
    ]

    for value in values {
      let big = BigInt(value)
      XCTAssertEqual(self.hash(big), value)
    }
  }

  func test_negative_aroundModulus_wrapsIfNeeded() {
    // Try this in 64-bit Python:
    // >>> x = -(1 << 61)
    // >>> hash(x - 1)
    // -2
    // >>> hash(x + 0)
    // -2
    // >>> hash(x + 1)
    // 0
    // >>> hash(x + 2)
    // -2305843009213693950
    // >>> hash(x + 3)
    // -2305843009213693949

    let modulus = -BigInt(1 << 61)
    XCTAssertEqual(self.hash(modulus - 1), -2)
    XCTAssertEqual(self.hash(modulus + 0), -1) // '-1' is used for errors
    XCTAssertEqual(self.hash(modulus + 1), 0)
    XCTAssertEqual(self.hash(modulus + 2), -2305843009213693950)
    XCTAssertEqual(self.hash(modulus + 3), -2305843009213693949)
  }

  // MARK: - Helper

  private func hash(_ value: BigInt) -> Int {
    // Key is 'I See the Light ' in ASCII
    let key: (UInt64, UInt64) = (0x4920536565207468, 0x65204c6967687420)
    let hasher = Hasher(key0: key.0, key1: key.1)
    return hasher.hash(value)
  }
}
