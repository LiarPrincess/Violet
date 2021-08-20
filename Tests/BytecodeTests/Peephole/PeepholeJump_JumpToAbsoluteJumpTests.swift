import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeJumpJumpToAbsoluteJumpTests: XCTestCase {

  // MARK: - Jump absolute

  func test_jumpAbsolute_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendJumpAbsolute(to: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .jumpAbsolute(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  // MARK: - JumpIfOrPop

  func test_jumpIfTrueOrPop_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  func test_jumpIfFalseOrPop_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .jumpIfFalseOrPop(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  // MARK: - PopJumpIfFalse

  func test_popJumpIfFalse_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendPopJumpIfFalse(to: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .popJumpIfFalse(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  func test_popJumpIfTrue_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendPopJumpIfTrue(to: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  // MARK: - Loops

  func test_setupLoop_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendSetupLoop(loopEnd: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .setupLoop(loopEndLabelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  func test_forIter_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendForIter(ifEmpty: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .forIter(ifEmptyLabelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  func test_continue_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendContinue(loopStartLabel: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .continue(loopStartLabelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  // MARK: - Exceptions

  func test_setupExcept_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendSetupExcept(firstExcept: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .setupExcept(firstExceptLabelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  func test_setupFinally_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendSetupFinally(finallyStart: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .setupFinally(finallyStartLabelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }

  // MARK: - With

  func test_setupWith_toJumpAbsolute_makesSingleJump() {
    let builder = createBuilder()
    let jumpLabel = builder.createLabel()
    let absoluteLabel = builder.createLabel()
    builder.appendSetupWith(afterBody: jumpLabel)
    builder.appendLoadName("Quasimodo")
    builder.setLabel(jumpLabel)
    builder.appendJumpAbsolute(to: absoluteLabel)
    builder.appendLoadName("Esmeralda")
    builder.setLabel(absoluteLabel)
    builder.appendLoadName("Claude Frollo")

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNames(code, "Quasimodo", "Esmeralda", "Claude Frollo")
    XCTAssertInstructions(
      code,
      .setupWith(afterBodyLabelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .jumpAbsolute(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .loadName(nameIndex: 2) // 4
    )
  }
}
