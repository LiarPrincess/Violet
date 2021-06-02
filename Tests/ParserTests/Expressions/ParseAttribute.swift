import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAttribute: XCTestCase {

  /// a.b
  func test_simple() {
    let parser = createExprParser(
      createToken(.identifier("a"), start: loc0, end: loc1),
      createToken(.dot,             start: loc2, end: loc3),
      createToken(.identifier("b"), start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      AttributeExpr(context: Load, start: 0:0, end: 5:10)
        Object
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: a
        Name: b
    """)
  }

  /// a.b.c = (a.b).c
  func test_isLeftAssociative() {
    let parser = createExprParser(
      createToken(.identifier("a"), start: loc0, end: loc1),
      createToken(.dot,             start: loc2, end: loc3),
      createToken(.identifier("b"), start: loc4, end: loc5),
      createToken(.dot,             start: loc6, end: loc7),
      createToken(.identifier("c"), start: loc7, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      AttributeExpr(context: Load, start: 0:0, end: 9:14)
        Object
          AttributeExpr(context: Load, start: 0:0, end: 5:10)
            Object
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: a
            Name: b
        Name: c
    """)
  }
}
