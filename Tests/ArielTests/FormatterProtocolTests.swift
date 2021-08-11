import XCTest
@testable import LibAriel

class FormatterProtocolTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.protocol(source: "protocol Elsa {}") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "protocol Elsa")
  }

  func test_full() {
    guard let declaration = Parser.protocol(source: """
@available(macOS 10.15, *)
public protocol Elsa: Princess where Element == Ice {}
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public protocol Elsa: Princess where Element == Ice
""")
  }
}
