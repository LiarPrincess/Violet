import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Hundred-Acre-Wood"
  let name = "__Winnie-the-Pooh"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Hundred-Acre-Wood__Winnie-the-Pooh"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteCellTests: XCTestCase {

  // MARK: - Store

  func test_appendStore_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendStoreCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .storeCell(cellIndex: 0))
  }

  func test_appendStore_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendStoreCell(name)
    builder.appendStoreCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .storeCell(cellIndex: 0),
                          .storeCell(cellIndex: 0))
  }

  // MARK: - Load

  func test_appendLoad_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadCell(cellIndex: 0))
  }

  func test_appendLoad_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadCell(name)
    builder.appendLoadCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadCell(cellIndex: 0),
                          .loadCell(cellIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDelete_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendDeleteCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .deleteCell(cellIndex: 0))
  }

  func test_appendDelete_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendDeleteCell(name)
    builder.appendDeleteCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .deleteCell(cellIndex: 0),
                          .deleteCell(cellIndex: 0))
  }
}
