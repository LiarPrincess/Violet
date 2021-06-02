import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseContinueBreak: XCTestCase {

  /// break
  func test_break() {
    let parser = createStmtParser(
      createToken(.break, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      BreakStmt(start: 0:0, end: 1:6)
    """)
  }

  /// continue
  func test_continue() {
    let parser = createStmtParser(
      createToken(.continue, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      ContinueStmt(start: 0:0, end: 1:6)
    """)
  }
}
