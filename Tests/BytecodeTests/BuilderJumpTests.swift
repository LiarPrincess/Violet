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
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .jumpAbsolute(labelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendJumpAbsolute_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendJumpAbsolute(to: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .jumpAbsolute(labelIndex: 0),
                          .nop,
                          .nop)
  }

  // MARK: - PopJumpIfTrue

  func test_appendPopJumpIfTrue() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendPopJumpIfTrue(to: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .popJumpIfTrue(labelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendPopJumpIfTrue_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendPopJumpIfTrue(to: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .popJumpIfTrue(labelIndex: 0),
                          .nop,
                          .nop)
  }

  // MARK: - PopJumpIfFalse

  func test_appendPopJumpIfFalse() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendPopJumpIfFalse(to: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .popJumpIfFalse(labelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendPopJumpIfFalse_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendPopJumpIfFalse(to: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .popJumpIfFalse(labelIndex: 0),
                          .nop,
                          .nop)
  }

  // MARK: - JumpIfTrueOrPop

  func test_appendJumpIfTrueOrPop() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .jumpIfTrueOrPop(labelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendJumpIfTrueOrPop_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .jumpIfTrueOrPop(labelIndex: 0),
                          .nop,
                          .nop)
  }

  // MARK: - JumpIfFalseOrPop

  func test_appendJumpIfFalseOrPop() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .jumpIfFalseOrPop(labelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendJumpIfFalseOrPop_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .jumpIfFalseOrPop(labelIndex: 0),
                          .nop,
                          .nop)
  }
}
