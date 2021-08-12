import XCTest
@testable import LibAriel

class FormatterProtocolTests: XCTestCase {

  func test_simple() {
    let declaration = Protocol(
      id: .dummyId,
      name: "Elsa",
      accessModifier: nil,
      modifiers: [],
      inheritance: [],
      attributes: [],
      genericRequirements: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "protocol Elsa")
  }

  func test_full() {
    let declaration = Protocol(
      id: .dummyId,
      name: "Elsa",
      accessModifier: .public,
      modifiers: [],
      inheritance: [InheritedType(typeName: "Princess")],
      attributes: [Attribute(name: "available")],
      genericRequirements: [
        GenericRequirement(
          kind: .sameType,
          leftType: Type(name: "Element"),
          rightType: Type(name: "Ice")
        )
      ]
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public protocol Elsa: Princess where Element == Ice
""")
  }
}
