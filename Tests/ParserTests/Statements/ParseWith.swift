import XCTest
import Core
import Lexer
@testable import Parser

class ParseWith: XCTestCase, Common, StatementMatcher {

  /// with Alice: "wonderland"
  func test_with() {
    var parser = self.createStmtParser(
      self.token(.with,                 start: loc0, end: loc1),
      self.token(.identifier("Alice"),  start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("wonderland"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchWith(stmt) else { return }

      XCTAssertEqual(d.items.count, 1)
      guard d.items.count == 1 else { return }
      XCTAssertWithItem(d.items[0], "Alice")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'wonderland'")

      XCTAssertStatement(stmt, "(with Alice do: 'wonderland')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// with Alice as smol: "wonderland"
  func test_with_alias() {
    var parser = self.createStmtParser(
      self.token(.with,                 start: loc0, end: loc1),
      self.token(.identifier("Alice"),  start: loc2, end: loc3),
      self.token(.as,                   start: loc4, end: loc5),
      self.token(.identifier("smol"),   start: loc6, end: loc7),
      self.token(.colon,                start: loc8, end: loc9),
      self.token(.string("wonderland"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchWith(stmt) else { return }

      XCTAssertEqual(d.items.count, 1)
      guard d.items.count == 1 else { return }
      XCTAssertWithItem(d.items[0], "(Alice as: smol)")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'wonderland'")

      XCTAssertStatement(stmt, "(with (Alice as: smol) do: 'wonderland')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// with Alice, Rabbit: "wonderland"
  func test_with_multipleItems() {
    var parser = self.createStmtParser(
      self.token(.with,                 start: loc0, end: loc1),
      self.token(.identifier("Alice"),  start: loc2, end: loc3),
      self.token(.comma,                start: loc4, end: loc5),
      self.token(.identifier("Rabbit"), start: loc6, end: loc7),
      self.token(.colon,                start: loc8, end: loc9),
      self.token(.string("wonderland"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchWith(stmt) else { return }

      XCTAssertEqual(d.items.count, 2)
      guard d.items.count == 2 else { return }
      XCTAssertWithItem(d.items[0], "Alice")
      XCTAssertWithItem(d.items[1], "Rabbit")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'wonderland'")

      XCTAssertStatement(stmt, "(with Alice Rabbit do: 'wonderland')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// with Alice as big, Rabbit as smol: "wonderland"
  func test_with_multipleItems_withAlias() {
    var parser = self.createStmtParser(
      self.token(.with,                 start: loc0, end: loc1),
      self.token(.identifier("Alice"),  start: loc2, end: loc3),
      self.token(.as,                   start: loc4, end: loc5),
      self.token(.identifier("big"),    start: loc6, end: loc7),
      self.token(.comma,                start: loc8, end: loc9),
      self.token(.identifier("Rabbit"), start: loc10, end: loc11),
      self.token(.as,                   start: loc12, end: loc13),
      self.token(.identifier("small"),  start: loc14, end: loc15),
      self.token(.colon,                start: loc16, end: loc17),
      self.token(.string("wonderland"), start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchWith(stmt) else { return }

      XCTAssertEqual(d.items.count, 2)
      guard d.items.count == 2 else { return }
      XCTAssertWithItem(d.items[0], "(Alice as: big)")
      XCTAssertWithItem(d.items[1], "(Rabbit as: small)")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'wonderland'")

      XCTAssertStatement(stmt, "(with (Alice as: big) (Rabbit as: small) do: 'wonderland')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }
}
