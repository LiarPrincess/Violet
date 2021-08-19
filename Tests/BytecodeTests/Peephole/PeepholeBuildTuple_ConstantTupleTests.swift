import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private let constants: [CodeObject.Constant] = [
  .true,
  .false,
  .none,
  .ellipsis,
  .integer(BigInt(-1)),
  .integer(BigInt()),
  .integer(BigInt(1)),
  .float(-1.0),
  .float(0),
  .float(1.0),
  .complex(real: 0.0, imag: 0.0),
  .complex(real: 1.0, imag: 0.0),
  .complex(real: 0.0, imag: 1.0),
  .string(""),
  .string("Elsa"),
  .bytes(Data()),
  // .code(CodeObject),
  .tuple([.true, .false, .none, .integer(BigInt(5))])
]

class PeepholeBuildTupleConstantTupleTests: XCTestCase {

  // MARK: - Small count

  func test_count0() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 0)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .buildTuple(elementCount: 0),
      .return
    )
  }

  func test_count1() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .tuple([.false]))
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 2),
      .return
    )
  }

  func test_count1_lastInstruction() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 1)

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .tuple([.false]))
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 2)
    )
  }

  func test_count2() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .tuple([.true, .false]))
    XCTAssertInstructions(
      code,
      .loadConst(index: 2),
      .return
    )
  }

  // MARK: - Different types

  func test_count1_differentConstantTypes() {
    for constant in constants {
      let builder = createBuilder()
      builder.appendConstant(constant)
      builder.appendBuildTuple(elementCount: 1)
      builder.appendReturn()

      let code = builder.finalize()
      XCTAssertNoLabels(code)
      XCTAssertConstants(code, constant, .tuple([constant]))
      XCTAssertInstructions(
        code,
        .loadConst(index: 1),
        .return
      )
    }
  }

  // MARK: - Extended

  func test_count256_createsExtendedLoadConst() {
    let builder = createBuilder()
    add256IntegerConstants(builder: builder)
    builder.appendBuildTuple(elementCount: 256) // extended(1), loadConst(0)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertInstructions(
      code,
      .extendedArg(1),
      .loadConst(index: 0),
      .return
    )
  }

  func test_count257_extendedConstant_createsExtendedLoadConst() {
    let builder = createBuilder()
    add256IntegerConstants(builder: builder)
    builder.appendTrue() // extended(1), loadConst(0)
    builder.appendBuildTuple(elementCount: 257) // extended(1), loadConst(1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertInstructions(
      code,
      .extendedArg(1),
      .loadConst(index: 1),
      .return
    )
  }

  // MARK: - Space

  func test_count1_thatRequiresDoubleExtended_whenThereIsNoSpace_fails() {
    let builder = createBuilder()
    // 'True' will get index '0'
    builder.appendTrue()
    // Add 65536 dummy constants to take slots
    add65536IntegerConstants(builder: builder, value: 0)
    // loadConst(0)
    // buildTuple(1) -> 2 slots, but loadConst(65537) would need 3
    builder.appendTrue()
    builder.appendBuildTuple(elementCount: 1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertInstructionsEndWith(
      code,
      .loadConst(index: 0),
      .buildTuple(elementCount: 1), // Not optimized!
      .return
    )
  }

  // MARK: - Nop

  func test_ignoresNop() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendNop()
    builder.appendFalse()
    builder.appendNop()
    builder.appendNop()
    builder.appendBuildTuple(elementCount: 2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .tuple([.true, .false]))
    XCTAssertInstructions(
      code,
      .loadConst(index: 2),
      .return
    )
  }
}
