import XCTest
import VioletCore
@testable import VioletBytecode

class BuilderOperationsTests: XCTestCase {

  // MARK: - Compare

  func test_appendCompareOp() {
    let operations: [Instruction.CompareType] = [
      .equal, .notEqual,
      .less, .lessEqual,
      .greater, .greaterEqual,
      .is, .isNot,
      .in, .notIn,
      .exceptionMatch
    ]

    for op in operations {
      let builder = createBuilder()
      builder.appendCompareOp(type: op)

      let code = builder.finalize()
      XCTAssertInstructions(code, .compareOp(type: op))
    }
  }

  // MARK: - Unary

  func test_appendUnaryPositive() {
    let builder = createBuilder()
    builder.appendUnaryPositive()

    let code = builder.finalize()
    XCTAssertInstructions(code, .unaryPositive)
  }

  func test_appendUnaryNegative() {
    let builder = createBuilder()
    builder.appendUnaryNegative()

    let code = builder.finalize()
    XCTAssertInstructions(code, .unaryNegative)
  }

  func test_appendUnaryNot() {
    let builder = createBuilder()
    builder.appendUnaryNot()

    let code = builder.finalize()
    XCTAssertInstructions(code, .unaryNot)
  }

  func test_appendUnaryInvert() {
    let builder = createBuilder()
    builder.appendUnaryInvert()

    let code = builder.finalize()
    XCTAssertInstructions(code, .unaryInvert)
  }

  // MARK: - Binary

  func test_appendBinaryPower() {
    let builder = createBuilder()
    builder.appendBinaryPower()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryPower)
  }

  func test_appendBinaryMultiply() {
    let builder = createBuilder()
    builder.appendBinaryMultiply()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryMultiply)
  }

  func test_appendBinaryMatrixMultiply() {
    let builder = createBuilder()
    builder.appendBinaryMatrixMultiply()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryMatrixMultiply)
  }

  func test_appendBinaryFloorDivide() {
    let builder = createBuilder()
    builder.appendBinaryFloorDivide()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryFloorDivide)
  }

  func test_appendBinaryTrueDivide() {
    let builder = createBuilder()
    builder.appendBinaryTrueDivide()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryTrueDivide)
  }

  func test_appendBinaryModulo() {
    let builder = createBuilder()
    builder.appendBinaryModulo()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryModulo)
  }

  func test_appendBinaryAdd() {
    let builder = createBuilder()
    builder.appendBinaryAdd()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryAdd)
  }

  func test_appendBinarySubtract() {
    let builder = createBuilder()
    builder.appendBinarySubtract()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binarySubtract)
  }

  // MARK: - Binary - Shift

  func test_appendBinaryLShift() {
    let builder = createBuilder()
    builder.appendBinaryLShift()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryLShift)
  }

  func test_appendBinaryRShift() {
    let builder = createBuilder()
    builder.appendBinaryRShift()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryRShift)
  }

  // MARK: - Binary - Bit

  func test_appendBinaryAnd() {
    let builder = createBuilder()
    builder.appendBinaryAnd()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryAnd)
  }

  func test_appendBinaryXor() {
    let builder = createBuilder()
    builder.appendBinaryXor()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryXor)
  }

  func test_appendBinaryOr() {
    let builder = createBuilder()
    builder.appendBinaryOr()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binaryOr)
  }

  // MARK: - InPlace

  func test_appendInPlacePower() {
    let builder = createBuilder()
    builder.appendInPlacePower()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlacePower)
  }

  func test_appendInPlaceMultiply() {
    let builder = createBuilder()
    builder.appendInPlaceMultiply()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceMultiply)
  }

  func test_appendInPlaceMatrixMultiply() {
    let builder = createBuilder()
    builder.appendInPlaceMatrixMultiply()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceMatrixMultiply)
  }

  func test_appendInPlaceFloorDivide() {
    let builder = createBuilder()
    builder.appendInPlaceFloorDivide()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceFloorDivide)
  }

  func test_appendInPlaceTrueDivide() {
    let builder = createBuilder()
    builder.appendInPlaceTrueDivide()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceTrueDivide)
  }

  func test_appendInPlaceModulo() {
    let builder = createBuilder()
    builder.appendInPlaceModulo()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceModulo)
  }

  func test_appendInPlaceAdd() {
    let builder = createBuilder()
    builder.appendInPlaceAdd()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceAdd)
  }

  func test_appendInPlaceSubtract() {
    let builder = createBuilder()
    builder.appendInPlaceSubtract()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceSubtract)
  }

  // MARK: - InPlace - Shift

  func test_appendInPlaceLShift() {
    let builder = createBuilder()
    builder.appendInPlaceLShift()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceLShift)
  }

  func test_appendInPlaceRShift() {
    let builder = createBuilder()
    builder.appendInPlaceRShift()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceRShift)
  }

  // MARK: - InPlace - Bit

  func test_appendInPlaceAnd() {
    let builder = createBuilder()
    builder.appendInPlaceAnd()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceAnd)
  }

  func test_appendInPlaceXor() {
    let builder = createBuilder()
    builder.appendInPlaceXor()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceXor)
  }

  func test_appendInPlaceOr() {
    let builder = createBuilder()
    builder.appendInPlaceOr()

    let code = builder.finalize()
    XCTAssertInstructions(code, .inPlaceOr)
  }
}
