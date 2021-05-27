import XCTest
import VioletCore

class MutableCollectionRemoveDuplicates: XCTestCase {

  func test_emptySelf() {
    var zelf = [Int]()
    zelf.removeDuplicates()
    XCTAssertEqual(zelf, [])
  }

  func test_allDifferent() {
    let before = [1, 2, 3, 4, 5]

    var zelf = before
    zelf.removeDuplicates()
    XCTAssertEqual(zelf, before)
  }

  func test_allDuplicates() {
    var zelf = Array(repeatElement(1, count: 10))
    zelf.removeDuplicates()
    XCTAssertEqual(zelf, [1])
  }

  // This will check stability.
  func test_duplicate_prefix() {
    var zelf = [1, 1, 2, 3, 4, 5]
    zelf.removeDuplicates()
    XCTAssertEqual(zelf, [1, 2, 3, 4, 5])
  }

  // This will check stability.
  func test_duplicate_suffix() {
    var zelf = [1, 2, 3, 4, 5, 5]
    zelf.removeDuplicates()
    XCTAssertEqual(zelf, [1, 2, 3, 4, 5])
  }

  // This will check stability.
  func test_duplicate_middle() {
    var zelf = [1, 2, 3, 3, 4, 5]
    zelf.removeDuplicates()
    XCTAssertEqual(zelf, [1, 2, 3, 4, 5])
  }
}
