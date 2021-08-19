import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeBuildTupleTests: XCTestCase {

  func test_loadName_buildTuple_return_doesNothing() {
    let builder = createBuilder()
    builder.appendLoadName("Belle")
    builder.appendLoadName("Beast")
    builder.appendBuildTuple(elementCount: 2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Belle", "Beast")
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .buildTuple(elementCount: 2),
      .return
    )
  }

  func test_removesNops() {
    let builder = createBuilder()
    builder.appendNop()
    builder.appendLoadName("Belle")
    builder.appendNop()
    builder.appendBuildTuple(elementCount: 1)

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Belle")
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .buildTuple(elementCount: 1)
    )
  }
}
