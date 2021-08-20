import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeJumpJumpToReturnTests: XCTestCase {

  // MARK: - Jump absolute

  func test_jumpAbsolute_toReturn_justReturns() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpAbsolute(to: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    // This label will not be used, but we can't remove it.
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .return, // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  // MARK: - JumpIf - does nothing

  func test_jumpIfTrueOrPop_toReturn_justReturns() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  func test_jumpIfFalseOrPop_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .jumpIfFalseOrPop(labelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  // MARK: - PopJumpIfFalse - does nothing

  func test_popJumpIfFalse_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendPopJumpIfFalse(to: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .popJumpIfFalse(labelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  func test_popJumpIfTrue_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendPopJumpIfTrue(to: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  // MARK: - Loops - do nothing

   func test_setupLoop_toReturn_doesNothing() {
     let builder = createBuilder()
     let label = builder.createLabel()
     builder.appendSetupLoop(loopEnd: label)
     builder.appendLoadName("Ariel")
     builder.setLabel(label)
     builder.appendReturn()

     let code = builder.finalize()
     XCTAssertLabelTargets(code, 2)
     XCTAssertNames(code, "Ariel")
     XCTAssertInstructions(
       code,
       .setupLoop(loopEndLabelIndex: 0), // 0
       .loadName(nameIndex: 0), // 1
       .return // 2
     )
   }

  func test_forIter_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendForIter(ifEmpty: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .forIter(ifEmptyLabelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  func test_continue_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendContinue(loopStartLabel: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .continue(loopStartLabelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  // MARK: - Exceptions - do nothing

  func test_setupExcept_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendSetupExcept(firstExcept: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .setupExcept(firstExceptLabelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  func test_setupFinally_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendSetupFinally(finallyStart: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .setupFinally(finallyStartLabelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }

  // MARK: - While - do nothing

  func test_setupWith_toReturn_doesNothing() {
    let builder = createBuilder()
    let label = builder.createLabel()
    builder.appendSetupWith(afterBody: label)
    builder.appendLoadName("Ariel")
    builder.setLabel(label)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2)
    XCTAssertNames(code, "Ariel")
    XCTAssertInstructions(
      code,
      .setupWith(afterBodyLabelIndex: 0), // 0
      .loadName(nameIndex: 0), // 1
      .return // 2
    )
  }
}
