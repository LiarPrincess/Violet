import XCTest
import Core
import Lexer
@testable import Parser

class ParseAssert: XCTestCase, Common {

  /// assert Aladdin
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.assert,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      AssertStmt(start: 0:0, end: 3:8)
        Test
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: Aladdin
        Msg: none
    """)
  }

  /// assert Aladdin, Jasmine
  func test_withMessage() {
    let parser = self.createStmtParser(
      self.token(.assert,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AssertStmt(start: 0:0, end: 7:12)
        Test
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: Aladdin
        Msg
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: Jasmine
    """)
  }
}
