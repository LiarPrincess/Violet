import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

private func createMangledName() -> MangledName {
  let className = "Fa"
  let name = "__Mulan"
  let mangled = MangledName(className: className, name: name)
  let expectedMangled = "_Fa__Mulan"
  XCTAssertEqual(mangled.value, expectedMangled)
  return mangled
}

class BuilderLoadStoreDeleteNameTests: XCTestCase {

  // MARK: - Store

  func test_appendStoreName() {
    let name = "Mulan"

    let builder = createBuilder()
    builder.appendStoreName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .storeName(nameIndex: 0))
  }

  func test_appendStoreName_isReused() {
    let name = "Mulan"

    let builder = createBuilder()
    builder.appendStoreName(name)
    builder.appendStoreName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .storeName(nameIndex: 0),
                          .storeName(nameIndex: 0))
  }

  func test_appendStoreName_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendStoreName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .storeName(nameIndex: 0))
  }

  func test_appendStoreName_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendStoreName(name)
    builder.appendStoreName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .storeName(nameIndex: 0),
                          .storeName(nameIndex: 0))
  }

  // MARK: - Load

  func test_appendLoadName() {
    let name = "Mulan"

    let builder = createBuilder()
    builder.appendLoadName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .loadName(nameIndex: 0))
  }

  func test_appendLoadName_isReused() {
    let name = "Mulan"

    let builder = createBuilder()
    builder.appendLoadName(name)
    builder.appendLoadName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .loadName(nameIndex: 0),
                          .loadName(nameIndex: 0))
  }

  func test_appendLoadName_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendLoadName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .loadName(nameIndex: 0))
  }

  func test_appendLoadName_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendLoadName(name)
    builder.appendLoadName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .loadName(nameIndex: 0),
                          .loadName(nameIndex: 0))
  }

  // MARK: - DeleteName

  func test_appendDeleteName() {
    let name = "Mulan"

    let builder = createBuilder()
    builder.appendDeleteName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code, .deleteName(nameIndex: 0))
  }

  func test_appendDeleteName_isReused() {
    let name = "Mulan"

    let builder = createBuilder()
    builder.appendDeleteName(name)
    builder.appendDeleteName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name)
    XCTAssertInstructions(code,
                          .deleteName(nameIndex: 0),
                          .deleteName(nameIndex: 0))
  }

  func test_appendDeleteName_mangled() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendDeleteName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code, .deleteName(nameIndex: 0))
  }

  func test_appendDeleteName_mangled_isReused() {
    let name = createMangledName()

    let builder = createBuilder()
    builder.appendDeleteName(name)
    builder.appendDeleteName(name)

    let code = builder.finalize()
    XCTAssertNames(code, name.value)
    XCTAssertInstructions(code,
                          .deleteName(nameIndex: 0),
                          .deleteName(nameIndex: 0))
  }
}
