import XCTest
import Core
import Lexer
@testable import Parser

class ParseDelete: XCTestCase, Common {

  /// del Jafar
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.del,                 start: loc0, end: loc1),
      self.token(.identifier("Jafar"), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      DeleteStmt(start: 0:0, end: 3:8)
        IdentifierExpr(context: Del, start: 2:2, end: 3:8)
          Value: Jafar
    """)
  }

  // del Jafar,
  func test_withCommaAfter() {
    let parser = self.createStmtParser(
      self.token(.del,             start: loc0, end: loc1),
      self.token(.identifier("Jafar"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      DeleteStmt(start: 0:0, end: 5:10)
        IdentifierExpr(context: Del, start: 2:2, end: 3:8)
          Value: Jafar
    """)
  }

  // del Jafar, Iago, Lamp
  func test_multiple() {
    let parser = self.createStmtParser(
      self.token(.del,                 start: loc0, end: loc1),
      self.token(.identifier("Jafar"), start: loc2, end: loc3),
      self.token(.comma,               start: loc4, end: loc5),
      self.token(.identifier("Iago"),  start: loc6, end: loc7),
      self.token(.comma,               start: loc8, end: loc9),
      self.token(.identifier("Lamp"),  start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      DeleteStmt(start: 0:0, end: 11:16)
        IdentifierExpr(context: Del, start: 2:2, end: 3:8)
          Value: Jafar
        IdentifierExpr(context: Del, start: 6:6, end: 7:12)
          Value: Iago
        IdentifierExpr(context: Del, start: 10:10, end: 11:16)
          Value: Lamp
    """)
  }

  // del agrabah[0]
  func test_subscript() {
    let parser = self.createStmtParser(
      self.token(.del,                   start: loc0, end: loc1),
      self.token(.identifier("agrabah"), start: loc2, end: loc3),
      self.token(.leftSqb,               start: loc4, end: loc5),
      self.token(.int(0),                start: loc6, end: loc7),
      self.token(.rightSqb,              start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      DeleteStmt(start: 0:0, end: 9:14)
        SubscriptExpr(context: Del, start: 2:2, end: 9:14)
          Object
            IdentifierExpr(context: Load, start: 2:2, end: 3:8)
              Value: agrabah
          Slice(start: 4:4, end: 9:14)
            Index
              IntExpr(context: Load, start: 6:6, end: 7:12)
                Value: 0
    """)
  }

  // del agrabah.jafar
  func test_attribute() {
    let parser = self.createStmtParser(
      self.token(.del,                   start: loc0, end: loc1),
      self.token(.identifier("agrabah"), start: loc2, end: loc3),
      self.token(.dot,                   start: loc4, end: loc5),
      self.token(.identifier("jafar")  , start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      DeleteStmt(start: 0:0, end: 7:12)
        AttributeExpr(context: Del, start: 2:2, end: 7:12)
          Object
            IdentifierExpr(context: Load, start: 2:2, end: 3:8)
              Value: agrabah
          Name: jafar
    """)
  }
}
