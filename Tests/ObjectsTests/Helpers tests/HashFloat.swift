import XCTest
import VioletCore
@testable import VioletObjects

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting

class HashFloat: XCTestCase {

  // MARK: - Int zero

  func test_int_zero_isZero() {
    XCTAssertEqual(self.hash(+0.0), 0)
    XCTAssertEqual(self.hash(-0.0), 0)
  }

  // MARK: - Int positive

  func test_int_positive_small_stayTheSame() {
    for value in 1...255 {
      let double = Double(value)
      XCTAssertEqual(self.hash(double), value)
    }
  }

  func test_int_positive_aroundInt32max_stayTheSame() {
    let values: [Int] = [
      Int(Int32.max) - 1,
      Int(Int32.max) + 0,
      Int(Int32.max) + 1
    ]

    for value in values {
      let double = Double(value)
      XCTAssertEqual(self.hash(double), value)
    }
  }

  func test_int_positive_aroundModulus_wrapsIfNeeded() {
    // This is a dummy test, `1 << 61` is well beyond `Double` precision,
    // so all of the numbers are basically the same:
    // modulus:        2.305 843 009 213 694 e+18
    // modulus.nextUp: 2.305 843 009 213 694 5e+18

    // Try this in 64-bit Python:
    //  >>> x = float(1 << 61)
    //  >>> hash(x - 2)
    //  1
    //  >>> hash(x - 1)
    //  1
    //  >>> hash(x + 0)
    //  1
    //  >>> hash(x + 1)
    //  1

    let modulus = Double(1 << 61)
    XCTAssertEqual(self.hash(modulus - 2), 1)
    XCTAssertEqual(self.hash(modulus - 1), 1)
    XCTAssertEqual(self.hash(modulus + 0), 1)
    XCTAssertEqual(self.hash(modulus + 1), 1)
  }

  // MARK: - Int negative

  func test_int_negative_1_isMinus1() {
    // CPython would return '-2'.
    let zero = Double(-1)
    XCTAssertEqual(self.hash(zero), -1)
  }

  func test_int_negative_small_stayTheSame() {
    for value in 2...255 {
      let negValue = -value
      let double = Double(negValue)
      XCTAssertEqual(self.hash(double), negValue)
    }
  }

  func test_int_negative_aroundInt32min_stayTheSame() {
    let values: [Int] = [
      Int(Int32.min) - 1,
      Int(Int32.min) + 0,
      Int(Int32.min) + 1
    ]

    for value in values {
      let double = Double(value)
      XCTAssertEqual(self.hash(double), value)
    }
  }

  func test_int_negative_aroundModulus_wrapsIfNeeded() {
    // Just as in 'positive' case the `Double` precision is not enough,
    // so all of the numbers are basically the same.

    // Try this in 64-bit Python:
    // x = -float(1 << 61)
    // >>> hash(x - 1)
    // -2 <-- it is actually '-1' but CPython uses '-1' for errors.
    // >>> hash(x)
    // -2
    // >>> hash(x + 1)
    // -2
    // >>> hash(x + 2)
    // -2
    // >>> hash(x + 3)
    // -2

    let modulus = -Double(1 << 61)
    XCTAssertEqual(self.hash(modulus - 1), -1)
    XCTAssertEqual(self.hash(modulus + 0), -1)
    XCTAssertEqual(self.hash(modulus + 1), -1)
    XCTAssertEqual(self.hash(modulus + 2), -1)
    XCTAssertEqual(self.hash(modulus + 3), -1)
  }

  // MARK: - Decimal

  func test_decimal_positive() {
    //  >>> hash(1.1)
    //  230584300921369601
    //  >>> hash(1.2)
    //  461168601842738689
    //  >>> hash(1.3)
    //  691752902764108289

    XCTAssertEqual(self.hash(1.1), 230584300921369601)
    XCTAssertEqual(self.hash(1.2), 461168601842738689)
    XCTAssertEqual(self.hash(1.3), 691752902764108289)
  }

  func test_decimal_negative() {
    //  >>> hash(-1.1)
    //  -230584300921369601
    //  >>> hash(-1.2)
    //  -461168601842738689
    //  >>> hash(-1.3)
    //  -691752902764108289

    XCTAssertEqual(self.hash(-1.1), -230584300921369601)
    XCTAssertEqual(self.hash(-1.2), -461168601842738689)
    XCTAssertEqual(self.hash(-1.3), -691752902764108289)
  }

  // MARK: - NaN

  func test_nan_isZero() {
    // >>> hash(float('nan'))
    // 0

    XCTAssertEqual(self.hash(Double.nan), 0)

    // `NaN` with fancy bits filled.
    XCTAssertEqual(self.hash(Double.signalingNaN), 0)
  }

  // MARK: - Inf

  func test_inf_X() {
    // >>> hash(float('inf'))
    // 314159
    // >>> hash(float('-inf'))
    // -314159

    XCTAssertEqual(self.hash(+Double.infinity), 314_159)
    XCTAssertEqual(self.hash(-Double.infinity), -314_159)
  }

  // MARK: - Helper

  private func hash(_ value: Double) -> Int {
    // Key is 'I See the Light ' in ASCII
    let key: (UInt64, UInt64) = (0x4920536565207468, 0x65204c6967687420)
    let hasher = Hasher(key0: key.0, key1: key.1)
    return hasher.hash(value)
  }
}
