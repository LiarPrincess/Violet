import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderLoadStoreDeleteSubscriptTests: XCTestCase {

  func test_appendBinarySubscript() {
    let builder = createBuilder()
    builder.appendBinarySubscript()

    let code = builder.finalize()
    XCTAssertInstructions(code, .binarySubscript)
  }

  func test_appendStoreSubscript() {
    let builder = createBuilder()
    builder.appendStoreSubscript()

    let code = builder.finalize()
    XCTAssertInstructions(code, .storeSubscript)
  }

  func test_appendDeleteSubscript() {
    let builder = createBuilder()
    builder.appendDeleteSubscript()

    let code = builder.finalize()
    XCTAssertInstructions(code, .deleteSubscript)
  }
}
