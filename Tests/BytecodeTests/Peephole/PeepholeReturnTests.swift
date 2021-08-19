import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeReturnTests: XCTestCase {

  // MARK: - Nothing after

  func test_return_nothingAfter_doesNothing() {
    let builder = createBuilder()
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNoConstants(code)
    XCTAssertInstructions(
      code,
      .return
    )
  }

  func test_returnNone_nothingAfter_doesNothing() {
    let builder = createBuilder()
    builder.appendNone()
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .return
    )
  }

  // MARK: - Nop prefix

  func test_removesNops() {
    let builder = createBuilder()
    builder.appendNop()
    builder.appendNop()
    builder.appendNone()
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .return
    )
  }

  // MARK: - Instructions after

  func test_returnNone_removesInstructionsAfter() {
    let builder = createBuilder()
    builder.appendNone()
    builder.appendReturn()
    builder.appendNop()
    builder.appendString("To remove")

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .none, .string("To remove"))
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .return
    )
  }

  // MARK: - Instructions after with jump

  func test_ifValue0_returnValue1_else_returnValue2_removesInstructionsAfter() {
    // if elsa:
    //     return 5
    //     (things)
    // return None
    // (things)

    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendLoadName("elsa")
    builder.appendPopJumpIfFalse(to: label)
    builder.appendInteger(BigInt(5))
    builder.appendReturn()
    builder.appendNop()
    builder.appendString("To remove")

    builder.setLabel(label)
    builder.appendNone()
    builder.appendReturn()
    builder.appendString("To remove 2")
    builder.appendNop()

    let code = builder.finalize()
    XCTAssertNames(code, "elsa")
    XCTAssertLabelTargets(code, 4)
    XCTAssertConstants(
      code,
      .integer(BigInt(5)),
      .string("To remove"),
      .none,
      .string("To remove 2")
    )
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0), // 0
      .popJumpIfFalse(labelIndex: 0), // 1
      .loadConst(index: 0), // 2
      .return, // 3
      .loadConst(index: 2), // 4 <- label0 target
      .return
    )
  }
}
