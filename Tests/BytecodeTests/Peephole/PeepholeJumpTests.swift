import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeJumpIfOrPopTests: XCTestCase {

  // MARK: - jumpAbsolute

  func test_jumpAbsolute_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendJumpAbsolute(to: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .jumpAbsolute(labelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - jumpIfTrueOrPop

  func test_jumpIfTrueOrPop_removesNops() {
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

  // MARK: - jumpIfFalseOrPop

  func test_jumpIfFalseOrPop_removesNops() {
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

  // MARK: - popJumpIfFalse

  func test_popJumpIfFalse_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendPopJumpIfFalse(to: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .popJumpIfFalse(labelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - popJumpIfTrue

  func test_popJumpIfTrue_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendPopJumpIfTrue(to: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - setupLoop

  func test_setupLoop_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendSetupLoop(loopEnd: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .setupLoop(loopEndLabelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - forIter

  func test_forIter_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendForIter(ifEmpty: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .forIter(ifEmptyLabelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - continue

  func test_continue_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendContinue(loopStartLabel: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .continue(loopStartLabelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - setupExcept

  func test_setupExcept_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendSetupExcept(firstExcept: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .setupExcept(firstExceptLabelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - setupFinally

  func test_setupFinally_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendSetupFinally(finallyStart: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .setupFinally(finallyStartLabelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }

  // MARK: - setupWith

  func test_setupWith_removesNops() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendNop()
    builder.appendSetupWith(afterBody: label)
    builder.appendNop()
    builder.setLabel(label)
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 1)
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .setupWith(afterBodyLabelIndex: 0), // 0
      .loadConst(index: 0) // 1
    )
  }
}
