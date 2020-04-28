import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAsync: XCTestCase, Common {

  /// async def cook(): "Ratatouille"
  func test_def() {
    let parser = self.createStmtParser(
      self.token(.async,                 start: loc0, end: loc1),
      self.token(.def,                   start: loc2, end: loc3),
      self.token(.identifier("cook"),    start: loc4, end: loc5),
      self.token(.leftParen,             start: loc6, end: loc7),
      self.token(.rightParen,            start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("Ratatouille"), start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      AsyncFunctionDefStmt(start: 0:0, end: 13:18)
        Name: cook
        Args
          Arguments(start: 8:8, end: 8:8)
            Args: none
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
    let parser = self.createStmtParser(
      self.token(.async,                start: loc0, end: loc1),
      self.token(.with,                 start: loc2, end: loc3),
      self.token(.identifier("Alice"),  start: loc4, end: loc5),
      self.token(.colon,                start: loc6, end: loc7),
      self.token(.string("wonderland"), start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.async,                 start: loc0, end: loc1),
      self.token(.for,                   start: loc2, end: loc3),
      self.token(.identifier("person"),  start: loc4, end: loc5),
      self.token(.in,                    start: loc6, end: loc7),
      self.token(.identifier("castle"),  start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("becomeItem"),  start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.async,                start: loc0, end: loc1),
      self.token(.while,                start: loc2, end: loc3),
      self.token(.identifier("Frollo"), start: loc4, end: loc5),
      self.token(.colon,                start: loc6, end: loc7),
      self.token(.string("Quasimodo"),  start: loc8, end: loc9)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .unexpectedToken(.while, expected: [.def, .with, .for]))
      XCTAssertEqual(error.location, loc2)
    }
  }
}
