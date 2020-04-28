import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseCallComprehension: XCTestCase, Common {

  // MARK: - As single argument

  /// f(a for b in [])
  func test_simple() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.rightParen,      start: loc16, end: loc17)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 17:22)
      CallExpr(context: Load, start: 0:0, end: 17:22)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          GeneratorExpr(context: Load, start: 4:4, end: 15:20)
            Element
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: a
            Generators
              Comprehension(start: 6:6, end: 15:20)
                isAsync: false
                Target
                  IdentifierExpr(context: Store, start: 8:8, end: 9:14)
                    Value: b
                Iterable
                  ListExpr(context: Load, start: 12:12, end: 15:20)
                    Elements: none
                Ifs: none
        Keywords: none
    """)
  }

  // MARK: - After positional

  /// f(1, a for b in [])
  func test_afterPositional_withoutParens_fails() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("a"), start: loc10, end: loc11),
      self.token(.for,             start: loc12, end: loc13),
      self.token(.identifier("b"), start: loc14, end: loc15),
      self.token(.in,              start: loc16, end: loc17),
      self.token(.leftSqb,         start: loc18, end: loc19),
      self.token(.rightSqb,        start: loc20, end: loc21),
      self.token(.rightParen,      start: loc22, end: loc23)
    )

    self.assert_callWithGeneratorArgumentWithoutParens(
      parser: parser,
      at: loc10
    )
  }

  private func assert_callWithGeneratorArgumentWithoutParens(
    parser: Parser,
    at location: SourceLocation,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let error = self.error(parser,
                                 file: file,
                                 line: line) else {
      return
    }

    XCTAssertEqual(error.location, location, file: file, line: line)

    switch error.kind {
    case .callWithGeneratorArgumentWithoutParens:
      break
    default:
      XCTAssert(false, "\(error.kind)", file: file, line: line)
    }
  }

  /// f(1, (a for b in []))
  func test_afterPositional_inParens() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.leftParen,       start: loc10, end: loc11),
      self.token(.identifier("a"), start: loc12, end: loc13),
      self.token(.for,             start: loc14, end: loc15),
      self.token(.identifier("b"), start: loc16, end: loc17),
      self.token(.in,              start: loc18, end: loc19),
      self.token(.leftSqb,         start: loc20, end: loc21),
      self.token(.rightSqb,        start: loc22, end: loc23),
      self.token(.rightParen,      start: loc24, end: loc25),
      self.token(.rightParen,      start: loc26, end: loc27)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 27:32)
      CallExpr(context: Load, start: 0:0, end: 27:32)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          FloatExpr(context: Load, start: 6:6, end: 7:12)
            Value: 1.0
          GeneratorExpr(context: Load, start: 10:10, end: 25:30)
            Element
              IdentifierExpr(context: Load, start: 12:12, end: 13:18)
                Value: a
            Generators
              Comprehension(start: 14:14, end: 23:28)
                isAsync: false
                Target
                  IdentifierExpr(context: Store, start: 16:16, end: 17:22)
                    Value: b
                Iterable
                  ListExpr(context: Load, start: 20:20, end: 23:28)
                    Elements: none
                Ifs: none
        Keywords: none
    """)
  }

  // MARK: - Before positional

  /// f(a for b in [], 1)
  func test_beforePositional_withoutParens_fails() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.comma,           start: loc16, end: loc17),
      self.token(.float(1.0),      start: loc18, end: loc19),
      self.token(.rightParen,      start: loc20, end: loc21)
    )

    self.assert_callWithGeneratorArgumentWithoutParens(
      parser: parser,
      at: loc4
    )
  }

  /// f((a for b in []), 1)
  func test_beforePositional_inParens() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.leftParen,       start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.for,             start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.in,              start: loc12, end: loc13),
      self.token(.leftSqb,         start: loc14, end: loc15),
      self.token(.rightSqb,        start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19),
      self.token(.comma,           start: loc20, end: loc21),
      self.token(.float(1.0),      start: loc22, end: loc23),
      self.token(.rightParen,      start: loc24, end: loc25)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 25:30)
      CallExpr(context: Load, start: 0:0, end: 25:30)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          GeneratorExpr(context: Load, start: 4:4, end: 19:24)
            Element
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: a
            Generators
              Comprehension(start: 8:8, end: 17:22)
                isAsync: false
                Target
                  IdentifierExpr(context: Store, start: 10:10, end: 11:16)
                    Value: b
                Iterable
                  ListExpr(context: Load, start: 14:14, end: 17:22)
                    Elements: none
                Ifs: none
          FloatExpr(context: Load, start: 22:22, end: 23:28)
            Value: 1.0
        Keywords: none
    """)
  }

  // MARK: - Comma after

  /// f(a for b in [],)
  func test_commaAfter() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.comma,           start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 19:24)
      CallExpr(context: Load, start: 0:0, end: 19:24)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          GeneratorExpr(context: Load, start: 4:4, end: 15:20)
            Element
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: a
            Generators
              Comprehension(start: 6:6, end: 15:20)
                isAsync: false
                Target
                  IdentifierExpr(context: Store, start: 8:8, end: 9:14)
                    Value: b
                Iterable
                  ListExpr(context: Load, start: 12:12, end: 15:20)
                    Elements: none
                Ifs: none
        Keywords: none
    """)
  }
}
