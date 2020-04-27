import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

class ParseAttribute: XCTestCase, Common {

  /// a.b
  func test_simple() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.dot,             start: loc6, end: loc7),
      self.token(.identifier("c"), start: loc7, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

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
