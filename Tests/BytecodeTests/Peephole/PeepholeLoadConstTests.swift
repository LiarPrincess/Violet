import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeLoadConstTests: XCTestCase {

  func test_loadConst_return_doesNothing() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .return
    )
  }

  func test_removesNops() {
    let builder = createBuilder()
    builder.appendNop()
    builder.appendNop()
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0)
    )
  }
}
