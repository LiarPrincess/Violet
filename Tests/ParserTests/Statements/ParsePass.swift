import XCTest
import Core
import Lexer
@testable import Parser

class ParsePass: XCTestCase, Common {

  /// pass
  func test_pass() {
    let parser = self.createStmtParser(
      self.token(.pass, start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      PassStmt(start: 0:0, end: 1:6)
    """)
  }
}
