import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderStringTests: XCTestCase {

  // MARK: - FormatValue

  func test_appendFormatValue() {
    let conversions: [Instruction.StringConversion] = [.none, .ascii, .repr, .str]
    let formats = [true, false]

    for c in conversions {
      for f in formats {
        let builder = createBuilder()
        builder.appendFormatValue(conversion: c, hasFormat: f)

        let code = builder.finalize()
        XCTAssertInstructions(code, .formatValue(conversion: c, hasFormat: f))
      }
    }
  }

  // MARK: - BuildString

  func test_appendBuildString() {
    let builder = createBuilder()
    builder.appendBuildString(count: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildString(elementCount: 42))
  }

  func test_appendBuildString_extended() {
    let builder = createBuilder()
    builder.appendBuildString(count: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildString(elementCount: 0))
  }

  func test_appendBuildString_extended2() {
    let builder = createBuilder()
    builder.appendBuildString(count: 0xff_ffff)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(0xff),
                          .extendedArg(0xff),
                          .buildString(elementCount: 0xff))
  }

  func test_appendBuildString_extended3() {
    let builder = createBuilder()
    builder.appendBuildString(count: 0xffff_ffff)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(0xff),
                          .extendedArg(0xff),
                          .extendedArg(0xff),
                          .buildString(elementCount: 0xff))
  }
}
