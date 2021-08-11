import XCTest
@testable import LibAriel

class FormatterAssociatedTypeTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.associatedtype(source: """
associatedtype elsa: Princess
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
associatedtype elsa: Princess
""")
  }

  func test_full() {
    guard let declaration = Parser.associatedtype(source: """
@available(macOS 10.15, *)
associatedtype elsa: Princess
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
associatedtype elsa: Princess
""")
  }
}
