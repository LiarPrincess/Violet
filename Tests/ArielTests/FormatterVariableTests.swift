import XCTest
@testable import LibAriel

class FormatterVariableTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.variable(source: "let elsa = 1") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "let elsa = 1")
  }

  func test_full() {
    guard let declaration = Parser.variable(source: """
@available(macOS 10.15, *)
private let elsa: Princess = Princess()
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
private let elsa: Princess = Princess()
""")
  }

  // MARK: - Init

  func test_longInitializer() {
    guard let declaration = Parser.variable(source: """
let elsa: Princess = {
  let power = "Ice"
  return Princess(power: power)
}()
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: 10)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
let elsa: Princess = {
  let po <and so on…>
""")
  }

  func test_longInitializer_unclosedSingleQuote_isClosed() {
    guard let declaration = Parser.variable(source: """
let elsa: Princess = "Let it go! Let it go!"
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: 10)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
let elsa: Princess = "Let it go <and so on…>"
""")
  }

  func test_longInitializer_unclosedTripleQuote_isClosed() {
    guard let declaration = Parser.variable(source: #"""
let elsa: Princess = """Let it go! Let it go!"""
"""#) else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: 10)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, #"""
let elsa: Princess = """Let it  <and so on…>"""
"""#)
  }
}
