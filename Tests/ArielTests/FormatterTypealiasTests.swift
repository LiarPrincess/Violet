import XCTest
@testable import LibAriel

class FormatterTypealiasTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.typealias(source: """
typealias Elsa = Princess
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
typealias Elsa = Princess
""")
  }

  func test_full() {
    guard let declaration = Parser.typealias(source: """
@available(macOS 10.15, *)
private typealias Elsa<T> = Princess where T: Ice
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
private typealias Elsa<T> = Princess where T: Ice
""")
  }
}
