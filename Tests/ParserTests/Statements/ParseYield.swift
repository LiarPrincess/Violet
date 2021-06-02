import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseYield: XCTestCase {

  // MARK: - Yield

  /// yield
  func test_withoutValue() {
    let parser = createStmtParser(
      createToken(.yield, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      ExprStmt(start: 0:0, end: 1:6)
        YieldExpr(context: Load, start: 0:0, end: 1:6)
          Value: none
    """)
  }

  /// yield Megara
  func test_value() {
    let parser = createStmtParser(
      createToken(.yield,                start: loc0, end: loc1),
      createToken(.identifier("Megara"), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      ExprStmt(start: 0:0, end: 3:8)
        YieldExpr(context: Load, start: 0:0, end: 3:8)
          Value
            IdentifierExpr(context: Load, start: 2:2, end: 3:8)
              Value: Megara
    """)
  }

  /// yield Megara,
  func test_value_withCommaAfter_yieldsTuple() {
    let parser = createStmtParser(
      createToken(.yield,                start: loc0, end: loc1),
      createToken(.identifier("Megara"), start: loc2, end: loc3),
      createToken(.comma,                start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      ExprStmt(start: 0:0, end: 5:10)
        YieldExpr(context: Load, start: 0:0, end: 5:10)
          Value
            TupleExpr(context: Load, start: 2:2, end: 5:10)
              Elements
                IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                  Value: Megara
    """)
  }

  /// yield Pain, Panic
  func test_value_multiple() {
    let parser = createStmtParser(
      createToken(.yield,           start: loc0, end: loc1),
      createToken(.identifier("Pain"), start: loc2, end: loc3),
      createToken(.comma,           start: loc4, end: loc5),
      createToken(.identifier("Panic"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ExprStmt(start: 0:0, end: 7:12)
        YieldExpr(context: Load, start: 0:0, end: 7:12)
          Value
            TupleExpr(context: Load, start: 2:2, end: 7:12)
              Elements
                IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                  Value: Pain
                IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                  Value: Panic
    """)
  }

  /// yield from Olympus
  func test_from() {
    let parser = createStmtParser(
      createToken(.yield,                 start: loc0, end: loc1),
      createToken(.from,                  start: loc2, end: loc3),
      createToken(.identifier("Olympus"), start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      ExprStmt(start: 0:0, end: 5:10)
        YieldFromExpr(context: Load, start: 0:0, end: 5:10)
          Value
            IdentifierExpr(context: Load, start: 4:4, end: 5:10)
              Value: Olympus
    """)
  }
}
