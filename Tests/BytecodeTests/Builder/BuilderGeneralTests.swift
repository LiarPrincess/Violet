import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderGeneralTests: XCTestCase {

  // MARK: - Nop

  func test_appendNop() {
    let builder = createBuilder()
    builder.appendNop()

    // 'nop' will be removed if we use peephole optimizer.
    let code = builder.finalize(usePeepholeOptimizer: false)
    XCTAssertInstructions(code, .nop)
  }

  // MARK: - Pop

  func test_appendPopTop() {
    let builder = createBuilder()
    builder.appendPopTop()

    let code = builder.finalize()
    XCTAssertInstructions(code, .popTop)
  }

  // MARK: - Rot

  func test_appendRotTwo() {
    let builder = createBuilder()
    builder.appendRotTwo()

    let code = builder.finalize()
    XCTAssertInstructions(code, .rotTwo)
  }

  func test_appendRotThree() {
    let builder = createBuilder()
    builder.appendRotThree()

    let code = builder.finalize()
    XCTAssertInstructions(code, .rotThree)
  }

  // MARK: - Dup

  func test_appendDupTop() {
    let builder = createBuilder()
    builder.appendDupTop()

    let code = builder.finalize()
    XCTAssertInstructions(code, .dupTop)
  }

  func test_appendDupTopTwo() {
    let builder = createBuilder()
    builder.appendDupTopTwo()

    let code = builder.finalize()
    XCTAssertInstructions(code, .dupTopTwo)
  }

  // MARK: - Print

  func test_appendPrintExpr() {
    let builder = createBuilder()
    builder.appendPrintExpr()

    let code = builder.finalize()
    XCTAssertInstructions(code, .printExpr)
  }

  // MARK: - Annotations

  func test_appendSetupAnnotations() {
    let builder = createBuilder()
    builder.appendSetupAnnotations()

    let code = builder.finalize()
    XCTAssertInstructions(code, .setupAnnotations)
  }

  // MARK: - Pop block

  func test_appendPopBlock() {
    let builder = createBuilder()
    builder.appendPopBlock()

    let code = builder.finalize()
    XCTAssertInstructions(code, .popBlock)
  }

  // MARK: - Slice

  func test_appendBuildSlice() {
    let values: [Instruction.SliceArg] = [.lowerUpper, .lowerUpperStep]

    for v in values {
      let builder = createBuilder()
      builder.appendBuildSlice(arg: v)

      let code = builder.finalize()
      XCTAssertInstructions(code, .buildSlice(type: v))
    }
  }

   // MARK: - ExtendedArg

  func test_appendExtendedArg() {
    let values: [UInt8] = [0, 1, 128, 254, 255]

    for v in values {
      let builder = createBuilder()
      builder.appendExtendedArg(value: v)

      // trailing 'extendedArg' will be removed if we used peephole optimizer.
      let code = builder.finalize(usePeepholeOptimizer: false)
      XCTAssertInstructions(code, .extendedArg(v))
    }
  }

  func test_appendExtendedArg_multipleInRow() {
    let values: [UInt8] = [0, 1, 128, 254, 255]

    let builder = createBuilder()
    for v in values {
      builder.appendExtendedArg(value: v)
    }

    // trailing 'extendedArg' will be removed if we used peephole optimizer.
    let code = builder.finalize(usePeepholeOptimizer: false)

    for (index, v) in values.enumerated() {
      builder.appendExtendedArg(value: v)
      XCTAssertEqual(code.instructions[index], .extendedArg(v))
    }
  }
}
