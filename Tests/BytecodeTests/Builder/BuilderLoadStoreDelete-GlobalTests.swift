import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Tangled"
  let name = "__Rapunzel"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Tangled__Rapunzel"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteGlobalTests: XCTestCase {

  // MARK: - Store

  func test_appendStoreGlobal() {
    let name = "Rapunzel"

    let builder = createBuilder()
    builder.appendStoreGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .storeGlobal(nameIndex: 0))
  }

  func test_appendStoreGlobal_isReused() {
    let name = "Rapunzel"

    let builder = createBuilder()
    builder.appendStoreGlobal(name)
    builder.appendStoreGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .storeGlobal(nameIndex: 0),
                          .storeGlobal(nameIndex: 0))
  }

  func test_appendStoreGlobal_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendStoreGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .storeGlobal(nameIndex: 0))
  }

  func test_appendStoreGlobal_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendStoreGlobal(name)
    builder.appendStoreGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .storeGlobal(nameIndex: 0),
                          .storeGlobal(nameIndex: 0))
  }

  // MARK: - Load

  func test_appendLoadGlobal() {
    let name = "Rapunzel"

    let builder = createBuilder()
    builder.appendLoadGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .loadGlobal(nameIndex: 0))
  }

  func test_appendLoadGlobal_isReused() {
    let name = "Rapunzel"

    let builder = createBuilder()
    builder.appendLoadGlobal(name)
    builder.appendLoadGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .loadGlobal(nameIndex: 0),
                          .loadGlobal(nameIndex: 0))
  }

  func test_appendLoadGlobal_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendLoadGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .loadGlobal(nameIndex: 0))
  }

  func test_appendLoadGlobal_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendLoadGlobal(name)
    builder.appendLoadGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .loadGlobal(nameIndex: 0),
                          .loadGlobal(nameIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDeleteGlobal() {
    let name = "Rapunzel"

    let builder = createBuilder()
    builder.appendDeleteGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .deleteGlobal(nameIndex: 0))
  }

  func test_appendDeleteGlobal_isReused() {
    let name = "Rapunzel"

    let builder = createBuilder()
    builder.appendDeleteGlobal(name)
    builder.appendDeleteGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .deleteGlobal(nameIndex: 0),
                          .deleteGlobal(nameIndex: 0))
  }

  func test_appendDeleteGlobal_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendDeleteGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .deleteGlobal(nameIndex: 0))
  }

  func test_appendDeleteGlobal_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendDeleteGlobal(name)
    builder.appendDeleteGlobal(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .deleteGlobal(nameIndex: 0),
                          .deleteGlobal(nameIndex: 0))
  }
}
