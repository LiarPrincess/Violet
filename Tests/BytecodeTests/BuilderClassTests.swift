import XCTest
import VioletCore
@testable import VioletBytecode

class BuilderClassTests: XCTestCase {

  func test_appendLoadBuildClass() {
    let builder = createBuilder()
    builder.appendLoadBuildClass()

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadBuildClass)
  }
}
