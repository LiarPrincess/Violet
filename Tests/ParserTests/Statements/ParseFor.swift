import XCTest
import Core
import Lexer
@testable import Parser

class ParseFor: XCTestCase, Common {

  /// for person in castle: "becomeItem"
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("person"),  start: loc2, end: loc3),
      self.token(.in,                    start: loc4, end: loc5),
      self.token(.identifier("castle"),  start: loc6, end: loc7),
      self.token(.colon,                 start: loc8, end: loc9),
      self.token(.string("becomeItem"),  start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ForStmt(start: 0:0, end: 11:16)
        Target
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: person
        Iterable
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: castle
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(start: 10:10, end: 11:16)
              String: 'becomeItem'
        OrElse: none
    """)
  }

  /// for Gaston, in village: "evil"
  func test_withCommaAfterTarget_isTuple() {
    let parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("Gaston"),  start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.in,                    start: loc6, end: loc7),
      self.token(.identifier("village"), start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("evil"),        start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      ForStmt(start: 0:0, end: 13:18)
        Target
          TupleExpr(start: 2:2, end: 5:10)
            Elements
              IdentifierExpr(start: 2:2, end: 3:8)
                Value: Gaston
        Iterable
          IdentifierExpr(start: 8:8, end: 9:14)
            Value: village
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(start: 12:12, end: 13:18)
              String: 'evil'
        OrElse: none
    """)
  }

  /// for Gaston, LeFou in village: "evil"
  /// LeFou is Gaston sidekick
  func test_withCommaTargetTuple() {
    let parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("Gaston"),  start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("LeFou"),   start: loc6, end: loc7),
      self.token(.in,                    start: loc8, end: loc9),
      self.token(.identifier("village"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("evil"),        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ForStmt(start: 0:0, end: 15:20)
        Target
          TupleExpr(start: 2:2, end: 7:12)
            Elements
              IdentifierExpr(start: 2:2, end: 3:8)
                Value: Gaston
              IdentifierExpr(start: 6:6, end: 7:12)
                Value: LeFou
        Iterable
          IdentifierExpr(start: 10:10, end: 11:16)
            Value: village
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(start: 14:14, end: 15:20)
              String: 'evil'
        OrElse: none
    """)
  }

  /// for person in Belle, Maurice: "go castle"
  /// Maurice is Belle father
  func test_withIterTuple() {
    let parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("person"),  start: loc2, end: loc3),
      self.token(.in,                    start: loc4, end: loc5),
      self.token(.identifier("Belle"),   start: loc6, end: loc7),
      self.token(.comma,                 start: loc8, end: loc9),
      self.token(.identifier("Maurice"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("go castle"),   start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ForStmt(start: 0:0, end: 15:20)
        Target
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: person
        Iterable
          TupleExpr(start: 6:6, end: 11:16)
            Elements
              IdentifierExpr(start: 6:6, end: 7:12)
                Value: Belle
              IdentifierExpr(start: 10:10, end: 11:16)
                Value: Maurice
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(start: 14:14, end: 15:20)
              String: 'go castle'
        OrElse: none
    """)
  }

  /// for person in Belle: "Husband"
  /// else: "Beast"
  func test_withElse() {
    let parser = self.createStmtParser(
      self.token(.for,                  start: loc0, end: loc1),
      self.token(.identifier("person"), start: loc2, end: loc3),
      self.token(.in,                   start: loc4, end: loc5),
      self.token(.identifier("Belle"),  start: loc6, end: loc7),
      self.token(.colon,                start: loc8, end: loc9),
      self.token(.string("Husband"),    start: loc10, end: loc11),
      self.token(.newLine,              start: loc12, end: loc13),
      self.token(.else,                 start: loc14, end: loc15),
      self.token(.colon,                start: loc16, end: loc17),
      self.token(.string("Beast"),      start: loc18, end: loc19)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      ForStmt(start: 0:0, end: 19:24)
        Target
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: person
        Iterable
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: Belle
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(start: 10:10, end: 11:16)
              String: 'Husband'
        OrElse
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(start: 18:18, end: 19:24)
              String: 'Beast'
    """)
  }
}
