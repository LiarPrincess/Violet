import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class PeepholeBuildTupleUnpackSequenceTests: XCTestCase {

  // MARK: - Count 0, 1, 2, 3

  func test_count0_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendBuildTuple(elementCount: 0)
    builder.appendUnpackSequence(elementCount: 0)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .return
    )
  }

  func test_count1_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendBuildTuple(elementCount: 1)
    builder.appendUnpackSequence(elementCount: 1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .return
    )
  }

  func test_count2_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendBuildTuple(elementCount: 2)
    builder.appendUnpackSequence(elementCount: 2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .rotTwo,
      .return
    )
  }

  func test_count3_justLoadsConstants() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendNone()
    builder.appendBuildTuple(elementCount: 3)
    builder.appendUnpackSequence(elementCount: 3)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .loadConst(index: 0),
      .rotThree,
      .rotTwo,
      .return
    )
  }

  // MARK: - Count 4, 256

  func test_count4_doesNothing() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendBuildTuple(elementCount: 4)
    builder.appendUnpackSequence(elementCount: 4)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertConstants(code, .none, .ellipsis)
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .loadConst(index: 0),
      .loadConst(index: 1),
      .buildTuple(elementCount: 4),
      .unpackSequence(elementCount: 4),
      .return
    )
  }

  func test_count256_doesNothing() {
    // We need at least 1 non-constant, otherwise it would be folded to tuple
    // constant.

    let builder = createBuilder()
    add256IntegerConstants(builder: builder)
    builder.appendLoadName("Ariel")
    builder.appendBuildTuple(elementCount: 256)
    builder.appendUnpackSequence(elementCount: 256)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel")

    XCTAssertInstructionsEndWith(
      code,
      .loadName(nameIndex: 0), // 0
      .extendedArg(1), // 1
      .buildTuple(elementCount: 0), // 2
      .extendedArg(1), // 3
      .unpackSequence(elementCount: 0), // 4
      .return // 5
    )
  }

  // MARK: - Unequal count

  func test_tupleCount3_sequenceCount4_doesNothing() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendBuildTuple(elementCount: 3)
    builder.appendUnpackSequence(elementCount: 4)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertConstants(code, .none, .ellipsis)
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .loadConst(index: 0),
      .loadConst(index: 1),
      .buildTuple(elementCount: 3),
      .unpackSequence(elementCount: 4),
      .return
    )
  }

  func test_tupleCount4_sequenceCount3_doesNothing() {
    let builder = createBuilder()
    builder.appendLoadName("Ariel")
    builder.appendLoadName("Eric")
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendBuildTuple(elementCount: 4)
    builder.appendUnpackSequence(elementCount: 3)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertNoLabels(code)
    XCTAssertNames(code, "Ariel", "Eric")
    XCTAssertConstants(code, .none, .ellipsis)
    XCTAssertInstructions(
      code,
      .loadName(nameIndex: 0),
      .loadName(nameIndex: 1),
      .loadConst(index: 0),
      .loadConst(index: 1),
      .buildTuple(elementCount: 4),
      .unpackSequence(elementCount: 3),
      .return
    )
  }
}
