import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParsePass: XCTestCase {

  /// pass
  func test_pass() {
    let parser = createStmtParser(
      createToken(.pass, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      PassStmt(start: 0:0, end: 1:6)
    """)
  }
}
