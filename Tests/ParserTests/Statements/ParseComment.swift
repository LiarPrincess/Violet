import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

class ParseComment: XCTestCase, Common {

  /// \# Elsa
  /// pass
  func test_startWithComment() {
    let parser = self.createStmtParser(
      self.token(.comment("Elsa"), start: loc0, end: loc1),
      self.token(.newLine,         start: loc2, end: loc3),
      self.token(.pass,            start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 4:4, end: 5:10)
      PassStmt(start: 4:4, end: 5:10)
    """)
  }

  /// \# Elsa
  /// pass
  /// pass
  func test_startWithComment_multipleStatements() {
    let parser = self.createStmtParser(
      self.token(.comment("Elsa"), start: loc0, end: loc1),
      self.token(.newLine,         start: loc2, end: loc3),
      self.token(.pass,            start: loc4, end: loc5),
      self.token(.newLine,         start: loc6, end: loc7),
      self.token(.pass,            start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 4:4, end: 9:14)
      PassStmt(start: 4:4, end: 5:10)
      PassStmt(start: 8:8, end: 9:14)
    """)
  }
}
