import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderFunctionTests: XCTestCase {

  // MARK: - Make

  func test_appendMakeFunction_noFlags() {
    let flags = Instruction.FunctionFlags()

    let builder = createBuilder()
    builder.appendMakeFunction(flags: flags)

    let code = builder.finalize()
    XCTAssertInstructions(code, .makeFunction(flags: flags))
  }

  func test_appendMakeFunction_allFlags() {
    let flags = Instruction.FunctionFlags(rawValue: 0xff)

    let builder = createBuilder()
    builder.appendMakeFunction(flags: flags)

    let code = builder.finalize()
    XCTAssertInstructions(code, .makeFunction(flags: flags))
  }

  // MARK: - Call function

  func test_appendCallFunction() {
    let builder = createBuilder()
    builder.appendCallFunction(argumentCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .callFunction(argumentCount: 42))
  }

  func test_appendCallFunction_extended() {
    let builder = createBuilder()
    builder.appendCallFunction(argumentCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .callFunction(argumentCount: 0))
  }

  // MARK: - Call function kw

  func test_appendCallFunctionKw() {
    let builder = createBuilder()
    builder.appendCallFunctionKw(argumentCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .callFunctionKw(argumentCount: 42))
  }

  func test_appendCallFunctionKw_extended() {
    let builder = createBuilder()
    builder.appendCallFunctionKw(argumentCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .callFunctionKw(argumentCount: 0))
  }

  // MARK: - Call function ex

  func test_appendCallFunctionEx_no() {
    let values = [true, false]

    for v in values {
      let builder = createBuilder()
      builder.appendCallFunctionEx(hasKeywordArguments: v)

      let code = builder.finalize()
      XCTAssertInstructions(code, .callFunctionEx(hasKeywordArguments: v))
    }
  }

  // MARK: - Load

  func test_appendLoadMethod() {
    // https://www.youtube.com/watch?v=TrRbB-qUJfY
    let name = "kiss_the_girl"

    let builder = createBuilder()
    builder.appendLoadMethod(name: name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .loadMethod(nameIndex: 0))
  }

  func test_appendLoadMethod_nameIsReused() {
    // https://www.youtube.com/watch?v=TrRbB-qUJfY
    let name = "kiss_the_girl"

    let builder = createBuilder()
    builder.appendLoadMethod(name: name)
    builder.appendLoadMethod(name: name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .loadMethod(nameIndex: 0),
                          .loadMethod(nameIndex: 0))
  }

  // MARK: - Call method

  func test_appendCallMethod() {
    let builder = createBuilder()
    builder.appendCallMethod(argumentCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .callMethod(argumentCount: 42))
  }

  func test_appendCallMethod_extended() {
    let builder = createBuilder()
    builder.appendCallMethod(argumentCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .callMethod(argumentCount: 0))
  }

  // MARK: - Return

  func test_appendReturn() {
    let builder = createBuilder()
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertInstructions(code, .return)
  }
}
