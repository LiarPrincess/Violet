import XCTest
@testable import LibAriel

class FormatterTypealiasTests: XCTestCase {

  func test_simple() {
    let declaration = Typealias(
      id: .dummyId,
      name: "Elsa",
      accessModifier: nil,
      modifiers: [],
      initializer: TypeInitializer(value: "Princess"),
      attributes: [],
      genericParameters: [],
      genericRequirements: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
typealias Elsa = Princess
""")
  }

  func test_full() {
    let declaration = Typealias(
      id: .dummyId,
      name: "Elsa",
      accessModifier: .public,
      modifiers: [],
      initializer: TypeInitializer(value: "Princess"),
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
          leftType: Type(name: "Power.Type"),
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
public typealias Elsa<Power: MagicPower> = Princess where Power.Type == Ice
""")
  }
}
