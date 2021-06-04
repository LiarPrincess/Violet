import XCTest
import VioletCore
@testable import VioletBytecode

// swiftlint:disable:next type_name
class BuilderConstantsUsesScalarsForStringsTests: XCTestCase {

  // See comment above 'UseScalarsToHashString' for details.
  func test_string_usesScalars_toDifferentiateStrings() {
    let s0 = "é"
    let s1 = "e\u{0301}"
    XCTAssertEqual(s0, s1) // Equal according to Swift

    let builder = createBuilder()
    builder.appendString(s0)
    builder.appendString(s1)

    let code = builder.finalize()
    XCTAssertConstants(code, .string(s0), .string(s1))
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 1))
  }
}
