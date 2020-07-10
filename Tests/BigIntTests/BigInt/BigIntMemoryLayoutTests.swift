import XCTest
@testable import Core

class BigIntMemoryLayoutTests: XCTestCase {

  func test_size() {
    let singleWord = 8
    XCTAssertEqual(MemoryLayout<BigInt>.size, singleWord)
    XCTAssertEqual(MemoryLayout<BigInt>.stride, singleWord)
  }
}
