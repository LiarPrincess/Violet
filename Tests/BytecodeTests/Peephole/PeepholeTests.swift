import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

/// Tests that do not depend on any optimizations.
class PeepholeTests: XCTestCase {

  func test_extendedArg_withoutInstructions_generatesNoCode() {
    let values: [UInt8] = [0, 1, 128, 254, 255]

    for v in values {
      let builder = createBuilder()
      builder.appendExtendedArg(value: v)

      let code = builder.finalize()
      XCTAssertNoInstructions(code)
    }
  }
}
