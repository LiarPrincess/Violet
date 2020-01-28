import XCTest
import Core
import Lexer
@testable import Parser

class ParseExpressionStatement: XCTestCase, Common {

  /// "Ariel+Eric"
  func test_expression() {
    let parser = self.createStmtParser(
      self.token(.string("Ariel+Eric"), start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      ExprStmt(start: 0:0, end: 1:6)
        StringExpr(context: Load, start: 0:0, end: 1:6)
          String: 'Ariel+Eric'
    """)
  }
}
