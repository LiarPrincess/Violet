import XCTest
@testable import LibAriel

class FormatterAssociatedTypeTests: XCTestCase {

  func test_simple() {
    let declaration = AssociatedType(
      id: .dummyId,
      name: "Elsa",
      accessModifier: nil,
      modifiers: [],
      inheritance: [],
      initializer: nil,
      attributes: [],
      genericRequirements: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "associatedtype Elsa")
  }

  func test_full() {
    let declaration = AssociatedType(
      id: .dummyId,
      name: "Elsa",
      accessModifier: .public,
      modifiers: [],
      inheritance: [InheritedType(typeName: "Princess")],
      initializer: TypeInitializer(value: "Princess"),
      attributes: [Attribute(name: "available")],
      genericRequirements: [
        GenericRequirement(
          kind: .sameType,
          leftType: Type(name: "Power"),
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
public associatedtype Elsa: Princess = Princess where Power == Ice
""")
  }
}
