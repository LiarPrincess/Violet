import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseIfExpr: XCTestCase {

  /// prince if belle else beast
  func test_simple() {
    let parser = createExprParser(
      createToken(.identifier("prince"), start: loc0, end: loc1),
      createToken(.if,                   start: loc2, end: loc3),
      createToken(.identifier("belle"),  start: loc4, end: loc5),
      createToken(.else,                 start: loc6, end: loc7),
      createToken(.identifier("beast"),  start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      IfExpr(context: Load, start: 0:0, end: 9:14)
        Test
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: belle
        Body
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: prince
        OrElse
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: beast
    """)
  }
}
