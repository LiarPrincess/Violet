import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseDecorators: XCTestCase {

  // MARK: - General

  /// @Joy
  /// class Riley: "feel"
  func test_simple() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.newLine,                start: loc4, end: loc5),
      createToken(.class,                  start: loc6, end: loc7),
      createToken(.identifier("Riley"),    start: loc8, end: loc9),
      createToken(.colon,                  start: loc10, end: loc11),
      createToken(.string("feel"),         start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      ClassDefStmt(start: 0:0, end: 13:18)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'feel'
        Decorators
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Joy
    """)
  }

  /// @Emotion.Joy
  /// class Riley: "feel"
  func test_dottedName() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Emotion"),  start: loc2, end: loc3),
      createToken(.dot,                    start: loc4, end: loc5),
      createToken(.identifier("Joy"),      start: loc6, end: loc7),
      createToken(.newLine,                start: loc8, end: loc9),
      createToken(.class,                  start: loc10, end: loc11),
      createToken(.identifier("Riley"),    start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("feel"),         start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'feel'
        Decorators
          AttributeExpr(context: Load, start: 2:2, end: 7:12)
            Object
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Emotion
            Name: Joy
    """)
  }

  /// @Joy
  /// @Sadness
  /// class Riley: "feel"
  func test_multiple() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.newLine,                start: loc4, end: loc5),
      createToken(.at,                     start: loc6, end: loc7),
      createToken(.identifier("Sadness"),  start: loc8, end: loc9),
      createToken(.newLine,                start: loc10, end: loc11),
      createToken(.class,                  start: loc12, end: loc13),
      createToken(.identifier("Riley"),    start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("feel"),         start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      ClassDefStmt(start: 0:0, end: 19:24)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'feel'
        Decorators
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Joy
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: Sadness
    """)
  }

  // MARK: - Arguments

  /// @Joy()
  /// class Riley: "feel"
  func test_arguments_none() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.rightParen,             start: loc6, end: loc7),
      createToken(.newLine,                start: loc8, end: loc9),
      createToken(.class,                  start: loc10, end: loc11),
      createToken(.identifier("Riley"),    start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("feel"),         start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'feel'
        Decorators
          CallExpr(context: Load, start: 2:2, end: 7:12)
            Name
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Joy
            Args: none
            Keywords: none
    """)
  }

  /// @Joy(memory)
  /// class Riley: "feel"
  func test_arguments_positional() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("memory"),   start: loc6, end: loc7),
      createToken(.rightParen,             start: loc8, end: loc9),
      createToken(.newLine,                start: loc10, end: loc11),
      createToken(.class,                  start: loc12, end: loc13),
      createToken(.identifier("Riley"),    start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("feel"),         start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      ClassDefStmt(start: 0:0, end: 19:24)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'feel'
        Decorators
          CallExpr(context: Load, start: 2:2, end: 9:14)
            Name
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Joy
            Args
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: memory
            Keywords: none
    """)
  }

  /// @Joy(memory="happy")
  /// class Riley: "feel"
  func test_arguments_keyword() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("memory"),   start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.string("happy"),        start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.newLine,                start: loc14, end: loc15),
      createToken(.class,                  start: loc16, end: loc17),
      createToken(.identifier("Riley"),    start: loc18, end: loc19),
      createToken(.colon,                  start: loc20, end: loc21),
      createToken(.string("feel"),         start: loc22, end: loc23)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      ClassDefStmt(start: 0:0, end: 23:28)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 22:22, end: 23:28)
            StringExpr(context: Load, start: 22:22, end: 23:28)
              String: 'feel'
        Decorators
          CallExpr(context: Load, start: 2:2, end: 13:18)
            Name
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Joy
            Args: none
            Keywords
              Keyword(start: 6:6, end: 11:16)
                Kind
                  Named('memory')
                Value
                  StringExpr(context: Load, start: 10:10, end: 11:16)
                    String: 'happy'
    """)
  }

  /// @Joy(core, memory="happy")
  /// class Riley: "feel"
  func test_arguments_multiple() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("core"),     start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.identifier("memory"),   start: loc10, end: loc11),
      createToken(.equal,                  start: loc12, end: loc13),
      createToken(.string("happy"),        start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.newLine,                start: loc18, end: loc19),
      createToken(.class,                  start: loc20, end: loc21),
      createToken(.identifier("Riley"),    start: loc22, end: loc23),
      createToken(.colon,                  start: loc24, end: loc25),
      createToken(.string("feel"),         start: loc26, end: loc27)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 27:32)
      ClassDefStmt(start: 0:0, end: 27:32)
        Name: Riley
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 26:26, end: 27:32)
            StringExpr(context: Load, start: 26:26, end: 27:32)
              String: 'feel'
        Decorators
          CallExpr(context: Load, start: 2:2, end: 17:22)
            Name
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: Joy
            Args
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: core
            Keywords
              Keyword(start: 10:10, end: 15:20)
                Kind
                  Named('memory')
                Value
                  StringExpr(context: Load, start: 14:14, end: 15:20)
                    String: 'happy'
    """)
  }

  // MARK: - Function

  /// @Joy
  /// def feel(): "emotion"
  func test_function() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.newLine,                start: loc4, end: loc5),
      createToken(.def,                    start: loc6, end: loc7),
      createToken(.identifier("feel"),     start: loc8, end: loc9),
      createToken(.leftParen,              start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("emotion"),      start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: feel
        Args
          Arguments(start: 12:12, end: 12:12)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'emotion'
        Decorators
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Joy
        Returns: none
    """)
  }

  /// @Joy
  /// async def feel(): "emotion"
  func test_function_async() {
    let parser = createStmtParser(
      createToken(.at,                     start: loc0, end: loc1),
      createToken(.identifier("Joy"),      start: loc2, end: loc3),
      createToken(.newLine,                start: loc4, end: loc5),
      createToken(.async,                  start: loc6, end: loc7),
      createToken(.def,                    start: loc8, end: loc9),
      createToken(.identifier("feel"),     start: loc10, end: loc11),
      createToken(.leftParen,              start: loc12, end: loc13),
      createToken(.rightParen,             start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("emotion"),      start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      AsyncFunctionDefStmt(start: 0:0, end: 19:24)
        Name: feel
        Args
          Arguments(start: 14:14, end: 14:14)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'emotion'
        Decorators
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Joy
        Returns: none
    """)
  }
}
