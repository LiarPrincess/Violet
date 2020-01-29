import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// ```c
/// class    with function
/// function with if
/// if       with while
/// while    with for
/// for      with with
/// with     with class
/// try??
/// ```
class ParseSuite: XCTestCase, Common {

  /// class Peter:
  ///   def fly():
  ///     up
  func test_class_withFunction() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      ClassDefStmt(start: 0:0, end: 25:30)
        Name: Peter
        Bases: none
        Keywords: none
        Body
          FunctionDefStmt(start: 10:10, end: 25:30)
            Name: fly
            Args
              Arguments(start: 16:16, end: 16:16)
                Args: none
                Defaults: none
                Vararg: none
                KwOnlyArgs: none
                KwOnlyDefaults: none
                Kwarg: none
            Body
              ExprStmt(start: 24:24, end: 25:30)
                StringExpr(context: Load, start: 24:24, end: 25:30)
                  String: 'up'
            Decorators: none
            Returns: none
        Decorators: none
    """)
  }

  /// def fly():
  ///   if Peter:
  ///      fly
  func test_function_withIf() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      FunctionDefStmt(start: 0:0, end: 25:30)
        Name: fly
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          IfStmt(start: 14:14, end: 25:30)
            Test
              IdentifierExpr(context: Load, start: 16:16, end: 17:22)
                Value: Peter
            Body
              ExprStmt(start: 24:24, end: 25:30)
                IdentifierExpr(context: Load, start: 24:24, end: 25:30)
                  Value: fly
            OrElse: none
        Decorators: none
        Returns: none
    """)
  }

  /// if Hook:
  ///   while tick:
  ///      run
  func test_if_withWhile() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      IfStmt(start: 0:0, end: 21:26)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Hook
        Body
          WhileStmt(start: 10:10, end: 21:26)
            Test
              IdentifierExpr(context: Load, start: 12:12, end: 13:18)
                Value: tick
            Body
              ExprStmt(start: 20:20, end: 21:26)
                StringExpr(context: Load, start: 20:20, end: 21:26)
                  String: 'run'
            OrElse: none
        OrElse: none
    """)
  }

  /// while tick:
  ///   for tock in crocodile:
  ///      run
  func test_while_withFor() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      WhileStmt(start: 0:0, end: 25:30)
        Test
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: tick
        Body
          ForStmt(start: 10:10, end: 25:30)
            Target
              IdentifierExpr(context: Store, start: 12:12, end: 13:18)
                Value: tock
            Iterable
              IdentifierExpr(context: Load, start: 16:16, end: 17:22)
                Value: crocodile
            Body
              ExprStmt(start: 24:24, end: 25:30)
                StringExpr(context: Load, start: 24:24, end: 25:30)
                  String: 'run'
            OrElse: none
        OrElse: none
    """)
  }

  /// for tock in crocodile:
  ///   with Hook:
  ///      run
  func test_for_withWith() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      ForStmt(start: 0:0, end: 25:30)
        Target
          IdentifierExpr(context: Store, start: 2:2, end: 3:8)
            Value: tock
        Iterable
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: crocodile
        Body
          WithStmt(start: 14:14, end: 25:30)
            Items
              WithItem(start: 16:16, end: 17:22)
                ContextExpr
                  IdentifierExpr(context: Load, start: 16:16, end: 17:22)
                    Value: Hook
                OptionalVars: none
            Body
              ExprStmt(start: 24:24, end: 25:30)
                StringExpr(context: Load, start: 24:24, end: 25:30)
                  String: 'run'
        OrElse: none
    """)
  }

  /// with TinkerBell:
  ///   class Dust:
  ///      fly
  func test_with_withClass() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      WithStmt(start: 0:0, end: 21:26)
        Items
          WithItem(start: 2:2, end: 3:8)
            ContextExpr
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: TinkerBell
            OptionalVars: none
        Body
          ClassDefStmt(start: 10:10, end: 21:26)
            Name: Dust
            Bases: none
            Keywords: none
            Body
              ExprStmt(start: 20:20, end: 21:26)
                StringExpr(context: Load, start: 20:20, end: 21:26)
                  String: 'fly'
            Decorators: none
    """)
  }
}
