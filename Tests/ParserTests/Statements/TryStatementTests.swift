import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable function_body_length
// swiftlint:disable file_length

class TryStatementTests: XCTestCase,
  Common,
  DestructStatementKind,
  DestructExpressionKind,
  DestructStringGroup {

  // MARK: - No else or finally

  /// try: "Mulan"
  func test_try_withoutFinallyOrElse_throws() {
    var parser = self.createStmtParser(
      self.token(.try,             start: loc0, end: loc1),
      self.token(.colon,           start: loc2, end: loc3),
      self.token(.string("Mulan"), start: loc4, end: loc5)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .tryWithoutExceptOrFinally)
      XCTAssertEqual(error.location, loc0)
    }
  }

  // MARK: - Only finally

  /// try:     "Ping"
  /// finally: "Mulan"
  func test_finally() {
    var parser = self.createStmtParser(
      self.token(.try,             start: loc0,  end: loc1),
      self.token(.colon,           start: loc2,  end: loc3),
      self.token(.string("Ping"),  start: loc4,  end: loc5),
      self.token(.finally,         start: loc6,  end: loc7),
      self.token(.colon,           start: loc8,  end: loc9),
      self.token(.string("Mulan"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.handlers, [])
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ping\"")

      XCTAssertEqual(d.finalBody.count, 1)
      guard d.finalBody.count == 1 else { return }
      XCTAssertStatement(d.finalBody[0], "\"Mulan\"")

      XCTAssertStatement(stmt, "(try \"Ping\" finally: \"Mulan\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  // MARK: - Except

  /// try:    "Mulan"
  /// except: "Ping"
  func test_except() {
    var parser = self.createStmtParser(
      self.token(.try,             start: loc0,  end: loc1),
      self.token(.colon,           start: loc2,  end: loc3),
      self.token(.string("Mulan"), start: loc4,  end: loc5),
      self.token(.except,          start: loc6,  end: loc7),
      self.token(.colon,           start: loc8,  end: loc9),
      self.token(.string("Ping"),  start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.orElse, [])
      XCTAssertEqual(d.finalBody, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 1)
      guard d.handlers.count == 1 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except do: \"Ping\")")

      XCTAssertStatement(stmt, "(try \"Mulan\" (except do: \"Ping\"))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// try: "Mulan"
  /// except Soldier: "Ping"
  func test_except_type() {
    var parser = self.createStmtParser(
      self.token(.try,                   start: loc0,  end: loc1),
      self.token(.colon,                 start: loc2,  end: loc3),
      self.token(.string("Mulan"),       start: loc4,  end: loc5),
      self.token(.except,                start: loc6,  end: loc7),
      self.token(.identifier("Soldier"), start: loc8,  end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("Ping"),        start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.orElse, [])
      XCTAssertEqual(d.finalBody, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 1)
      guard d.handlers.count == 1 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except Soldier do: \"Ping\")")

      XCTAssertStatement(stmt, "(try \"Mulan\" (except Soldier do: \"Ping\"))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// try: "Mulan"
  /// except Disguise as Soldier: "Ping"
  /// ^OMG this works soo... well
  func test_except_type_withName() {
    var parser = self.createStmtParser(
      self.token(.try,                    start: loc0,  end: loc1),
      self.token(.colon,                  start: loc2,  end: loc3),
      self.token(.string("Mulan"),        start: loc4,  end: loc5),
      self.token(.except,                 start: loc6,  end: loc7),
      self.token(.identifier("Disguise"), start: loc8,  end: loc9),
      self.token(.as,                     start: loc10, end: loc11),
      self.token(.identifier("Soldier"),  start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ping"),         start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.orElse, [])
      XCTAssertEqual(d.finalBody, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 1)
      guard d.handlers.count == 1 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except Disguise as: Soldier do: \"Ping\")")

      XCTAssertStatement(stmt, "(try \"Mulan\" (except Disguise as: Soldier do: \"Ping\"))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// try: "Mulan"
  /// except Soldier: "Ping"
  /// except: "Pong"
  func test_except_multiple() {
    var parser = self.createStmtParser(
      self.token(.try,                   start: loc0,  end: loc1),
      self.token(.colon,                 start: loc2,  end: loc3),
      self.token(.string("Mulan"),       start: loc4,  end: loc5),
      self.token(.except,                start: loc6,  end: loc7),
      self.token(.identifier("Soldier"), start: loc8,  end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("Ping"),        start: loc12, end: loc13),
      self.token(.except,                start: loc14, end: loc15),
      self.token(.colon,                 start: loc16, end: loc17),
      self.token(.string("Pong"),        start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.orElse, [])
      XCTAssertEqual(d.finalBody, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 2)
      guard d.handlers.count == 2 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except Soldier do: \"Ping\")")
      XCTAssertExceptHandler(d.handlers[1], "(except do: \"Pong\")")

      XCTAssertStatement(stmt, "(try \"Mulan\" (except Soldier do: \"Ping\") (except do: \"Pong\"))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// else: "Fa Mulan"
  func test_except_else() {
    var parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.except,             start: loc6,  end: loc7),
      self.token(.colon,              start: loc8,  end: loc9),
      self.token(.string("Ping"),     start: loc10, end: loc11),
      self.token(.else,               start: loc12, end: loc13),
      self.token(.colon,              start: loc14, end: loc15),
      self.token(.string("Fa Mulan"), start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.finalBody, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 1)
      guard d.handlers.count == 1 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except do: \"Ping\")")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "\"Fa Mulan\"")

      print(stmt)
      XCTAssertStatement(stmt, "(try \"Mulan\" (except do: \"Ping\") else: \"Fa Mulan\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// finally: "Fa Mulan"
  func test_except_finally() {
    var parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.except,             start: loc6,  end: loc7),
      self.token(.colon,              start: loc8,  end: loc9),
      self.token(.string("Ping"),     start: loc10, end: loc11),
      self.token(.finally,            start: loc12, end: loc13),
      self.token(.colon,              start: loc14, end: loc15),
      self.token(.string("Fa Mulan"), start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 1)
      guard d.handlers.count == 1 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except do: \"Ping\")")

      XCTAssertEqual(d.finalBody.count, 1)
      guard d.finalBody.count == 1 else { return }
      XCTAssertStatement(d.finalBody[0], "\"Fa Mulan\"")

      print(stmt)
      XCTAssertStatement(stmt, "(try \"Mulan\" (except do: \"Ping\") finally: \"Fa Mulan\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// else:   "Pong"
  /// finally: "Fa Mulan"
  func test_except_else_finally() {
    var parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.except,             start: loc6,  end: loc7),
      self.token(.colon,              start: loc8,  end: loc9),
      self.token(.string("Ping"),     start: loc10, end: loc11),
      self.token(.else,               start: loc12, end: loc13),
      self.token(.colon,              start: loc14, end: loc15),
      self.token(.string("Pong"),     start: loc16, end: loc17),
      self.token(.finally,            start: loc18, end: loc19),
      self.token(.colon,              start: loc20, end: loc21),
      self.token(.string("Fa Mulan"), start: loc22, end: loc23)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructTry(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Mulan\"")

      XCTAssertEqual(d.handlers.count, 1)
      guard d.handlers.count == 1 else { return }
      XCTAssertExceptHandler(d.handlers[0], "(except do: \"Ping\")")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "\"Pong\"")

      XCTAssertEqual(d.finalBody.count, 1)
      guard d.finalBody.count == 1 else { return }
      XCTAssertStatement(d.finalBody[0], "\"Fa Mulan\"")

      print(stmt)
      XCTAssertStatement(stmt, "(try \"Mulan\" (except do: \"Ping\") else: \"Pong\" finally: \"Fa Mulan\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc23)
    }
  }

  // MARK: - Else without except

  /// try: "Mulan"
  /// else: "Ping"
  /// finally: "Fa Mulan"
  func test_else_withoutExcept_throws() {
    var parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.else,               start: loc6,  end: loc7),
      self.token(.colon,              start: loc8,  end: loc9),
      self.token(.string("Ping"),     start: loc10, end: loc11),
      self.token(.finally,            start: loc12, end: loc13),
      self.token(.colon,              start: loc14, end: loc15),
      self.token(.string("Fa Mulan"), start: loc16, end: loc17)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .tryWithElseWithoutExcept)
      XCTAssertEqual(error.location, loc0)
    }
  }
}
