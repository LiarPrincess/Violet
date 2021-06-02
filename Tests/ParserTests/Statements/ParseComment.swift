import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseComment: XCTestCase {

  /// \# Elsa
  /// pass
  func test_startWithComment() {
    let parser = createStmtParser(
      createToken(.comment("Elsa"), start: loc0, end: loc1),
      createToken(.newLine,         start: loc2, end: loc3),
      createToken(.pass,            start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 2:2, end: 5:10)
      PassStmt(start: 4:4, end: 5:10)
    """)
  }

  /// \# Elsa
  /// pass
  /// pass
  func test_startWithComment_multipleStatements() {
    let parser = createStmtParser(
      createToken(.comment("Elsa"), start: loc0, end: loc1),
      createToken(.newLine,         start: loc2, end: loc3),
      createToken(.pass,            start: loc4, end: loc5),
      createToken(.newLine,         start: loc6, end: loc7),
      createToken(.pass,            start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 2:2, end: 9:14)
      PassStmt(start: 4:4, end: 5:10)
      PassStmt(start: 8:8, end: 9:14)
    """)
  }
}
