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

  func test_appendStore_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendStoreFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .storeFree(freeIndex: 0))
  }

  func test_appendStore_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendStoreFree(name)
    builder.appendStoreFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .storeFree(freeIndex: 0),
                          .storeFree(freeIndex: 0))
  }

  // MARK: - Load

  func test_appendLoad_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadFree(freeIndex: 0))
  }

  func test_appendLoad_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadFree(name)
    builder.appendLoadFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadFree(freeIndex: 0),
                          .loadFree(freeIndex: 0))
  }

  // MARK: - Load - class free

  func test_appendLoadClassFree_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadClassFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadClassFree(freeIndex: 0))
  }

  func test_appendLoadClassFree_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendLoadClassFree(name)
    builder.appendLoadClassFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .loadClassFree(freeIndex: 0),
                          .loadClassFree(freeIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDelete_mangled() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendDeleteFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code, .deleteFree(freeIndex: 0))
  }

  func test_appendDelete_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder(freeVariableNames: [name])
    builder.appendDeleteFree(name)
    builder.appendDeleteFree(name)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .deleteFree(freeIndex: 0),
                          .deleteFree(freeIndex: 0))
  }
}
