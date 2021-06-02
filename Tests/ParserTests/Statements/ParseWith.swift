import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseWith: XCTestCase {

  /// with Alice: "wonderland"
  func test_simple() {
    let parser = createStmtParser(
      createToken(.with,                 start: loc0, end: loc1),
      createToken(.identifier("Alice"),  start: loc2, end: loc3),
      createToken(.colon,                start: loc4, end: loc5),
      createToken(.string("wonderland"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      WithStmt(start: 0:0, end: 7:12)
        Items
          WithItem(start: 2:2, end: 3:8)
            ContextExpr
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Alice
            OptionalVars: none
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'wonderland'
    """)
  }

  /// with Alice as smol: "wonderland"
  func test_alias() {
    let parser = createStmtParser(
      createToken(.with,                 start: loc0, end: loc1),
      createToken(.identifier("Alice"),  start: loc2, end: loc3),
      createToken(.as,                   start: loc4, end: loc5),
      createToken(.identifier("smol"),   start: loc6, end: loc7),
      createToken(.colon,                start: loc8, end: loc9),
      createToken(.string("wonderland"), start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      WithStmt(start: 0:0, end: 11:16)
        Items
          WithItem(start: 2:2, end: 7:12)
            ContextExpr
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Alice
            OptionalVars
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: smol
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(context: Load, start: 10:10, end: 11:16)
              String: 'wonderland'
    """)
  }

  /// with Alice, Rabbit: "wonderland"
  func test_multipleItems() {
    let parser = createStmtParser(
      createToken(.with,                 start: loc0, end: loc1),
      createToken(.identifier("Alice"),  start: loc2, end: loc3),
      createToken(.comma,                start: loc4, end: loc5),
      createToken(.identifier("Rabbit"), start: loc6, end: loc7),
      createToken(.colon,                start: loc8, end: loc9),
      createToken(.string("wonderland"), start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      WithStmt(start: 0:0, end: 11:16)
        Items
          WithItem(start: 2:2, end: 3:8)
            ContextExpr
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Alice
            OptionalVars: none
          WithItem(start: 6:6, end: 7:12)
            ContextExpr
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: Rabbit
            OptionalVars: none
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(context: Load, start: 10:10, end: 11:16)
              String: 'wonderland'
    """)
  }

  /// with Alice as big, Rabbit as smol: "wonderland"
  func test_multipleItems_withAlias() {
    let parser = createStmtParser(
      createToken(.with,                 start: loc0, end: loc1),
      createToken(.identifier("Alice"),  start: loc2, end: loc3),
      createToken(.as,                   start: loc4, end: loc5),
      createToken(.identifier("big"),    start: loc6, end: loc7),
      createToken(.comma,                start: loc8, end: loc9),
      createToken(.identifier("Rabbit"), start: loc10, end: loc11),
      createToken(.as,                   start: loc12, end: loc13),
      createToken(.identifier("small"),  start: loc14, end: loc15),
      createToken(.colon,                start: loc16, end: loc17),
      createToken(.string("wonderland"), start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      WithStmt(start: 0:0, end: 19:24)
        Items
          WithItem(start: 2:2, end: 7:12)
            ContextExpr
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Alice
            OptionalVars
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: big
          WithItem(start: 10:10, end: 15:20)
            ContextExpr
              IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                Value: Rabbit
            OptionalVars
              IdentifierExpr(context: Store, start: 14:14, end: 15:20)
                Value: small
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'wonderland'
    """)
  }
}
