import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseGlobalNonlocal: XCTestCase {

  // MARK: - global

  /// global Aladdin
  func test_global() {
    let parser = createStmtParser(
      createToken(.global,                start: loc0, end: loc1),
      createToken(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      GlobalStmt(start: 0:0, end: 3:8)
        Aladdin
    """)
  }

  /// global Aladdin, Jasmine
  func test_global_multiple() {
    let parser = createStmtParser(
      createToken(.global,                start: loc0, end: loc1),
      createToken(.identifier("Aladdin"), start: loc2, end: loc3),
      createToken(.comma,                 start: loc4, end: loc5),
      createToken(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createStmtParser(
      createToken(.nonlocal,            start: loc0, end: loc1),
      createToken(.identifier("Genie"), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      NonlocalStmt(start: 0:0, end: 3:8)
        Genie
    """)
  }

  /// nonlocal Genie, MagicCarpet
  func test_nonlocal_multiple() {
    let parser = createStmtParser(
      createToken(.nonlocal,                  start: loc0, end: loc1),
      createToken(.identifier("Genie"),       start: loc2, end: loc3),
      createToken(.comma,                     start: loc4, end: loc5),
      createToken(.identifier("MagicCarpet"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      NonlocalStmt(start: 0:0, end: 7:12)
        Genie
        MagicCarpet
    """)
  }
}
