import XCTest
@testable import LibAriel

class FormatterSubscriptTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.subscript(source: """
subscript(arg: Int) -> String
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
subscript(arg: Int) -> String
""")
  }

  func test_full() {
    guard let declaration = Parser.subscript(source: """
@available(macOS 10.15, *)
private subscript<T>(arg: T) -> Elsa where T: Ice
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
private subscript<T>(arg: T) -> Elsa where T: Ice
""")
  }
}
