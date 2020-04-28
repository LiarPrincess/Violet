import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseDecorators: XCTestCase, Common {

  // MARK: - General

  /// @Joy
  /// class Riley: "feel"
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.at,                     start: loc0, end: loc1),
      self.token(.identifier("Joy"),      start: loc2, end: loc3),
      self.token(.newLine,                start: loc4, end: loc5),
      self.token(.class,                  start: loc6, end: loc7),
      self.token(.identifier("Riley"),    start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("feel"),         start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: feel
        Args
          Arguments(start: 12:12, end: 12:12)
            Args: none
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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      AsyncFunctionDefStmt(start: 0:0, end: 19:24)
        Name: feel
        Args
          Arguments(start: 14:14, end: 14:14)
            Args: none
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
