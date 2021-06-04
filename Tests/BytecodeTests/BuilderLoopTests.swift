import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderLoopTests: XCTestCase {

  // MARK: - SetupLoop

  func test_appendSetupLoop() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendSetupLoop(loopEnd: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .setupLoop(loopEndLabel: 0),
                          .nop,
                          .nop)
  }

  func test_appendSetupLoop_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendSetupLoop(loopEnd: label) // 0 (extended Arg), 1
    builder.appendNop() // 2
    builder.setLabel(label)
    builder.appendNop() // 3

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .setupLoop(loopEndLabel: 0),
                          .nop,
                          .nop)
  }

  // MARK: - GetIter

  func test_appendGetIter() {
    let builder = createBuilder()
    builder.appendGetIter()

    let code = builder.finalize()
    XCTAssertInstructions(code, .getIter)
  }

  // MARK: - ForIter

  func test_appendForIter() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendForIter(ifEmpty: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .forIter(ifEmptyLabel: 0),
                          .nop,
                          .nop)
  }

  func test_appendForIter_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendForIter(ifEmpty: label) // 0 (extended Arg), 1
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .forIter(ifEmptyLabel: 0),
                          .nop,
                          .nop)
  }

  // MARK: - GetYieldFromIter

  func test_GetYieldFromIter() {
    let builder = createBuilder()
    builder.appendGetYieldFromIter()

    let code = builder.finalize()
    XCTAssertInstructions(code, .getYieldFromIter)
  }

  // MARK: - Break

  func test_appendBreak() {
    let builder = createBuilder()
    builder.appendBreak()

    let code = builder.finalize()
    XCTAssertInstructions(code, .break)
  }

  // MARK: - Continue

  func test_appendContinue() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendContinue(loopStartLabel: label) // 0
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertInstructions(code,
                          .continue(loopStartLabel: 0),
                          .nop,
                          .nop)
  }

  func test_appendContinue_extended() {
    let builder = createBuilder()
    add255Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendContinue(loopStartLabel: label) // 0 (extended Arg), 1
    builder.appendNop() // 1
    builder.setLabel(label)
    builder.appendNop() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, jumpAddress: 3)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .continue(loopStartLabel: 0),
                          .nop,
                          .nop)
  }
}
