import XCTest
@testable import LibAriel

class FormatterFunctionTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.function(source: "func elsa() -> Int") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "func elsa() -> Int")
  }

  func test_full() {
    guard let declaration = Parser.function(source: """
@available(macOS 10.15, *)
private func elsa<T>(arg: T) throws -> Princess where T: Ice {}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
private func elsa<T>(arg: T) throws -> Princess where T: Ice
""")
  }
}
