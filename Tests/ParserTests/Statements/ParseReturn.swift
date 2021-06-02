import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseReturn: XCTestCase {

  /// return
  func test_withoutValue() {
    let parser = createStmtParser(
      createToken(.return, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      ReturnStmt(start: 0:0, end: 1:6)
        Value: none
    """)
  }

  /// return Megara
  func test_value() {
    let parser = createStmtParser(
      createToken(.return,               start: loc0, end: loc1),
      createToken(.identifier("Megara"), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      ReturnStmt(start: 0:0, end: 3:8)
        Value
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Megara
    """)
  }

  /// return Megara,
  func test_withCommaAfter_returnsTuple() {
    let parser = createStmtParser(
      createToken(.return,               start: loc0, end: loc1),
      createToken(.identifier("Megara"), start: loc2, end: loc3),
      createToken(.comma,                start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      ReturnStmt(start: 0:0, end: 5:10)
        Value
          TupleExpr(context: Load, start: 2:2, end: 5:10)
            Elements
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Megara
    """)
  }

  /// return Calliope, Melpomene, Terpsichore
  /// Those are the names of the muses (Thalia and Clio are missing)
  func test_multiple() {
    let parser = createStmtParser(
      createToken(.return,                    start: loc0, end: loc1),
      createToken(.identifier("Calliope"),    start: loc2, end: loc3),
      createToken(.comma,                     start: loc4, end: loc5),
      createToken(.identifier("Melpomene"),   start: loc6, end: loc7),
      createToken(.comma,                     start: loc8, end: loc9),
      createToken(.identifier("Terpsichore"), start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ReturnStmt(start: 0:0, end: 11:16)
        Value
          TupleExpr(context: Load, start: 2:2, end: 11:16)
            Elements
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Calliope
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: Melpomene
              IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                Value: Terpsichore
    """)
  }
}
