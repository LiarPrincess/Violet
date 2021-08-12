import XCTest
@testable import LibAriel

class FormatterExtensionTests: XCTestCase {

  func test_simple() {
    let declaration = Extension(
      id: .dummyId,
      extendedType: "Elsa",
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
    XCTAssertEqual(result, "extension Elsa")
  }

  func test_full() {
    let declaration = Extension(
      id: .dummyId,
      extendedType: "Elsa",
      accessModifier: .public,
      modifiers: [],
      inheritance: [InheritedType(typeName: "Princess")],
      attributes: [Attribute(name: "available")],
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
public extension Elsa: Princess where Power.Kind == Ice
""")
  }
}
