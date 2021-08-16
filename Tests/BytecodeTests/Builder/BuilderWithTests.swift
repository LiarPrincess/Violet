import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

/// with alice: wonderland
///
///  0 LOAD_NAME                0 (alice)
///  2 SETUP_WITH              10 (to 14)
///  4 POP_TOP
///  6 LOAD_NAME                1 (wonderland)
///  8 POP_TOP
/// 10 POP_BLOCK
/// 12 LOAD_CONST               0 (None)
/// 14 WITH_CLEANUP_START
/// 16 WITH_CLEANUP_FINISH
/// 18 END_FINALLY
/// 20 LOAD_CONST               0 (None)
/// 22 RETURN_VALUE
class BuilderWithTests: XCTestCase {

  // MARK: - Setup

  func test_appendSetupWith() {
    let builder = createBuilder()
    let label = builder.createLabel()

    builder.appendSetupWith(afterBody: label)
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .setupWith(afterBodyLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  // MARK: - Cleanup

  func test_appendWithCleanupStart() {
    let builder = createBuilder()
    builder.appendWithCleanupStart()

    let code = builder.finalize()
    XCTAssertInstructions(code, .withCleanupStart)
  }

  func test_appendWithCleanupFinish() {
    let builder = createBuilder()
    builder.appendWithCleanupFinish()

    let code = builder.finalize()
    XCTAssertInstructions(code, .withCleanupFinish)
  }

  // MARK: - Async

  func test_appendBeforeAsyncWith() {
    let builder = createBuilder()
    builder.appendBeforeAsyncWith()

    let code = builder.finalize()
    XCTAssertInstructions(code, .beforeAsyncWith)
  }

  func test_appendSetupAsyncWith() {
    let builder = createBuilder()
    builder.appendSetupAsyncWith()

    let code = builder.finalize()
    XCTAssertInstructions(code, .setupAsyncWith)
  }
}
