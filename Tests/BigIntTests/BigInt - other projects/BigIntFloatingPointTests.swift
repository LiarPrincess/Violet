import XCTest
@testable import BigInt

// Tests taken from:
// https://github.com/benrimmington/swift-numerics/blob/BigInt/Tests/BigIntTests/BigIntTests.swift

private typealias Word = BigIntStorage.Word

class BigIntFloatingPointTests: XCTestCase {

  func test_special() {
    self.testBinaryFloatingPoint(Float32.self)
    self.testBinaryFloatingPoint(Float64.self)
  }

  // swiftlint:disable:next function_body_length
  private func testBinaryFloatingPoint<T: BinaryFloatingPoint>(_ type: T.Type) {
    let zero = BigInt(0)

    var expected = BigInt(T.greatestFiniteMagnitude.significandBitPattern)
    expected |= BigInt(1) << T.significandBitCount
    expected <<= T.greatestFiniteMagnitude.exponent
    expected >>= T.significandBitCount

    XCTAssertEqual(BigInt(exactly: -T.greatestFiniteMagnitude), -expected)
    XCTAssertEqual(BigInt(exactly: +T.greatestFiniteMagnitude), +expected)
    XCTAssertEqual(BigInt(-T.greatestFiniteMagnitude), -expected)
    XCTAssertEqual(BigInt(+T.greatestFiniteMagnitude), +expected)

    XCTAssertNil(BigInt(exactly: -T.infinity))
    XCTAssertNil(BigInt(exactly: +T.infinity))

    XCTAssertNil(BigInt(exactly: -T.leastNonzeroMagnitude))
    XCTAssertNil(BigInt(exactly: +T.leastNonzeroMagnitude))
    XCTAssertEqual(BigInt(-T.leastNonzeroMagnitude), zero)
    XCTAssertEqual(BigInt(+T.leastNonzeroMagnitude), zero)

    XCTAssertNil(BigInt(exactly: -T.leastNormalMagnitude))
    XCTAssertNil(BigInt(exactly: +T.leastNormalMagnitude))
    XCTAssertEqual(BigInt(-T.leastNormalMagnitude), zero)
    XCTAssertEqual(BigInt(+T.leastNormalMagnitude), zero)

    XCTAssertNil(BigInt(exactly: T.nan))
    XCTAssertNil(BigInt(exactly: T.signalingNaN))

    XCTAssertNil(BigInt(exactly: -T.pi))
    XCTAssertNil(BigInt(exactly: +T.pi))
    XCTAssertEqual(BigInt(-T.pi), BigInt(-3))
    XCTAssertEqual(BigInt(+T.pi), BigInt(3))

    XCTAssertNil(BigInt(exactly: -T.ulpOfOne))
    XCTAssertNil(BigInt(exactly: +T.ulpOfOne))
    XCTAssertEqual(BigInt(-T.ulpOfOne), zero)
    XCTAssertEqual(BigInt(+T.ulpOfOne), zero)

    XCTAssertEqual(BigInt(exactly: -T.zero), zero)
    XCTAssertEqual(BigInt(exactly: +T.zero), zero)
    XCTAssertEqual(BigInt(-T.zero), zero)
    XCTAssertEqual(BigInt(+T.zero), zero)
  }

  func test_random() {
    for _ in 0..<100 {
      let small = Float32.random(in: -10 ... +10)
      XCTAssertEqual(BigInt(small), BigInt(Int64(small)))

      let large = Float32.random(in: -0x1p23 ... +0x1p23)
      XCTAssertEqual(BigInt(large), BigInt(Int64(large)))
    }

    for _ in 0..<100 {
      let small = Float64.random(in: -10 ... +10)
      XCTAssertEqual(BigInt(small), BigInt(Int64(small)))

      let large = Float64.random(in: -0x1p52 ... +0x1p52)
      XCTAssertEqual(BigInt(large), BigInt(Int64(large)))
    }
  }
}
