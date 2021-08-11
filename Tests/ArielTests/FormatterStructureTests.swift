import XCTest
@testable import LibAriel

class FormatterStructureTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.structure(source: "struct Elsa: Princess {}") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "struct Elsa: Princess")
  }

  func test_full() {
    guard let declaration = Parser.structure(source: """
@available(macOS 10.15, *)
public struct Elsa<T>: Princess where T: Ice {}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public struct Elsa<T>: Princess where T: Ice
""")
  }
}
