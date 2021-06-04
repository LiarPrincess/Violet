import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Belle"
  let name = "__Beast"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Belle__Beast"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteAttributeTests: XCTestCase {

  // MARK: - Store

  func test_appendStoreAttribute() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendStoreAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .storeAttribute(nameIndex: 0))
  }

  func test_appendStoreAttribute_isReused() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendStoreAttribute(name)
    builder.appendStoreAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .storeAttribute(nameIndex: 0),
                          .storeAttribute(nameIndex: 0))
  }

  func test_appendStoreAttribute_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendStoreAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .storeAttribute(nameIndex: 0))
  }

  func test_appendStoreAttribute_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendStoreAttribute(name)
    builder.appendStoreAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .storeAttribute(nameIndex: 0),
                          .storeAttribute(nameIndex: 0))
  }

  // MARK: - Load

  func test_appendLoadAttribute() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendLoadAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .loadAttribute(nameIndex: 0))
  }

  func test_appendLoadAttribute_isReused() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendLoadAttribute(name)
    builder.appendLoadAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .loadAttribute(nameIndex: 0),
                          .loadAttribute(nameIndex: 0))
  }

  func test_appendLoadAttribute_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendLoadAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .loadAttribute(nameIndex: 0))
  }

  func test_appendLoadAttribute_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendLoadAttribute(name)
    builder.appendLoadAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .loadAttribute(nameIndex: 0),
                          .loadAttribute(nameIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDeleteAttribute() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendDeleteAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .deleteAttribute(nameIndex: 0))
  }

  func test_appendDeleteAttribute_isReused() {
    let name = "Belle"

    let builder = createBuilder()
    builder.appendDeleteAttribute(name)
    builder.appendDeleteAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .deleteAttribute(nameIndex: 0),
                          .deleteAttribute(nameIndex: 0))
  }

  func test_appendDeleteAttribute_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendDeleteAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .deleteAttribute(nameIndex: 0))
  }

  func test_appendDeleteAttribute_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendDeleteAttribute(name)
    builder.appendDeleteAttribute(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .deleteAttribute(nameIndex: 0),
                          .deleteAttribute(nameIndex: 0))
  }
}
