import XCTest
@testable import LibAriel

class FormatterEnumerationTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.enumeration(source: """
enum Elsa: Princess {
  case letItGo
}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "enum Elsa: Princess")
  }

  func test_simple_noCases() {
    guard let declaration = Parser.enumeration(source: "enum Elsa {}") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "enum Elsa")
  }

  func test_full() {
    guard let declaration = Parser.enumeration(source: """
@available(macOS 10.15, *)
public indirect enum Elsa<T>: Princess where T: Ice {
  case letItGo
}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public indirect enum Elsa<T>: Princess where T: Ice
""")
  }
}
