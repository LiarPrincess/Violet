import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseGlobalNonlocal: XCTestCase, Common {

  // MARK: - global

  /// global Aladdin
  func test_global() {
    let parser = self.createStmtParser(
      self.token(.global,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      GlobalStmt(start: 0:0, end: 3:8)
        Aladdin
    """)
  }

  /// global Aladdin, Jasmine
  func test_global_multiple() {
    let parser = self.createStmtParser(
      self.token(.global,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      GlobalStmt(start: 0:0, end: 7:12)
        Aladdin
        Jasmine
    """)
  }

  // MARK: - nonlocal

  /// nonlocal Genie
  func test_nonlocal() {
    let parser = self.createStmtParser(
      self.token(.nonlocal,            start: loc0, end: loc1),
      self.token(.identifier("Genie"), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      NonlocalStmt(start: 0:0, end: 3:8)
        Genie
    """)
  }

  /// nonlocal Genie, MagicCarpet
  func test_nonlocal_multiple() {
    let parser = self.createStmtParser(
      self.token(.nonlocal,                  start: loc0, end: loc1),
      self.token(.identifier("Genie"),       start: loc2, end: loc3),
      self.token(.comma,                     start: loc4, end: loc5),
      self.token(.identifier("MagicCarpet"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      NonlocalStmt(start: 0:0, end: 7:12)
        Genie
        MagicCarpet
    """)
  }
}
