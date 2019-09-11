import XCTest
import Core
import Lexer
@testable import Parser

class ParseAnnAssign: XCTestCase,
Common, ExpressionMatcher, StatementMatcher, StringMatcher {

  /// Flounder:Animal = "Friend"
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Flounder"), start: loc0, end: loc1),
      self.token(.colon,                  start: loc2, end: loc3),
      self.token(.identifier("Animal"),   start: loc4, end: loc5),
      self.token(.equal,                  start: loc6, end: loc7),
      self.token(.string("Friend"),       start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Flounder")
      XCTAssertExpression(d.annotation, "Animal")
      XCTAssertExpression(d.value, "'Friend'")
      XCTAssertEqual(d.isSimple, true)

      XCTAssertStatement(stmt, "(Flounder:Animal = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// Ariel:Mermaid
  func test_withoutValue() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"),   start: loc0, end: loc1),
      self.token(.colon,                 start: loc2, end: loc3),
      self.token(.identifier("Mermaid"), start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Ariel")
      XCTAssertExpression(d.annotation, "Mermaid")
      XCTAssertEqual(d.value, nil)
      XCTAssertEqual(d.isSimple, true)

      XCTAssertStatement(stmt, "(Ariel:Mermaid)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// Sea.Flounder:Animal = "Friend"
  func test_toAttribute() {

    var parser = self.createStmtParser(
      self.token(.identifier("Sea"),      start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.identifier("Flounder"), start: loc4, end: loc5),
      self.token(.colon,                  start: loc6, end: loc7),
      self.token(.identifier("Animal"),   start: loc8, end: loc9),
      self.token(.equal,                  start: loc10, end: loc11),
      self.token(.string("Friend"),       start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Sea.Flounder")
      XCTAssertExpression(d.annotation, "Animal")
      XCTAssertExpression(d.value, "'Friend'")
      XCTAssertEqual(d.isSimple, false) // <-- this

      XCTAssertStatement(stmt, "(Sea.Flounder:Animal = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// Sea[Flounder]:Animal = "Friend"
  func test_toSubscript() {
    var parser = self.createStmtParser(
      self.token(.identifier("Sea"),      start: loc0, end: loc1),
      self.token(.leftSqb,                start: loc2, end: loc3),
      self.token(.identifier("Flounder"), start: loc4, end: loc5),
      self.token(.rightSqb,               start: loc6, end: loc7),
      self.token(.colon,                  start: loc8, end: loc9),
      self.token(.identifier("Animal"),   start: loc10, end: loc11),
      self.token(.equal,                  start: loc12, end: loc13),
      self.token(.string("Friend"),       start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Sea[Flounder]")
      XCTAssertExpression(d.annotation, "Animal")
      XCTAssertExpression(d.value, "'Friend'")
      XCTAssertEqual(d.isSimple, false) // <-- this

      XCTAssertStatement(stmt, "(Sea[Flounder]:Animal = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// (Ariel):Mermaid = "Princess"
  func test_inParen_isNotSimple() {
    var parser = self.createStmtParser(
      self.token(.leftParen,             start: loc0, end: loc1),
      self.token(.identifier("Ariel"),   start: loc2, end: loc3),
      self.token(.rightParen,            start: loc4, end: loc5),
      self.token(.colon,                 start: loc6, end: loc7),
      self.token(.identifier("Mermaid"), start: loc8, end: loc9),
      self.token(.equal,                 start: loc10, end: loc11),
      self.token(.string("Princess"),    start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Ariel")
      XCTAssertExpression(d.annotation, "Mermaid")
      XCTAssertExpression(d.value, "'Princess'")
      XCTAssertEqual(d.isSimple, false) // <-- this (because parens!)

      XCTAssertStatement(stmt, "(Ariel:Mermaid = 'Princess')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// 3:Witch = "Ursula"
  func test_toConstants_throws() {
    var parser = self.createStmtParser(
      self.token(.int(BigInt(3)),       start: loc0, end: loc1),
      self.token(.colon,                start: loc2, end: loc3),
      self.token(.identifier("Witch"),  start: loc4, end: loc5),
      self.token(.equal,                start: loc6, end: loc7),
      self.token(.string("Ursula"),     start: loc8, end: loc9)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAnnAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }
}
