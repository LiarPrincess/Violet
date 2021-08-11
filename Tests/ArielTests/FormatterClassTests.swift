import XCTest
@testable import LibAriel

class FormatterClassTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.class(source: "class Elsa: Princess {}") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "class Elsa: Princess")
  }

  func test_full() {
    guard let declaration = Parser.class(source: """
@available(macOS 10.15, *)
public final class Elsa<T>: Princess where T: Ice {}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public final class Elsa<T>: Princess where T: Ice
""")
  }
}
