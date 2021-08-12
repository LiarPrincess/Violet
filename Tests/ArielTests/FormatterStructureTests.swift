import XCTest
@testable import LibAriel

class FormatterStructureTests: XCTestCase {

  func test_simple() {
    let declaration = Structure(
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
    XCTAssertEqual(result, "struct Elsa")
  }

  func test_full() {
    let declaration = Structure(
      id: .dummyId,
      name: "Elsa",
      accessModifier: .public,
      modifiers: [],
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
public struct Elsa<Power: MagicPower>: Princess where Power.Kind == Ice
""")
  }
}
