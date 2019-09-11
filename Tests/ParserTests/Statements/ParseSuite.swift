import XCTest
import Core
import Lexer
@testable import Parser

/// ```c
/// class    with function
/// function with if
/// if       with while
/// while    with for
/// for      with with
/// with     with class
/// try??
/// ```
class ParseSuite: XCTestCase, Common, ExpressionMatcher, StatementMatcher {

  /// class Peter:
  ///   def fly():
  ///     up
  func test_class_withFunction() {
    var parser = self.createStmtParser(
      self.token(.class,               start: loc0, end: loc1),
      self.token(.identifier("Peter"), start: loc2, end: loc3),
      self.token(.colon,               start: loc4, end: loc5),
      self.token(.newLine,             start: loc6, end: loc7),
      self.token(.indent,              start: loc8, end: loc9),
      self.token(.def,                 start: loc10, end: loc11),
      self.token(.identifier("fly"),   start: loc12, end: loc13),
      self.token(.leftParen,           start: loc14, end: loc15),
      self.token(.rightParen,          start: loc16, end: loc17),
      self.token(.colon,               start: loc18, end: loc19),
      self.token(.newLine,             start: loc20, end: loc21),
      self.token(.indent,              start: loc22, end: loc23),
      self.token(.string("up"),        start: loc24, end: loc25),
      self.token(.newLine,             start: loc26, end: loc27),
      self.token(.dedent,              start: loc28, end: loc29),
      self.token(.dedent,              start: loc30, end: loc31)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "(def fly() do: 'up')")

      XCTAssertStatement(stmt, "(class Peter body: (def fly() do: 'up'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25) // 'up' is is last statement
    }
  }

