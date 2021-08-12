import XCTest
@testable import LibAriel

// swiftlint:disable line_length
// swiftlint:disable function_body_length

class FormatterFunctionTests: XCTestCase {

  func test_simple() {
    let declaration = Function(
      id: .dummyId,
      name: "elsa",
      accessModifier: nil,
      modifiers: [],
      parameters: [],
      output: nil,
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
    XCTAssertEqual(result, "func elsa()")
  }

  func test_full() {
    let declaration = Function(
      id: .dummyId,
      name: "sing",
      accessModifier: .public,
      modifiers: [.final, .class],
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
      output: Type(name: "Int"),
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
public final class func sing<S: Singer>(singer s: S = .elsa, lyrics: String...) throws -> Int where S: Princess
""")
  }
}
