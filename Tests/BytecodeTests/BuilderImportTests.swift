import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderImportTests: XCTestCase {

  // MARK: - Name

  func test_appendImportName() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendImportName(name: name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .importName(nameIndex: 0))
  }

  func test_appendImportName_nameIsReused() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendImportName(name: name)
    builder.appendImportName(name: name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .importName(nameIndex: 0),
                          .importName(nameIndex: 0))
  }

  // MARK: - Star

  func test_appendImportStar() {
    let builder = createBuilder()
    builder.appendImportStar()

    let code = builder.finalize()
    XCTAssertInstructions(code, .importStar)
  }

  // MARK: - From

  func test_appendImportFrom() {
    let name = "Beast"

    let builder = createBuilder()
    builder.appendImportFrom(name: name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .importFrom(nameIndex: 0))
  }

  func test_appendImportFrom_nameIsReused() {
    let name = "Beast"

    let builder = createBuilder()
    builder.appendImportFrom(name: name)
    builder.appendImportFrom(name: name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .importFrom(nameIndex: 0),
                          .importFrom(nameIndex: 0))
  }
}