  /// def fly():
  ///   if Peter:
  ///      fly
  func test_function_withIf() {
    var parser = self.createStmtParser(
      self.token(.def,                 start: loc0, end: loc1),
      self.token(.identifier("fly"),   start: loc2, end: loc3),
      self.token(.leftParen,           start: loc4, end: loc5),
      self.token(.rightParen,          start: loc6, end: loc7),
      self.token(.colon,               start: loc8, end: loc9),
      self.token(.newLine,             start: loc10, end: loc11),
      self.token(.indent,              start: loc12, end: loc13),
      self.token(.if,                  start: loc14, end: loc15),
      self.token(.identifier("Peter"), start: loc16, end: loc17),
      self.token(.colon,               start: loc18, end: loc19),
      self.token(.newLine,             start: loc20, end: loc21),
      self.token(.indent,              start: loc22, end: loc23),
      self.token(.identifier("fly"),   start: loc24, end: loc25),
      self.token(.newLine,             start: loc26, end: loc27),
      self.token(.dedent,              start: loc28, end: loc29),
      self.token(.dedent,              start: loc30, end: loc31)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFunctionDef(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "(if Peter then: fly)")

      XCTAssertStatement(stmt, "(def fly() do: (if Peter then: fly))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25) // 'fly' is is last statement
    }
  }

  /// if Hook:
  ///   while tick:
  ///      run
  func test_if_withWhile() {
    var parser = self.createStmtParser(
      self.token(.if,                 start: loc0, end: loc1),
      self.token(.identifier("Hook"), start: loc2, end: loc3),
      self.token(.colon,              start: loc4, end: loc5),
      self.token(.newLine,            start: loc6, end: loc7),
      self.token(.indent,             start: loc8, end: loc9),
      self.token(.while,              start: loc10, end: loc11),
      self.token(.identifier("tick"), start: loc12, end: loc13),
      self.token(.colon,              start: loc14, end: loc15),
      self.token(.newLine,            start: loc16, end: loc17),
      self.token(.indent,             start: loc18, end: loc19),
      self.token(.string("run"),      start: loc20, end: loc21),
      self.token(.newLine,            start: loc22, end: loc23),
      self.token(.dedent,             start: loc24, end: loc25),
      self.token(.dedent,             start: loc26, end: loc27)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchIf(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "(while tick do: 'run')")

      XCTAssertStatement(stmt, "(if Hook then: (while tick do: 'run'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc21) // 'run' is is last statement
    }
  }

  /// while tick:
  ///   for tock in crocodile:
  ///      run
  func test_while_withFor() {
    var parser = self.createStmtParser(
      self.token(.while,                   start: loc0, end: loc1),
      self.token(.identifier("tick"),      start: loc2, end: loc3),
      self.token(.colon,                   start: loc4, end: loc5),
      self.token(.newLine,                 start: loc6, end: loc7),
      self.token(.indent,                  start: loc8, end: loc9),
      self.token(.for,                     start: loc10, end: loc11),
      self.token(.identifier("tock"),      start: loc12, end: loc13),
      self.token(.in,                      start: loc14, end: loc15),
      self.token(.identifier("crocodile"), start: loc16, end: loc17),
      self.token(.colon,                   start: loc18, end: loc19),
      self.token(.newLine,                 start: loc20, end: loc21),
      self.token(.indent,                  start: loc22, end: loc23),
      self.token(.string("run"),           start: loc24, end: loc25),
      self.token(.newLine,                 start: loc26, end: loc27),
      self.token(.dedent,                  start: loc28, end: loc29),
      self.token(.dedent,                  start: loc30, end: loc31)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchWhile(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "(for tock in: crocodile do: 'run')")

      XCTAssertStatement(stmt, "(while tick do: (for tock in: crocodile do: 'run'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25) // 'run' is is last statement
    }
  }

  /// for tock in crocodile:
  ///   with Hook:
  ///      run
  func test_for_withWith() {
    var parser = self.createStmtParser(
      self.token(.for,                     start: loc0, end: loc1),
      self.token(.identifier("tock"),      start: loc2, end: loc3),
      self.token(.in,                      start: loc4, end: loc5),
      self.token(.identifier("crocodile"), start: loc6, end: loc7),
      self.token(.colon,                   start: loc8, end: loc9),
      self.token(.newLine,                 start: loc10, end: loc11),
      self.token(.indent,                  start: loc12, end: loc13),
      self.token(.with,                    start: loc14, end: loc15),
      self.token(.identifier("Hook"),      start: loc16, end: loc17),
      self.token(.colon,                   start: loc18, end: loc19),
      self.token(.newLine,                 start: loc20, end: loc21),
      self.token(.indent,                  start: loc22, end: loc23),
      self.token(.string("run"),           start: loc24, end: loc25),
      self.token(.newLine,                 start: loc26, end: loc27),
      self.token(.dedent,                  start: loc28, end: loc29),
      self.token(.dedent,                  start: loc30, end: loc31)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFor(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "(with Hook do: 'run')")

      XCTAssertStatement(stmt, "(for tock in: crocodile do: (with Hook do: 'run'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25) // 'run' is is last statement
    }
  }

  /// with TinkerBell:
  ///   class Dust:
  ///      fly
  func test_with_withClass() {
    var parser = self.createStmtParser(
      self.token(.with,                     start: loc0, end: loc1),
      self.token(.identifier("TinkerBell"), start: loc2, end: loc3),
      self.token(.colon,                    start: loc4, end: loc5),
      self.token(.newLine,                  start: loc6, end: loc7),
      self.token(.indent,                   start: loc8, end: loc9),
      self.token(.class,                    start: loc10, end: loc11),
      self.token(.identifier("Dust"),       start: loc12, end: loc13),
      self.token(.colon,                    start: loc14, end: loc15),
      self.token(.newLine,                  start: loc16, end: loc17),
      self.token(.indent,                   start: loc18, end: loc19),
      self.token(.string("fly"),            start: loc20, end: loc21),
      self.token(.newLine,                  start: loc22, end: loc23),
      self.token(.dedent,                   start: loc24, end: loc25),
      self.token(.dedent,                   start: loc26, end: loc27)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchWith(stmt) else { return }

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "(class Dust body: 'fly')")

      XCTAssertStatement(stmt, "(with TinkerBell do: (class Dust body: 'fly'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc21) // 'fly' is is last statement
    }
  }
}
