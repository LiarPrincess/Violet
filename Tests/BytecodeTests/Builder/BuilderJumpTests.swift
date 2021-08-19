import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderJumpTests: XCTestCase {

  // MARK: - JumpAbsolute

  func test_appendJumpAbsolute() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpAbsolute(to: label) // 0
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .jumpAbsolute(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendJumpAbsolute_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendJumpAbsolute(to: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .jumpAbsolute(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  // MARK: - PopJumpIfTrue

  func test_appendPopJumpIfTrue() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendPopJumpIfTrue(to: label) // 0
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .popJumpIfTrue(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendPopJumpIfTrue_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendPopJumpIfTrue(to: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .popJumpIfTrue(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  // MARK: - PopJumpIfFalse

  func test_appendPopJumpIfFalse() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendPopJumpIfFalse(to: label) // 0
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .popJumpIfFalse(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendPopJumpIfFalse_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendPopJumpIfFalse(to: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .popJumpIfFalse(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  // MARK: - JumpIfTrueOrPop

  func test_appendJumpIfTrueOrPop() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label) // 0
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .jumpIfTrueOrPop(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendJumpIfTrueOrPop_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .jumpIfTrueOrPop(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  // MARK: - JumpIfFalseOrPop

  func test_appendJumpIfFalseOrPop() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label) // 0
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .jumpIfFalseOrPop(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendJumpIfFalseOrPop_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .jumpIfFalseOrPop(labelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }
}
