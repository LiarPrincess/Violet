import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class ParseTry: XCTestCase, Common {

  // MARK: - No else or finally

  /// try: "Mulan"
  func test_withoutFinallyOrElse_throws() {
    let parser = self.createStmtParser(
      self.token(.try,             start: loc0, end: loc1),
      self.token(.colon,           start: loc2, end: loc3),
      self.token(.string("Mulan"), start: loc4, end: loc5)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .tryWithoutExceptOrFinally)
      XCTAssertEqual(error.location, loc0)
    }
  }

  // MARK: - Only finally

  /// try:     "Ping"
  /// finally: "Mulan"
  func test_finally() {
    let parser = self.createStmtParser(
      self.token(.try,             start: loc0,  end: loc1),
      self.token(.colon,           start: loc2,  end: loc3),
      self.token(.string("Ping"),  start: loc4,  end: loc5),
      self.token(.newLine,         start: loc6,  end: loc7),
      self.token(.finally,         start: loc8,  end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.string("Mulan"), start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      TryStmt(start: 0:0, end: 13:18)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Ping'
        Handlers: none
        OrElse: none
        Finally
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(start: 12:12, end: 13:18)
              String: 'Mulan'
    """)
  }

  // MARK: - Except

  /// try:    "Mulan"
  /// except: "Ping"
  func test_except() {
    let parser = self.createStmtParser(
      self.token(.try,             start: loc0,  end: loc1),
      self.token(.colon,           start: loc2,  end: loc3),
      self.token(.string("Mulan"), start: loc4,  end: loc5),
      self.token(.newLine,         start: loc6,  end: loc7),
      self.token(.except,          start: loc8,  end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.string("Ping"),  start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      TryStmt(start: 0:0, end: 13:18)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except Soldier: "Ping"
  func test_except_type() {
    let parser = self.createStmtParser(
      self.token(.try,                   start: loc0,  end: loc1),
      self.token(.colon,                 start: loc2,  end: loc3),
      self.token(.string("Mulan"),       start: loc4,  end: loc5),
      self.token(.newLine,               start: loc6,  end: loc7),
      self.token(.except,                start: loc8,  end: loc9),
      self.token(.identifier("Soldier"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("Ping"),        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      TryStmt(start: 0:0, end: 15:20)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 15:20)
            Kind
              Typed
                Type
                  IdentifierExpr(start: 10:10, end: 11:16)
                    Value: Soldier
                AsName: none
            Body
              ExprStmt(start: 14:14, end: 15:20)
                StringExpr(start: 14:14, end: 15:20)
                  String: 'Ping'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except Disguise as Soldier: "Ping"
  func test_except_type_withName() {
    let parser = self.createStmtParser(
      self.token(.try,                    start: loc0,  end: loc1),
      self.token(.colon,                  start: loc2,  end: loc3),
      self.token(.string("Mulan"),        start: loc4,  end: loc5),
      self.token(.newLine,                start: loc6,  end: loc7),
      self.token(.except,                 start: loc8,  end: loc9),
      self.token(.identifier("Disguise"), start: loc10, end: loc11),
      self.token(.as,                     start: loc12, end: loc13),
      self.token(.identifier("Soldier"),  start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("Ping"),         start: loc18, end: loc19)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      TryStmt(start: 0:0, end: 19:24)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 19:24)
            Kind
              Typed
                Type
                  IdentifierExpr(start: 10:10, end: 11:16)
                    Value: Disguise
                AsName: Soldier
            Body
              ExprStmt(start: 18:18, end: 19:24)
                StringExpr(start: 18:18, end: 19:24)
                  String: 'Ping'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except Soldier: "Ping"
  /// except: "Pong"
  func test_except_multiple() {
    let parser = self.createStmtParser(
      self.token(.try,                   start: loc0,  end: loc1),
      self.token(.colon,                 start: loc2,  end: loc3),
      self.token(.string("Mulan"),       start: loc4,  end: loc5),
      self.token(.newLine,               start: loc6,  end: loc7),
      self.token(.except,                start: loc8,  end: loc9),
      self.token(.identifier("Soldier"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("Ping"),        start: loc14, end: loc15),
      self.token(.newLine,               start: loc16, end: loc17),
      self.token(.except,                start: loc18, end: loc19),
      self.token(.colon,                 start: loc20, end: loc21),
      self.token(.string("Pong"),        start: loc22, end: loc23)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      TryStmt(start: 0:0, end: 23:28)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 15:20)
            Kind
              Typed
                Type
                  IdentifierExpr(start: 10:10, end: 11:16)
                    Value: Soldier
                AsName: none
            Body
              ExprStmt(start: 14:14, end: 15:20)
                StringExpr(start: 14:14, end: 15:20)
                  String: 'Ping'
          ExceptHandler(start: 18:18, end: 23:28)
            Kind
              Default
            Body
              ExprStmt(start: 22:22, end: 23:28)
                StringExpr(start: 22:22, end: 23:28)
                  String: 'Pong'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// else: "Fa Mulan"
  func test_except_else() {
    let parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.newLine,            start: loc6,  end: loc7),
      self.token(.except,             start: loc8,  end: loc9),
      self.token(.colon,              start: loc10, end: loc11),
      self.token(.string("Ping"),     start: loc12, end: loc13),
      self.token(.newLine,            start: loc14, end: loc15),
      self.token(.else,               start: loc16, end: loc17),
      self.token(.colon,              start: loc18, end: loc19),
      self.token(.string("Fa Mulan"), start: loc20, end: loc21)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      TryStmt(start: 0:0, end: 21:26)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(start: 20:20, end: 21:26)
              String: 'Fa Mulan'
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// finally: "Fa Mulan"
  func test_except_finally() {
    let parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.newLine,            start: loc6,  end: loc7),
      self.token(.except,             start: loc8,  end: loc9),
      self.token(.colon,              start: loc10, end: loc11),
      self.token(.string("Ping"),     start: loc12, end: loc13),
      self.token(.newLine,            start: loc14, end: loc15),
      self.token(.finally,            start: loc16, end: loc17),
      self.token(.colon,              start: loc18, end: loc19),
      self.token(.string("Fa Mulan"), start: loc20, end: loc21)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      TryStmt(start: 0:0, end: 21:26)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse: none
        Finally
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(start: 20:20, end: 21:26)
              String: 'Fa Mulan'
    """)
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// else:   "Pong"
  /// finally: "Fa Mulan"
  func test_except_else_finally() {
    let parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.newLine,            start: loc6,  end: loc7),
      self.token(.except,             start: loc8,  end: loc9),
      self.token(.colon,              start: loc10, end: loc11),
      self.token(.string("Ping"),     start: loc12, end: loc13),
      self.token(.newLine,            start: loc14, end: loc15),
      self.token(.else,               start: loc16, end: loc17),
      self.token(.colon,              start: loc18, end: loc19),
      self.token(.string("Pong"),     start: loc20, end: loc21),
      self.token(.newLine,            start: loc22, end: loc23),
      self.token(.finally,            start: loc24, end: loc25),
      self.token(.colon,              start: loc26, end: loc27),
      self.token(.string("Fa Mulan"), start: loc28, end: loc29)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 29:34)
      TryStmt(start: 0:0, end: 29:34)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(start: 20:20, end: 21:26)
              String: 'Pong'
        Finally
          ExprStmt(start: 28:28, end: 29:34)
            StringExpr(start: 28:28, end: 29:34)
              String: 'Fa Mulan'
    """)
  }

  // MARK: - Else without except

  /// try: "Mulan"
  /// else: "Ping"
  /// finally: "Fa Mulan"
  func test_else_withoutExcept_throws() {
    let parser = self.createStmtParser(
      self.token(.try,                start: loc0,  end: loc1),
      self.token(.colon,              start: loc2,  end: loc3),
      self.token(.string("Mulan"),    start: loc4,  end: loc5),
      self.token(.newLine,            start: loc6,  end: loc7),
      self.token(.else,               start: loc8,  end: loc9),
      self.token(.colon,              start: loc10, end: loc11),
      self.token(.string("Ping"),     start: loc12, end: loc13),
      self.token(.newLine,            start: loc14, end: loc15),
      self.token(.finally,            start: loc16, end: loc17),
      self.token(.colon,              start: loc18, end: loc19),
      self.token(.string("Fa Mulan"), start: loc20, end: loc21)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .tryWithElseWithoutExcept)
      XCTAssertEqual(error.location, loc0)
    }
  }
}
