import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseFor: XCTestCase {

  /// for person in castle: "becomeItem"
  func test_simple() {
    let parser = createStmtParser(
      createToken(.for,                   start: loc0, end: loc1),
      createToken(.identifier("person"),  start: loc2, end: loc3),
      createToken(.in,                    start: loc4, end: loc5),
      createToken(.identifier("castle"),  start: loc6, end: loc7),
      createToken(.colon,                 start: loc8, end: loc9),
      createToken(.string("becomeItem"),  start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ForStmt(start: 0:0, end: 11:16)
        Target
          IdentifierExpr(context: Store, start: 2:2, end: 3:8)
            Value: person
        Iterable
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: castle
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(context: Load, start: 10:10, end: 11:16)
              String: 'becomeItem'
        OrElse: none
    """)
  }

  /// for Gaston, in village: "evil"
  func test_withCommaAfterTarget_isTuple() {
    let parser = createStmtParser(
      createToken(.for,                   start: loc0, end: loc1),
      createToken(.identifier("Gaston"),  start: loc2, end: loc3),
      createToken(.comma,                 start: loc4, end: loc5),
      createToken(.in,                    start: loc6, end: loc7),
      createToken(.identifier("village"), start: loc8, end: loc9),
      createToken(.colon,                 start: loc10, end: loc11),
      createToken(.string("evil"),        start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      ForStmt(start: 0:0, end: 13:18)
        Target
          TupleExpr(context: Store, start: 2:2, end: 5:10)
            Elements
              IdentifierExpr(context: Store, start: 2:2, end: 3:8)
                Value: Gaston
        Iterable
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: village
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'evil'
        OrElse: none
    """)
  }

  /// for Gaston, LeFou in village: "evil"
  /// LeFou is Gaston sidekick
  func test_withCommaTargetTuple() {
    let parser = createStmtParser(
      createToken(.for,                   start: loc0, end: loc1),
      createToken(.identifier("Gaston"),  start: loc2, end: loc3),
      createToken(.comma,                 start: loc4, end: loc5),
      createToken(.identifier("LeFou"),   start: loc6, end: loc7),
      createToken(.in,                    start: loc8, end: loc9),
      createToken(.identifier("village"), start: loc10, end: loc11),
      createToken(.colon,                 start: loc12, end: loc13),
      createToken(.string("evil"),        start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ForStmt(start: 0:0, end: 15:20)
        Target
          TupleExpr(context: Store, start: 2:2, end: 7:12)
            Elements
              IdentifierExpr(context: Store, start: 2:2, end: 3:8)
                Value: Gaston
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: LeFou
        Iterable
          IdentifierExpr(context: Load, start: 10:10, end: 11:16)
            Value: village
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'evil'
        OrElse: none
    """)
  }

  /// for person in Belle, Maurice: "go castle"
  /// Maurice is Belle father
  func test_withIterTuple() {
    let parser = createStmtParser(
      createToken(.for,                   start: loc0, end: loc1),
      createToken(.identifier("person"),  start: loc2, end: loc3),
      createToken(.in,                    start: loc4, end: loc5),
      createToken(.identifier("Belle"),   start: loc6, end: loc7),
      createToken(.comma,                 start: loc8, end: loc9),
      createToken(.identifier("Maurice"), start: loc10, end: loc11),
      createToken(.colon,                 start: loc12, end: loc13),
      createToken(.string("go castle"),   start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ForStmt(start: 0:0, end: 15:20)
        Target
          IdentifierExpr(context: Store, start: 2:2, end: 3:8)
            Value: person
        Iterable
          TupleExpr(context: Load, start: 6:6, end: 11:16)
            Elements
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: Belle
              IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                Value: Maurice
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'go castle'
        OrElse: none
    """)
  }

  /// for person in Belle: "Husband"
  /// else: "Beast"
  func test_withElse() {
    let parser = createStmtParser(
      createToken(.for,                  start: loc0, end: loc1),
      createToken(.identifier("person"), start: loc2, end: loc3),
      createToken(.in,                   start: loc4, end: loc5),
      createToken(.identifier("Belle"),  start: loc6, end: loc7),
      createToken(.colon,                start: loc8, end: loc9),
      createToken(.string("Husband"),    start: loc10, end: loc11),
      createToken(.newLine,              start: loc12, end: loc13),
      createToken(.else,                 start: loc14, end: loc15),
      createToken(.colon,                start: loc16, end: loc17),
      createToken(.string("Beast"),      start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      ForStmt(start: 0:0, end: 19:24)
        Target
          IdentifierExpr(context: Store, start: 2:2, end: 3:8)
            Value: person
        Iterable
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Belle
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(context: Load, start: 10:10, end: 11:16)
              String: 'Husband'
        OrElse
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'Beast'
    """)
  }
}
