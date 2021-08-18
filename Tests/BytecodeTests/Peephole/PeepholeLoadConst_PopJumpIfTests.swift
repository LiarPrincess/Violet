import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

// swiftlint:disable file_length

class PeepholeLoadConstPopJumpIfTests: XCTestCase {

  // MARK: - PopJumpIfFalse - true

  func test_loadConst_popJumpIfFalse_onTrueConstant_removesCheck() {
    // if true:
    //     return 5
    // return None

    for trueConstant in trueConstants {
      let builder = createBuilder()
      let label = builder.createLabel()
      builder.appendConstant(trueConstant)
      builder.appendPopJumpIfFalse(to: label)
      builder.appendInteger(BigInt(5))
      builder.appendReturn()

      builder.setLabel(label)
      builder.appendNone()
      builder.appendReturn()

      let code = builder.finalize()
      // Label should be re-targeted, but we will not use it anyway.
      XCTAssertLabelTargets(code, 2)
      XCTAssertConstants(
        code,
        trueConstant,
        .integer(BigInt(5)),
        .none
      )
      XCTAssertInstructions(
        code,
        // No jump here
        .loadConst(index: 1),
        .return,
        // Other branch has to stay because we do not do any control flow analysis
        .loadConst(index: 2),
        .return
      )
    }
  }

  func test_loadConst_extended_popJumpIfFalse_onTrueConstant_removesCheck() {
    // if true:
    //     return 5
    // return None

    let builder = createBuilder()
    add255IntegerConstants(builder: builder)
    let label = builder.createLabel()
    builder.appendTrue()
    builder.appendPopJumpIfFalse(to: label)
    builder.appendInteger(BigInt(5))
    builder.appendReturn()

    builder.setLabel(label)
    builder.appendNone()
    builder.appendReturn()

    let code = builder.finalize()
    // Label should be re-targeted, but we will not use it anyway.
    XCTAssertLabelTargets(code, 259)
    XCTAssertConstantAtIndex256(code, .true)

    var instructions = getInstructionsWith255IntegerConstants()
    instructions.append(contentsOf: [
      // No jump here
      .extendedArg(1), // 256
      .loadConst(index: 1), // 257
      .return, // 258
      // Other branch has to stay because we do not do any control flow analysis
      .extendedArg(1), // 259
      .loadConst(index: 2), // 260
      .return // 262
    ])

    XCTAssertInstructions(code, instructions)
  }

  func test_loadConst_popJumpIfFalse_extended_onTrueConstant_removesCheck() {
    // if true:
    //     return 5
    // return None

    let builder = createBuilder()
    add255Labels(builder: builder)
    let label = builder.createLabel()
    builder.appendTrue()
    builder.appendPopJumpIfFalse(to: label)
    builder.appendInteger(BigInt(5))
    builder.appendReturn()

    builder.setLabel(label)
    builder.appendNone()
    builder.appendReturn()

    let code = builder.finalize()
    // Label should be re-targeted, but we will not use it anyway.
    XCTAssertLabelAtIndex256(code, instructionIndex: 2)
    XCTAssertConstants(
      code,
      .true,
      .integer(BigInt(5)),
      .none
    )
    XCTAssertInstructions(
      code,
      // No jump here
      .loadConst(index: 1), // 0
      .return, // 1
      // Other branch has to stay because we do not do any control flow analysis
      .loadConst(index: 2), // 2
      .return // 3
    )
  }

  // MARK: - PopJumpIfFalse - false

  func test_loadConst_popJumpIfFalse_onFalseConstant_doesNothing() {
    // if false:
    //     return 5
    // return True

    for falseConstant in falseConstants {
      let builder = createBuilder()
      let label = builder.createLabel()
      builder.appendConstant(falseConstant)
      builder.appendPopJumpIfFalse(to: label)
      builder.appendInteger(BigInt(5))
      builder.appendReturn()

      builder.setLabel(label)
      builder.appendTrue()
      builder.appendReturn()

      let code = builder.finalize()
      XCTAssertLabelTargets(code, 4)
      XCTAssertConstants(
        code,
        falseConstant,
        .integer(BigInt(5)),
        .true
      )
      XCTAssertInstructions(
        code,
        .loadConst(index: 0), // 0
        .popJumpIfFalse(labelIndex: 0), // 1
        .loadConst(index: 1), // 2
        .return, // 3
        .loadConst(index: 2), // 4
        .return // 5
      )
    }
  }

