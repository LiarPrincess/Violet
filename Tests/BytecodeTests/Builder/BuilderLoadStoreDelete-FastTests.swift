import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Paris"
  let name = "__Esmeralda"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Paris__Esmeralda"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteFastTests: XCTestCase {

  // MARK: - Store

  func test_appendStoreFast_mangled() {
    let name = createMangledName()

    let builder = createBuilder(variableNames: [name])
    builder.appendStoreFast(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .storeFast(variableIndex: 0))
  }

  func test_appendStoreFast_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(variableNames: [name])
    builder.appendStoreFast(name)
    builder.appendStoreFast(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .storeFast(variableIndex: 0),
                          .storeFast(variableIndex: 0))
  }

  // MARK: - Load

  func test_appendLoadFast_mangled() {
    let name = createMangledName()

    let builder = createBuilder(variableNames: [name])
    builder.appendLoadFast(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadFast(variableIndex: 0))
  }

  func test_appendLoadFast_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(variableNames: [name])
    builder.appendLoadFast(name)
    builder.appendLoadFast(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadFast(variableIndex: 0),
                          .loadFast(variableIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDeleteFast_mangled() {
    let name = createMangledName()

    let builder = createBuilder(variableNames: [name])
    builder.appendDeleteFast(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .deleteFast(variableIndex: 0))
  }

  func test_appendDeleteFast_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(variableNames: [name])
    builder.appendDeleteFast(name)
    builder.appendDeleteFast(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .deleteFast(variableIndex: 0),
                          .deleteFast(variableIndex: 0))
  }
}
