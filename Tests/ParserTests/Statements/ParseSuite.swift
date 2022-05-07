import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces
// cSpell:ignore tock

/// ```c
/// class    with function
/// function with if
/// if       with while
/// while    with for
/// for      with with
/// with     with class
/// try??
/// ```
class ParseSuite: XCTestCase {

  /// def fly():
  ///                <-- this line is empty
  ///   pass
  func test_multipleNewLines_atTheBeginning() {
    let parser = createStmtParser(
      createToken(.def,                 start: loc0, end: loc1),
      createToken(.identifier("fly"),   start: loc2, end: loc3),
      createToken(.leftParen,           start: loc4, end: loc5),
      createToken(.rightParen,          start: loc6, end: loc7),
      createToken(.colon,               start: loc8, end: loc9),
      createToken(.newLine,             start: loc10, end: loc11),
      createToken(.newLine,             start: loc12, end: loc13), // < here
      createToken(.indent,              start: loc14, end: loc15),
      createToken(.pass,                start: loc16, end: loc17),
      createToken(.newLine,             start: loc18, end: loc19),
      createToken(.dedent,              start: loc21, end: loc21)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: fly
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          PassStmt(start: 16:16, end: 17:22)
        Decorators: none
        Returns: none
    """)
  }

  /// class Peter:
  ///   def fly():
  ///     up
  func test_class_withFunction() {
    let parser = createStmtParser(
      createToken(.class,               start: loc0, end: loc1),
      createToken(.identifier("Peter"), start: loc2, end: loc3),
      createToken(.colon,               start: loc4, end: loc5),
      createToken(.newLine,             start: loc6, end: loc7),
      createToken(.indent,              start: loc8, end: loc9),
      createToken(.def,                 start: loc10, end: loc11),
      createToken(.identifier("fly"),   start: loc12, end: loc13),
      createToken(.leftParen,           start: loc14, end: loc15),
      createToken(.rightParen,          start: loc16, end: loc17),
      createToken(.colon,               start: loc18, end: loc19),
      createToken(.newLine,             start: loc20, end: loc21),
      createToken(.indent,              start: loc22, end: loc23),
      createToken(.string("up"),        start: loc24, end: loc25),
      createToken(.newLine,             start: loc26, end: loc27),
      createToken(.dedent,              start: loc28, end: loc29),
      createToken(.dedent,              start: loc30, end: loc31)
    )

    guard let ast = parse(parser) else { return }

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
                PosOnlyArgCount: 0
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
    let parser = createStmtParser(
      createToken(.def,                 start: loc0, end: loc1),
      createToken(.identifier("fly"),   start: loc2, end: loc3),
      createToken(.leftParen,           start: loc4, end: loc5),
      createToken(.rightParen,          start: loc6, end: loc7),
      createToken(.colon,               start: loc8, end: loc9),
      createToken(.newLine,             start: loc10, end: loc11),
      createToken(.indent,              start: loc12, end: loc13),
      createToken(.if,                  start: loc14, end: loc15),
      createToken(.identifier("Peter"), start: loc16, end: loc17),
      createToken(.colon,               start: loc18, end: loc19),
      createToken(.newLine,             start: loc20, end: loc21),
      createToken(.indent,              start: loc22, end: loc23),
      createToken(.identifier("fly"),   start: loc24, end: loc25),
      createToken(.newLine,             start: loc26, end: loc27),
      createToken(.dedent,              start: loc28, end: loc29),
      createToken(.dedent,              start: loc30, end: loc31)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      FunctionDefStmt(start: 0:0, end: 25:30)
        Name: fly
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
            PosOnlyArgCount: 0
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
    let parser = createStmtParser(
      createToken(.if,                 start: loc0, end: loc1),
      createToken(.identifier("Hook"), start: loc2, end: loc3),
      createToken(.colon,              start: loc4, end: loc5),
      createToken(.newLine,            start: loc6, end: loc7),
      createToken(.indent,             start: loc8, end: loc9),
      createToken(.while,              start: loc10, end: loc11),
      createToken(.identifier("tick"), start: loc12, end: loc13),
      createToken(.colon,              start: loc14, end: loc15),
      createToken(.newLine,            start: loc16, end: loc17),
      createToken(.indent,             start: loc18, end: loc19),
      createToken(.string("run"),      start: loc20, end: loc21),
      createToken(.newLine,            start: loc22, end: loc23),
      createToken(.dedent,             start: loc24, end: loc25),
      createToken(.dedent,             start: loc26, end: loc27)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createStmtParser(
      createToken(.while,                   start: loc0, end: loc1),
      createToken(.identifier("tick"),      start: loc2, end: loc3),
      createToken(.colon,                   start: loc4, end: loc5),
      createToken(.newLine,                 start: loc6, end: loc7),
      createToken(.indent,                  start: loc8, end: loc9),
      createToken(.for,                     start: loc10, end: loc11),
      createToken(.identifier("tock"),      start: loc12, end: loc13),
      createToken(.in,                      start: loc14, end: loc15),
      createToken(.identifier("crocodile"), start: loc16, end: loc17),
      createToken(.colon,                   start: loc18, end: loc19),
      createToken(.newLine,                 start: loc20, end: loc21),
      createToken(.indent,                  start: loc22, end: loc23),
      createToken(.string("run"),           start: loc24, end: loc25),
      createToken(.newLine,                 start: loc26, end: loc27),
      createToken(.dedent,                  start: loc28, end: loc29),
      createToken(.dedent,                  start: loc30, end: loc31)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createStmtParser(
      createToken(.for,                     start: loc0, end: loc1),
      createToken(.identifier("tock"),      start: loc2, end: loc3),
      createToken(.in,                      start: loc4, end: loc5),
      createToken(.identifier("crocodile"), start: loc6, end: loc7),
      createToken(.colon,                   start: loc8, end: loc9),
      createToken(.newLine,                 start: loc10, end: loc11),
      createToken(.indent,                  start: loc12, end: loc13),
      createToken(.with,                    start: loc14, end: loc15),
      createToken(.identifier("Hook"),      start: loc16, end: loc17),
      createToken(.colon,                   start: loc18, end: loc19),
      createToken(.newLine,                 start: loc20, end: loc21),
      createToken(.indent,                  start: loc22, end: loc23),
      createToken(.string("run"),           start: loc24, end: loc25),
      createToken(.newLine,                 start: loc26, end: loc27),
      createToken(.dedent,                  start: loc28, end: loc29),
      createToken(.dedent,                  start: loc30, end: loc31)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createStmtParser(
      createToken(.with,                     start: loc0, end: loc1),
      createToken(.identifier("TinkerBell"), start: loc2, end: loc3),
      createToken(.colon,                    start: loc4, end: loc5),
      createToken(.newLine,                  start: loc6, end: loc7),
      createToken(.indent,                   start: loc8, end: loc9),
      createToken(.class,                    start: loc10, end: loc11),
      createToken(.identifier("Dust"),       start: loc12, end: loc13),
      createToken(.colon,                    start: loc14, end: loc15),
      createToken(.newLine,                  start: loc16, end: loc17),
      createToken(.indent,                   start: loc18, end: loc19),
      createToken(.string("fly"),            start: loc20, end: loc21),
      createToken(.newLine,                  start: loc22, end: loc23),
      createToken(.dedent,                   start: loc24, end: loc25),
      createToken(.dedent,                   start: loc26, end: loc27)
    )

    guard let ast = parse(parser) else { return }

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
