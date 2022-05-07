import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAsync: XCTestCase {

  /// async def cook(): "Ratatouille"
  func test_def() {
    let parser = createStmtParser(
      createToken(.async,                 start: loc0, end: loc1),
      createToken(.def,                   start: loc2, end: loc3),
      createToken(.identifier("cook"),    start: loc4, end: loc5),
      createToken(.leftParen,             start: loc6, end: loc7),
      createToken(.rightParen,            start: loc8, end: loc9),
      createToken(.colon,                 start: loc10, end: loc11),
      createToken(.string("Ratatouille"), start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      AsyncFunctionDefStmt(start: 0:0, end: 13:18)
        Name: cook
        Args
          Arguments(start: 8:8, end: 8:8)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// async with Alice: "wonderland"
  func test_with() {
    let parser = createStmtParser(
      createToken(.async,                start: loc0, end: loc1),
      createToken(.with,                 start: loc2, end: loc3),
      createToken(.identifier("Alice"),  start: loc4, end: loc5),
      createToken(.colon,                start: loc6, end: loc7),
      createToken(.string("wonderland"), start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AsyncWithStmt(start: 0:0, end: 9:14)
        Items
          WithItem(start: 4:4, end: 5:10)
            ContextExpr
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: Alice
            OptionalVars: none
        Body
          ExprStmt(start: 8:8, end: 9:14)
            StringExpr(context: Load, start: 8:8, end: 9:14)
              String: 'wonderland'
    """)
  }

  /// async for person in castle: "becomeItem"
  func test_for() {
    let parser = createStmtParser(
      createToken(.async,                 start: loc0, end: loc1),
      createToken(.for,                   start: loc2, end: loc3),
      createToken(.identifier("person"),  start: loc4, end: loc5),
      createToken(.in,                    start: loc6, end: loc7),
      createToken(.identifier("castle"),  start: loc8, end: loc9),
      createToken(.colon,                 start: loc10, end: loc11),
      createToken(.string("becomeItem"),  start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      AsyncForStmt(start: 0:0, end: 13:18)
        Target
          IdentifierExpr(context: Store, start: 4:4, end: 5:10)
            Value: person
        Iterable
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: castle
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'becomeItem'
        OrElse: none
    """)
  }

  /// async while Frollo: "Quasimodo"
  func test_while_throws() {
    let parser = createStmtParser(
      createToken(.async,                start: loc0, end: loc1),
      createToken(.while,                start: loc2, end: loc3),
      createToken(.identifier("Frollo"), start: loc4, end: loc5),
      createToken(.colon,                start: loc6, end: loc7),
      createToken(.string("Quasimodo"),  start: loc8, end: loc9)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .unexpectedToken(.while, expected: [.def, .with, .for]))
      XCTAssertEqual(error.location, loc2)
    }
  }
}
