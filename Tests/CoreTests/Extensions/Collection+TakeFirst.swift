import XCTest
import VioletCore

class CollectionTakeFirst: XCTestCase {

  func test_emptySelf() {
    let zelf = [Int]()
    let result1 = zelf.takeFirst(0)
    XCTAssertEqual(result1, [])

    let result2 = zelf.takeFirst(10)
    XCTAssertEqual(result2, [])
  }

  func test_takeZero() {
    let zelf = [1, 2, 3, 4]
    let result = zelf.takeFirst(0)
    XCTAssertEqual(result, [])
  }

  func test_takePart() {
    let zelf = [1, 2, 3, 4]
    let result = zelf.takeFirst(3)
    XCTAssertEqual(result, [1, 2, 3])
  }

  func test_takeWhole() {
    let zelf = [1, 2, 3, 4]
    let result = zelf.takeFirst(4)
    XCTAssertEqual(result, [1, 2, 3, 4])
  }

  func test_takeMoreThanWhole() {
    let zelf = [1, 2, 3, 4]
    let result = zelf.takeFirst(10)
    XCTAssertEqual(result, [1, 2, 3, 4])
  }
}
