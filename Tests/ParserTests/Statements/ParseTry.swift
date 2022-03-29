import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseTry: XCTestCase {

  // MARK: - No else or finally

  /// try: "Mulan"
  func test_withoutFinallyOrElse_throws() {
    let parser = createStmtParser(
      createToken(.try,             start: loc0, end: loc1),
      createToken(.colon,           start: loc2, end: loc3),
      createToken(.string("Mulan"), start: loc4, end: loc5)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .tryWithoutExceptOrFinally)
      XCTAssertEqual(error.location, loc0)
    }
  }

  // MARK: - Only finally

  /// try:     "Ping"
  /// finally: "Mulan"
  func test_finally() {
    let parser = createStmtParser(
      createToken(.try,             start: loc0,  end: loc1),
      createToken(.colon,           start: loc2,  end: loc3),
      createToken(.string("Ping"),  start: loc4,  end: loc5),
      createToken(.newLine,         start: loc6,  end: loc7),
      createToken(.finally,         start: loc8,  end: loc9),
      createToken(.colon,           start: loc10, end: loc11),
      createToken(.string("Mulan"), start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      TryStmt(start: 0:0, end: 13:18)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Ping'
        Handlers: none
        OrElse: none
        Finally
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'Mulan'
    """)
  }

  // MARK: - Except

  /// try:    "Mulan"
  /// except: "Ping"
  func test_except() {
    let parser = createStmtParser(
      createToken(.try,             start: loc0,  end: loc1),
      createToken(.colon,           start: loc2,  end: loc3),
      createToken(.string("Mulan"), start: loc4,  end: loc5),
      createToken(.newLine,         start: loc6,  end: loc7),
      createToken(.except,          start: loc8,  end: loc9),
      createToken(.colon,           start: loc10, end: loc11),
      createToken(.string("Ping"),  start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      TryStmt(start: 0:0, end: 13:18)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(context: Load, start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except Soldier: "Ping"
  func test_except_type() {
    let parser = createStmtParser(
      createToken(.try,                   start: loc0,  end: loc1),
      createToken(.colon,                 start: loc2,  end: loc3),
      createToken(.string("Mulan"),       start: loc4,  end: loc5),
      createToken(.newLine,               start: loc6,  end: loc7),
      createToken(.except,                start: loc8,  end: loc9),
      createToken(.identifier("Soldier"), start: loc10, end: loc11),
      createToken(.colon,                 start: loc12, end: loc13),
      createToken(.string("Ping"),        start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      TryStmt(start: 0:0, end: 15:20)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 15:20)
            Kind
              Typed
                Type
                  IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                    Value: Soldier
                AsName: none
            Body
              ExprStmt(start: 14:14, end: 15:20)
                StringExpr(context: Load, start: 14:14, end: 15:20)
                  String: 'Ping'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except Disguise as Soldier: "Ping"
  func test_except_type_withName() {
    let parser = createStmtParser(
      createToken(.try,                    start: loc0,  end: loc1),
      createToken(.colon,                  start: loc2,  end: loc3),
      createToken(.string("Mulan"),        start: loc4,  end: loc5),
      createToken(.newLine,                start: loc6,  end: loc7),
      createToken(.except,                 start: loc8,  end: loc9),
      createToken(.identifier("Disguise"), start: loc10, end: loc11),
      createToken(.as,                     start: loc12, end: loc13),
      createToken(.identifier("Soldier"),  start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("Ping"),         start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      TryStmt(start: 0:0, end: 19:24)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 19:24)
            Kind
              Typed
                Type
                  IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                    Value: Disguise
                AsName: Soldier
            Body
              ExprStmt(start: 18:18, end: 19:24)
                StringExpr(context: Load, start: 18:18, end: 19:24)
                  String: 'Ping'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except Soldier: "Ping"
  /// except: "Pong"
  func test_except_multiple() {
    let parser = createStmtParser(
      createToken(.try,                   start: loc0,  end: loc1),
      createToken(.colon,                 start: loc2,  end: loc3),
      createToken(.string("Mulan"),       start: loc4,  end: loc5),
      createToken(.newLine,               start: loc6,  end: loc7),
      createToken(.except,                start: loc8,  end: loc9),
      createToken(.identifier("Soldier"), start: loc10, end: loc11),
      createToken(.colon,                 start: loc12, end: loc13),
      createToken(.string("Ping"),        start: loc14, end: loc15),
      createToken(.newLine,               start: loc16, end: loc17),
      createToken(.except,                start: loc18, end: loc19),
      createToken(.colon,                 start: loc20, end: loc21),
      createToken(.string("Pong"),        start: loc22, end: loc23)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      TryStmt(start: 0:0, end: 23:28)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 15:20)
            Kind
              Typed
                Type
                  IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                    Value: Soldier
                AsName: none
            Body
              ExprStmt(start: 14:14, end: 15:20)
                StringExpr(context: Load, start: 14:14, end: 15:20)
                  String: 'Ping'
          ExceptHandler(start: 18:18, end: 23:28)
            Kind
              Default
            Body
              ExprStmt(start: 22:22, end: 23:28)
                StringExpr(context: Load, start: 22:22, end: 23:28)
                  String: 'Pong'
        OrElse: none
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// else: "Fa Mulan"
  func test_except_else() {
    let parser = createStmtParser(
      createToken(.try,                start: loc0,  end: loc1),
      createToken(.colon,              start: loc2,  end: loc3),
      createToken(.string("Mulan"),    start: loc4,  end: loc5),
      createToken(.newLine,            start: loc6,  end: loc7),
      createToken(.except,             start: loc8,  end: loc9),
      createToken(.colon,              start: loc10, end: loc11),
      createToken(.string("Ping"),     start: loc12, end: loc13),
      createToken(.newLine,            start: loc14, end: loc15),
      createToken(.else,               start: loc16, end: loc17),
      createToken(.colon,              start: loc18, end: loc19),
      createToken(.string("Fa Mulan"), start: loc20, end: loc21)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      TryStmt(start: 0:0, end: 21:26)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(context: Load, start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(context: Load, start: 20:20, end: 21:26)
              String: 'Fa Mulan'
        Finally: none
    """)
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// finally: "Fa Mulan"
  func test_except_finally() {
    let parser = createStmtParser(
      createToken(.try,                start: loc0,  end: loc1),
      createToken(.colon,              start: loc2,  end: loc3),
      createToken(.string("Mulan"),    start: loc4,  end: loc5),
      createToken(.newLine,            start: loc6,  end: loc7),
      createToken(.except,             start: loc8,  end: loc9),
      createToken(.colon,              start: loc10, end: loc11),
      createToken(.string("Ping"),     start: loc12, end: loc13),
      createToken(.newLine,            start: loc14, end: loc15),
      createToken(.finally,            start: loc16, end: loc17),
      createToken(.colon,              start: loc18, end: loc19),
      createToken(.string("Fa Mulan"), start: loc20, end: loc21)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      TryStmt(start: 0:0, end: 21:26)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(context: Load, start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse: none
        Finally
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(context: Load, start: 20:20, end: 21:26)
              String: 'Fa Mulan'
    """)
  }

  /// try: "Mulan"
  /// except: "Ping"
  /// else:   "Pong"
  /// finally: "Fa Mulan"
  func test_except_else_finally() {
    let parser = createStmtParser(
      createToken(.try,                start: loc0,  end: loc1),
      createToken(.colon,              start: loc2,  end: loc3),
      createToken(.string("Mulan"),    start: loc4,  end: loc5),
      createToken(.newLine,            start: loc6,  end: loc7),
      createToken(.except,             start: loc8,  end: loc9),
      createToken(.colon,              start: loc10, end: loc11),
      createToken(.string("Ping"),     start: loc12, end: loc13),
      createToken(.newLine,            start: loc14, end: loc15),
      createToken(.else,               start: loc16, end: loc17),
      createToken(.colon,              start: loc18, end: loc19),
      createToken(.string("Pong"),     start: loc20, end: loc21),
      createToken(.newLine,            start: loc22, end: loc23),
      createToken(.finally,            start: loc24, end: loc25),
      createToken(.colon,              start: loc26, end: loc27),
      createToken(.string("Fa Mulan"), start: loc28, end: loc29)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 29:34)
      TryStmt(start: 0:0, end: 29:34)
        Body
          ExprStmt(start: 4:4, end: 5:10)
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'Mulan'
        Handlers
          ExceptHandler(start: 8:8, end: 13:18)
            Kind
              Default
            Body
              ExprStmt(start: 12:12, end: 13:18)
                StringExpr(context: Load, start: 12:12, end: 13:18)
                  String: 'Ping'
        OrElse
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(context: Load, start: 20:20, end: 21:26)
              String: 'Pong'
        Finally
          ExprStmt(start: 28:28, end: 29:34)
            StringExpr(context: Load, start: 28:28, end: 29:34)
              String: 'Fa Mulan'
    """)
  }

  // MARK: - Else without except

  /// try: "Mulan"
  /// else: "Ping"
  /// finally: "Fa Mulan"
  func test_else_withoutExcept_throws() {
    let parser = createStmtParser(
      createToken(.try,                start: loc0,  end: loc1),
      createToken(.colon,              start: loc2,  end: loc3),
      createToken(.string("Mulan"),    start: loc4,  end: loc5),
      createToken(.newLine,            start: loc6,  end: loc7),
      createToken(.else,               start: loc8,  end: loc9),
      createToken(.colon,              start: loc10, end: loc11),
      createToken(.string("Ping"),     start: loc12, end: loc13),
      createToken(.newLine,            start: loc14, end: loc15),
      createToken(.finally,            start: loc16, end: loc17),
      createToken(.colon,              start: loc18, end: loc19),
      createToken(.string("Fa Mulan"), start: loc20, end: loc21)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .tryWithElseWithoutExcept)
      XCTAssertEqual(error.location, loc0)
    }
  }
}
