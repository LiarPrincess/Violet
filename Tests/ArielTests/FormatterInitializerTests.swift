import XCTest
@testable import LibAriel

// swiftlint:disable line_length
// swiftlint:disable function_body_length

class FormatterInitializerTests: XCTestCase {

  func test_simple() {
    let declaration = Initializer(
      id: .dummyId,
      accessModifier: nil,
      modifiers: [],
      isOptional: false,
      parameters: [],
      throws: nil,
      attributes: [],
      genericParameters: [],
      genericRequirements: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "init()")
  }

  func test_full() {
    let declaration = Initializer(
      id: .dummyId,
      accessModifier: .public,
      modifiers: [.final, .convenience],
      isOptional: true,
      parameters: [
        Parameter(
          firstName: "singer",
          secondName: "s",
          type: Type(name: "S"),
          isVariadic: false,
          defaultValue: VariableInitializer(value: ".elsa")
        ),
        Parameter(
          firstName: "lyrics",
          secondName: nil,
          type: Type(name: "String"),
          isVariadic: true,
          defaultValue: nil
        )
      ],
      throws: .throws,
      attributes: [Attribute(name: "available")],
      genericParameters: [
        GenericParameter(
          name: "S",
          inheritedType: Type(name: "Singer")
        )
      ],
      genericRequirements: [
        GenericRequirement(
          kind: .conformance,
          leftType: Type(name: "S"),
          rightType: Type(name: "Princess")
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
public final convenience init?<S: Singer>(singer s: S = .elsa, lyrics: String...) throws where S: Princess
""")
  }
}
