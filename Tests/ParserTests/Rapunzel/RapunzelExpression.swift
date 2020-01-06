import Foundation
import XCTest
import Lexer
import Core
@testable import Parser

internal func XCTAssertDoc(_ expr: ExpressionKind,
                           _ expected: String,
                           _ message:  String = "",
                           file: StaticString = #file,
                           line: UInt         = #line) {
  let doc = expr.doc
  let result = doc.layout()
  XCTAssertEqual(result, expected, message, file: file, line: line)
}

@available(*, deprecated, message: "Usable only when writing tests")
private func dump(_ expr: ExpressionKind) {
  print("========")
  print(expr.doc.layout())
  print("========")
}

/// Song reference: https://www.youtube.com/watch?v=t6Ol7VsZGk4
class RapunzelExpression: XCTestCase {

  // MARK: - Trivial

  func test_none() {
    XCTAssertDoc(.none, "None")
  }

  func test_ellipsis() {
    XCTAssertDoc(.ellipsis, "...")
  }

  func test_identifier() {
    XCTAssertDoc(.identifier("look_at_this_stuff"), "look_at_this_stuff")
  }

  // MARK: - Basic types

  func test_booleans() {
    XCTAssertDoc(.true, "True")
    XCTAssertDoc(.false, "False")
  }

  func test_numeric() {
    // swiftlint:disable:next number_separator
    XCTAssertDoc(.int(1989), "1989")

    XCTAssertDoc(.float(19.89), "19.89")

    XCTAssertDoc(.complex(real: 19, imag: 8.9), """
      Complex
        real: 19.0
        imag: 8.9
      """)
  }

  func test_string() {
    let literal = StringGroup.literal("Isn't it neat?")
    XCTAssertDoc(.string(literal), """
      String literal
        'Isn't it neat?'
      """)

    let formatted = StringGroup.literal("Wouldn't you think my collection's complete?")
    let formattedValue = StringGroup.formattedValue(
      self.expression(.string(formatted)),
      conversion: .ascii,
      spec: "Wouldn't you think I'm the girl"
    )

    XCTAssertDoc(.string(formattedValue), """
      Formatted string
        Expression(start: 1:10, end: 2:20)
          String literal
            'Wouldn't you think my collection's complete?'
        Conversion: ascii
        Spec: Wouldn't you think I'm the girl
      """)

    let joined = StringGroup.joined([literal, formattedValue])
    XCTAssertDoc(.string(joined), """
    Joined string
      String literal
        'Isn't it neat?'
      Formatted string
        Expression(start: 1:10, end: 2:20)
          String literal
            'Wouldn't you think my collection's complete?'
        Conversion: ascii
        Spec: Wouldn't you think I'm the girl
    """)
  }

  func test_bytes() {
    let data = Data([1,2,3,4,5,6])
    XCTAssertDoc(.bytes(data), """
      Bytes
        Count: \(data.count)
      """)
  }

  // MARK: - Operations

  func test_unaryOp() {
    let operators: [UnaryOperator] = [.invert, .not, .plus, .minus]

    let r = "The girl who has everything?"
    let right = self.stringExpression(r)

    for op in operators {
      let expr = ExpressionKind.unaryOp(op, right: right)
      XCTAssertDoc(expr, """
        Unary operation
          Operation: \(op)
          Right
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(r)'
        """)
    }
  }

  func test_binaryOp() {
    let operators: [BinaryOperator] = [
      .add, .sub,
      .mul, .matMul, .pow,
      .div, .modulo,
      .leftShift, .rightShift,
      .bitOr, .bitXor, .bitAnd, .floorDiv
    ]

    let l = "Look at this trove"
    let left = self.stringExpression(l)

    let r = "Treasures untold"
    let right = self.stringExpression(r)

    for op in operators {
      let expr = ExpressionKind.binaryOp(op, left: left, right: right)
      XCTAssertDoc(expr, """
        Binary operation
          Operation: \(op)
          Left
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(l)'
          Right
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(r)'
        """)
    }
  }

  func test_boolOp() {
    let operators: [BooleanOperator] = [.and, .or]

    let l = "How many wonders can one cavern hold?"
    let left = self.stringExpression(l)

    let r = "Lookin' around here you'd think"
    let right = self.stringExpression(r)

    for op in operators {
      let expr = ExpressionKind.boolOp(op, left: left, right: right)
      XCTAssertDoc(expr, """
        Bool operation
          Operation: \(op)
          Left
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(l)'
          Right
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(r)'
        """)
    }
  }

  func test_compareOp() {
    let operators: [ComparisonOperator] = [
      .equal, .notEqual,
      .less, .lessEqual,
      .greater, .greaterEqual,
      .`is`, .isNot,
      .`in`, .notIn
    ]

    let l = "Sure"
    let left = self.stringExpression(l)

    let r = "She's got everything"
    let right = self.stringExpression(r)

    for op in operators {
      let element = ComparisonElement(op: op, right: right)
      let elements = NonEmptyArray(first: element)

      let expr = ExpressionKind.compare(left: left, elements: elements)
      XCTAssertDoc(expr, """
        Compare operation
          Left
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(l)'
          Elements
            ComparisonElement
              Operation: \(op)
              Expression(start: 1:10, end: 2:20)
                String literal
                  '\(r)'
        """)
    }
  }

  // MARK: - Collections

  func test_tuple() {
    let s0 = "I've got gadgets and gizmos a-plenty"
    let s1 = "I've got whose-its and whats-its galore"

    let expr = ExpressionKind.tuple([
      self.stringExpression(s0),
      self.stringExpression(s1)
    ])

    XCTAssertDoc(expr, """
      Tuple
        Expression(start: 1:10, end: 2:20)
          String literal
            '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String literal
            '\(s1)'
      """)
  }

  func test_list() {
    let s0 = "You want thingamabobs?"
    let s1 = "I got twenty"

    let expr = ExpressionKind.list([
      self.stringExpression(s0),
      self.stringExpression(s1)
    ])

    XCTAssertDoc(expr, """
      List
        Expression(start: 1:10, end: 2:20)
          String literal
            '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String literal
            '\(s1)'
      """)
  }

  func test_dist() {
    let s0 = "But who cares?"
    let s1 = "No big deal"
    let s2 = "I want more"

    let expr = ExpressionKind.dictionary([
      .keyValue(
        key: self.stringExpression(s0),
        value: self.stringExpression(s1)
      ),
      .unpacking(self.stringExpression(s2))
    ])

    XCTAssertDoc(expr, """
      Dictionary
        Key/value
          Key
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(s0)'
          Value
            Expression(start: 1:10, end: 2:20)
              String literal
                '\(s1)'
        Unpack
          Expression(start: 1:10, end: 2:20)
            String literal
              '\(s2)'
      """)
  }

  func test_set() {
    let s0 = "I wanna be where the people are"
    let s1 = "I wanna see, wanna see 'em dancin'"

    let expr = ExpressionKind.set([
      self.stringExpression(s0),
      self.stringExpression(s1)
    ])

    XCTAssertDoc(expr, """
      Set
        Expression(start: 1:10, end: 2:20)
          String literal
            '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String literal
            '\(s1)'
      """)
  }

  // MARK: - Helpers

  private func stringExpression(_ value: String) -> Expression {
    return self.expression(.string(.literal(value)))
  }

  private func expression(_ kind: ExpressionKind) -> Expression {
    return Expression(
      kind,
      start: SourceLocation(line: 1, column: 10),
      end: SourceLocation(line: 2, column: 20)
    )
  }
}