  // MARK: - PopJumpIfTrue - false

  func test_loadConst_popJumpIfTrue_onFalseConstant_removesCheck() {
    // if not false:
    //     return 5
    // return True

    for falseConstant in falseConstants {
      let builder = createBuilder()
      let label = builder.createLabel()
      builder.appendConstant(falseConstant)
      builder.appendPopJumpIfTrue(to: label)
      builder.appendInteger(BigInt(5))
      builder.appendReturn()

      builder.setLabel(label)
      builder.appendTrue()
      builder.appendReturn()

      let code = builder.finalize()
      // Label should be re-targeted, but we will not use it anyway.
      XCTAssertLabelTargets(code, 2)
      XCTAssertConstants(
        code,
        falseConstant,
        .integer(BigInt(5)),
        .true
      )
      XCTAssertInstructions(
        code,
        // No jump here
        .loadConst(index: 1), // 0
        .return, // 1
        // Other branch has to stay because we do not do any control flow analysis
        .loadConst(index: 2), // 2
        .return // 3
      )
    }
  }

  func test_loadConst_extended_popJumpIfTrue_onFalseConstant_removesCheck() {
    // if true:
    //     return 5
    // return None

    let builder = createBuilder()
    add255IntegerConstants(builder: builder)
    let label = builder.createLabel()
    builder.appendFalse()
    builder.appendPopJumpIfTrue(to: label)
    builder.appendInteger(BigInt(5))
    builder.appendReturn()

    builder.setLabel(label)
    builder.appendNone()
    builder.appendReturn()

    let code = builder.finalize()
    // Label should be re-targeted, but we will not use it anyway.
    XCTAssertLabelTargets(code, 259)
    XCTAssertConstantAtIndex256(code, .false)

    var instructions = getInstructionsWith255IntegerConstants()
    instructions.append(contentsOf: [
      // No jump here
      .extendedArg(1), // 256
      .loadConst(index: 1), // 257
      .return, // 258
      // Other branch has to stay because we do not do any control flow analysis
      .extendedArg(1), // 259
      .loadConst(index: 2), // 260
      .return // 262
    ])

    XCTAssertInstructions(code, instructions)
  }

  func test_loadConst_popJumpIfTrue_extended_onFalseConstant_removesCheck() {
    // if true:
    //     return 5
    // return None

    let builder = createBuilder()
    add255Labels(builder: builder)
    let label = builder.createLabel()
    builder.appendFalse()
    builder.appendPopJumpIfTrue(to: label)
    builder.appendInteger(BigInt(5))
    builder.appendReturn()

    builder.setLabel(label)
    builder.appendNone()
    builder.appendReturn()

    let code = builder.finalize()
    // Label should be re-targeted, but we will not use it anyway.
    XCTAssertLabelAtIndex256(code, instructionIndex: 2)
    XCTAssertConstants(
      code,
      .false,
      .integer(BigInt(5)),
      .none
    )
    XCTAssertInstructions(
      code,
      // No jump here
      .loadConst(index: 1), // 0
      .return, // 1
      // Other branch has to stay because we do not do any control flow analysis
      .loadConst(index: 2), // 2
      .return // 3
    )
  }

  // MARK: - PopJumpIfTrue - true

  func test_loadConst_popJumpIfTrue_onTrueConstant_doesNothing() {
    // if false:
    //     return 5
    // return False

    for trueConstant in trueConstants {
      let builder = createBuilder()
      let label = builder.createLabel()
      builder.appendConstant(trueConstant)
      builder.appendPopJumpIfTrue(to: label)
      builder.appendInteger(BigInt(5))
      builder.appendReturn()

      builder.setLabel(label)
      builder.appendFalse()
      builder.appendReturn()

      let code = builder.finalize()
      XCTAssertLabelTargets(code, 4)
      XCTAssertConstants(
        code,
        trueConstant,
        .integer(BigInt(5)),
        .false
      )
      XCTAssertInstructions(
        code,
        .loadConst(index: 0), // 0
        .popJumpIfTrue(labelIndex: 0), // 1
        .loadConst(index: 1), // 2
        .return, // 3
        .loadConst(index: 2), // 4
        .return // 5
      )
    }
  }
}
