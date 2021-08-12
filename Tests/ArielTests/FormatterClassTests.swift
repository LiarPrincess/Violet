import XCTest
@testable import LibAriel

class FormatterClassTests: XCTestCase {

  func test_simple() {
    let declaration = Class(
      id: .dummyId,
      name: "Elsa",
      accessModifier: nil,
      modifiers: [],
      inheritance: [],
      attributes: [],
      genericParameters: [],
      genericRequirements: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "class Elsa")
  }

  func test_full() {
    let declaration = Class(
      id: .dummyId,
      name: "Elsa",
      accessModifier: .public,
      modifiers: [.final],
      inheritance: [InheritedType(typeName: "Princess")],
      attributes: [Attribute(name: "available")],
      genericParameters: [
        GenericParameter(
          name: "Power",
          inheritedType: Type(name: "MagicPower")
        )
      ],
      genericRequirements: [
        GenericRequirement(
          kind: .sameType,
          leftType: Type(name: "Power.Kind"),
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
public final class Elsa<Power: MagicPower>: Princess where Power.Kind == Ice
""")
  }
}
