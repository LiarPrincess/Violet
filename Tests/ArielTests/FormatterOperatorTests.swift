import XCTest
@testable import LibAriel

class FormatterOperatorTests: XCTestCase {

  func test_simple() {
    let declaration = Operator(
      id: .dummyId,
      name: "<+>",
      accessModifier: nil,
      modifiers: [],
      kind: .infix,
      operatorPrecedenceAndTypes: [],
      attributes: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "infix operator <+>")
  }

  func test_full() {
    let declaration = Operator(
      id: .dummyId,
      name: "<+>",
      accessModifier: .public,
      modifiers: [],
      kind: .infix,
      operatorPrecedenceAndTypes: ["MultiplicationPrecedence"],
      attributes: [Attribute(name: "available")]
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public infix operator <+>: MultiplicationPrecedence
""")
  }
}
