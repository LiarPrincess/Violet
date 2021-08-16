import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Snow"
  let name = "__White"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Snow__White"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteClosureTests: XCTestCase {

  // MARK: - Cell

  func test_appendLoadClosureCell_mangled() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadClosureCell(name: name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadClosure(cellOrFreeIndex: 0))
  }

  func test_appendLoadClosureCell_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(cellVariableNames: [name])
    builder.appendLoadClosureCell(name: name)
    builder.appendLoadClosureCell(name: name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadClosure(cellOrFreeIndex: 0),
                          .loadClosure(cellOrFreeIndex: 0))
  }

  // MARK: - Free

  func test_appendLoadClosureFree_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadClosureFree(name: name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadClosure(cellOrFreeIndex: 0))
  }

  func test_appendLoadClosureFree_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadClosureFree(name: name)
    builder.appendLoadClosureFree(name: name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadClosure(cellOrFreeIndex: 0),
                          .loadClosure(cellOrFreeIndex: 0))
  }
}
