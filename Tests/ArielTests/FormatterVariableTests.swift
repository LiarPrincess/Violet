import XCTest
@testable import LibAriel

class FormatterVariableTests: XCTestCase {

  func test_simple() {
    let declaration = Variable(
      id: .dummyId,
      name: "elsa",
      keyword: "let",
      accessModifiers: nil,
      modifiers: [],
      typeAnnotation: nil,
      initializer: VariableInitializer(value: "1"),
      accessors: [],
      attributes: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "let elsa = 1")
  }

  func test_full() {
    let declaration = Variable(
      id: .dummyId,
      name: "elsa",
      keyword: "let",
      accessModifiers: GetSetAccessModifiers(get: .public, set: .internal),
      modifiers: [.final, .class],
      typeAnnotation: TypeAnnotation(typeName: "Princess"),
      initializer: VariableInitializer(value: "Princess()"),
      accessors: [
        Accessor(kind: .get, modifier: nil, attributes: []),
        Accessor(kind: ._read, modifier: nil, attributes: []),
        Accessor(kind: .set, modifier: nil, attributes: []),
        Accessor(kind: ._modify, modifier: nil, attributes: [])
      ],
      attributes: [Attribute(name: "available")]
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: nil
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
public internal(set) final class let elsa: Princess = Princess() { get; _read; set; _modify }
""")
  }

  // MARK: - Init

  func test_longInitializer() {
    let declaration = Variable(
      id: .dummyId,
      name: "elsa",
      keyword: "let",
      accessModifiers: nil,
      modifiers: [],
      typeAnnotation: TypeAnnotation(typeName: "Princess"),
      initializer: VariableInitializer(value: """
        {
          let power = "Ice"
          return Princess(power: power)
        }()
        """),
      accessors: [],
      attributes: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: 10
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
let elsa: Princess = {
  let po <and so on…>
""")
  }

  func test_longInitializer_unclosedSingleQuote_isClosed() {
    let declaration = Variable(
      id: .dummyId,
      name: "elsa",
      keyword: "let",
      accessModifiers: nil,
      modifiers: [],
      typeAnnotation: TypeAnnotation(typeName: "Princess"),
      initializer: VariableInitializer(value: "\"Let it go! Let it go!\""),
      accessors: [],
      attributes: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: 10
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
let elsa: Princess = "Let it go <and so on…>"
""")
  }

  func test_longInitializer_unclosedTripleQuote_isClosed() {
    let declaration = Variable(
      id: .dummyId,
      name: "elsa",
      keyword: "let",
      accessModifiers: nil,
      modifiers: [],
      typeAnnotation: TypeAnnotation(typeName: "Princess"),
      initializer: VariableInitializer(value: "\"\"\"Let it go! Let it go!\"\"\""),
      accessors: [],
      attributes: []
    )

    let formatter = Formatter(
      newLineAfterAttribute: true,
      maxInitializerLength: 10
    )

    let result = formatter.format(declaration)
    XCTAssertEqual(result, #"""
let elsa: Princess = """Let it  <and so on…>"""
"""#)
  }
}
