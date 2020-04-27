import XCTest
import VioletCore

class BidirectionalCollectionEndsWith: XCTestCase {

  // MARK: - Empty

  func test_emptySelf() {
    let zelf = [Int]()
    let suffix = [1, 2]
    XCTAssertFalse(zelf.ends(with: suffix))
  }

  func test_emptySuffix() {
    let zelf = [1, 2]
    let suffix = [Int]()
    XCTAssertTrue(zelf.ends(with: suffix))
  }

  func test_emptySelf_emptySuffix() {
    let zelf = [Int]()
    let suffix = [Int]()
    XCTAssertTrue(zelf.ends(with: suffix))
  }

  // MARK: - Ends with

  func test_endsWith_equalLength() {
    let zelf = [1, 2]
    let suffix = [1, 2]
    XCTAssertTrue(zelf.ends(with: suffix))
  }

  func test_endsWith_selfLonger() {
    let zelf = [1, 2, 3, 4]
    let suffix = [3, 4]
    XCTAssertTrue(zelf.ends(with: suffix))
  }

  // MARK: - Not ends with

  func test_notEndsWith_equalLength() {
    let zelf = [1, 2]
    XCTAssertFalse(zelf.ends(with: [1, 3]))
    XCTAssertFalse(zelf.ends(with: [0, 2]))
  }

  func test_notEndsWith_suffixLonger() {
    let zelf = [3, 4]
    let suffix = [1, 2, 3, 4]
    XCTAssertFalse(zelf.ends(with: suffix))
  }
}
