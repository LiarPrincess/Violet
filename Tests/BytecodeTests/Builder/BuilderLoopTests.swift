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
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(code,
                          .setupLoop(loopEndLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendSetupLoop_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendSetupLoop(loopEnd: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .setupLoop(loopEndLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
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
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(code,
                          .forIter(ifEmptyLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendForIter_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendForIter(ifEmpty: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .forIter(ifEmptyLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
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
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    // Jump to 2, does not make sense, but this is where we called 'setLabel'.
    XCTAssertLabelTargets(code, 2)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(code,
                          .continue(loopStartLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }

  func test_appendContinue_extended() {
    let builder = createBuilder()
    add256Labels(builder: builder)

    let label = builder.createLabel()
    builder.appendContinue(loopStartLabel: label) // 0 (extended Arg), 1
    builder.appendTrue() // 1
    builder.setLabel(label)
    builder.appendFalse() // 2

    let code = builder.finalize()
    XCTAssertLabelAtIndex256(code, instructionIndex: 3)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .continue(loopStartLabelIndex: 0),
                          .loadConst(index: 0),
                          .loadConst(index: 1))
  }
}
