import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable function_body_length

class ParseIfStatement: XCTestCase, Common {

  /// if Pooh: "Honey"
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.if,                 start: loc0, end: loc1),
      self.token(.identifier("Pooh"), start: loc2, end: loc3),
      self.token(.colon,              start: loc4, end: loc5),
      self.token(.string("Honey"),    start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      IfStmt(start: 0:0, end: 7:12)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Pooh
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Honey'
        OrElse: none
    """)
  }

  /// if Pooh: "Honey"
  /// else: "More honey"
  func test_withElse() {
    let parser = self.createStmtParser(
      self.token(.if,                   start: loc0, end: loc1),
      self.token(.identifier("Pooh"),   start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Honey"),      start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.else,                 start: loc10, end: loc11),
      self.token(.colon,                start: loc12, end: loc13),
      self.token(.string("More honey"), start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      IfStmt(start: 0:0, end: 15:20)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Pooh
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Honey'
        OrElse
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'More honey'
    """)
  }

  /// if Pooh: "Honey"
  /// elif Tigger: "Bouncing"
  /// Expected:
  /// ```
  /// If0
  ///   test: Pooh
  ///   body: Honey
  ///   orelse:
  ///     If1
  ///       test: Tigger
  ///       body: Bouncing
  ///       orelse: empty
  /// ```
  func test_withElif() {
    let parser = self.createStmtParser(
      self.token(.if,                   start: loc0, end: loc1),
      self.token(.identifier("Pooh"),   start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Honey"),      start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.elif,                 start: loc10, end: loc11),
      self.token(.identifier("Tigger"), start: loc12, end: loc13),
      self.token(.colon,                start: loc14, end: loc15),
      self.token(.string("Bouncing"),   start: loc16, end: loc17)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      IfStmt(start: 0:0, end: 17:22)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Pooh
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Honey'
        OrElse
          IfStmt(start: 10:10, end: 17:22)
            Test
              IdentifierExpr(context: Load, start: 12:12, end: 13:18)
                Value: Tigger
            Body
              ExprStmt(start: 16:16, end: 17:22)
                StringExpr(context: Load, start: 16:16, end: 17:22)
                  String: 'Bouncing'
            OrElse: none
    """)
  }

  /// if Pooh:     "Honey"
  /// elif Tigger: "Bouncing"
  /// else:        "Carrots?"
  /// Expected AST is similiar to the one in `test_withElif`.
  func test_withElif_andElse() {
    let parser = self.createStmtParser(
      self.token(.if,                   start: loc0, end: loc1),
      self.token(.identifier("Pooh"),   start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Honey"),      start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.elif,                 start: loc10, end: loc11),
      self.token(.identifier("Tigger"), start: loc12, end: loc13),
      self.token(.colon,                start: loc14, end: loc15),
      self.token(.string("Bouncing"),   start: loc16, end: loc17),
      self.token(.newLine,              start: loc18, end: loc19),
      self.token(.else,                 start: loc20, end: loc21),
      self.token(.colon,                start: loc22, end: loc23),
      self.token(.string("Carrots?"),   start: loc24, end: loc25)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      IfStmt(start: 0:0, end: 25:30)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Pooh
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Honey'
        OrElse
          IfStmt(start: 10:10, end: 25:30)
            Test
              IdentifierExpr(context: Load, start: 12:12, end: 13:18)
                Value: Tigger
            Body
              ExprStmt(start: 16:16, end: 17:22)
                StringExpr(context: Load, start: 16:16, end: 17:22)
                  String: 'Bouncing'
            OrElse
              ExprStmt(start: 24:24, end: 25:30)
                StringExpr(context: Load, start: 24:24, end: 25:30)
                  String: 'Carrots?'
    """)
  }
}
