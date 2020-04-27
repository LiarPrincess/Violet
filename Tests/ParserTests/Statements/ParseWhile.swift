import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

class ParseWhile: XCTestCase, Common {

  /// while Frollo: "Quasimodo"
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.while,                start: loc0, end: loc1),
      self.token(.identifier("Frollo"), start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Quasimodo"),  start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.while,                start: loc0, end: loc1),
      self.token(.identifier("Frollo"), start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Quasimodo"),  start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.else,                 start: loc10, end: loc11),
      self.token(.colon,                start: loc12, end: loc13),
      self.token(.string("Esmeralda"),  start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
