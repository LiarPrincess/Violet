import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseWhile: XCTestCase {

  /// while Frollo: "Quasimodo"
  func test_simple() {
    let parser = createStmtParser(
      createToken(.while,                start: loc0, end: loc1),
      createToken(.identifier("Frollo"), start: loc2, end: loc3),
      createToken(.colon,                start: loc4, end: loc5),
      createToken(.string("Quasimodo"),  start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      WhileStmt(start: 0:0, end: 7:12)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Frollo
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Quasimodo'
        OrElse: none
    """)
  }

  /// while Frollo: "Quasimodo"
  /// else: "Esmeralda"
  func test_withElse() {
    let parser = createStmtParser(
      createToken(.while,                start: loc0, end: loc1),
      createToken(.identifier("Frollo"), start: loc2, end: loc3),
      createToken(.colon,                start: loc4, end: loc5),
      createToken(.string("Quasimodo"),  start: loc6, end: loc7),
      createToken(.newLine,              start: loc8, end: loc9),
      createToken(.else,                 start: loc10, end: loc11),
      createToken(.colon,                start: loc12, end: loc13),
      createToken(.string("Esmeralda"),  start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      WhileStmt(start: 0:0, end: 15:20)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Frollo
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Quasimodo'
        OrElse
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Esmeralda'
    """)
  }
}
