import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

/// Tests that do not depend on any optimizations.
class PeepholeTests: XCTestCase {

  func test_noInstructions_doNotCrash() {
    let builder = createBuilder()
    let code = builder.finalize()
    XCTAssertNoInstructions(code)
  }

  func test_onlyNop_producesEmpty() {
    let builder = createBuilder()
    builder.appendNop()
    builder.appendNop()
    builder.appendNop()

    let code = builder.finalize()
    XCTAssertNoInstructions(code)
  }

  func test_extendedArg1_withoutInstructions_generatesNoCode() {
    let builder = createBuilder()
    builder.appendExtendedArg(value: 42)

    let code = builder.finalize()
    XCTAssertNoInstructions(code)
  }

  func test_extendedArg2_withoutInstructions_generatesNoCode() {
    let builder = createBuilder()
    builder.appendExtendedArg(value: 42)
    builder.appendExtendedArg(value: 43)

    let code = builder.finalize()
    XCTAssertNoInstructions(code)
  }

  func test_extendedArg3_withoutInstructions_generatesNoCode() {
    let builder = createBuilder()
    builder.appendExtendedArg(value: 42)
    builder.appendExtendedArg(value: 43)
    builder.appendExtendedArg(value: 44)

    let code = builder.finalize()
    XCTAssertNoInstructions(code)
  }
}
