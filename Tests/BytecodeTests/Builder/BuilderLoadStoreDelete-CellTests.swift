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

  func test_appendStoreCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendStoreCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .storeCell(cellIndex: 0))
  }

  func test_appendStoreCell_mangled_isReused() {
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

  func test_appendLoadCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadCell(cellIndex: 0))
  }

  func test_appendLoadCell_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadCell(name)
    builder.appendLoadCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadCell(cellIndex: 0),
                          .loadCell(cellIndex: 0))
  }

  // MARK: - Load - class cell

  func test_appendLoadClassCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadClassCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadClassCell(cellIndex: 0))
  }

  func test_appendLoadClassCell_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadClassCell(name)
    builder.appendLoadClassCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadClassCell(cellIndex: 0),
                          .loadClassCell(cellIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDeleteCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendDeleteCell(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .deleteCell(cellIndex: 0))
  }

  func test_appendDeleteCell_mangled_isReused() {
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
