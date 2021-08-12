import XCTest
@testable import LibAriel

// swiftlint:disable line_length
// swiftlint:disable function_body_length

class FormatterSubscriptTests: XCTestCase {

  func test_simple() {
    let declaration = Subscript(
      id: .dummyId,
      accessModifiers: nil,
      modifiers: [],
      indices: [
        Parameter(
          firstName: "arg",
          secondName: nil,
          type: Type(name: "Int"),
          isVariadic: false,
          defaultValue: nil
        )
      ],
      result: Type(name: "String"),
      accessors: [
        Accessor(kind: .get, modifier: nil, attributes: [])
      ],
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
subscript(arg: Int) -> String { get }
""")
  }

  func test_full() {
    let declaration = Subscript(
      id: .dummyId,
      accessModifiers: GetSetAccessModifiers(get: .public, set: .internal),
      modifiers: [.final],
      indices: [
        Parameter(
          firstName: "singer",
          secondName: nil,
          type: Type(name: "S"),
          isVariadic: false,
          defaultValue: nil
        ),
        Parameter(
          firstName: "loud",
          secondName: nil,
          type: Type(name: "Bool"),
          isVariadic: false,
          defaultValue: nil
        )
      ],
      result: Type(name: "String"),
      accessors: [
        Accessor(kind: .get, modifier: nil, attributes: []),
        Accessor(kind: ._read, modifier: nil, attributes: []),
        Accessor(kind: .set, modifier: nil, attributes: []),
        Accessor(kind: ._modify, modifier: nil, attributes: [])
      ],
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
public internal(set) final subscript<S: Singer>(singer: S, loud: Bool) -> String { get; _read; set; _modify } where S: Princess
""")
  }
}
