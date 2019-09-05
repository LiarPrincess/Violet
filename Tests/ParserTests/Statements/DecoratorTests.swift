import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class DecoratorTests: XCTestCase, Common, ExpressionMatcher, StatementMatcher {

  // MARK: - General

  /// @Joy
  /// class Riley: "feel"
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.newLine,                start: loc4, end: loc5),
      self.token(.class,                  start: loc6, end: loc7),
      self.token(.identifier("Riley"),    start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("feel"),         start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc3)

      XCTAssertStatement(stmt, "(class Riley decorators: @Joy body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// @Emotion.Joy
  /// class Riley: "feel"
  func test_dottedName() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Emotion"),  start: loc2, end: loc3),
      self.token(.dot,                    start: loc4, end: loc5),
      self.token(.identifier("Joy"),      start: loc6, end: loc7),
      self.token(.newLine,                start: loc8, end: loc9),
      self.token(.class,                  start: loc10, end: loc11),
      self.token(.identifier("Riley"),    start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("feel"),         start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Emotion.Joy")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc7)

      XCTAssertStatement(stmt, "(class Riley decorators: @Emotion.Joy body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// @Joy
  /// @Sadness
  /// class Riley: "feel"
  func test_multiple() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.newLine,                start: loc4, end: loc5),
      self.token(.at,                     start: loc6, end: loc7),
      self.token(.identifier("Sadness"),  start: loc8, end: loc9),
      self.token(.newLine,                start: loc10, end: loc11),
      self.token(.class,                  start: loc12, end: loc13),
      self.token(.identifier("Riley"),    start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("feel"),         start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 2)
      guard d.decorators.count == 2 else { return }

      XCTAssertExpression(d.decorators[0], "Joy")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc3)

      XCTAssertExpression(d.decorators[1], "Sadness")
      XCTAssertEqual(d.decorators[1].start, loc8)
      XCTAssertEqual(d.decorators[1].end,   loc9)

      XCTAssertStatement(stmt, "(class Riley decorators: @Joy @Sadness body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }

  // MARK: - Arguments

  /// @Joy()
  /// class Riley: "feel"
  func test_arguments_none() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.rightParen,             start: loc6, end: loc7),
      self.token(.newLine,                start: loc8, end: loc9),
      self.token(.class,                  start: loc10, end: loc11),
      self.token(.identifier("Riley"),    start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("feel"),         start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy()")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc7)

      XCTAssertStatement(stmt, "(class Riley decorators: @Joy() body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// @Joy(memory)
  /// class Riley: "feel"
  func test_arguments_positional() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("memory"),   start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.newLine,                start: loc10, end: loc11),
      self.token(.class,                  start: loc12, end: loc13),
      self.token(.identifier("Riley"),    start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("feel"),         start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy(memory)")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc9)

      XCTAssertStatement(stmt, "(class Riley decorators: @Joy(memory) body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }

  /// @Joy(memory="happy")
  /// class Riley: "feel"
  func test_arguments_keyword() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("memory"),   start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.string("happy"),        start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.newLine,                start: loc14, end: loc15),
      self.token(.class,                  start: loc16, end: loc17),
      self.token(.identifier("Riley"),    start: loc18, end: loc19),
      self.token(.colon,                  start: loc20, end: loc21),
      self.token(.string("feel"),         start: loc22, end: loc23)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy(memory='happy')")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc13)

      XCTAssertStatement(stmt, "(class Riley decorators: @Joy(memory='happy') body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc23)
    }
  }

  /// @Joy(core, memory="happy")
  /// class Riley: "feel"
  func test_arguments_multiple() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("core"),     start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("memory"),   start: loc10, end: loc11),
      self.token(.equal,                  start: loc12, end: loc13),
      self.token(.string("happy"),        start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.newLine,                start: loc18, end: loc19),
      self.token(.class,                  start: loc20, end: loc21),
      self.token(.identifier("Riley"),    start: loc22, end: loc23),
      self.token(.colon,                  start: loc24, end: loc25),
      self.token(.string("feel"),         start: loc26, end: loc27)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchClassDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy(core memory='happy')")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc17)

      XCTAssertStatement(stmt, "(class Riley decorators: @Joy(core memory='happy') body: 'feel')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc27)
    }
  }

  // MARK: - Function

  /// @Joy
  /// def feel(): "emotion"
  func test_function() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.newLine,                start: loc4, end: loc5),
      self.token(.def,                    start: loc6, end: loc7),
      self.token(.identifier("feel"),     start: loc8, end: loc9),
      self.token(.leftParen,              start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("emotion"),      start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFunctionDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc3)

      XCTAssertStatement(stmt, "(def feel() decorators: @Joy do: 'emotion')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// @Joy
  /// async def feel(): "emotion"
  func test_function_async() {
    var parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.newLine,                start: loc4, end: loc5),
      self.token(.async,                  start: loc6, end: loc7),
      self.token(.def,                    start: loc8, end: loc9),
      self.token(.identifier("feel"),     start: loc10, end: loc11),
      self.token(.leftParen,              start: loc12, end: loc13),
      self.token(.rightParen,             start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("emotion"),      start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAsyncFunctionDef(stmt) else { return }

      XCTAssertEqual(d.decorators.count, 1)
      guard d.decorators.count == 1 else { return }

      XCTAssertExpression(d.decorators[0], "Joy")
      XCTAssertEqual(d.decorators[0].start, loc2)
      XCTAssertEqual(d.decorators[0].end,   loc3)

      XCTAssertStatement(stmt, "(asyncDef feel() decorators: @Joy do: 'emotion')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }
}
