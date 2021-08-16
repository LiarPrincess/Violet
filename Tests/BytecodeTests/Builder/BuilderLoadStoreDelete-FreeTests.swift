import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Olympus"
  let name = "__Hercules"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Olympus__Hercules"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteFreeTests: XCTestCase {

  // MARK: - Store

  func test_appendStoreCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendStoreFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .storeCellOrFree(cellOrFreeIndex: 0))
  }

  func test_appendStoreCell_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendStoreFree(name)
    builder.appendStoreFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .storeCellOrFree(cellOrFreeIndex: 0),
                          .storeCellOrFree(cellOrFreeIndex: 0))
  }

  // MARK: - Load

  func test_appendLoadCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadCellOrFree(cellOrFreeIndex: 0))
  }

  func test_appendLoadCell_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadFree(name)
    builder.appendLoadFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadCellOrFree(cellOrFreeIndex: 0),
                          .loadCellOrFree(cellOrFreeIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDeleteCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendDeleteFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .deleteCellOrFree(cellOrFreeIndex: 0))
  }

  func test_appendDeleteCell_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendDeleteFree(name)
    builder.appendDeleteFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .deleteCellOrFree(cellOrFreeIndex: 0),
                          .deleteCellOrFree(cellOrFreeIndex: 0))
  }
}
