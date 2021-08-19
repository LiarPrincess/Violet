import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeJumpIfOrPopTests: XCTestCase {

  // MARK: - Return after

  func test_ifTrue_return_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label)
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertNoConstants(code)
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 0), // 0
      .return // 1
    )
  }

  func test_ifFalse_return_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label)
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertNoConstants(code)
    XCTAssertInstructions(
      code,
      .jumpIfFalseOrPop(labelIndex: 0), // 0
      .return // 1
    )
  }

  // MARK: - Removes nops

  func test_ifTrue_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendJumpIfTrueOrPop(to: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  func test_ifFalse_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendJumpIfFalseOrPop(to: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .jumpIfFalseOrPop(labelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }
}
