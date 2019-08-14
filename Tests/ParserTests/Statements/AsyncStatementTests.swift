import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable function_body_length

class AsyncStatementTests: XCTestCase, Common, DestructStatementKind {

  /// async def cook(): "Ratatouille"
  func test_def() {
    var parser = self.createStmtParser(
      self.token(.async,                 start: loc0, end: loc1),
      self.token(.def,                   start: loc2, end: loc3),
      self.token(.identifier("cook"),    start: loc4, end: loc5),
      self.token(.leftParen,             start: loc6, end: loc7),
      self.token(.rightParen,            start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("Ratatouille"), start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAsyncFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc8)
      XCTAssertEqual(d.args.end,   loc8)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(asyncDef cook () do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// async with Alice: "wonderland"
  func test_with() {
    var parser = self.createStmtParser(
      self.token(.async,                start: loc0, end: loc1),
      self.token(.with,                 start: loc2, end: loc3),
      self.token(.identifier("Alice"),  start: loc4, end: loc5),
      self.token(.colon,                start: loc6, end: loc7),
      self.token(.string("wonderland"), start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAsyncWith(stmt) else { return }

      XCTAssertEqual(d.items.count, 1)
      guard d.items.count == 1 else { return }
      XCTAssertWithItem(d.items[0], "Alice")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"wonderland\"")

      XCTAssertStatement(stmt, "(asyncWith Alice do: \"wonderland\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// async for person in castle: "becomeItem"
  func test_for() {
    var parser = self.createStmtParser(
      self.token(.async,                 start: loc0, end: loc1),
      self.token(.for,                   start: loc2, end: loc3),
      self.token(.identifier("person"),  start: loc4, end: loc5),
      self.token(.in,                    start: loc6, end: loc7),
      self.token(.identifier("castle"),  start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("becomeItem"),  start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAsyncFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "castle")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"becomeItem\"")

      XCTAssertStatement(stmt, "(asyncFor person in: castle do: \"becomeItem\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// async while Frollo: "Quasimodo"
  func test_while_throws() {
    var parser = self.createStmtParser(
      self.token(.async,                start: loc0, end: loc1),
      self.token(.while,                start: loc2, end: loc3),
      self.token(.identifier("Frollo"), start: loc4, end: loc5),
      self.token(.colon,                start: loc6, end: loc7),
      self.token(.string("Quasimodo"),  start: loc8, end: loc9)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .unexpectedToken(.while, expected: [.def, .with, .for]))
      XCTAssertEqual(error.location, loc2)
    }
  }
}
