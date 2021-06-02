import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAssert: XCTestCase {

  /// assert Aladdin
  func test_simple() {
    let parser = createStmtParser(
      createToken(.assert,                start: loc0, end: loc1),
      createToken(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      AssertStmt(start: 0:0, end: 3:8)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Aladdin
        Msg: none
    """)
  }

  /// assert Aladdin, Jasmine
  func test_withMessage() {
    let parser = createStmtParser(
      createToken(.assert,                start: loc0, end: loc1),
      createToken(.identifier("Aladdin"), start: loc2, end: loc3),
      createToken(.comma,                 start: loc4, end: loc5),
      createToken(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AssertStmt(start: 0:0, end: 7:12)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Aladdin
        Msg
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Jasmine
    """)
  }
}
