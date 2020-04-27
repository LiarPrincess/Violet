import XCTest
import VioletCore

class BidirectionalCollectionDropLast: XCTestCase {

  func test_emptySelf() {
    let zelf = [Int]()
    let result = zelf.dropLast { $0 == 0 }
    XCTAssertEqual(result, [])
  }

  func test_consumeNone() {
    let zelf = [1, 2, 3, 4]
    let result = zelf.dropLast { $0 == 0 }
    XCTAssertEqual(result, [1, 2, 3, 4])
  }

  func test_consumePart() {
    let zelf = [1, 2, 3, 4]
    let result = zelf.dropLast { $0 == 3 || $0 == 4 }
    XCTAssertEqual(result, [1, 2])
  }

  func test_consumeWhole() {
    let zelf = [1, 1, 1, 1]
    let result = zelf.dropLast { $0 == 1 }
    XCTAssertEqual(result, [])
  }

  func test_leaveFirstChar() {
    let zelf = [1, 2, 2, 2]
    let result = zelf.dropLast { $0 == 2 }
    XCTAssertEqual(result, [1])
  }
}
