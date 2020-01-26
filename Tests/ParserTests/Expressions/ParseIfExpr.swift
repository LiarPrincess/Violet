import XCTest
import Core
import Lexer
@testable import Parser

class ParseIfExpr: XCTestCase, Common {

  /// prince if belle else beast
  func test_simple() {
    let parser = self.createExprParser(
      self.token(.identifier("prince"), start: loc0, end: loc1),
      self.token(.if,                   start: loc2, end: loc3),
      self.token(.identifier("belle"),  start: loc4, end: loc5),
      self.token(.else,                 start: loc6, end: loc7),
      self.token(.identifier("beast"),  start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }
    
    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      IfExpr(start: 0:0, end: 9:14)
        Test
          IdentifierExpr(start: 4:4, end: 5:10)
            Value: belle
        Body
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: prince
        OrElse
          IdentifierExpr(start: 8:8, end: 9:14)
            Value: beast
    """)
  }
}
