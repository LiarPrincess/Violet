import XCTest
@testable import LibAriel

class FormatterExtensionTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.extension(source: "extension Elsa {}") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "extension Elsa")
  }

  func test_full() {
    guard let declaration = Parser.extension(source: """
@available(macOS 10.15, *)
private extension Elsa: Princess where T: Ice {}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
private extension Elsa: Princess where T: Ice
""")
  }
}
