import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeBuildTupleTests: XCTestCase {

  func test_buildTuple_return_noChanges() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .buildTuple(elementCount: 2),
      .return
    )
  }

  func test_fewNops_loadConst_removesNops() {
    let builder = createBuilder()
    builder.appendNop()
    builder.appendTrue()
    builder.appendNop()
    builder.appendBuildTuple(elementCount: 1)

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .buildTuple(elementCount: 1)
    )
  }
}
