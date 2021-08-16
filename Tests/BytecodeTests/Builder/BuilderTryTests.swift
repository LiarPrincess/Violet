import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderTryTests: XCTestCase {

  // MARK: - PopExcept

  func test_appendPopExcept() {
    let builder = createBuilder()
    builder.appendPopExcept()

    let code = builder.finalize()
    XCTAssertInstructions(code, .popExcept)
  }

  // MARK: - EndFinally

  func test_appendEndFinally() {
    let builder = createBuilder()
    builder.appendEndFinally()

    let code = builder.finalize()
    XCTAssertInstructions(code, .endFinally)
  }

  // MARK: - SetupExcept

  func test_appendSetupExcept() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendSetupExcept(firstExcept: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .setupExcept(firstExceptLabelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendSetupExcept_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendSetupExcept(firstExcept: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .setupExcept(firstExceptLabelIndex: 0),
                          .nop,
                          .nop)
  }

  // MARK: - SetupFinally

  func test_appendSetupFinally() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendSetupFinally(finallyStart: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .setupFinally(finallyStartLabelIndex: 0),
                          .nop,
                          .nop)
  }

  func test_appendSetupFinally_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendSetupFinally(finallyStart: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .setupFinally(finallyStartLabelIndex: 0),
                          .nop,
                          .nop)
  }

  // MARK: - RaiseVarargs

  func test_appendRaiseVarargs() {
    let values: [Instruction.RaiseArg] = [
      .reRaise,
      .exceptionOnly,
      .exceptionAndCause
    ]

    for v in values {
      let builder = createBuilder()
      builder.appendRaiseVarargs(arg: v)

      let code = builder.finalize()
      XCTAssertInstructions(code, .raiseVarargs(type: v))
    }
  }
}
