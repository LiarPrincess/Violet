import XCTest
import VioletCore

class DictionaryTakeExisting: XCTestCase {

  // MARK: - Take existing

  func test_takeExisting_noIntersection_justMerge() {
    var zelf = [1: "Elsa"]
    let other = [2: "Anna"]

    zelf.merge(other, uniquingKeysWith: .takeExisting)
    XCTAssertEqual(zelf, [1: "Elsa", 2: "Anna"])
  }

  func test_takeExisting_withIntersection_takeExisting() {
    var zelf = [1: "Elsa"]
    let other = [1: "Anna"]

    zelf.merge(other, uniquingKeysWith: .takeExisting)
    XCTAssertEqual(zelf, [1: "Elsa"])
  }
}
