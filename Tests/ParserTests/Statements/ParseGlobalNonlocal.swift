import XCTest
import Core
import Lexer
@testable import Parser

class ParseGlobalNonlocal: XCTestCase, Common, StatementMatcher {

  // MARK: - global

  /// global Aladdin
  func test_global() {
    var parser = self.createStmtParser(
      self.token(.global,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchGlobal(stmt) else { return }

      XCTAssertEqual(d, ["Aladdin"])

      XCTAssertStatement(stmt, "(global Aladdin)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// global Aladdin, Jasmine
  func test_global_multiple() {
    var parser = self.createStmtParser(
      self.token(.global,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchGlobal(stmt) else { return }

      XCTAssertEqual(d, ["Aladdin", "Jasmine"])

      XCTAssertStatement(stmt, "(global Aladdin Jasmine)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - nonlocal

  /// nonlocal Genie
  func test_nonlocal() {
    var parser = self.createStmtParser(
      self.token(.nonlocal,            start: loc0, end: loc1),
      self.token(.identifier("Genie"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchNonlocal(stmt) else { return }

      XCTAssertEqual(d, ["Genie"])

      XCTAssertStatement(stmt, "(nonlocal Genie)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// nonlocal Genie, MagicCarpet
  func test_nonlocal_multiple() {
    var parser = self.createStmtParser(
      self.token(.nonlocal,                  start: loc0, end: loc1),
      self.token(.identifier("Genie"),       start: loc2, end: loc3),
      self.token(.comma,                     start: loc4, end: loc5),
      self.token(.identifier("MagicCarpet"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchNonlocal(stmt) else { return }

      XCTAssertEqual(d, ["Genie", "MagicCarpet"])

      XCTAssertStatement(stmt, "(nonlocal Genie MagicCarpet)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }
}
