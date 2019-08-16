import XCTest
import Core
import Lexer
@testable import Parser

// TODO: finish suite tests

/// ```c
/// class    with function
/// function with if
/// if       with while
/// while    with for
/// for      with with
/// with     with class
/// try??
/// ```
class SuiteTests: XCTestCase,
Common, DestructExpressionKind, DestructStatementKind {

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
      guard let dFor = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(dFor.body.count, 1)
      guard dFor.body.count == 1 else { return }
      XCTAssertStatement(dFor.body[0], "(if Peter then: fly)")

      XCTAssertStatement(stmt, "(def fly () do: (if Peter then: fly))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25) // 'fly' is is last statement
    }
  }
}
