import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderGeneratorTests: XCTestCase {

  // MARK: - Yield

  func test_appendYieldValue() {
    let builder = createBuilder()
    builder.appendYieldValue()

    let code = builder.finalize()
    XCTAssertInstructions(code, .yieldValue)
  }

  func test_appendYieldFrom() {
    let builder = createBuilder()
    builder.appendYieldFrom()

    let code = builder.finalize()
    XCTAssertInstructions(code, .yieldFrom)
  }

  // MARK: - Await

  func test_appendGetAwaitable() {
    let builder = createBuilder()
    builder.appendGetAwaitable()

    let code = builder.finalize()
    XCTAssertInstructions(code, .getAwaitable)
  }

  func test_appendGetAIter() {
    let builder = createBuilder()
    builder.appendGetAIter()

    let code = builder.finalize()
    XCTAssertInstructions(code, .getAIter)
  }

  func test_appendGetANext() {
    let builder = createBuilder()
    builder.appendGetANext()

    let code = builder.finalize()
    XCTAssertInstructions(code, .getANext)
  }
}
