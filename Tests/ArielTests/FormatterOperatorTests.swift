import XCTest
@testable import LibAriel

class FormatterOperatorTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.operator(source: "infix operator <+>") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "infix operator <+>")
  }

  func test_full() {
    guard let declaration = Parser.operator(source: """
@available(macOS 10.15, *)
infix operator <+>: MultiplicationPrecedence
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
infix operator <+>: MultiplicationPrecedence
""")
  }
}
