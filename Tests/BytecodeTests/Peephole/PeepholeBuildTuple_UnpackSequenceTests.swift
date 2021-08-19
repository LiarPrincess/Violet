import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeBuildTupleUnpackSequenceTests: XCTestCase {

  // MARK: - Count 0, 1, 2, 3

  func test_count0_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 0)
    builder.appendUnpackSequence(elementCount: 0)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .return
    )
  }

  func test_count1_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 1)
    builder.appendUnpackSequence(elementCount: 1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .return
    )
  }

  func test_count2_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendBuildTuple(elementCount: 2)
    builder.appendUnpackSequence(elementCount: 2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .rotTwo,
      .return
    )
  }

  func test_count3_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendNone()
    builder.appendBuildTuple(elementCount: 3)
    builder.appendUnpackSequence(elementCount: 3)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .none)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .loadConst(index: 2),
      .rotThree,
      .rotTwo,
      .return
    )
  }

  // MARK: - Count 4, 256

  func test_count4_doesNothing() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendBuildTuple(elementCount: 4)
    builder.appendUnpackSequence(elementCount: 4)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .none, .ellipsis)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .loadConst(index: 2),
      .loadConst(index: 3),
      .buildTuple(elementCount: 4),
      .unpackSequence(elementCount: 4),
      .return
    )
  }

  func test_count256_doesNothing() {
    let builder = createBuilder()
    add255IntegerConstants(builder: builder)
    builder.appendTrue()
    builder.appendBuildTuple(elementCount: 256)
    builder.appendUnpackSequence(elementCount: 256)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstantAtIndex256(code, .true)

    var instrucions = getInstructionsWith255IntegerConstants()
    instrucions.append(contentsOf: [
      .extendedArg(1), // 256
      .loadConst(index: 0), // 257
      .extendedArg(1), // 258
      .buildTuple(elementCount: 0), // 259
      .extendedArg(1), // 260
      .unpackSequence(elementCount: 0), // 261
      .return // 262
    ])

    XCTAssertInstructions(code, instrucions)
  }

  // MARK: - Unequal count

  func test_tupleCount3_sequenceCount4_doesNothing() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendBuildTuple(elementCount: 3)
    builder.appendUnpackSequence(elementCount: 4)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .none, .ellipsis)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .loadConst(index: 2),
      .loadConst(index: 3),
      .buildTuple(elementCount: 3),
      .unpackSequence(elementCount: 4),
      .return
    )
  }

  func test_tupleCount4_sequenceCount3_doesNothing() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendBuildTuple(elementCount: 4)
    builder.appendUnpackSequence(elementCount: 3)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertConstants(code, .true, .false, .none, .ellipsis)
    XCTAssertInstructions(
      code,
      .loadConst(index: 0),
      .loadConst(index: 1),
      .loadConst(index: 2),
      .loadConst(index: 3),
      .buildTuple(elementCount: 4),
      .unpackSequence(elementCount: 3),
      .return
    )
  }
}
